create table teams (
    cid varchar2(25),
    team_name varchar2(500) not null,
    confederation varchar2(100),
    ranking number not null,
    seeded varchar2(1) not null,
    group_cid varchar2(1) not null,
    group_draw_cid varchar2(25) not null,
    constraint teams_pk primary key (cid),
    constraint teams_seeded_yn_chk check (seeded in ('Y', 'N')),
    constraint teams_groups_fk foreign key (group_cid) references groups(cid))
/

comment on table teams is 'The teams that have qualified for the tournament';

comment on column teams.cid is 'Unique identifier for a Team. This is the FIFA trigram. See https://en.wikipedia.org/wiki/List_of_FIFA_country_codes';
comment on column teams.team_name is 'The full name of the team';
comment on column teams.confederation is 'The Confederation to which the team is affiliated. There are seven regional confederations affiliated to FIFA';
comment on column teams.ranking is 'The official FIFA world ranking for the team at the start of the tournament';
comment on column teams.group_cid is 'The group in which the team is drawn';
comment on column teams.group_draw_cid is 'The draw identifier within the group. Used to generate the group fixtures and save me typing !';