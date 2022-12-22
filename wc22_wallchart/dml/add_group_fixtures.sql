set serverout on 
clear screen
declare
    -- Match dates added manually later
    type tbl_teams is table of teams.team_name%type index by teams.group_draw_cid%type;
    v_teams tbl_teams;        
    v_home varchar2(2);
    v_away varchar2(2);
    
    procedure add_fixture(i_group in varchar2, i_t1_draw in varchar2,
        i_t2_draw in varchar2, i_t1 in varchar2, i_t2 in varchar2)
    is
        C_STAGE constant fixtures.stage_cid%type := 'GROUP';
    begin
        insert into fixtures(stage_cid, group_cid, t1_draw_cid, t2_draw_cid, t1_cid, t2_cid)
        values(C_STAGE, i_group, i_t1_draw, i_t2_draw, i_t1, i_t2);
    end add_fixture;    
    
    
begin
    for r_group in ( select cid from groups) loop
        -- Get the teams in this group
        for r_team in ( 
            select cid, group_draw_cid 
            from teams 
            where group_cid = r_group.cid)
        loop
            v_teams(r_team.group_draw_cid) := r_team.cid;
        end loop;    
        -- Pattern of group fixtures is 
        --    A1 v A2
        --    A3 v A4
        --    A1 v A3
        --    A2 v A4
        --    A4 v A1
        --    A2 v A3
        v_home := r_group.cid||1;
        v_away := r_group.cid||2;
        add_fixture( r_group.cid, v_home, v_away, v_teams(v_home), v_teams(v_away));

        v_home := r_group.cid||3;
        v_away := r_group.cid||4;
        add_fixture( r_group.cid, v_home, v_away, v_teams(v_home), v_teams(v_away));

        v_home := r_group.cid||1;
        v_away := r_group.cid||3;
        add_fixture( r_group.cid, v_home, v_away, v_teams(v_home), v_teams(v_away));

        v_home := r_group.cid||2;
        v_away := r_group.cid||4;
        add_fixture( r_group.cid, v_home, v_away, v_teams(v_home), v_teams(v_away));

        v_home := r_group.cid||4;
        v_away := r_group.cid||1;
        add_fixture( r_group.cid, v_home, v_away, v_teams(v_home), v_teams(v_away));

        v_home := r_group.cid||2;
        v_away := r_group.cid||3;
        add_fixture( r_group.cid, v_home, v_away, v_teams(v_home), v_teams(v_away));

    end loop;    
    commit;
end;
/
