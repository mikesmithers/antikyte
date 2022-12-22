set serverout on
declare
    v_stage stages.cid%type;
    
    procedure ins ( i_cid in varchar2, i_stage in varchar2, i_group in varchar2 default null) 
    is
    begin
        insert into draw( cid, stage_cid, group_cid)
        values( i_cid, i_stage, i_group);
    end ins;
    
begin
    -- Group Stage and Round of 16
    for r_group in ( select cid from groups order by 1) loop
        v_stage := 'GROUP';
        for i in 1..4 loop
            ins(r_group.cid||i, v_stage, r_group.cid);
        end loop;
        
        v_stage := 'R16';
        ins( 'WINNER_'||r_group.cid, v_stage, r_group.cid);
        ins( 'SECOND_'||r_group.cid, v_stage, r_group.cid);
    end loop;    

    --Quarter Finals
    v_stage := 'QF';
    for j in 1..8 loop
        ins( 'WINNER_R16_'||j, v_stage);
    end loop;
    
    -- Semis
    v_stage := 'SF';
    for k in 1..4 loop
        ins('WINNER_QF_'||k, v_stage);
    end loop;
    
    -- TPP
    v_stage := 'TPP';
    ins('LOSER_SF_1', v_stage);
    ins('LOSER_SF_2', v_stage);
    
    v_stage := 'F';
    ins('WINNER_SF_1', v_stage);
    ins('WINNER_SF_2', v_stage);

end;
/

commit;