-- Modified version of Dion Cho's script - http://dioncho.wordpress.com/?s=v%24sql_shared_cursor
--
-- Modified by Kerry Osborne
-- I just changed the output columns (got rid of sql_text and address columns and added last_load_time)
-- I also ordered the output by last_load_time.
-- 
set serveroutput on
declare
  c         number;
  col_cnt   number;
  col_rec   dbms_sql.desc_tab;
  col_value varchar2(4000);
  ret_val    number;
begin
  c := dbms_sql.open_cursor;
  dbms_sql.parse(c,
      'select q.sql_text, q.last_load_time, s.*
      from v$sql_shared_cursor s, v$sql q
      where s.sql_id = q.sql_id
          and s.child_number = q.child_number
          and q.sql_id like ''&sql_id''
      order by last_load_time',
      dbms_sql.native);
  dbms_sql.describe_columns(c, col_cnt, col_rec);

  for idx in 1 .. col_cnt loop
    dbms_sql.define_column(c, idx, col_value, 4000);
  end loop;

  ret_val := dbms_sql.execute(c);

  while(dbms_sql.fetch_rows(c) > 0) loop
    for idx in 1 .. col_cnt loop
      dbms_sql.column_value(c, idx, col_value);
      if col_rec(idx).col_name in ('SQL_ID', 'CHILD_NUMBER','LAST_LOAD_TIME') then
        dbms_output.put_line(rpad(col_rec(idx).col_name, 30) ||
                ' = ' || col_value);
      elsif col_value = 'Y' then
        dbms_output.put_line(rpad(col_rec(idx).col_name, 30) ||
                ' = ' || col_value);
      end if;

    end loop;

    dbms_output.put_line('--------------------------------------------------');

   end loop;

  dbms_sql.close_cursor(c);

end;
/


fztcq26ppyvp3

=============

set serveroutput on
declare
c SYS_REFCURSOR
BEGIN
  OPEN c FOR select tablespace_name from dba_tablespaces;
  RETURN c;
END;




DECLARE
    CURSOR stud_cur IS
    SELECT STUDENT_NAME FROM STUDENT.STUDENT_DETAILS WHERE CLASS_ID= 'C';

    l_stud STUDENT.STUDENT_DETAILS%ROWTYPE;
    BEGIN
      OPEN stud_cur;
      LOOP
        FETCH stud_cur INTO l_stud;
        EXIT WHEN stud_cur%NOTFOUND;

        /* The first time, stud_cur.STUDENT_NAME will be Jack, then Jill... */
      END LOOP;
    CLOSE stud_cur;
END;



DECLARE
 CURSOR stud_cur IS
 select tablespace_name from dba_tablespaces;
 l_tblspc dba_tablespaces.tablespace_name%TYPE;
 BEGIN
 OPEN stud_cur;
 LOOP
 FETCH stud_cur INTO l_tblspc;
 EXIT WHEN stud_cur%NOTFOUND;
 END LOOP;
 CLOSE stud_cur;
 END;


 /
 
 
 
 @snapper.sql ash=sql_id+event ,stats 1 1 all