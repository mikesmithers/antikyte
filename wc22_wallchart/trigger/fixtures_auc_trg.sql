create or replace trigger fixtures_auc_trg
    for update of t1_score, t2_score, t1_pens, t2_pens on fixtures
    compound trigger
    
        v_group dbms_utility.name_array;
        v_fix_id dbms_utility.number_array;
        v_group_idx pls_integer := 0;
        v_ko_idx pls_integer := 0;
    after each row is
    begin
        skippy.log('Start Group IDX : '||v_group_idx);
        -- For each row updated, see if it's part of the Group stage or a Knockout stage
        if :new.group_cid is not null then
            v_group_idx := v_group_idx + 1;
            v_group( v_group_idx) := :new.group_cid;
        else
            v_ko_idx := v_ko_idx + 1;
            v_fix_id(v_ko_idx) := :new.id;
        end if;    
        skippy.log('End Group IDX : '||v_group_idx);
    end after each row;    

    after statement is
    begin
        if v_group_idx > 0 then
            for i in 1..v_group_idx loop
                skippy.log('Group : '||v_group(i));
                maintain_draw.update_r16_draw( v_group( i));
            end loop;
        end if;
        
        if v_ko_idx > 0 then
            for j in 1..v_ko_idx loop
                maintain_draw.update_other_ko( v_fix_id( j));
            end loop;
        end if;
    end after statement;
end;
/
        