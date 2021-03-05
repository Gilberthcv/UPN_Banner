select 'EXTERNAL_COURSE_KEY|EXTERNAL_PERSON_KEY|ROLE|DATA_SOURCE_KEY' from dual;
    SELECT DISTINCT
        case when b.SSBSECT_SCHD_CODE = 'VIR' OR b.ssbsect_insm_code = 'V'
            then b.ssbsect_subj_code ||'.'|| b.ssbsect_crse_numb ||'.'|| b.ssbsect_term_code ||'.'|| b.ssbsect_crn ||'.'|| 'V'
          else b.ssbsect_subj_code ||'.'|| b.ssbsect_crse_numb ||'.'|| b.ssbsect_term_code ||'.'|| b.ssbsect_crn ||'.'|| 'P' end ||'|'||
        a.sfrstcr_pidm ||
        '|S|' ||
        CASE SUBSTR(a.sfrstcr_term_code,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
            WHEN '3' THEN 'UPN.Matriculas.Banner.PDN'
            WHEN '4' THEN 'UPN.Matriculas.Banner.UG'
            WHEN '5' THEN 'UPN.Matriculas.Banner.WA'
            WHEN '7' THEN 'UPN.Matriculas.Banner.Ingles'
          ELSE 'UPN.Matriculas.Banner.EPEC' END
    FROM sfrstcr a,
         ssbsect b,
         (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
              , MIN(SSRMEET_START_DATE) AS START_DATE
              , MAX(SSRMEET_END_DATE) AS END_DATE
          FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN) c
    WHERE a.sfrstcr_term_code = b.ssbsect_term_code AND a.sfrstcr_crn = b.ssbsect_crn
        AND b.ssbsect_term_code = c.ssrmeet_term_code AND b.ssbsect_crn = c.ssrmeet_crn
        AND a.sfrstcr_rsts_code in ('RE','RW','RA')
        AND b.SSBSECT_SSTS_CODE = 'A' AND b.SSBSECT_MAX_ENRL > 0 AND b.SSBSECT_ENRL > 0
        AND b.ssbsect_subj_code not in ('ACAD','REPS','TEST','XPEN','XSER')
        AND c.START_DATE <= SYSDATE +7 AND c.END_DATE >= SYSDATE -16
        AND b.ssbsect_term_code in (SELECT DISTINCT sobptrm_term_code FROM sobptrm
                                    WHERE sobptrm_start_date <= SYSDATE +7 AND sobptrm_end_date >= SYSDATE -16)
    UNION
    SELECT DISTINCT
        case when b.SSBSECT_SCHD_CODE = 'VIR' OR b.ssbsect_insm_code = 'V'
            then b.ssbsect_subj_code ||'.'|| b.ssbsect_crse_numb ||'.'|| b.ssbsect_term_code ||'.'|| b.ssbsect_crn ||'.'|| 'V'
          else b.ssbsect_subj_code ||'.'|| b.ssbsect_crse_numb ||'.'|| b.ssbsect_term_code ||'.'|| b.ssbsect_crn ||'.'|| 'P' end ||'|'||
        a.sirasgn_pidm ||'|'||
        case when b.SSBSECT_SCHD_CODE = 'VIR' OR b.ssbsect_insm_code = 'V' then 'PV' else 'PP' end ||'|'||        
        CASE SUBSTR(a.sirasgn_term_code,4,1) --'UPN.<Instancia>.Banner.<Nivel>'
            WHEN '3' THEN 'UPN.Matriculas.Banner.PDN'
            WHEN '4' THEN 'UPN.Matriculas.Banner.UG'
            WHEN '5' THEN 'UPN.Matriculas.Banner.WA'
            WHEN '7' THEN 'UPN.Matriculas.Banner.Ingles'
          ELSE 'UPN.Matriculas.Banner.EPEC' END
    FROM sirasgn a,
         ssbsect b,
         (SELECT DISTINCT SSRMEET_TERM_CODE, SSRMEET_CRN
              , MIN(SSRMEET_START_DATE) AS START_DATE
              , MAX(SSRMEET_END_DATE) AS END_DATE
          FROM SSRMEET GROUP BY SSRMEET_TERM_CODE, SSRMEET_CRN) c
    WHERE a.sirasgn_term_code = b.ssbsect_term_code AND a.sirasgn_crn = b.ssbsect_crn
        AND b.ssbsect_term_code = c.ssrmeet_term_code AND b.ssbsect_crn = c.ssrmeet_crn
        AND b.SSBSECT_SSTS_CODE = 'A' AND b.SSBSECT_MAX_ENRL > 0 AND b.SSBSECT_ENRL > 0
        AND b.ssbsect_subj_code not in ('ACAD','REPS','TEST','XPEN','XSER')
        AND c.START_DATE <= SYSDATE +7 AND c.END_DATE >= SYSDATE -16
        AND b.ssbsect_term_code in (SELECT DISTINCT sobptrm_term_code FROM sobptrm
                                    WHERE sobptrm_start_date <= SYSDATE +7 AND sobptrm_end_date >= SYSDATE -16);
  spool off