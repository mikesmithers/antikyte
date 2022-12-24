-- There are 8 groups - A to H
insert into groups(cid)
    select chr(rownum + ascii('A') -1)
    from dual
    connect by rownum <= 8;
commit;    
