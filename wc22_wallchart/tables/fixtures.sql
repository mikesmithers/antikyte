create table fixtures(
    id number generated always as identity,
    match_date date,
    stage_cid varchar2(25) not null,
    group_cid varchar2(25),
    t1_draw_cid varchar2(25) not null,
    t2_draw_cid varchar2(25) not null,
    t1_cid varchar2(25),
    t2_cid varchar2(25),
    t1_score number,
    t2_score number,
    t1_pens number,
    t2_pens number,
    winner_draw_cid varchar2(25),
    loser_draw_cid varchar2(25),
    t1_pts number generated always as (case when group_cid is not null then case when t1_score > t2_score then 3 when t1_score = t2_score then 1 else 0 end end) virtual,
    t2_pts number generated always as (case when group_cid is not null then case when t2_score > t1_score then 3 when t2_score = t1_score then 1 else 0 end end) virtual,
    constraint fixtures_pk primary key (id),
    constraint fixtures_stages_fk foreign key (stage_cid) references stages(cid),
    constraint fixtures_groups_fk foreign key (group_cid) references groups(cid),
    constraint fixtures_t1_draw_fk foreign key (t1_draw_cid) references draw( cid),
    constraint fixtures_t2_draw_fk foreign key (t2_draw_cid) references draw( cid),
    constraint fixtures_t1_teams_fk foreign key( t1_cid) references teams(cid),
    constraint fixtures_t2_teams_fk foreign key( t2_cid) references teams(cid),
    constraint fixtures_w_draw_fk foreign key (winner_draw_cid) references draw( cid),
    constraint fixtures_l_draw_fk foreign key (loser_draw_cid) references draw( cid)
    )
/

comment on table fixtures is 'The fixtures that make up the tournament';
comment on column fixtures.match_date is 'The date the match is scheduled for. Time element is optional';
comment on column fixtures.t1_draw_cid is 'The draw cid used to derive Team 1 for this fixture. This is known after the teams are assigned to groups or progress through the knockout stages';
comment on column fixtures.t2_draw_cid is 'The draw cid used to derive Team 2 for this fixture. This is known after the teams are assigned to groups or progress through the knockout stages';
comment on column fixtures.t1_pens is 'If a knockout game goes to a penalty shootout, the number of penalties scored in the shootout by Team 1';
comment on column fixtures.t2_pens is 'If a knockout game goes to a penalty shootout, the number of penalties scored in the shootout by Team 2';
comment on column fixtures.winner_draw_cid is 'If a knockout game then the draw_cid that the Winner will be assigned for the next round';
comment on column fixtures.t1_pts is 'If a group game, then the number of points gained by team1 in this game';
comment on column fixtures.t2_pts is 'If a group game, then the number of points gained by team2 in this game';