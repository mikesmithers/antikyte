create or replace procedure never_say_never( i_golden_rule in varchar2)
is
begin
    skippy.set_msg_group('WORDS_OF_WISDOM');
    skippy.log('Validating input');
    if i_golden_rule is null then
        raise_application_error(-20910, 'Must have a golden rule !');
    end if;

    if length(i_golden_rule) > 75 then
        raise_application_error(-20920, 'Golden rule must be more pithy !');
    end if;
    
    skippy.log('Input is valid. Processing...');
    skippy.log('Rule One - '||i_golden_rule);
    --
    -- Do something non-databasey here - send an email, start a scheduler job to run a shell script,
    -- print the golden rule on a tea-towel etc...
    --
    skippy.log('Rule Two - there are exceptions to EVERY rule');
exception when others then 
    skippy.err;
    raise;
end;
/