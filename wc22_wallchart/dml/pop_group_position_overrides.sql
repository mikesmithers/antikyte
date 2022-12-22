insert into group_position_override( team_cid, group_cid)
    select cid as team_cid,
        group_cid
    from teams;    
    
    