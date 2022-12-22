insert into stages( cid, stage_name)
values('GROUP', 'Group Stage')
/

insert into stages( cid, stage_name)
values('R16', 'Round of 16')
/

insert into stages( cid, stage_name)
values('QF', 'Quarter-Finals')
/

insert into stages( cid, stage_name)
values('SF', 'Semi-Finals')
/

insert into stages( cid, stage_name)
values('TPP', 'Third Place Play-Off')
/

insert into stages( cid, stage_name)
values('F', 'Final')
/

commit;

update stages
set stage_order =
    case cid
        when 'GROUP' then 1
        when 'R16' then 2
        when 'QF' then 3
        when 'SF' then 4
        when 'TPP' then 5
        when 'F' then 6
    end
/
commit;
