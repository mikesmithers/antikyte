create or replace package maintain_public_holidays
as
    function calculate_easter( i_year in number default null) return date;
    procedure add_standard_holidays( i_year in number);
    procedure generate_schedule;
end;
/