create table public_holidays(
    holiday_date date constraint public_holidays_pk primary key,
    holiday_name varchar2(100) not null,
    notes varchar2(4000))
/

comment on table public_holidays is 'The dates of Public Holidays in England';
comment on column public_holidays.holiday_date is 'The date on which the holiday falls';
comment on column public_holidays.holiday_name is 'The name of this holiday (e.g. Spring Bank Holiday)';
comment on column public_holidays.notes is 'The reason for including this holiday date';

create or replace trigger public_holidays_bi_trg
    before insert on public_holidays
    for each row
begin
    :new.holiday_date := trunc(:new.holiday_date);
end;
/