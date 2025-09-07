clear screen

-- Flush the buffer so we don't pick up any stray messages from earlier in the session
exec dbms_output.disable; 

declare
    v_status integer;
    v_messages dbmsoutput_linesarray;
begin
    -- Enable the buffer
    dbms_output.enable;

    -- Put some messages into the buffer
    -- dbms_output.put_line('Enabled');
    for i in 1..5 loop
        dbms_output.put_line('Message '||i);
    end loop;
    
    -- Retrieve all of the messages in a single call
    dbms_output.get_lines( v_messages, v_status);
    
    -- the count of messages is one more than the actual number of messages
    -- in the buffer !
    dbms_output.put_line('Message array elements = '||v_messages.count);
    
    for j in 1..v_messages.count - 1 loop
    
        -- Output the messages retrieved from the buffer
        dbms_output.put_line(v_messages(j)||' read from buffer');
    end loop;
    dbms_output.put_line(q'[That's all folks !]');
end;
/