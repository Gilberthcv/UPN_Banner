--AC039
SELECT X.SFBETRM_PIDM, X.SPRIDEN_ID, X.NOMBRE_ESTUDIANTE, X.SFBETRM_TERM_CODE, X.SOVLCUR_PROGRAM, X.SMRPRLE_PROGRAM_DESC, X.SOVLCUR_CAMP_CODE, X.FECHA_REGISTRO_CURSOS, X.TIPO_ESTUDIANTE, X.CREDITOS, X.CURSOS
FROM (
	SELECT DISTINCT
	    SFBETRM_PIDM, SPRIDEN_ID, CONCAT(SPRIDEN_LAST_NAME,CONCAT(', ',SPRIDEN_FIRST_NAME)) AS NOMBRE_ESTUDIANTE, SFBETRM_TERM_CODE, SOVLCUR_PROGRAM, SMRPRLE_PROGRAM_DESC, SOVLCUR_CAMP_CODE
	    , MIN(SFRSTCR_ADD_DATE) OVER(PARTITION BY SFRSTCR_PIDM,SFRSTCR_TERM_CODE) AS FECHA_REGISTRO_CURSOS
		, CASE COALESCE(SOVLCUR_STYP_CODE,'C')
			WHEN 'N' THEN 
				CASE 
					WHEN SOVLCUR_LEVL_CODE = 'UG' AND SGRCHRT_CHRT_CODE = 'NEW_REING' THEN 'Nuevo Reingreso'
					WHEN SOVLCUR_LEVL_CODE = 'UG' AND SGRCHRT_CHRT_CODE = 'REINGRESO' THEN 'Reingreso'
					WHEN SOVLCUR_ADMT_CODE = 'II' THEN 'Intercambio IN'
					ELSE 'Nuevo' END
			WHEN 'C' THEN 
				CASE 
					WHEN SOVLCUR_LEVL_CODE = 'UG' AND SGRCHRT_CHRT_CODE = 'NEW_REING' THEN 'Nuevo Reingreso'
					WHEN SOVLCUR_LEVL_CODE = 'UG' AND SGRCHRT_CHRT_CODE = 'REINGRESO' THEN 'Reingreso'
					WHEN SOVLCUR_ADMT_CODE = 'II' THEN 'Intercambio IN'
					WHEN SOVLCUR_ADMT_CODE <> 'RE' AND SGRSATT_ATTS_CODE = 'TINT' THEN 'Intercambio OUT'
					WHEN SGRSACT_ACTC_CODE = 'DTO' AND SGRSATT_ATTS_CODE = 'TINT' THEN 'Doble Titulacion OUT'
					WHEN SGRSACT_ACTC_CODE = 'ITO' AND SGRSATT_ATTS_CODE = 'TINT' THEN 'Intercambio OUT'
					ELSE 'Continuo' END
			ELSE COALESCE(SOVLCUR_STYP_CODE,'C') END AS TIPO_ESTUDIANTE
	    , SUM(SFRSTCR_CREDIT_HR) OVER(PARTITION BY SFRSTCR_PIDM,SFRSTCR_TERM_CODE) AS CREDITOS
	    , COUNT(SFRSTCR_CRN) OVER(PARTITION BY SFRSTCR_PIDM,SFRSTCR_TERM_CODE) AS CURSOS
	    , MAX(CASE WHEN SSBSECT_SUBJ_CODE = 'XSER' THEN SSBSECT_SUBJ_CODE END) OVER(PARTITION BY SFRSTCR_PIDM,SFRSTCR_TERM_CODE) AS MATERIA_XSER
	FROM SFBETRM
			INNER JOIN SFRSTCR ON SFBETRM_PIDM = SFRSTCR_PIDM AND SFBETRM_TERM_CODE = SFRSTCR_TERM_CODE AND SFRSTCR_RSTS_CODE IN ('RE','RW','RA','WC','RF','RO','IA')
			INNER JOIN SSBSECT ON SFRSTCR_TERM_CODE = SSBSECT_TERM_CODE AND SFRSTCR_CRN = SSBSECT_CRN
			LEFT JOIN SOVLCUR ON SFBETRM_PIDM = SOVLCUR_PIDM
												AND SOVLCUR_SEQNO = (SELECT MAX(S1.SOVLCUR_SEQNO) FROM SOVLCUR S1
																		WHERE S1.SOVLCUR_PIDM = SFBETRM_PIDM AND SFBETRM_TERM_CODE BETWEEN S1.SOVLCUR_TERM_CODE AND COALESCE(S1.SOVLCUR_TERM_CODE_END,'999996')
																			AND S1.SOVLCUR_LEVL_CODE = 'UG' AND S1.SOVLCUR_LMOD_CODE = 'LEARNER' AND S1.SOVLCUR_CACT_CODE = 'ACTIVE')
			LEFT JOIN SMRPRLE ON SOVLCUR_PROGRAM = SMRPRLE_PROGRAM
			--LEFT JOIN STVCAMP ON SOVLCUR_CAMP_CODE = STVCAMP_CODE
			LEFT JOIN SGRCHRT ON SFBETRM_PIDM = SGRCHRT_PIDM AND (SGRCHRT_ACTIVE_IND = 'Y' OR SGRCHRT_ACTIVE_IND IS NULL) AND SGRCHRT_CHRT_CODE IN ('NEW_REING','REINGRESO')
									AND SGRCHRT_TERM_CODE_EFF = (SELECT MAX(C1.SGRCHRT_TERM_CODE_EFF) FROM SGRCHRT C1
																	WHERE C1.SGRCHRT_PIDM = SFBETRM_PIDM AND C1.SGRCHRT_TERM_CODE_EFF <= SFBETRM_TERM_CODE
																		AND (C1.SGRCHRT_ACTIVE_IND = 'Y' OR C1.SGRCHRT_ACTIVE_IND IS NULL) AND C1.SGRCHRT_CHRT_CODE IN ('NEW_REING','REINGRESO'))
			LEFT JOIN SGRSATT ON SFBETRM_PIDM = SGRSATT_PIDM AND SGRSATT_ATTS_CODE = 'TINT'
									AND SGRSATT_TERM_CODE_EFF = (SELECT MAX(AT.SGRSATT_TERM_CODE_EFF) FROM SGRSATT AT
																	WHERE AT.SGRSATT_PIDM = SFBETRM_PIDM AND AT.SGRSATT_TERM_CODE_EFF <= SFBETRM_TERM_CODE AND AT.SGRSATT_ATTS_CODE = 'TINT')
			LEFT JOIN SGRSACT ON SFBETRM_PIDM = SGRSACT_PIDM AND SGRSACT_ACTC_CODE = 'ITO'
									AND SGRSACT_TERM_CODE = (SELECT MAX(AC.SGRSACT_TERM_CODE) FROM SGRSACT AC
																	WHERE AC.SGRSACT_PIDM = SFBETRM_PIDM AND AC.SGRSACT_TERM_CODE <= SFBETRM_TERM_CODE AND AC.SGRSACT_ACTC_CODE = 'ITO')
	     	LEFT JOIN SPRIDEN ON SFBETRM_PIDM = SPRIDEN_PIDM AND SPRIDEN_CHANGE_IND IS NULL
	WHERE SFBETRM_ESTS_CODE IN ('EL','RF','RO','SE') AND SFBETRM_TERM_CODE IN ('220435','220534')
	) X
WHERE X.MATERIA_XSER IS NULL
;