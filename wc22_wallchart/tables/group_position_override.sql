create table group_position_override(
    group_cid varchar2(25),
    team_cid varchar2(25),
    final_position number(1),
    constraint group_position_override_pk primary key (group_cid, team_cid),
    constraint group_position_override_final_position_chk check (final_position between 1 and 4))
/

comment on table group_position_override is 'Explicitly set the finishing position for a team in a group. Can be used if positons decided by drawing of lots, for example.';
comment on column group_position_override.final_position is q'[The team's finishing position in the group irrespective of any other tie-break criteria]';
