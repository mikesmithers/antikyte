create or replace package generate_jnl_trigger 
    authid current_user
as
    procedure build_trigger(
        i_base_table in varchar2,
        i_jnl_table in varchar2 default null,
        i_trigger_name in varchar2 default null,
        i_canonicalize_cols in varchar2 default null);
end;
/