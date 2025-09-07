create or replace package body never_say_never_ut
as

    -- no parameter value
    procedure no_parameter_value
    is
    begin
        never_say_never(null);
        ut.fail('Expected ORA-20910 but no error raised');
    exception when others then
        ut.expect(sqlcode).to_equal(-20910);
    end;    
        
    
    --%test( parameter_too_long)
    procedure parameter_too_long
    is
    begin
        never_say_never('you definitely do not want to ... rely only on the built-in to get the job done');
        ut.fail('Expected ORA-20920 but no error raised');
    exception when others then
        ut.expect(sqlcode).to_equal(-20920);
    end;
    
    --%test( valid parameter)
    procedure valid_parameter
    is
        c_expected constant varchar2(75) := 'Rule Two - there are exceptions to EVERY rule';
        v_messages dbmsoutput_linesarray;
        v_status number;
    begin
        -- Setup
       
        -- flush the buffer
        dbms_output.disable;
        -- enable the buffer
        dbms_output.enable;
        -- Turn on logging output
        skippy.enable_output;
        
        -- Execute
        never_say_never('I am never wrong');        
        
        -- Validate
        dbms_output.get_lines(v_messages, v_status);
        
        ut.expect(v_messages(v_messages.count - 1)).to_equal(c_expected);
        
        -- Teardown
        skippy.disable_output;
        
    exception when others then
        ut.fail(sqlerrm);
    end;
end;
/
