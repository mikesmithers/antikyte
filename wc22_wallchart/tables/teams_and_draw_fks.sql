alter table teams add constraint teams_draw_fk foreign key (group_draw_cid) references draw(cid);
alter table draw add constraint draw_teams_fk foreign key (team_cid) references teams(cid);