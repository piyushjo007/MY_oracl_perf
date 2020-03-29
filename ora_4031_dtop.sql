set echo off
set feedback off

column timecol new_value timestamp
column spool_extension new_value suffix
select to_char(sysdate,'Mondd_hh24mi') timecol,
'.out' spool_extension from sys.dual;
column output new_value dbname
select value || '_' output
from v$parameter where name = 'db_name';
REM SPOOLING FILE
spool ora_4030_&&dbname&&timestamp&&suffix
set trim on
set trims on
set lines 300
set pages 3000
set verify off
PROMPT 
select to_char(sysdate, 'dd-MON-yyyy hh24:mi:ss') "Script Run TimeStamp" from dual;
PROMPT 
select to_char(startup_time, 'dd-MON-yyyy hh24:mi:ss') "Startup Time" from v$instance;
PROMPT 

PROMPT ORA- 4031 DIAGNOSTICS FOR &&dbname&&timestamp
PROMPT 
PROMPT Lists of regular and hidden parameters that indicate how the SGA is configured.
REM
REM
REM  GATHER PARAMETER SPECIFIC TO SHARED POOL / SGA TUNING
REM
REM ======================================================================
REM SGAparameter.sql
PROMPT SGA configuration information and parameters affecting the SGA.
PROMPT  _______________________________________________________________
PROMPT 
set lines 120
set pages 999
clear col
set trimout on
set trimspool on
PROMPT 
col "Setting" format 999,999,999,999
col "MBytes" format 999,999
col lifetime format a40 heading "Database Started Last"
select to_char(startup_time, 'dd-Mon-yyyy hh24:mi:ss') Lifetime from v$instance;
PROMPT 
PROMPT 
select 'Shared Pool Size'||':  '||decode(value,null,-1,value) "Setting"
   ,(value/1024/1024) "MBytes"
from v$parameter where name='shared_pool_size'
union
select 'Shared Pool Reserved Area'||':  '||decode(value,null,-1,value) "Setting"
   ,(value/1024/1024) "MBytes"
from v$parameter where name='shared_pool_reserved_size'
union
select 'Log Buffer'||':  '||decode(value,null,-1,value) "Setting"
   ,(value/1024/1024) "MBytes"
from v$parameter where name='log_buffer'
union
select 'Streams Pool Size'||':  '||decode(value,null,-1,value) "Setting"
   ,(value/1024/1024) "MBytes"
