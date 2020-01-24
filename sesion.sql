Set lines 350
Set pages 1000
col "BLOCKING Inst:SID" for a20
col "ID:SID,SERIAL" for a20
Col machine for a40
col MODULE for a35
col STATUS for a15 
Col USERNAME for a20
Col Event for a50
col final_blocking_session for 999999
SELECT  LOGON_TIME, event,  module, username,   INST_ID ||' : ' ||sid ||',' || SERIAL# "ID:SID,SERIAL" , BLOCKING_INSTANCE||' : ' ||BLOCKING_SESSION "BLOCKING Inst:SID",final_blocking_session, sql_id, machine, SECONDS_IN_WAIT, status FROM gv$session 
WHERE wait_class != 'Idle' ORDER BY  SECONDS_IN_WAIT DESC, event DESC;
