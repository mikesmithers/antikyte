-- There are 8 groups - A to H
insert into groups
    select chr(rownum + ascii('A') -1)
    from dual
    connect by rownum <= 8;
commit;    

-- add the winner_draw_cid and second_draw_cid values
-- done this way because I added these columns to the table later on

update groups
set winner_draw_cid = 'WINNER_'||cid,
    second_draw_cid = 'SECOND_'||cid;
commit;