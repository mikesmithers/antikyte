create table draw(
    cid varchar2(25),
    stage_cid varchar2(25) not null, 
    group_cid varchar2(1),
    team_cid varchar2(25),
    constraint draw_pk primary key (cid),
    constraint draw_stages_fk foreign key (stage_cid) references stages(cid))
/

-- NOTE - there is a circular dependency between DRAW and TEAMS.
-- DRAW.TEAM_CID is an FK to TEAMS.CID
-- TEAMS.GROUP_DRAW_CID is an FK to DRAW.CID
-- Therefore, we need to create both tables first before creating the respective Foreign Keys
--
comment on table draw is 'The framework used to work out which teams play each other in the tournament fixtures';
comment on column draw.cid is 'Unique identifier for a draw identifier to be assigned to a team';