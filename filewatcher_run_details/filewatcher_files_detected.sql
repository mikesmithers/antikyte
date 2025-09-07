select
    t.step_no,
    treat( t.user_data as sys.scheduler_filewatcher_result).actual_file_name as filename,
    treat( t.user_data as sys.scheduler_filewatcher_result).file_size as file_size,
    treat( t.user_data as sys.scheduler_filewatcher_result).file_timestamp as file_ts,
    t.enq_time,
    x.name as filewatcher,
    x.requested_file_name as search_pattern,
    x.credential_name as credential_name
from sys.scheduler_filewatcher_qt t,
    table(t.user_data.matching_requests) x
where enq_time > trunc(sysdate)
order by enq_time
/