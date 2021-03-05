#!/bin/bash

iclientpath=./instantclient

export NLS_LANG=.AL32UTF8
export LD_LIBRARY_PATH=$iclientpath
export PATH=$PATH:$iclientpath
export TWO_TASK='(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=aroupnbndb.sis.laureate.or)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=aroupnbn_sisrw)))'

#do clcean up
rm -rf ./*.txt

sqlplus -s -L laureatedev/laureatedev << _EOF_
   SET ECHO OFF
   SET LINESIZE 500
   SET NEWPAGE 0
   SET SPACE 0
   SET PAGESIZE 0
   SET FEEDBACK OFF
   SET HEADING OFF
   SET TRIMSPOOL ON
   SET TAB OFF

   alter session set NLS_LANG='AMERICAS_AMERICA.AL32UTF8'

    SPOOL ./BbPeriodos.txt
   
        SELECT 'EXTERNAL_TERM_KEY|NAME|DURATION|START_DATE|END_DATE|DATA_SOURCE_KEY' FROM DUAL;
        SELECT SOBPTRM_TERM_CODE ||'|'||
            STVTERM_DESC ||'|'||
            'R' ||'|'||
            TO_CHAR(SOBPTRM_START_DATE,'YYYYMMDD') ||'|'||
            TO_CHAR(SOBPTRM_END_DATE,'YYYYMMDD') ||'|'||
            'UPN.Periodos.Banner' --'UPN.<Instancia>.Banner.<Nivel>'
        FROM SOBPTRM
                INNER JOIN STVTERM ON SOBPTRM_TERM_CODE = STVTERM_CODE
        WHERE SOBPTRM_TERM_CODE <> '999996'
            AND SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10
        ;
	SPOOL OFF
 
    SPOOL ./BbNodos.txt
        SELECT 'EXTERNAL_NODE_KEY|NAME|PARENT_NODE_KEY|DATA_SOURCE_KEY' FROM DUAL;
        SELECT 'PEPN01'||'.'||'UPN' ||'|'||
            'UPN' ||'|'||
            'PEPN01' ||'|'||
            'UPN.Nodos.Banner'
        FROM DUAL
        UNION
        SELECT DISTINCT 'PEPN01'||'.'||'UPN'
                ||'.'||CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                        WHEN '3' THEN 'PN'
                        WHEN '4' THEN 'UG'
                        WHEN '5' THEN 'WA'
                        WHEN '7' THEN 'IN'
                        ELSE 'EP' END ||'|'||
            CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                WHEN '3' THEN 'Programa de Nivelacion'
                WHEN '4' THEN 'Pregrado Regular'
                WHEN '5' THEN 'Working Adult'
                WHEN '7' THEN 'Ingles'
                ELSE 'Escuela de Posgrado' END ||'|'||
            'PEPN01'||'.'||'UPN' ||'|'||
            'UPN.Nodos.Banner'
        FROM SSBSECT A
                INNER JOIN SSRATTR B ON A.SSBSECT_TERM_CODE = B.SSRATTR_TERM_CODE AND A.SSBSECT_CRN = B.SSRATTR_CRN
                INNER JOIN STVCAMP C ON A.SSBSECT_CAMP_CODE = C.STVCAMP_CODE
                INNER JOIN STVATTR D ON B.SSRATTR_ATTR_CODE = D.STVATTR_CODE
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) E ON A.SSBSECT_TERM_CODE = E.SSRMEET_TERM_CODE AND A.SSBSECT_CRN = E.SSRMEET_CRN
        WHERE A.SSBSECT_SSTS_CODE = 'A'
            AND SYSDATE BETWEEN E.START_DATE-20 AND E.END_DATE+10
            AND A.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        UNION
        SELECT DISTINCT 'PEPN01'||'.'||'UPN'
                ||'.'||CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                        WHEN '3' THEN 'PN'
                        WHEN '4' THEN 'UG'
                        WHEN '5' THEN 'WA'
                        WHEN '7' THEN 'IN'
                        ELSE 'EP' END
                ||'.'||CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE A.SSBSECT_CAMP_CODE END ||'|'||
            CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'Trujillo' ELSE C.STVCAMP_DESC END ||'|'||
            'PEPN01'||'.'||'UPN'
                ||'.'||CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                        WHEN '3' THEN 'PN'
                        WHEN '4' THEN 'UG'
                        WHEN '5' THEN 'WA'
                        WHEN '7' THEN 'IN'
                        ELSE 'EP' END ||'|'||
            'UPN.Nodos.Banner'
        FROM SSBSECT A
                INNER JOIN SSRATTR B ON A.SSBSECT_TERM_CODE = B.SSRATTR_TERM_CODE AND A.SSBSECT_CRN = B.SSRATTR_CRN
                INNER JOIN STVCAMP C ON A.SSBSECT_CAMP_CODE = C.STVCAMP_CODE
                INNER JOIN STVATTR D ON B.SSRATTR_ATTR_CODE = D.STVATTR_CODE
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) E ON A.SSBSECT_TERM_CODE = E.SSRMEET_TERM_CODE AND A.SSBSECT_CRN = E.SSRMEET_CRN
        WHERE A.SSBSECT_SSTS_CODE = 'A'
            AND SYSDATE BETWEEN E.START_DATE-20 AND E.END_DATE+10
            AND A.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        UNION
        SELECT DISTINCT 'PEPN01'||'.'||'UPN'
                ||'.'||CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                        WHEN '3' THEN 'PN'
                        WHEN '4' THEN 'UG'
                        WHEN '5' THEN 'WA'
                        WHEN '7' THEN 'IN'
                        ELSE 'EP' END
                ||'.'||CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE A.SSBSECT_CAMP_CODE END
                ||'.'||B.SSRATTR_ATTR_CODE ||'|'||
            D.STVATTR_DESC ||'|'||
            'PEPN01'||'.'||'UPN'
                ||'.'||CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                        WHEN '3' THEN 'PN'
                        WHEN '4' THEN 'UG'
                        WHEN '5' THEN 'WA'
                        WHEN '7' THEN 'IN'
                        ELSE 'EP' END
                ||'.'||CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE A.SSBSECT_CAMP_CODE END ||'|'||
            'UPN.Nodos.Banner'
        FROM SSBSECT A
                INNER JOIN SSRATTR B ON A.SSBSECT_TERM_CODE = B.SSRATTR_TERM_CODE AND A.SSBSECT_CRN = B.SSRATTR_CRN
                INNER JOIN STVCAMP C ON A.SSBSECT_CAMP_CODE = C.STVCAMP_CODE
                INNER JOIN STVATTR D ON B.SSRATTR_ATTR_CODE = D.STVATTR_CODE
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) E ON A.SSBSECT_TERM_CODE = E.SSRMEET_TERM_CODE AND A.SSBSECT_CRN = E.SSRMEET_CRN
        WHERE A.SSBSECT_SSTS_CODE = 'A'
            AND SYSDATE BETWEEN E.START_DATE-20 AND E.END_DATE+10
            AND A.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        UNION
        SELECT DISTINCT 'PEPN01'||'.'||'UPN'
                ||'.'||CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                        WHEN '3' THEN 'PN'
                        WHEN '4' THEN 'UG'
                        WHEN '5' THEN 'WA'
                        WHEN '7' THEN 'IN'
                        ELSE 'EP' END
                ||'.'||CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE A.SSBSECT_CAMP_CODE END
                ||'.'||B.SSRATTR_ATTR_CODE
                ||'.'||A.SSBSECT_TERM_CODE ||'|'||
            A.SSBSECT_TERM_CODE ||'|'||
            'PEPN01'||'.'||'UPN'
                ||'.'||CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                        WHEN '3' THEN 'PN'
                        WHEN '4' THEN 'UG'
                        WHEN '5' THEN 'WA'
                        WHEN '7' THEN 'IN'
                        ELSE 'EP' END
                ||'.'||CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE A.SSBSECT_CAMP_CODE END
                ||'.'||B.SSRATTR_ATTR_CODE ||'|'||
            'UPN.Nodos.Banner'
        FROM SSBSECT A
                INNER JOIN SSRATTR B ON A.SSBSECT_TERM_CODE = B.SSRATTR_TERM_CODE AND A.SSBSECT_CRN = B.SSRATTR_CRN
                INNER JOIN STVCAMP C ON A.SSBSECT_CAMP_CODE = C.STVCAMP_CODE
                INNER JOIN STVATTR D ON B.SSRATTR_ATTR_CODE = D.STVATTR_CODE
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) E ON A.SSBSECT_TERM_CODE = E.SSRMEET_TERM_CODE AND A.SSBSECT_CRN = E.SSRMEET_CRN
        WHERE A.SSBSECT_SSTS_CODE = 'A'
            AND SYSDATE BETWEEN E.START_DATE-20 AND E.END_DATE+10
            AND A.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        ;
	SPOOL OFF

    SPOOL ./BbUsuarios.txt
        SELECT 'EXTERNAL_PERSON_KEY|USER_ID|FIRSTNAME|LASTNAME|EMAIL|ROW_STATUS|AVAILABLE_IND|DATA_SOURCE_KEY|M_PHONE' FROM DUAL;
        SELECT DISTINCT
            A.EXTERNAL_PERSON_KEY ||'|'||
            B.SPRIDEN_ID ||'|'||
            B.SPRIDEN_FIRST_NAME ||'|'||
            REPLACE(B.SPRIDEN_LAST_NAME,'/',' ') ||'|'||
            LOWER(CASE WHEN MAX(A.PREFERENCIA) OVER(PARTITION BY A.EXTERNAL_PERSON_KEY) = 'DOCENTE'
                THEN C.GOREMAL_EMAIL_ADDRESS ELSE B.SPRIDEN_ID ||'@upn.pe' END) ||'|'||
            A.ROW_STATUS ||'|'||
            A.AVAILABLE_IND ||'|'||
            'UPN.Usuarios.Banner' ||'|'||
            MAX(CASE WHEN D.SPRTELE_TELE_CODE = 'CP' THEN D.SPRTELE_PHONE_NUMBER END) OVER(PARTITION BY D.SPRTELE_PIDM)
        FROM ( SELECT DISTINCT
                    A.SFRSTCR_PIDM AS EXTERNAL_PERSON_KEY
                    , CASE WHEN C.SFBETRM_ESTS_CODE = 'EL' THEN 'ENABLED' ELSE 'DISABLED' END AS ROW_STATUS
                    , CASE WHEN C.SFBETRM_ESTS_CODE = 'EL' THEN 'Y' ELSE 'N' END AS AVAILABLE_IND
                    , NULL AS PREFERENCIA
                FROM SFRSTCR A
                        INNER JOIN SSBSECT B ON A.SFRSTCR_TERM_CODE = B.SSBSECT_TERM_CODE AND A.SFRSTCR_CRN = B.SSBSECT_CRN
                        INNER JOIN SFBETRM C ON A.SFRSTCR_PIDM = C.SFBETRM_PIDM AND A.SFRSTCR_TERM_CODE = C.SFBETRM_TERM_CODE AND C.SFBETRM_ESTS_CODE IS NOT NULL
                        INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                        , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                                    FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                                    ) D ON B.SSBSECT_TERM_CODE = D.SSRMEET_TERM_CODE AND B.SSBSECT_CRN = D.SSRMEET_CRN
                WHERE A.SFRSTCR_RSTS_CODE IN ('RW','RE','RA')
                    AND B.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
                    AND SYSDATE BETWEEN D.START_DATE-20 AND D.END_DATE+10
                    AND B.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                                WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
                UNION
                SELECT DISTINCT
                    A.SIRASGN_PIDM AS EXTERNAL_PERSON_KEY
                    , CASE WHEN C.SIBINST_FCST_CODE = 'AC' THEN 'ENABLED' ELSE 'DISABLED' END AS ROW_STATUS
                    , CASE WHEN C.SIBINST_FCST_CODE = 'AC' THEN 'Y' ELSE 'N' END AS AVAILABLE_IND
                    , 'DOCENTE' AS PREFERENCIA
                FROM SIRASGN A
                        INNER JOIN SSBSECT B ON A.SIRASGN_TERM_CODE = B.SSBSECT_TERM_CODE AND A.SIRASGN_CRN = B.SSBSECT_CRN
                        INNER JOIN SIBINST C ON A.SIRASGN_PIDM = C.SIBINST_PIDM
                                                            AND C.SIBINST_TERM_CODE_EFF = (SELECT MAX(C1.SIBINST_TERM_CODE_EFF) FROM SIBINST C1
                                                                                            WHERE C1.SIBINST_PIDM = A.SIRASGN_PIDM AND C1.SIBINST_TERM_CODE_EFF <> '999996')
                        INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                        , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                                    FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                                    ) D ON B.SSBSECT_TERM_CODE = D.SSRMEET_TERM_CODE AND B.SSBSECT_CRN = D.SSRMEET_CRN
                WHERE C.SIBINST_FCST_CODE = 'AC'
                    AND SYSDATE BETWEEN D.START_DATE-20 AND D.END_DATE+10
                    AND B.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                                WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
                ) A
                    INNER JOIN SPRIDEN B ON A.EXTERNAL_PERSON_KEY = B.SPRIDEN_PIDM AND B.SPRIDEN_CHANGE_IND IS NULL
                    LEFT JOIN GOREMAL C ON A.EXTERNAL_PERSON_KEY = C.GOREMAL_PIDM AND C.GOREMAL_STATUS_IND = 'A' AND C.GOREMAL_EMAL_CODE = 'UNIV'
                                                    AND C.GOREMAL_ACTIVITY_DATE = (SELECT MAX(C1.GOREMAL_ACTIVITY_DATE) FROM GOREMAL C1
                                                                                    WHERE C1.GOREMAL_PIDM = A.EXTERNAL_PERSON_KEY AND C1.GOREMAL_STATUS_IND = 'A' AND C1.GOREMAL_EMAL_CODE = 'UNIV')
                    LEFT JOIN SPRTELE D ON A.EXTERNAL_PERSON_KEY = D.SPRTELE_PIDM AND D.SPRTELE_TELE_CODE = 'CP'
        ;
	SPOOL OFF
   
    SPOOL ./BbRoles.txt
        SELECT 'EXTERNAL_PERSON_KEY|ROLE_ID|DATA_SOURCE_KEY' FROM DUAL;
        SELECT DISTINCT
            A.SFRSTCR_PIDM ||'|'||
            'PEPN01.UPN.Estudiante.' ||
                CASE SUBSTR(A.SFRSTCR_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN B.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE B.SSBSECT_CAMP_CODE END ||'|'||
            CASE SUBSTR(A.SFRSTCR_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.Rol.Banner.PDN'
                WHEN '4' THEN 'UPN.Rol.Banner.UG'
                WHEN '5' THEN 'UPN.Rol.Banner.WA'
                WHEN '7' THEN 'UPN.Rol.Banner.Ingles'
                ELSE 'UPN.Rol.Banner.EPEC' END AS DATA_SOURCE_KEY
        FROM SFRSTCR A
                INNER JOIN SSBSECT B ON A.SFRSTCR_TERM_CODE = B.SSBSECT_TERM_CODE AND A.SFRSTCR_CRN = B.SSBSECT_CRN
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) C ON B.SSBSECT_TERM_CODE = C.SSRMEET_TERM_CODE AND B.SSBSECT_CRN = C.SSRMEET_CRN
        WHERE A.SFRSTCR_RSTS_CODE IN ('RW','RE','RA')
            AND B.SSBSECT_SSTS_CODE = 'A' AND B.SSBSECT_ENRL > 0 --AND B.SSBSECT_MAX_ENRL > 0
            AND B.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
            AND SYSDATE BETWEEN C.START_DATE-20 AND C.END_DATE+10
            AND B.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        UNION
        SELECT DISTINCT
            C.SIRASGN_PIDM ||'|'||
            'PEPN01.UPN.Docente.' ||
                CASE SUBSTR(C.SIRASGN_TERM_CODE ,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'|'||
            CASE SUBSTR(C.SIRASGN_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.Rol.Banner.PDN'
                WHEN '4' THEN 'UPN.Rol.Banner.UG'
                WHEN '5' THEN 'UPN.Rol.Banner.WA'
                WHEN '7' THEN 'UPN.Rol.Banner.Ingles'
                ELSE 'UPN.Rol.Banner.EPEC' END
        FROM SIRASGN C
                INNER JOIN SSBSECT D ON C.SIRASGN_TERM_CODE = D.SSBSECT_TERM_CODE AND C.SIRASGN_CRN = D.SSBSECT_CRN
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) E ON D.SSBSECT_TERM_CODE = E.SSRMEET_TERM_CODE AND D.SSBSECT_CRN = E.SSRMEET_CRN
        WHERE D.SSBSECT_SSTS_CODE = 'A' AND D.SSBSECT_ENRL > 0 --AND D.SSBSECT_MAX_ENRL > 0
            AND D.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
            AND SYSDATE BETWEEN E.START_DATE-20 AND E.END_DATE+10
            AND D.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        ;
    SPOOL OFF

    SPOOL ./BbCursos.txt
       SELECT 'EXTERNAL_COURSE_KEY|COURSE_ID|COURSE_NAME|AVAILABLE_IND|ROW_STATUS|DURATION|START_DATE|END_DATE|TERM_KEY|DATA_SOURCE_KEY|PRIMARY_EXTERNAL_NODE_KEY|EXTERNAL_ASSOCIATION_KEY' FROM DUAL;
        SELECT DISTINCT
            CASE WHEN A.SSBSECT_SCHD_CODE = 'VIR' OR A.SSBSECT_INSM_CODE = 'V'
                THEN A.SSBSECT_SUBJ_CODE ||'.'|| A.SSBSECT_CRSE_NUMB ||'.'|| A.SSBSECT_TERM_CODE ||'.'|| A.SSBSECT_CRN ||'.'|| 'V'
                ELSE A.SSBSECT_SUBJ_CODE ||'.'|| A.SSBSECT_CRSE_NUMB ||'.'|| A.SSBSECT_TERM_CODE ||'.'|| A.SSBSECT_CRN ||'.'|| 'P' END ||'|'||
            CASE WHEN A.SSBSECT_SCHD_CODE = 'VIR' OR A.SSBSECT_INSM_CODE = 'V'
                THEN A.SSBSECT_SUBJ_CODE ||'.'|| A.SSBSECT_CRSE_NUMB ||'.'|| A.SSBSECT_TERM_CODE ||'.'|| A.SSBSECT_CRN ||'.'|| 'V'
                ELSE A.SSBSECT_SUBJ_CODE ||'.'|| A.SSBSECT_CRSE_NUMB ||'.'|| A.SSBSECT_TERM_CODE ||'.'|| A.SSBSECT_CRN ||'.'|| 'P' END ||'|'||
            CASE WHEN A.SSBSECT_SCHD_CODE = 'VIR' OR A.SSBSECT_INSM_CODE = 'V'
                THEN B.SCBCRSE_TITLE ||'(Virtual)'
                ELSE B.SCBCRSE_TITLE ||'(Presencial)' END ||'|'||
            CASE WHEN A.SSBSECT_SSTS_CODE = 'A' THEN 'Y' ELSE 'N' END ||'|'||
            CASE WHEN A.SSBSECT_SSTS_CODE = 'A' THEN 'ENABLED' ELSE 'DISABLED' END ||'|'||
            'R' ||'|'||
            TO_CHAR(D.START_DATE-20,'YYYYMMDD') ||'|'||
            TO_CHAR(D.END_DATE+10,'YYYYMMDD') ||'|'||
            A.SSBSECT_TERM_CODE ||'|'||
            CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.Cursos.Banner.PDN'
                WHEN '4' THEN 'UPN.Cursos.Banner.UG'
                WHEN '5' THEN 'UPN.Cursos.Banner.WA'
                WHEN '7' THEN 'UPN.Cursos.Banner.Ingles'
                ELSE 'UPN.Cursos.Banner.EPEC' END ||'|'||
            'PEPN01.UPN.' ||
                CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE A.SSBSECT_CAMP_CODE END ||'.'||
                C.SSRATTR_ATTR_CODE ||'.'|| A.SSBSECT_TERM_CODE ||'|'||
            A.SSBSECT_CRN || '.PEPN01.UPN.' ||
                CASE SUBSTR(A.SSBSECT_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN A.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE A.SSBSECT_CAMP_CODE END ||'.'||
                C.SSRATTR_ATTR_CODE ||'.'|| A.SSBSECT_TERM_CODE
        FROM SSBSECT A
                INNER JOIN SCBCRSE B ON A.SSBSECT_SUBJ_CODE = B.SCBCRSE_SUBJ_CODE AND A.SSBSECT_CRSE_NUMB = B.SCBCRSE_CRSE_NUMB
                                                AND B.SCBCRSE_EFF_TERM = (SELECT MAX(B1.SCBCRSE_EFF_TERM) FROM SCBCRSE B1
                                                                            WHERE B1.SCBCRSE_SUBJ_CODE = A.SSBSECT_SUBJ_CODE AND B1.SCBCRSE_CRSE_NUMB = A.SSBSECT_CRSE_NUMB
                                                                                AND B1.SCBCRSE_EFF_TERM <= A.SSBSECT_TERM_CODE)
                INNER JOIN SSRATTR C ON A.SSBSECT_TERM_CODE = C.SSRATTR_TERM_CODE AND A.SSBSECT_CRN = C.SSRATTR_CRN
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) D ON A.SSBSECT_TERM_CODE = D.SSRMEET_TERM_CODE AND A.SSBSECT_CRN = D.SSRMEET_CRN
        WHERE A.SSBSECT_SSTS_CODE = 'A' AND A.SSBSECT_ENRL > 0 --AND A.SSBSECT_MAX_ENRL > 0
            AND A.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
            AND SYSDATE BETWEEN D.START_DATE-20 AND D.END_DATE+10
            AND A.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        ;
    SPOOL OFF

    SPOOL ./BbMatriculas.txt
        SELECT 'EXTERNAL_COURSE_KEY|EXTERNAL_PERSON_KEY|ROLE|DATA_SOURCE_KEY' FROM DUAL;
        SELECT DISTINCT
            CASE WHEN B.SSBSECT_SCHD_CODE = 'VIR' OR B.SSBSECT_INSM_CODE = 'V'
                THEN B.SSBSECT_SUBJ_CODE ||'.'|| B.SSBSECT_CRSE_NUMB ||'.'|| B.SSBSECT_TERM_CODE ||'.'|| B.SSBSECT_CRN ||'.'|| 'V'
                ELSE B.SSBSECT_SUBJ_CODE ||'.'|| B.SSBSECT_CRSE_NUMB ||'.'|| B.SSBSECT_TERM_CODE ||'.'|| B.SSBSECT_CRN ||'.'|| 'P' END ||'|'||
            A.SFRSTCR_PIDM ||'|'||
            'S' ||'|'||
            CASE SUBSTR(B.SSBSECT_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.Matriculas.Banner.PDN'
                WHEN '4' THEN 'UPN.Matriculas.Banner.UG'
                WHEN '5' THEN 'UPN.Matriculas.Banner.WA'
                WHEN '7' THEN 'UPN.Matriculas.Banner.Ingles'
                ELSE 'UPN.Matriculas.Banner.EPEC' END
        FROM SFRSTCR A
                INNER JOIN SSBSECT B ON A.SFRSTCR_TERM_CODE = B.SSBSECT_TERM_CODE AND A.SFRSTCR_CRN = B.SSBSECT_CRN
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) C ON B.SSBSECT_TERM_CODE = C.SSRMEET_TERM_CODE AND B.SSBSECT_CRN = C.SSRMEET_CRN
        WHERE A.SFRSTCR_RSTS_CODE IN ('RW','RE','RA')
            AND B.SSBSECT_SSTS_CODE = 'A' AND B.SSBSECT_ENRL > 0 --AND B.SSBSECT_MAX_ENRL > 0
            AND B.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
            AND SYSDATE BETWEEN C.START_DATE-20 AND C.END_DATE+10
            AND B.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        UNION
        SELECT DISTINCT
            CASE WHEN B.SSBSECT_SCHD_CODE = 'VIR' OR B.SSBSECT_INSM_CODE = 'V'
                THEN B.SSBSECT_SUBJ_CODE ||'.'|| B.SSBSECT_CRSE_NUMB ||'.'|| B.SSBSECT_TERM_CODE ||'.'|| B.SSBSECT_CRN ||'.'|| 'V'
                ELSE B.SSBSECT_SUBJ_CODE ||'.'|| B.SSBSECT_CRSE_NUMB ||'.'|| B.SSBSECT_TERM_CODE ||'.'|| B.SSBSECT_CRN ||'.'|| 'P' END ||'|'||
            A.SIRASGN_PIDM ||'|'||
            CASE WHEN B.SSBSECT_SCHD_CODE = 'VIR' OR B.SSBSECT_INSM_CODE = 'V' THEN 'PV' ELSE 'PP' END ||'|'||
            CASE SUBSTR(B.SSBSECT_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.Matriculas.Banner.PDN'
                WHEN '4' THEN 'UPN.Matriculas.Banner.UG'
                WHEN '5' THEN 'UPN.Matriculas.Banner.WA'
                WHEN '7' THEN 'UPN.Matriculas.Banner.Ingles'
                ELSE 'UPN.Matriculas.Banner.EPEC' END
        FROM SIRASGN A
                INNER JOIN SSBSECT B ON A.SIRASGN_TERM_CODE = B.SSBSECT_TERM_CODE AND A.SIRASGN_CRN = B.SSBSECT_CRN
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) C ON B.SSBSECT_TERM_CODE = C.SSRMEET_TERM_CODE AND B.SSBSECT_CRN = C.SSRMEET_CRN
        WHERE B.SSBSECT_SSTS_CODE = 'A' AND B.SSBSECT_ENRL > 0 --AND B.SSBSECT_MAX_ENRL > 0
            AND B.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
            AND SYSDATE BETWEEN C.START_DATE-20 AND C.END_DATE+10
            AND B.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        ;
    SPOOL OFF

    SPOOL ./BbUsuariosNodos.txt
        SELECT 'EXTERNAL_ASSOCIATION_KEY|EXTERNAL_NODE_KEY|EXTERNAL_USER_KEY|DATA_SOURCE_KEY' FROM DUAL;
        SELECT DISTINCT
            E.SPRIDEN_ID ||'.PEPN01.UPN.'||
                CASE SUBSTR(A.SFRSTCR_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN B.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE B.SSBSECT_CAMP_CODE END ||'.'||
                C.SSRATTR_ATTR_CODE  ||'.'|| A.SFRSTCR_TERM_CODE ||'|'||
            'PEPN01.UPN.' ||
                CASE SUBSTR(A.SFRSTCR_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN B.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE B.SSBSECT_CAMP_CODE END ||'.'||
                C.SSRATTR_ATTR_CODE  ||'.'|| A.SFRSTCR_TERM_CODE ||'|'||
            A.SFRSTCR_PIDM ||'|'||
            CASE SUBSTR(A.SFRSTCR_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.UsuarioNodo.Banner.PDN'
                WHEN '4' THEN 'UPN.UsuarioNodo.Banner.UG'
                WHEN '5' THEN 'UPN.UsuarioNodo.Banner.WA'
                WHEN '7' THEN 'UPN.UsuarioNodo.Banner.Ingles'
                ELSE 'UPN.UsuarioNodo.Banner.EPEC' END
        FROM SFRSTCR A
                INNER JOIN SSBSECT B ON A.SFRSTCR_TERM_CODE = B.SSBSECT_TERM_CODE AND A.SFRSTCR_CRN = B.SSBSECT_CRN
                INNER JOIN SSRATTR C ON B.SSBSECT_TERM_CODE = C.SSRATTR_TERM_CODE AND B.SSBSECT_CRN = C.SSRATTR_CRN
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) D ON B.SSBSECT_TERM_CODE = D.SSRMEET_TERM_CODE AND B.SSBSECT_CRN = D.SSRMEET_CRN
                INNER JOIN SPRIDEN E ON A.SFRSTCR_PIDM = E.SPRIDEN_PIDM AND E.SPRIDEN_CHANGE_IND IS NULL
        WHERE A.SFRSTCR_RSTS_CODE IN ('RW','RE','RA')
            AND B.SSBSECT_SSTS_CODE = 'A' AND B.SSBSECT_ENRL > 0 --AND B.SSBSECT_MAX_ENRL > 0
            AND B.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
            AND SYSDATE BETWEEN D.START_DATE-20 AND D.END_DATE+10
            AND B.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        UNION
        SELECT DISTINCT
            E.SPRIDEN_ID ||'.PEPN01.UPN.'||
                CASE SUBSTR(A.SIRASGN_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN B.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE B.SSBSECT_CAMP_CODE END ||'.'||
                C.SSRATTR_ATTR_CODE  ||'.'|| A.SIRASGN_TERM_CODE ||'|'||
            'PEPN01.UPN.' ||
                CASE SUBSTR(A.SIRASGN_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN B.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE B.SSBSECT_CAMP_CODE END ||'.'||
                C.SSRATTR_ATTR_CODE  ||'.'|| A.SIRASGN_TERM_CODE ||'|'||
            A.SIRASGN_PIDM ||'|'||
            CASE SUBSTR(A.SIRASGN_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.UsuarioNodo.Banner.PDN'
                WHEN '4' THEN 'UPN.UsuarioNodo.Banner.UG'
                WHEN '5' THEN 'UPN.UsuarioNodo.Banner.WA'
                WHEN '7' THEN 'UPN.UsuarioNodo.Banner.Ingles'
                ELSE 'UPN.UsuarioNodo.Banner.EPEC' END
        FROM SIRASGN A
                INNER JOIN SSBSECT B ON A.SIRASGN_TERM_CODE = B.SSBSECT_TERM_CODE AND A.SIRASGN_CRN = B.SSBSECT_CRN
                INNER JOIN SSRATTR C ON B.SSBSECT_TERM_CODE = C.SSRATTR_TERM_CODE AND B.SSBSECT_CRN = C.SSRATTR_CRN
                INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                            FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                            ) D ON B.SSBSECT_TERM_CODE = D.SSRMEET_TERM_CODE AND B.SSBSECT_CRN = D.SSRMEET_CRN
                INNER JOIN SPRIDEN E ON A.SIRASGN_PIDM = E.SPRIDEN_PIDM AND E.SPRIDEN_CHANGE_IND IS NULL
        WHERE B.SSBSECT_SSTS_CODE = 'A' AND B.SSBSECT_ENRL > 0 --AND B.SSBSECT_MAX_ENRL > 0
            AND B.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
            AND SYSDATE BETWEEN D.START_DATE-20 AND D.END_DATE+10
            AND B.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                        WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
        ;
    SPOOL OFF

    SPOOL ./BbMatriculaOrgs.txt

        select 'external_organization_key|external_person_key|role|data_source_key' from dual;
        SELECT distinct 'PEPN01.UPN.ORG.' || CASE
                WHEN b.sorlcur_levl_code = 'UG'
                    AND substr(b.sorlcur_program,
                                5,
                                6) = 'UG'
                    AND b.sorlcur_program <> 'PDN-UG' THEN
                'UG'
                WHEN b.sorlcur_levl_code = 'UG'
                    AND substr(b.sorlcur_program,
                                5,
                                6) = 'WA' THEN
                'WA'
                WHEN b.sorlcur_levl_code = 'UG'
                    AND b.sorlcur_program = 'PDN-UG' THEN
                'PN'
                WHEN b.sorlcur_levl_code IN ('DO',
                                            'EC',
                                            'MA') THEN
                'EP'
            END || '.' || CASE
                WHEN b.sorlcur_camp_code IN ('TML',
                                            'TSI') THEN
                'TRU'
                ELSE
                b.sorlcur_camp_code
            END||'|'||
            a.gobsrid_pidm||
            '|S'||
            '|Banner'
        FROM gobsrid a,
            sorlcur b
        WHERE a.gobsrid_pidm = b.sorlcur_pidm
        AND b.sorlcur_cact_code = 'ACTIVE'
        AND b.sorlcur_lmod_code = 'LEARNER'
        AND b.sorlcur_current_cde = 'Y'
        AND b.sorlcur_levl_code <> 'CR'
        minus
        SELECT 'PEPN01.UPN.ORG.' || CASE       
                WHEN b.sorlcur_levl_code = 'UG'
                    AND b.sorlcur_program = 'PDN-UG' THEN
                'PN'
            END || '.' || CASE
                WHEN b.sorlcur_camp_code IN ('TML',
                                            'TSI') THEN
                'TRU'
                ELSE
                b.sorlcur_camp_code
            END||'|'||
            a.gobsrid_pidm||
            '|S'||
            '|Banner'
        FROM gobsrid a,
            sorlcur b
        WHERE a.gobsrid_pidm = b.sorlcur_pidm
        AND b.sorlcur_cact_code = 'ACTIVE'
        AND b.sorlcur_lmod_code = 'LEARNER'
        AND b.sorlcur_current_cde = 'Y'
            --and a.gobsrid_pidm=8888
        AND b.sorlcur_levl_code <> 'CR'; 
    spool off 

    SPOOL ./BbMetacursos.txt
        SELECT 'EXTERNAL_COURSE_KEY|COURSE_ID|COURSE_NAME|AVAILABLE_IND|ROW_STATUS|DURATION|START_DATE|END_DATE|TERM_KEY|DATA_SOURCE_KEY|PRIMARY_EXTERNAL_NODE_KEY|EXTERNAL_ASSOCIATION_KEY|MASTER_COURSE_KEY' FROM DUAL;
        SELECT DISTINCT
            CASE WHEN F.SSBSECT_SCHD_CODE = 'VIR' OR F.SSBSECT_INSM_CODE = 'V'
                THEN F.SSBSECT_SUBJ_CODE ||'.'|| F.SSBSECT_CRSE_NUMB ||'.'|| F.SSBSECT_TERM_CODE ||'.'|| F.SSBSECT_CRN ||'.'|| 'V'
                ELSE F.SSBSECT_SUBJ_CODE ||'.'|| F.SSBSECT_CRSE_NUMB ||'.'|| F.SSBSECT_TERM_CODE ||'.'|| F.SSBSECT_CRN ||'.'|| 'P' END ||'|'||
            CASE WHEN F.SSBSECT_SCHD_CODE = 'VIR' OR F.SSBSECT_INSM_CODE = 'V'
                THEN F.SSBSECT_SUBJ_CODE ||'.'|| F.SSBSECT_CRSE_NUMB ||'.'|| F.SSBSECT_TERM_CODE ||'.'|| F.SSBSECT_CRN ||'.'|| 'V'
                ELSE F.SSBSECT_SUBJ_CODE ||'.'|| F.SSBSECT_CRSE_NUMB ||'.'|| F.SSBSECT_TERM_CODE ||'.'|| F.SSBSECT_CRN ||'.'|| 'P' END ||'|'||
            CASE WHEN F.SSBSECT_SCHD_CODE = 'VIR' OR F.SSBSECT_INSM_CODE = 'V'
                THEN F.SCBCRSE_TITLE ||'(Virtual)'
                ELSE F.SCBCRSE_TITLE ||'(Presencial)' END ||'|'||
            CASE WHEN F.SSBSECT_SSTS_CODE = 'A' THEN 'Y' ELSE 'N' END ||'|'||
            CASE WHEN F.SSBSECT_SSTS_CODE = 'A' THEN 'ENABLED' ELSE 'DISABLED' END ||'|'||
            'R' ||'|'||
            TO_CHAR(F.START_DATE-20,'YYYYMMDD') ||'|'||
            TO_CHAR(F.END_DATE+10,'YYYYMMDD') ||'|'||
            F.SSBSECT_TERM_CODE ||'|'||
            CASE SUBSTR(F.SSBSECT_TERM_CODE,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
                WHEN '3' THEN 'UPN.Cursos.Banner.PDN'
                WHEN '4' THEN 'UPN.Cursos.Banner.UG'
                WHEN '5' THEN 'UPN.Cursos.Banner.WA'
                WHEN '7' THEN 'UPN.Cursos.Banner.Ingles'
                ELSE 'UPN.Cursos.Banner.EPEC' END ||'|'||
            'PEPN01.UPN.' ||
                CASE SUBSTR(F.SSBSECT_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN F.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE F.SSBSECT_CAMP_CODE END ||'.'||
                F.SSRATTR_ATTR_CODE ||'.'|| F.SSBSECT_TERM_CODE ||'|'||
            F.SSBSECT_CRN || '.PEPN01.UPN.' ||
                CASE SUBSTR(F.SSBSECT_TERM_CODE,4,1)
                    WHEN '3' THEN 'PN'
                    WHEN '4' THEN 'UG'
                    WHEN '5' THEN 'WA'
                    WHEN '7' THEN 'IN'
                    ELSE 'EP' END ||'.'||
                CASE WHEN F.SSBSECT_CAMP_CODE IN ('TML','TSI') THEN 'TRU' ELSE F.SSBSECT_CAMP_CODE END ||'.'||
                F.SSRATTR_ATTR_CODE ||'.'|| F.SSBSECT_TERM_CODE ||'|'||
            G.SSBSECT_SUBJ_CODE ||'.'|| G.SSBSECT_CRSE_NUMB ||'.'|| F.SSBSECT_TERM_CODE ||'.'|| F.NRC_PADRE ||'.'|| 'P'
        FROM ( SELECT DISTINCT
                    A.SSBSECT_TERM_CODE, A.SSBSECT_CRN, A.SSBSECT_SUBJ_CODE, A.SSBSECT_CRSE_NUMB, B.SCBCRSE_TITLE, A.SSBSECT_SCHD_CODE, A.SSBSECT_INSM_CODE
                    , A.SSBSECT_SSTS_CODE, A.SSBSECT_CAMP_CODE, D.START_DATE, D.END_DATE, C.SSRATTR_ATTR_CODE, E.SSRXLST_XLST_GROUP
                    , MIN(A.SSBSECT_CRN) OVER(PARTITION BY A.SSBSECT_TERM_CODE, E.ssrxlst_xlst_group) AS NRC_PADRE
                FROM SSBSECT A
                        INNER JOIN SCBCRSE B ON A.SSBSECT_SUBJ_CODE = B.SCBCRSE_SUBJ_CODE AND A.SSBSECT_CRSE_NUMB = B.SCBCRSE_CRSE_NUMB
                                                        AND B.SCBCRSE_EFF_TERM = (SELECT MAX(B1.SCBCRSE_EFF_TERM) FROM SCBCRSE B1
                                                                                    WHERE B1.SCBCRSE_SUBJ_CODE = A.SSBSECT_SUBJ_CODE AND B1.SCBCRSE_CRSE_NUMB = A.SSBSECT_CRSE_NUMB
                                                                                        AND B1.SCBCRSE_EFF_TERM <= A.SSBSECT_TERM_CODE)
                        INNER JOIN SSRATTR C ON A.SSBSECT_TERM_CODE = C.SSRATTR_TERM_CODE AND A.SSBSECT_CRN = C.SSRATTR_CRN
                        INNER JOIN (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
                                        , MIN(SSRMEET_START_DATE) AS START_DATE, MAX(SSRMEET_END_DATE) AS END_DATE
                                    FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN
                                    ) D ON A.SSBSECT_TERM_CODE = D.SSRMEET_TERM_CODE AND A.SSBSECT_CRN = D.SSRMEET_CRN
                        INNER JOIN SSRXLST E ON A.SSBSECT_TERM_CODE = E.SSRXLST_TERM_CODE AND A.SSBSECT_CRN = E.SSRXLST_CRN
                WHERE A.SSBSECT_SSTS_CODE = 'A' AND A.SSBSECT_ENRL > 0 --AND A.SSBSECT_MAX_ENRL > 0
                    AND A.SSBSECT_SUBJ_CODE NOT IN ('ACAD','REPS','TEST','XPEN','XSER')
                    AND SYSDATE BETWEEN D.START_DATE-20 AND D.END_DATE+10
                    AND A.SSBSECT_TERM_CODE IN (SELECT DISTINCT SOBPTRM_TERM_CODE FROM SOBPTRM
                                                WHERE SYSDATE BETWEEN SOBPTRM_START_DATE-20 AND SOBPTRM_END_DATE+10)
                ) F
                    INNER JOIN SSBSECT G ON F.SSBSECT_TERM_CODE = G.SSBSECT_TERM_CODE AND F.NRC_PADRE = G.SSBSECT_CRN
        WHERE F.SSBSECT_CRN <> F.NRC_PADRE
        ;
    SPOOL OFF

   exit
_EOF_

scp -i upnBlackboard.key *.txt usftpbb_p@10.144.3.204:~/
rm *.txt
