clear screen
---- flush the buffer
--exec dbms_output.disable; 
--
---- Enable the buffer
--exec dbms_output.enable; 
--
--exec dbms_output.put_line('This is going to the buffer');

declare
    v_status integer;
    v_message varchar2(32767);
begin
    dbms_output.enable;
    dbms_output.put_line('This is going to the buffer');
    dbms_output.get_line( v_message, v_status);
    if v_status = 1 then
        dbms_output.put_line('No lines in the buffer');
    else
        dbms_output.put_line('Message in buffer : '||v_message);
    end if;
end;
/