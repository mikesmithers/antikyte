-- Run this script once the tournament teams are known and have been drawn into their groups
merge into draw d
using teams t
on ( t.group_draw_cid = d.cid)
when matched then update
    set d.team_cid = t.cid;
    
commit;    