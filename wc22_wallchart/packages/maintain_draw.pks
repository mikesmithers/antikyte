create or replace package maintain_draw
as
    procedure update_r16_draw( i_group in groups.cid%type);
    procedure validate_override( i_group in groups.cid%type);
    procedure update_other_ko( i_fix_id in fixtures.id%type);
end maintain_draw;
/
    