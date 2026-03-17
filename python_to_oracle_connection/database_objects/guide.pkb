create or replace package body guide
as

    procedure pickup
    ( 
        i_name in varchar2, 
        i_species in varchar2, 
        i_poet in varchar2, 
        i_notes in varchar2,
        o_id out number
    )
    is
    begin
        insert into hitchhikers( being_name, species, is_poet, notes)
        values(i_name, upper(i_species), i_poet, i_notes )
        returning id into o_id;
    end;

    function hiker_count return pls_integer
    is
        v_rtn pls_integer;
    begin
        select count(*) 
        into v_rtn
        from hitchhikers;

        return v_rtn;
    end;
end;
/

