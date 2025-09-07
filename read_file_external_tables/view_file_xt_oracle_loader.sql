drop table view_file_xt;
 
create table view_file_xt
(
    line number,
    text clob
)
organization external
(
    type oracle_loader
    default directory incoming_files
    access parameters 
    (
        records delimited by newline
        nologfile
        nobadfile
        nodiscardfile
        fields terminated by '~'
        missing field values are null
        (
                line recnum,
                text char(2097152)
        )
    ) 
    location('')
)
reject limit unlimited
/