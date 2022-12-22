insert into match_event_types ( cid, event_name, description)
values('GOAL', 'Goal', 'Goal scored from open play');

insert into match_event_types ( cid, event_name, description)
values('ASSIST', 'Assist', 'Assist for a goal. Used as a tie-breaker in Golden Boot standings');

insert into match_event_types ( cid, event_name, description)
values('OG', 'Own-Goal', null);

insert into match_event_types ( cid, event_name, description)
values('PEN_SCORED', 'Penalty Scored', 'Goal scored from a penalty during the match (not in a shootout)');

insert into match_event_types ( cid, event_name, description)
values('PEN_MISSED', 'Missed Penalty', 'Penalty missed during the match (not in a shootout)');

insert into match_event_types ( cid, event_name, description)
values('YELLOW', 'Caution', 'The first caution in the match for a player');

insert into match_event_types ( cid, event_name, description)
values('SECOND_YELLOW', 'Second Yellow', 'Second caution in the match - player is sent off');

insert into match_event_types ( cid, event_name, description)
values('RED', 'Straight Red', 'A player is sent-off for a serious offence');

commit;
