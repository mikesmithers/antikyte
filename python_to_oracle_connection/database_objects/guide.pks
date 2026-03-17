create or replace package guide
as
      procedure pickup
    ( 
        i_name in varchar2, 
        i_species in varchar2, 
        i_poet in varchar2, 
        i_notes in varchar2,
        o_id out number
    );
    function hiker_count return pls_integer;
end;
/
