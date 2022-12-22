create or replace package body maintain_draw
as
    GC_GROUP_TEAMS constant pls_integer := 4;
    GC_GROUP_MATCHES constant pls_integer := 3;
    
    procedure update_r16_draw(i_group in groups.cid%type)
    is 
        cursor c_standings is
        select st.cid, st.pos, 
            case st.pos when 1 then gr.winner_draw_cid when 2 then gr.second_draw_cid end as draw_cid
        from group_standings_vw st
        inner join groups gr
            on gr.cid = st.group_cid
        where pld = GC_GROUP_MATCHES
        and group_cid = i_group
        order by pos;
        
        type typ_teams is table of c_standings%rowtype index by pls_integer;
        v_teams typ_teams;
    begin
        skippy.log('I_GROUP : '||i_group);
        -- see if the group is now completed - i.e. all the teams have played all of their matches in the group
        open c_standings;
        fetch c_standings bulk collect into v_teams;
        close c_standings;
        if v_teams.count != 4 then
            -- Group isn't yet complete
            return;
        end if;    
        
        skippy.log('Updating DRAW');       
        update draw
        set team_cid = 
            case 
                when cid = v_teams(1).draw_cid then v_teams(1).cid
                when cid = v_teams(2).draw_cid then v_teams(2).cid  
            end 
        where cid in(v_teams(1).draw_cid, v_teams(2).draw_cid)
        and stage_cid = 'R16'
        and group_cid = i_group;
        
        skippy.log('Updating FIXTURES');
        update fixtures fix
        set t1_cid = 
            case 
                when t1_draw_cid = v_teams(1).draw_cid then v_teams(1).cid
                when t1_draw_cid = v_teams(2).draw_cid then v_teams(2).cid
                else t1_cid
            end,
            t2_cid =
                case
                    when t2_draw_cid = v_teams(1).draw_cid then v_teams(1).cid
                    when t2_draw_cid = v_teams(2).draw_cid then v_teams(2).cid
                    else t2_cid
                end
        where (
            fix.t1_draw_cid in (v_teams(1).draw_cid, v_teams(2).draw_cid)
            or
            fix.t2_draw_cid in (v_teams(1).draw_cid, v_teams(2).draw_cid))
        and fix.stage_cid = 'R16';
        skippy.log('Completed');
    end update_r16_draw;    
        
    procedure validate_override( i_group in groups.cid%type)
    is
        cursor c_overrides is
            select team_cid, final_position, 
                dense_rank() over ( order by final_position) as dr
            from group_position_override
            where final_position is not null
            and group_cid = i_group
            order by final_position;
        
        type typ_teams is table of c_overrides%rowtype index by pls_integer;
        v_teams typ_teams;

    begin
        -- If the override has been used then :
        -- 1 - ALL teams need to have an override position set
        -- 2 - there must be only one team with each ranking
        
        open c_overrides;
        fetch c_overrides bulk collect into v_teams;
        close c_overrides;
        if v_teams.count != GC_GROUP_TEAMS then
            raise_application_error(-20501, 'If the override is used then all teams must be assigned an override');
        end if;
        if v_teams(GC_GROUP_TEAMS).dr != 4 then
            raise_application_error(-20502, 'Each team must have a unique ranking');
        end if;    
        
        -- Update the Round of 16 draw with the overridden placings
        update_r16_draw(i_group);
    end validate_override;    

    procedure update_other_ko( i_fix_id in fixtures.id%type)
    is 
        cursor c_result is
            select 
                winner_draw_cid,
                loser_draw_cid,
                case 
                    when (t1_score + nvl(t1_pens, 0)) > (t2_score + nvl(t2_pens, 0)) then t1_cid 
                    else t2_cid 
                end as winner,
                case 
                    when (t1_score + nvl(t1_pens, 0)) < (t2_score + nvl(t2_pens, 0)) then t1_cid 
                    else t2_cid 
                end as loser
            from fixtures
            where id = i_fix_id;
            
        v_result c_result%rowtype;

    begin 
        open c_result;
        fetch c_result into v_result;
        close c_result;

        -- As an alternative approach, use the DRAW table to populate the fixtures teams for
        -- the next round...
        
        update draw
        set team_cid = case cid when v_result.winner_draw_cid then v_result.winner else v_result.loser end
        where cid in (v_result.winner_draw_cid, v_result.loser_draw_cid);
        
        merge into fixtures t1
        using draw
        on (
                draw.cid = t1.t1_draw_cid
            and draw.stage_cid = t1.stage_cid)
        when matched then update
        set t1.t1_cid = draw.team_cid;
        
        merge into fixtures t2
        using draw
        on (
                draw.cid = t2.t2_draw_cid
            and draw.stage_cid = t2.stage_cid)
        when matched then update
        set t2.t2_cid = draw.team_cid;
    end update_other_ko;        

end maintain_draw;
/
        