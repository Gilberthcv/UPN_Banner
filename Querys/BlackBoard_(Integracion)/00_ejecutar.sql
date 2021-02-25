SET NEWPAGE 0
SET SPACE 0
SET PAGESIZE 0
SET FEEDBACK OFF
SET HEADING OFF
set verify off
SET ECHO OFF

spool C:\Users\geg\Desktop\BlackBoard\periods_20181214.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\periods_20181214.sql;

spool C:\Users\geg\Desktop\BlackBoard\nodos_20190109.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\nodos_20190109.sql;

spool C:\Users\geg\Desktop\BlackBoard\courses_20181214.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\courses_20181214.sql;

spool C:\Users\geg\Desktop\BlackBoard\enrollments_20181214.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\enrollments_20181214.sql;

spool C:\Users\geg\Desktop\BlackBoard\roles_20181214.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\roles_20181214.sql;

spool C:\Users\geg\Desktop\BlackBoard\users_20181214.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\users_20181214.sql;

spool C:\Users\geg\Desktop\BlackBoard\users_nodos_20181214.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\users_nodos_20181214.sql;

spool C:\Users\geg\Desktop\BlackBoard\metacursos_20210204.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\metacursos_20210204.sql;
