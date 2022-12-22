create table match_events (
    id number generated always as identity,
    fix_id number not null,
    event_type_cid varchar2(25) not null,
    player_name varchar2(4000),
    player_team_cid varchar2(25),
    match_minute varchar2(25),
    constraint match_events_pk primary key (id),
    constraint match_events_fixtures_fk foreign key (fix_id) references fixtures( id),
    constraint match_events_match_event_types_fk foreign key (event_type_cid) references match_event_types(cid),
    constraint match_events_teams_fk foreign key( player_team_cid) references teams(cid))
/

comment on table match_events is 'What happened in a fixture - goals, cards etc';

comment on column match_events.match_minute is q'[The minute of the match in which the event took place. Defined as a varchar as the notation convention for soccer match time is to indicate added time at the end of a half with a "+" ( e.g. 45+2)]';
