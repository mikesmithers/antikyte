-- R16

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('03-DEC-2022', 'DD-MON-YYYY'), 'WINNER_A', 'SECOND_B', 'WINNER_R16_1', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('03-DEC-2022', 'DD-MON-YYYY'), 'WINNER_C', 'SECOND_D', 'WINNER_R16_2', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('05-DEC-2022', 'DD-MON-YYYY'), 'WINNER_E', 'SECOND_F', 'WINNER_R16_3', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('05-DEC-2022', 'DD-MON-YYYY'), 'WINNER_G', 'SECOND_H', 'WINNER_R16_4', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('04-DEC-2022', 'DD-MON-YYYY'), 'WINNER_B', 'SECOND_A', 'WINNER_R16_5', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('04-DEC-2022', 'DD-MON-YYYY'), 'WINNER_D', 'SECOND_C', 'WINNER_R16_6', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('06-DEC-2022', 'DD-MON-YYYY'), 'WINNER_F', 'SECOND_E', 'WINNER_R16_7', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'R16', to_date('06-DEC-2022', 'DD-MON-YYYY'), 'WINNER_H', 'SECOND_G', 'WINNER_R16_8', null);

-- QF
insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'QF', to_date('09-DEC-2022', 'DD-MON-YYYY'), 'WINNER_R16_1', 'WINNER_R16_2', 'WINNER_QF_1', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'QF', to_date('09-DEC-2022', 'DD-MON-YYYY'), 'WINNER_R16_3', 'WINNER_R16_4', 'WINNER_QF_2', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'QF', to_date('10-DEC-2022', 'DD-MON-YYYY'), 'WINNER_R16_5', 'WINNER_R16_6', 'WINNER_QF_3', null);

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'QF', to_date('10-DEC-2022', 'DD-MON-YYYY'), 'WINNER_R16_7', 'WINNER_R16_8', 'WINNER_QF_4', null);

-- SF

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'SF', to_date('13-DEC-2022', 'DD-MON-YYYY'), 'WINNER_QF_1', 'WINNER_QF_2', 'WINNER_SF_1', 'LOSER_SF_1');

insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'SF', to_date('14-DEC-2022', 'DD-MON-YYYY'), 'WINNER_QF_3', 'WINNER_QF_4', 'WINNER_SF_2', 'LOSER_SF_2');

-- Final
insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'F', to_date('18-DEC-2022', 'DD-MON-YYYY'), 'WINNER_SF_1', 'WINNER_SF_2', null, null);

-- Third Place
insert into fixtures( stage_cid, match_date, t1_draw_cid, t2_draw_cid, winner_draw_cid, loser_draw_cid)
values( 'TPP', to_date('17-DEC-2022', 'DD-MON-YYYY'), 'LOSER_SF_1', 'LOSER_SF_2', null, null);

commit;
