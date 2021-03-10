SET ECHO OFF
SET LINESIZE 500
SET NEWPAGE 0
SET SPACE 0
SET PAGESIZE 0
SET FEEDBACK OFF
SET HEADING OFF
SET TRIMSPOOL ON
SET TAB OFF

--alter session set NLS_LANG='AMERICAS_AMERICA.AL32UTF8'

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdCursos_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdCursos_20210305.sql

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdMatriculas_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdMatriculas_20210305.sql

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdMetacursos_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdMetacursos_20210305.sql

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdNodos_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdNodos_20210305.sql

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdPeriodos_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdPeriodos_20210305.sql

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdRoles_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdRoles_20210305.sql

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdUsuarios_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdUsuarios_20210305.sql

SPOOL C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\Test_extraccion\BdUsuariosNodos_20210305.txt
@C:\Users\geg\Documents\GitHub\UPN_Banner\Querys\BlackBoard_(Integracion)\20210305\BdUsuariosNodos_20210305.sql
