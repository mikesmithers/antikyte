create or replace package never_say_never_ut
as

    --%suite(Words of Wisdom)
     
    --%test( no parameter value)
    procedure no_parameter_value;
    
    --%test( parameter_too_long)
    procedure parameter_too_long;
    
    --%test( valid parameter)
    procedure valid_parameter;
end;
/
