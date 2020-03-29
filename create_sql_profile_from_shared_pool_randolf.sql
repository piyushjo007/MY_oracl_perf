/* Randolf Giest */
-- creates a sql profile from shared pool
-- sql_id_from child_no_from sql_id_to child_no_to category force_matching
declare
ar_profile_hints sys.sqlprof_attr;
cl_sql_text clob;
begin
select
extractvalue(value(d), '/hint') as outline_hints
bulk collect
into
ar_profile_hints
from
xmltable('/*/outline_data/hint'
passing (
select
xmltype(other_xml) as xmlval
from
v$sql_plan
where
sql_id = '&&1'
and child_number = &&2
and other_xml is not null
)
) d;

select
sql_fulltext
into
cl_sql_text
from
v$sql
where
sql_id = '&&3'
and child_number = &&4;

dbms_sqltune.import_sql_profile(
sql_text => cl_sql_text
, profile => ar_profile_hints
, category => '&&5'
, name => 'PROFILE_'||'&&3'||'_attach'
-- use force_match => true
-- to use CURSOR_SHARING=SIMILAR
-- behaviour, i.e. match even with
-- differing literals
, force_match => &&6
);
end;
/

select
extractvalue(value(d), '/hint') as outline_hints
bulk collect
into
ar_profile_hints
from
xmltable('/*/outline_data/hint'
passing (
select
xmltype(other_xml) as xmlval
from
v$sql_plan
where
sql_id = '7n2tng3mfcugz'
and child_number = 1993242657
and other_xml is not null
)
) d;