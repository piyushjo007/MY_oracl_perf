set lines 1000
set pages 100
select snap_id,begin_interval_time,end_interval_time from dba_hist_snapshot where begin_interval_time>sysdate-&1 and begin_interval_time<sysdate-&6 order by 1;

select 

select extract(month from sysdate) from dual;

select snap_id,begin_interval_time,end_interval_time from dba_hist_snapshot where begin_interval_time>sysdate-&1 and begin_interval_time<sysdate-&6 order by 1;


select begin_interval_time from dba_hist_snapshot where extract(day from begin_interval_time)=12;

select extract(day from a.sample_time) ,b.sql_id,sum(b.executions_total) from dba_hist_active_sess_history a ,dba_hist_sqlstat b where a.snap_id=b.snap_id and extract(month from a.sample_time)=5 and b.sql_id='58xh4snpvz0sz' group by extract(day from a.sample_time),b.sql_id order by 1;


208721

208727


   FILE_ID TABLESPACE_NAME
---------- ------------------------------
      2793 UNDO_TS
      1169 UNDO_TS
       542 UNDO_TS
       522 UNDO_TS
       511 UNDO_TS
       464 UNDO_TS
       351 UNDO_TS
       243 UNDO_TS
       241 UNDO_TS
       182 UNDO_TS
       180 UNDO_TS
       167 UNDO_TS
         3 UNDO_TS
         
         
 Reducing the undo generated  by direct path read using append can improve the performance as direct path read generate much less significant undo .
 
 
 116959347
 
 
 
 116959584
 53 116959821
 54 116959940
 
 
 
 decode(s.SQL_OPCODE,
     0,'No Command',
     1,'Create Table',
     2,'Insert',
     3,'Select',
     6,'Update',
     7,'Delete',
     9,'Create Index',
     15,'Alter Table',
     21,'Create View',
     23,'Validate Index',
     35,'Alter Database',
     39,'Create Tablespace',
     41,'Drop Tablespace',
     40,'Alter Tablespace',
     53,'Drop User',
     62,'Analyze Table',
     63,'Analyze Index',
     s.SQL_OPCODE||': Other') command
     
     
     
select count(*), decode(SQL_OPCODE,
 0,'No Command',
 1,'Create Table',
 2,'Insert',
 3,'Select',
 6,'Update',
 7,'Delete',
 9,'Create Index',
 15,'Alter Table',
 21,'Create View',
 23,'Validate Index',
 35,'Alter Database',
 39,'Create Tablespace',
 41,'Drop Tablespace',
 40,'Alter Tablespace',
 53,'Drop User',
 62,'Analyze Table',
 63,'Analyze Index',
 SQL_OPCODE||': Other') command
from v$active_session_history where SAMPLE_ID > 116959347 and SAMPLE_ID < 116959584 group by SQL_OPCODE
order by 1