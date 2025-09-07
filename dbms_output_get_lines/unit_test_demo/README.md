There are two versions of the code for the procedure we're testing :
- never_say_never.prc - includes dbms_output statements
- never_say_never_skippy.prc - uses Skippy logging instead

Similarly, there are two versions of the unit test package body :
- never_say_never_ut.pkb 
- never_say_never_ut_skippy.pkb - uses skippy to access the log messages

To run these examples you will need to install :
- [the Skippy logging framework](https://github.com/mikesmithers/skippy)
- [the utPLSQL 3x testing framework](https://www.utplsql.org/utPLSQL/v3.1.14/)