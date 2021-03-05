--BdMatriculas_
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