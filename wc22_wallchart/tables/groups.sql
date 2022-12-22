create table groups ( cid varchar2(1) constraint group_pk primary key)
organization index
/    

comment on table groups is 'A list of the identifying letters for each Group in the Group Stage';

alter table groups add winner_draw_cid varchar2(25);
alter table groups add second_draw_cid varchar2(25);


alter table groups add constraint groups_winner_draw_fk foreign key (winner_draw_cid) references draw(cid);
alter table groups add constraint groups_second_draw_fk foreign key (second_draw_cid) references draw(cid);