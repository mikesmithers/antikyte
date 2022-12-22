create table match_event_types( 
    cid varchar2(25),
    event_name varchar2(50) not null,
    description varchar2(500),
    constraint match_event_types_pk primary key (cid))
/

comment on table match_event_types is 'Things that can happen in a match (e.g. Goals, Penalties, Cards)';

comment on column match_event_types.event_name is 'Short name for an event';
comment on column match_event_types.description is 'A long description of the event type';