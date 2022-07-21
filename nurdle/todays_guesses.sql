create global temporary table todays_guesses(
    guess_no number not null,
    letter varchar2(1) not null,
    pos_in_word number(1) not null,
    status varchar2(1) not null,
    constraint todays_guesses_status_chk check (status in ('B', 'Y', 'G')))
    on commit preserve rows
/    