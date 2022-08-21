delete from public_holidays
where holiday_date = date '2022-05-30'
and holiday_name = 'SPRING BANK HOLIDAY';

insert into public_holidays( holiday_date, holiday_name, notes)
values(date '2022-06-02', 'SPRING BANK HOLIDAY', q'[Moved for the Queen's Platinum Jubilee]');

insert into public_holidays( holiday_date, holiday_name, notes)
values(date '2022-06-03', 'PLATINUM JUBILEE', q'[The Queen's Platinum Jubilee]');

commit;
