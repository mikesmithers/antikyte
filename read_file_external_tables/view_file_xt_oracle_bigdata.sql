--
-- A demo of creating an external table using the oracle_bigdata driver
--
drop table view_file_xt;
 
create table view_file_xt
(
    text clob
)
    organization external(
        type oracle_bigdata
        default directory incoming_files
        access parameters 
        (
            com.oracle.bigdata.fileformat=textfile
            com.oracle.bigdata.blankasnull=true
            com.oracle.bigdata.csv.rowformat.fields.terminator='\n'
            com.oracle.bigdata.ignoreblanklines=true
            com.oracle.bigdata.buffersize=2048
        ) 
        location('')
    )
    reject limit unlimited
/