from v$parameter where name='streams_pool_size'
union
select 'Buffer Cache'||':  '||decode(value,null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_cache_size'
union
select 'Recycle Cache'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_recycle_cache_size'
union
select 'Keep Cache'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_keep_cache_size'
union
select '2K Cache'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_2k_cache_size'
union
select '4K Cache'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_4k_cache_size'
union
select '8K Cache'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_8k_cache_size'
union
select '16K Cache'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_16k_cache_size'
union
select '32K Cache'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='db_32k_cache_size'
union
select 'Large Pool Size'||':  '||decode(value,null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='large_pool_size'
union
select 'Java Pool Size'||':  '||decode(value,null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='java_pool_size'
union
select 'SGA Max'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='sga_max_size'
union
select 'SGA Target'||':  '|| decode(value, null,-1,value) "Setting" 
   ,(value/1024/1024) "MBytes"
from v$parameter where name='sga_target'
order by 1
/
PROMPT 
col Setting format 999,999,99
PROMPT 
select 'Session Cached Cursors'||':  '|| decode(value, null,-1,value) "Setting" 
from v$parameter where name='session_cached_cursors'
union
select 'Open Cursors'||':  '||decode(value,null,-1,value) "Setting" 
from v$parameter where name='open_cursors'
union
select 'Processes'||':  '||decode(value,null,-1,value) "Setting" 
from v$parameter where name='processes'
union
select 'Sessions'||':  '||decode(value,null,-1,value) "Setting" 
from v$parameter where name='sessions'
union
select 'DB Files'||':  '||decode(value,null,-1,value) "Setting" 
from v$parameter where name='db_files'
union
select 'Shared Server (MTS)'||':  '||decode(value,null,-1,value) "Setting" 
from v$parameter where name='shared_server'
order by 1
/
PROMPT 
PROMPT 
col Setting format a30
PROMPT 
select 'Cursor Sharing'||':  '|| value "Setting" 
from v$parameter where name='cursor_sharing'
union
select 'Query Rewrite'||':  '||value "Setting" 
from v$parameter where name='query_rewrite_enabled'
union
select 'Statistics Level'||':  '||value "Setting" 
from v$parameter where name='statistics_level'
union
select 'Cache Advice'||':  '||value "Setting" 
from v$parameter where name='db_cache_advice'
union
select 'Compatible'||':  '||value "Setting" 
from v$parameter where name='compatible'
order by 1
/
PROMPT 
col resource_name format a25 head "Resource"
col current_utilization format 999,999,999,999 head "Current"
col max_utilization format 999,999,999,999 head "HWM"
col intl format a15 head "Setting"

select resource_name, current_utilization, max_utilization, initial_allocation intl
from v$resource_limit
where resource_name in ('processes', 'sessions','enqueue_locks','enqueue_resources',
   'ges_procs','ges_ress','ges_locks','ges_cache_ress','ges_reg_msgs',
   'ges_big_msgs','ges_rsv_msgs','gcs_resources','dml_locks','max_shared_servers')
/
PROMPT 
col Parameter format a35 wrap
col "Session Value" format a25 wrapped
col "Instance Value" format a25 wrapped
PROMPT 
select  a.ksppinm  "Parameter",
             b.ksppstvl "Session Value",
             c.ksppstvl "Instance Value"
      from x$ksppi a, x$ksppcv b, x$ksppsv c
     where a.indx = b.indx and a.indx = c.indx
       and a.ksppinm in ('_kghdsidx_count','__shared_pool_size','__streams_pool_size',
         '__db_cache_size','__java_pool_size','__large_pool_size', '_PX_use_large_pool', 
         '_large_pool_min_alloc','_shared_pool_reserved_min','_shared_pool_reserved_min_alloc',
         '_shared_pool_reserved_pct','_4031_dump_bitvec','4031_dump_interval',
         '_4031_max_dumps','4031_sga_dump_interval','4031_sga_max_dumps', '_kill_java_threads_on_eoc',
         '_optim_peek_user_binds','_px_bind_peek_sharing','event','_kgl_heap_size',
         '_library_cache_advice','_io_shared_pool_size','_NUMA_pool_size')
order by 1;
REM ======================================================================
REM SGAcomponenets.sql
REM  Investigate SGA components
set lines 132
set pages 999
set trimout on
set trimspool on
PROMPT 
PROMPT ANALYSIS ON THE AUTO-TUNED COMPONENTS IN THE SGA AND SHOWS ACTIVITY MOVING MEMORY AROUND IN THE SGA.
PROMPT  ___________________________________________________________________________________________________
PROMPT 
col component for a25 head "Component"
col status format a10 head "Status"
col initial_size for 999,999,999,999 head "Initial"
col parameter for a25 heading "Parameter"
col final_size for 999,999,999,999 head "Final"
col changed head "Changed At"
col user_specified_size for 999,999,999,999 head "Explicit Setting"
col current_size for 999,999,999,999 head "Current Size"
col min_size for 999,999,999,999 head "Min Size"
col max_size for 999,999,999,999 head "Max Size"
col granule_size for 999,999,999,999 head "Granule Size" 
break on report
compute sum of current_size on report 
select component, user_specified_size, current_size, min_size, max_size, granule_size
from v$sga_dynamic_components
/
PROMPT 
col last_oper_type for a15   head "Operation|Type"
col last_oper_mode for a15  head "Operation|Mode"
col lasttime for a25 head "Timestamp"
PROMPT SGA_DYNAMIC_COMPONENTS
PROMPT  ______________________
select component, last_oper_type, last_oper_mode, 
  to_char(last_oper_time, 'mm/dd/yyyy hh24:mi:ss') lasttime
from v$sga_dynamic_components
/
PROMPT 
PROMPT SGA_RESIZE_OPS
PROMPT  ______________________
select component, parameter, initial_size, final_size, status, 
to_char(end_time ,'mm/dd/yyyy hh24:mi:ss') changed
from v$sga_resize_ops
/
PROMPT 
PROMPT These values tend to help find explicit (minimum settings)
PROMPT for the components to help auto-tuning
PROMPT steer clear of over-aggressive moving of memory
PROMPT withing the SGA
PROMPT 
col low format 999,999,999,999 head "Lowest"
col high format 999,999,999,999 head "Highest"
col lowMB format 999,999 head "MBytes"
col highMB format 999,999 head "MBytes"
select component, min(final_size) low, (min(final_size/1024/1024)) lowMB,
max(final_size) high, (max(final_size/1024/1024)) highMB
from v$sga_resize_ops
group by component
/
PROMPT 
PROMPT 
clear breaks
PROMPT 
col name format a40 head "Name"
col resizeable format a4 head "Auto?"
PROMPT sgainfo
PROMPT __________
select * from v$sgainfo
/
set trimout off
set trimspool off
clear col
REM ======================================================================
REM CursorEfficiency.sql
PROMPT
PROMPT CURSOR_EFFICIENCY
PROMPT HWM information on cursor usage and cached cursor information.  
PROMPT  _____________________________________________________________
PROMPT This will help in determining if OPEN_CURSORS and SESSION_CACHED_CURSORS are over or under allocated.
PROMPT 
col "parameter" format a30 head "Init Parameter"
col value format 999,999,999,999 Head "Limit" 
col usage head "Max|Usage" 
select
  'session_cached_cursors'  parameter,
  lpad(value, 5)  value,
  decode(value, 0, '  n/a', to_char(100 * used / value, '990') || '%')  usage
from
  ( select
      max(s.value)  used
    from
      v$statname  n,
      v$sesstat  s
    where
      n.name = 'session cursor cache count' and
      s.statistic# = n.statistic#
  ),
  ( select
      value
    from
      v$parameter
    where
      name = 'session_cached_cursors'
  )
union all
select
  'open_cursors',
  lpad(value, 5),
  to_char(100 * used / value,  '990') || '%'
from
  ( select
      max(sum(s.value))  used
    from
      v$statname  n,
      v$sesstat  s
    where
      n.name in ('opened cursors current') and
      s.statistic# = n.statistic#
    group by
      s.sid
  ),
  ( select
      value
    from
      v$parameter
    where
      name = 'open_cursors'
  );
PROMPT 
REM ======================================================================
REM SGAStat.sql
PROMPT SGASTATS
PROMPT  _________
PROMPT COMPONENETS HAVING MORE THAN 10 PERCENT OF SHARED POOL OF SPACE IN SHARED POOL :
PROMPT  ________________________________________________________________________________
PROMPT 
set lines 100
set pages 9999
col mb format 999,999
col name heading "Name"

select name, round((bytes/1024/1024),0) MB 
from v$sgastat where pool='shared pool' 
and bytes > (select BYTES/10 from v$sgainfo where Name='Streams Pool Size')
order by bytes desc
/
clear breaks
PROMPT 
REM ====================================================
PROMPT
PROMPT
PROMPT SHARED_POOL ADVISORY 
PROMPT  _____________________ 
set lines 300
col shared_pool_size_for_estimate format 999,999,999,999 head "Shared Pool Size (MB)"
col shared_pool_size_factor head "Size Factor"
col estd_lc_memory_object_hits format 999,999,999,999 head "Estimated Hits in Library Cache"
col estd_lc_size format 999,999,999,999 head "Estimate of LC Size"
col estd_lc_memory_objects format 999,999,999,999 head "Estimate of objects in LC"
select 
shared_pool_size_for_estimate, 
shared_pool_size_factor,
estd_lc_memory_object_hits,
estd_lc_size, estd_lc_memory_objects
from v$shared_pool_advice
order by shared_pool_size_factor
/
REM ======================================================================
REM ReservedAnalysis.sql
PROMPT 												RESERVED POOL ANALYSIS 
PROMPT  _______________________________________________________________________________________________________________________________________
PROMPT memory chunk stress in the Shared Pool
PROMPT Large memory misses in the Shared Pool will be attemped in the Reserved Area. Another failure in the Reserved Area causes an 4031 error
PROMPT   
PROMPT  
PROMPT   					What should you look for?
PROMPT   Reserved Pool Misses = 0 can mean the Reserved Area is too big.  Reserved Pool Misses always increasing but "Shared Pool Misses" not 
PROMPT  increasing can mean the Reserved Area is too small.  In this case flushes in the Shared Pool satisfied the memory needs and a 4031 was not 
PROMPT   actually reported to the user.  Reserved Area Misses and "Shared Pool Misses" always increasing can mean the Reserved Area is too small 
PROMPT   and flushes in the Shared Pool are not helping (likely got an ORA-04031). 
PROMPT
PROMPT	 Failed Size small can indicate fragmentation issues in the Shared Pool.
PROMPT  ________________________________________________________________________
PROMPT
PROMPT
clear col
set lines 100
set pages 999
set termout off
set trimout on
set trimspool on
col free_space format 999,999,999,999 head "Reserved|Free Space"
col max_free_size format 999,999,999,999 head "Reserved|Max"
col avg_free_size format 999,999,999,999 head "Reserved|Avg"
col used_space format 999,999,999,999 head "Reserved|Used"
col requests format 999,999,999,999 head "Total|Requests"
col request_misses format 999,999,999,999 head "Reserved|Area|Misses"
col last_miss_size format 999,999,999,999 head "Size of|Last Miss" 
col request_failures format 9,999 head "Shared|Pool|Miss"
col last_failure_size format 999,999,999,999 head "Failed|Size"
select request_failures, last_failure_size, free_space, max_free_size, avg_free_size
from v$shared_pool_reserved
/
PROMPT 
PROMPT 
select used_space, requests, request_misses, last_miss_size
from v$shared_pool_reserved
/
PROMPT 
PROMPT
PROMPT Look at the breakdown of chunks for more detail on fragmentation.
PROMPT
PROMPT 
col average format 999,999.99
col maximum format 999,999
PROMPT 
select alloc_class, avg(chunk_size) average, max(chunk_size) maximum
from v$sql_shared_memory group by alloc_class
/
clear col
REM ======================================================================
REM LibCacheOverview.sql  -- shows general overview information about the Shared Pool and the Library Cache usage.  
PROMPT
PROMPT			 Library Cache Analysis
PROMPT  __________________________________________
PROMPT Library Cache usage.
set pagesize 999
set lines 70
set verify off
set heading off
set feedback off
PROMPT 
col start_up format a45 justify right
col sp_size     format          999,999,999 justify right
col x_sp_used   format          999,999,999 justify right
col sp_used_shr format          999,999,999 justify right
col sp_used_per format          999,999,999 justify right
col sp_used_run format          999,999,999 justify right
col sp_avail    format          999,999,999 justify right
col sp_sz_pins format           999,999,999 justify right
col sp_no_pins format           999,999 justify right
col sp_no_obj format            999,999 justify right
col sp_no_stmts format          999,999 justify right
col sp_sz_kept_chks format      999,999,999 justify right
col sp_no_kept_chks format      999,999 justify right
col 1time_sum_pct     format      999 justify right
col 1time_ttl_pct   format        999 justify right
col ltime_ttl     format   999,999,999 justify right
col 1time_sum     format      999,999,999,999 justify right
col tot_lc format  999,999,999,999 justify right
col sp_free format 999,999,999,999 justify right 
col val1 new_val x_sgasize noprint
col val2 new_val x_sp_size noprint
col val3 new_val x_lp_size noprint
col val4 new_val x_jp_size noprint
col val5 new_val x_bc_size noprint
col val6 new_val x_other_size noprint
col val7 new_val x_str_size noprint
col val8 new_val x_KGH noprint
select val1, val2, val3, val4, val5, val6, val7, val8
from (select sum(bytes) val1 from v$sgastat) s1,
    (select nvl(sum(bytes),0) val2 from v$sgastat where pool='shared pool') s2,
    (select nvl(sum(bytes),0) val3 from v$sgastat where pool='large pool') s3,
    (select nvl(sum(bytes),0) val4 from v$sgastat where pool='java pool') s4,
    (select nvl(sum(bytes),0) val5 from v$sgastat where name='buffer_cache') s5,
    (select nvl(sum(bytes),0) val6 from v$sgastat where name in ('log_buffer','fixed_sga')) s6,
    (select nvl(sum(bytes),0) val7 from v$sgastat where pool='streams pool') s7,
    (select nvl(sum(bytes),0) val8 from v$sgastat where pool='shared pool' and name='KGH: NO ACCESS') s8; 
col val1 new_val x_sp_used noprint
col val2 new_val x_sp_used_shr noprint
col val3 new_val x_sp_used_per noprint
col val4 new_val x_sp_used_run noprint
col val5 new_val x_sp_no_stmts noprint
col val6 new_val x_sp_vers noprint
select sum(sharable_mem+persistent_mem+runtime_mem) val1,
            sum(sharable_mem) val2, sum(runtime_mem) val4, sum(persistent_mem) val3,
            count(*) val5, max(version_count) val6
from   v$sqlarea; 
col val1 new_val x_1time_sum noprint
col val2 new_val x_1time_ttl noprint
select sum(sharable_mem+persistent_mem+runtime_mem) val1,
   count(*) val2
from   v$sqlarea
where executions=1; 
col val1 new_val x_ra noprint
select round(nvl((used_space+free_space),0),2) val1
from v$shared_pool_reserved; 
col val2 new_val x_sp_no_obj noprint
select count(*) val2 from v$db_object_cache;  
col val2 new_val x_sp_no_kept_chks noprint
col val3 new_val x_sp_sz_kept_chks noprint
select decode(count(*),'',0,count(*)) val2,
       decode(sum(sharable_mem),'',0,sum(sharable_mem)) val3
from   v$db_object_cache
where  kept='YES'; 
col val2 new_val x_sp_free_chks noprint
select sum(bytes) val2 from v$sgastat
where name='free memory' and pool='shared pool'; 
col val2 new_val x_sp_no_pins noprint
select count(*) val2
from v$session a, v$sqltext b
where a.sql_address||a.sql_hash_value = b.address||b.hash_value; 
col val2 new_val x_sp_sz_pins noprint
select sum(sharable_mem+persistent_mem+runtime_mem) val2
from   v$session a,
       v$sqltext b,
       v$sqlarea c
where  a.sql_address||a.sql_hash_value = b.address||b.hash_value and
       b.address||b.hash_value = c.address||c.hash_value; 
col val3 new_val x_tot_lc noprint
select nvl(sum(lc_inuse_memory_size)+sum(lc_freeable_memory_size),0) val3 
from v$library_cache_memory;
col val2 new_val x_sp_avail noprint
select &x_sp_size-(&x_tot_lc*1024*1024)-&x_sp_used val2
from   dual;
col val2 new_val x_sp_other noprint
select &x_sp_size-(&x_tot_lc*1024*1024) val2 
from dual;
PROMPT 
col val1 new_val x_trend_4031 noprint
col val2 new_val x_trend_size noprint
col val3 new_val x_trend_rS noprint
col val4 new_val x_trend_rs_size noprint
select request_misses val1,
decode(request_misses,0,0,last_Miss_Size) val2,
request_failures val3,
decode(request_failures,0,0,last_failure_size) val4
from v$shared_pool_reserved; 
set termout on
set heading off
PROMPT 
ttitle -
  center  'SGA/Shared Pool Breakdown'  skip 2
select  ' *** If database started recently, this data is not as useful ***',
       '                                    ',
        'Database Started:  '||to_char(startup_time, 'Mon/dd/yyyy hh24:mi:ss') start_up,
        'Instance Name/No:     '||instance_name||'-'||instance_number,
       '                                    ',
        'Breakdown of SGA           '||round((&x_sgasize/1024/1024),2)||'M   ',
        '   Shared Pool Size          : '
               ||round((&x_sp_size/1024/1024),2)||'M ('
                  ||round((&x_sp_size/&x_sgasize)*100,0)||'%)  Reserved ' 
                ||round((&x_ra/1024/1024),2)||'M ('
                ||round((&x_ra/&x_sp_size)*100,0)||'%)' sp_size,
        '   Large Pool                       : '||round((&x_lp_size/1024/1024),2)||'M ('
             ||round((&x_lp_size/&x_sgasize)*100,0)||'%)',
        '   Java Pool                        : '||round((&x_jp_size/1024/1024),2)||'M ('
             ||round((&x_jp_size/&x_sgasize)*100,0)||'%)',
        '   Buffer Cache                     : '||round((&x_bc_size/1024/1024),2)||'M ('
             ||round((&x_bc_size/&x_sgasize)*100,0)||'%)',
        '   Streams Pool                     : '||round((&x_str_size/1024/1024),2)||'M ('
             ||round((&x_str_size/&x_sgasize)*100,0)||'%)',
        '   Other Areas in SGA               : '||round((&x_other_size/1024/1024),2)||'M ('
             ||round((&x_other_size/&x_sgasize)*100,0)||'%)',
        '                                    ',
        ' *** High level breakdown of memory ***',
        '                                    ',
        '     sharable                      :  '
                ||round((&x_sp_used_shr/1024/1024),2)||'M' sp_used_shr,
        '     persistent                    :  '
                ||round((&x_sp_used_per/1024/1024),2)||'M' sp_used_per,
        '     runtime                       :  '
                ||round((&x_sp_used_run/1024/1024),2)||'M' sp_used_run,
        '                                    ',
        'SQL Memory Usage (total)                     : '
                ||round((&x_sp_used/1024/1024),2)||'M ('
                ||round((&x_sp_used/&x_sp_size)*100,0)||'%)',
        '                                    ',
        ' *** No guidelines on SQL in Library Cache, but if ***',
        ' *** pinning a lot of code--may need larger Shared Pool ***',
        '                                    ',
       '# of SQL statements                : '
                ||&x_sp_no_stmts sp_no_stmts,
       '# of pinned SQL statements         : '
                ||&x_sp_no_pins sp_no_pins,
       '# of programmatic constructs       : '
                ||&x_sp_no_obj sp_no_obj,
       '# of pinned programmatic construct : '
                ||&x_sp_no_kept_chks sp_no_kept_chks,
        '                                    ',
        'Efficiency Analysis:                     ',
       ' *** High versions (100s) could be bug ***',
        '                                    ',
        '  Max Child Cursors Found                              : '||&x_sp_vers,
        '  Programmatic construct memory size (Kept)            : '
                ||round((&x_sp_sz_kept_chks/1024/1024),2)||'M' sp_sz_kept_chks,
        '  Pinned SQL statements memory size (active sessions)  : '
                ||round((&x_sp_sz_pins/1024/1024),2)||'M' sp_sz_pins,
        '                                    ',
        ' *** LC at 50% or 60% of Shared Pool not uncommon ***',
        '                                    ',
        '  Estimated Total Library Cache Memory Usage  : '||&x_tot_lc||'M ('||
               100*(round(((&x_tot_lc) / (&x_sp_size/1024/1024)),2))||'%)' perc_lc,       
        '  Other Shared Pool Memory                    : '||
                round((&x_sp_other/1024/1024),2)||'M',
        '  Shared Pool Free Memory Chunks              : '||
                round(((&x_sp_free_chks) /1024/1024),2)||'M ('||
                100*(round((&x_sp_free_chks / &x_sp_size),2))||'%)' perc_free,
        '                                    ',
        ' ****Ideal percentages for 1 time executions is 20% or lower****     ',
        '                                    ',
        '  # of objects executed only 1 time           : '||&x_1time_ttl||' ('||
                100*round(((&x_1time_ttl / &x_sp_no_stmts)),2)||'%)',
        '  Memory for 1 time executions:               : '||
                round((&x_1time_sum/1024/1024),2)||'M ('||
                100*round(((&x_1time_sum / &x_sp_used)),2)||'%)',
        '                                    ',
        '  ***If these chunks are growing, SGA_TARGET may be too low***',
        '                                    ',
        '  Current KGH: NO ACCESS Allocations:  '||round((&x_KGH/1024/1024),2)||'M ('
             ||100*round((&x_KGH/&x_sp_size),2)||'%)',
        '                                    ',
        ' ***0 misses is ideal, but if growing value points to memory issues***',
        '                                    ',
        '  # Of Misses for memory                      : '|| &x_trend_rs,
        '  Size of last miss                           : '|| &x_trend_rs_size,
        '  # Of Misses for Reserved Area               : '|| &x_trend_4031,
        '  Size of last miss Reserved Area             : '|| &x_trend_size
from    v$instance;
PROMPT 
ttitle off
set heading on 
set feedback on
clear col
PROMPT 
REM ======================================================================
REM 
REM  Filename: LCObjectsStats.sql
REM
PROMPT  LIBRARY CACHE OBJECT STATS
PROMPT  ________________________________
PROMPT   This will breakdown the pinned and non-pinned objects in the library cache and sum up the memory required
PROMPT   for each type of object
PROMPT
PROMPT    If you see large objects listed that are not pinned, they can cause fragmentation over time if they get
PROMPT    flushed out and reloaded.
REM
REM    Runs on 8i/9i/9.2/10g
PROMPT 
col kept format a5
col type format a40
col memory format 999,999,999,999,999 
select kept, type, sum(sharable_mem) memory
from v$db_object_cache
group by kept, type
order by 1, 3 desc;
REM ======================================================================
PROMPT  SHARED POOL'S SUB POOLS AND SUB-SUB POOL UTILIZATIONS
PROMPT  ______________________________________________________
PROMPT
PROMPT Starting with 9i The Shared Pool divide its shared memory areas into subpools. Each subpool 
PROMPT will have Free List Buckets (containing pointers to memory chunks within the subpool ) and ,
PROMPT memory structure entries, and LRU list. 
PROMPT
PROMPT Number of sub pools and their utilizations 
PROMPT  _________________________________________
PROMPT 
select child#, gets
from v$latch_children
where name = 'shared pool'
order by child#;
PROMPT 
PROMPT Free memory segments counts in each pool for memory fragmentation
set lines 300
select KSMCHIDX "SubPool", 'sga heap('||KSMCHIDX||',0)'sga_heap,ksmchcom ChunkComment,
decode(round(ksmchsiz/1000),0,'0-1K', 1,'1-2K', 2,'2-3K',3,'3-4K',
4,'4-5K',5,'5-6k',6,'6-7k',7,'7-8k',8,
'8-9k', 9,'9-10k','> 10K') "size",
count(*),ksmchcls Status, sum(ksmchsiz) Bytes
from x$ksmsp
where KSMCHCOM = 'free memory'
group by ksmchidx, ksmchcls,
'sga heap('||KSMCHIDX||',0)',ksmchcom, ksmchcls,decode(round(ksmchsiz/1000),0,'0-1K',
 1,'1-2K', 2,'2-3K', 3,'3-4K',4,'4-5K',5,'5-6k',6,
 '6-7k',7,'7-8k',8,'8-9k', 9,'9-10k','> 10K') 
 order by 1;
 PROMPT 
 PROMPT 
PROMPT If you see lack of large chunks it is possible that you can face with ORA-04031 in near future.
PROMPT  ________________________________________________________________________________________________
PROMPT
PROMPT 		Use below query to check it the large chunks utilization is intermittent
PROMPT  _________________________________________________________________________________________________
PROMPT
PROMPT
PROMPT « select KSMCHIDX "SubPool", 'sga heap('||KSMCHIDX||',0)'sga_heap,ksmchcom ChunkComment,
PROMPT « decode(round(ksmchsiz/1000),0,'0-1K', 1,'1-2K', 2,'2-3K',3,'3-4K',
PROMPT « 4,'4-5K',5,'5-6k',6,'6-7k',7,'7-8k',8,
PROMPT «	 '8-9k', 9,'9-10k','> 10K') "size",
PROMPT «	count(*),ksmchcls Status, sum(ksmchsiz) Bytes
PROMPT «	from x$ksmsp
PROMPT «	where KSMCHCOM = 'free memory'
PROMPT «	group by ksmchidx, ksmchcls,
PROMPT «	'sga heap('||KSMCHIDX||',0)',ksmchcom, ksmchcls,decode(round(ksmchsiz/1000),0,'0-1K',
PROMPT «	 1,'1-2K', 2,'2-3K', 3,'3-4K',4,'4-5K',5,'5-6k',6,
PROMPT «	 '6-7k',7,'7-8k',8,'8-9k', 9,'9-10k','> 10K') 
PROMPT «  order by 1;
PROMPT
PROMPT  Watch for trends using these guidelines:
PROMPT  _______________________________________________________________________________________________________________________________________________________
PROMPT  
PROMPT " 		a) if ‘free’ memory is low (less than 5mb or so) you may need to increase the shared_pool_size and shared_pool_reserved_size. You should expect ‘free’ memory "
PROMPT " 		    to increase and decrease over time. Seeing trends where ‘free’ memory decreases consistently is not necessarily a problem, but seeing consistent spikes up and down could be a problem. "
PROMPT " 		b) if ‘freeable’ or ‘perm’ memory continually grows then it is possible you are seeing a memory bug. "
PROMPT " 		c) if ‘freeabl’ and ‘recr’ memory classes are always huge, this indicates that you have a lot of cursor info stored that is not releasing. "
PROMPT " 		d) if ‘free’ memory is huge but you are still getting 4031 errors, the problem is likely reloads and invalids in the library cache causing fragmentation."
PROMPT
PROMPT
PROMPT
SELECT KSMCHCLS CLASS, COUNT(KSMCHCLS) NUM, SUM(KSMCHSIZ) SIZ,
To_char( ((SUM(KSMCHSIZ)/COUNT(KSMCHCLS)/1024)),'999,999.00')||'k' "AVG SIZE"
FROM X$KSMSP GROUP BY KSMCHCLS;
PROMPT 
REM ======================================================================
PROMPT 
PROMPT IS LIBRARY_CACHE OR DICTIONARY_CACHE UTILIZATION SATISFACTORY ?
PROMPT  ________________________________________________________________
PROMPT
PROMPT 
set lines 200
SELECT NAMESPACE, PINS, PINHITS, RELOADS, INVALIDATIONS
FROM V$LIBRARYCACHE
ORDER BY NAMESPACE;
PROMPT
PROMPT High invalidations indicates that there is parsing problem with the namespace and high reloads indicates that there is a sizing problem which causes aging out.
PROMPT  _______________________________________________________________________________________________________________________________________________________
PROMPT
PROMPT DICTIONARY CACHE STATS
PROMPT  ______________________
PROMPT
PROMPT
SELECT PARAMETER, SUM(GETS),SUM(GETMISSES),100*SUM(GETS - GETMISSES)/SUM(GETS) as  "PCT_SUCC_GETS" ,SUM(MODIFICATIONS) as "UPDATES" FROM V$ROWCACHE WHERE GETS > 0 GROUP BY PARAMETER;
PROMPT 
PROMPT USING X$KSMLRU INTERNAL FIXED TABLE.
PROMPT  ___________________________________
PROMPT This can be used to identify what is causing the large allocations. KSMLRSIZ column of this table shows the amount of contiguous memory being allocated. 
PROMPT Values over around 5K start to be a problem, values over 10K are a serious problem, and values over 20K are very serious problems. Anything less
PROMPT  then 5K should not be a problem.
PROMPT  
 select * from x$ksmlru where ksmlrsiz > 5000;
PROMPT
PROMPT  After finding the result you should do the followings to correct fragmentation
PROMPT 
PROMPT 		(I) KEEP OBJECT BY PINNING
PROMPT  	(II) USE BIND VARIABLES 
PROMPT 
PROMPT Eliminate large anonymous PL/SQL block. Large anonymous PL/SQL blocks should be turned into small anonymous PL/SQL blocks that call packaged functions. 
PROMPT The packages should be ‘kept’ in memory. To view candidates
PROMPT 
PROMPT TO INVESTIGATES WHICH OBJECTS ARE PINNED INTO THE LIBRARY CACHE USE BELOW SQL
PROMPT  _____________________________________________________________________________
PROMPT 
PROMPT « SELECT OWNER, NAME, TYPE, SHARABLE_MEM
PROMPT « FROM V$DB_OBJECT_CACHE
PROMPT « WHERE  KEPT = 'YES'
PROMPT « ORDER BY SHARABLE_MEM DESC;
PROMPT 
PROMPT « SELECT SUM(SHARABLE_MEM) TTL FROM V$DB_OBJECT_CACHE WHERE KEPT='YES';
PROMPT 
PROMPT *************** The data provides more detailed information on what objects are pinned and how much memory is needed for them.
PROMPT 
PROMPT  ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
PROMPT IF YOUR INVESTIGATION CONCLUDES TO AN MEMORY FRAGMENTATION BELOW ARE THE SQLS ALREADY EXTRACTED IN $HOME/ORA_4030 DIR.
PROMPT BELOW IS THE DESCRIPTION OF THE SQL 
PROMPT •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
PROMPT 
PROMPT HardParses.sql : 
PROMPT ••••••••••••••••
PROMPT provides data on code in the Library Cache that was executed only once.
PROMPT Hard parses are expensive inside the Library Cache.   It is not possible to eliminate all hard parses, 
PROMPT but it is important to watch the 'per second' numbers for hard parses
PROMPT Periods of very high (in the hundreds or even thousands per second) should be investigated.
PROMPT NOTE:  In environments which tends to have a lot of code that is executed only once where tuning opportunities in the application are unlikely, 
PROMPT be sure to investigate settings for OPEN_CURSORS and SESSION_CACHED_CURSORS.   
PROMPT Having these values too high will cause these code pieces to stay around in the Shared Pool longer than needed.
PROMPT 
PROMPT PinCandidates.sql : 
PROMPT ••••••••••••••••
PROMPT lists code that may be pinning candidates.   
PROMPT You can change the query to look for code with large 'sharable_mem' and/or a high value for 'executions'.   
PROMPT Larger code pieces that are executed over and over may still get flushed out of the Library Cache over time.   
PROMPT Pinning the code will keep the code in memory for future connections that need the object.
PROMPT 
PROMPT SQLStats.sql : 
PROMPT ••••••••••••••••
PROMPT a starting point to investigate statistics about code in the Library Cache.
PROMPT NOTE:  If 'Versions HWM' is not showing an large number, then further research into copies (versions) may not be necessary.
PROMPT 
PROMPT SQLVersions.sql :
PROMPT ••••••••••••••••
PROMPT  helps to investigate SQL with multiple copies (versions) in the Library Cache.  
PROMPT These versions are to be expected in many cases, but excessive copies (versions) can indicate a problem.   
PROMPT Version_count > 5 is just a starting point.  In cases with excessive versions of code, 
PROMPT it would be appropriate to increase the condition in the query to focus on the problem code and ignore cases where a handful of versions of the code are expected.   
PROMPT You can use the SQLStats.sql code to find a better starting point for your query.
PROMPT NOTE:  Objects in the Library Cache will have Parent objects and Child objects associated with those parents.   
PROMPT The copies (child objects) will be created for a number of reasons and is not an automatic indication there are problems in the Library Cache.
PROMPT 
PROMPT The second script investigates variances between V$SQLAREA and V$SQL_SHARED_CURSOR with respect to "copies"/versions of the code in the Library Cache.   
PROMPT There have been bugs on some Oracle releases where an excessive variance pointed to problems with child cursors.
PROMPT 
PROMPT Literals.sql : 
PROMPT ••••••••••••••••
PROMPT find code using literals that will be executed fewer times (not shared).
PROMPT Investigating different settings for CURSOR_SHARING may help to tune the Library Cache to handle the literal values more efficiently. 
PROMPT 
PROMPT 
PROMPT
PROMPT •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
PROMPT ********************* X$KSMSP  : could be used in place of heapdump **************************
PROMPT •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
PROMPT  @KSMSP.sql
PROMPT  _______________________________________________________________________________________________________________________________________________________
PROMPT  WARNING ::::::
PROMPT   WARNING :::::: The information available in this view is the same that is generated as part of a HEAPDUMP level 2.  
PROMPT   WARNING :::::: selecting from X$KSMSP is asking one session to hold the shared pool latches in turn for a LONG period of time and should be avoided on live systems. 
PROMPT   WARNING :::::: 
PROMPT   If the result of the above query shows that must of the space available is on the top part of the list (meaning available only in very small chuncks). 
PROMPT   It is very likely that the error is due to a heavy fragmentation. 
SPOOL OFF