select ADDRESS, HASH_VALUE from V$SQLAREA where SQL_Id='&sql_id';

exec DBMS_SHARED_POOL.PURGE ('&addr,&hash','C');

select ADDRESS, HASH_VALUE from V$SQLAREA where SQL_Id='&sql_id';
