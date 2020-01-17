col username for a15
col tr_status for a15
col COMMAND_NAME for a20

select ss.sid, ss.serial#, ss.username, st.used_ublk, st.used_urec, ss.status, decode(st.flag,7683,'ONGOING',7811,'ROLLBACK', st.flag) tr_status,  sqt.command_name, ss.sql_id, ss.prev_sql_id
from v$session ss , v$transaction st, V$sqlcommand sqt
where ss.saddr = st.ses_addr
and sqt.command_type = ss.command
order by 3;
