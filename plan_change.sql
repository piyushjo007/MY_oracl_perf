Clear break
set pages 50 lines 300
col dt form a15
col EXECUTIONS format 999,999,999,999
select
                b.SQL_ID,
                b.PLAN_HASH_VALUE,
                b.snap_id, 
                to_char(a.BEGIN_INTERVAL_TIME,'DD-MON-YY HH24:MI') dt,
                sum(b.EXECUTIONS_DELTA)  "EXECUTIONS",
                round(sum(b.CPU_TIME_DELTA) /1000000,2) "CPU_TIME",
                round((sum(b.CPU_TIME_DELTA) /1000)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "CPUms/Exec",
                round(sum(b.ELAPSED_TIME_DELTA) /1000000,2) "ELAPSED_TIME",
                round((sum(b.ELAPSED_TIME_DELTA )/1000)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "ET(ms)/Exec",
                sum(b.BUFFER_GETS_DELTA ) "BUFFER_GETS",
                round(sum(b.BUFFER_GETS_DELTA)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "BGETS/Exec",
                round((sum(b.IOWAIT_DELTA )/1000)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "IO(ms)/Exec",
                round((sum(b.APWAIT_DELTA )/1000)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "APP(ms)/Exec",
                round((sum(b.CCWAIT_DELTA )/1000)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "CC(ms)/Exec",
                sum(b.DISK_READS_DELTA)   "DISK_READS",
                round(sum(b.DISK_READS_DELTA)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "DISK_READs/Exec",
                sum(b.rows_processed_delta) "ROWS_Procs",
                round(sum(b.rows_processed_delta)/sum(decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA)) ,2) "ROWS_PPRO/Exec",
                SHARABLE_MEM/1024/1024 SHARABLE_MEM_MB,LOADED_VERSIONS,
                sum(b.PARSE_CALLS_DELTA) "Parses",VERSION_COUNT
from
                sys.DBA_HIST_SQLSTAT b, sys.dba_hist_snapshot a
where sql_id = '&1'
AND   a.DBID = b.dbid
AND   a.INSTANCE_NUMBER = b.INSTANCE_NUMBER
and   a.SNAP_ID = b.SNAP_ID 
and   a.END_INTERVAL_TIME >= (sysdate - &2)
and   a.END_INTERVAL_TIME <= (sysdate - &3)
and   decode(b.EXECUTIONS_DELTA,0,1,b.EXECUTIONS_DELTA) > 0
group by b.SQL_ID,b.PLAN_HASH_VALUE,to_char(a.BEGIN_INTERVAL_TIME,'DD-MON-YY HH24:MI'),b.snap_id,VERSION_COUNT,SHARABLE_MEM,LOADED_VERSIONS
order by        b.snap_id                       
/
