--Validar_Cursos_Sustitutos_
SELECT DISTINCT NVL(P.SMBPOGN_TERM_CODE_EFF,P0.SMBPOGN_TERM_CODE_EFF) AS SMBPOGN_TERM_CODE_EFF, SMRSSUB_PIDM, S.SPRIDEN_ID, SMRSSUB_TERM_CODE_EFF
	, SMRSSUB_SUBJ_CODE_REQ, SMRSSUB_CRSE_NUMB_REQ, SMRSSUB_AREA, SMRSSUB_SUBJ_CODE_SUB, SMRSSUB_CRSE_NUMB_SUB, SMRSSUB_ACTIVITY_DATE, SMRSSUB_CREDITS
	, SMBSOTK_USER, TRIM( NVL(U.SPRIDEN_LAST_NAME,'') ||' '|| NVL(U.SPRIDEN_FIRST_NAME,'') ) AS USUARIO
FROM SMRSSUB
		INNER JOIN SPRIDEN S ON SMRSSUB_PIDM = S.SPRIDEN_PIDM AND S.SPRIDEN_CHANGE_IND IS NULL
		LEFT JOIN SMBPOGN P ON SMRSSUB_PIDM = P.SMBPOGN_PIDM
							AND P.SMBPOGN_TERM_CODE_EFF = (SELECT MAX(P1.SMBPOGN_TERM_CODE_EFF) FROM SMBPOGN P1
															WHERE P1.SMBPOGN_PIDM = SMRSSUB_PIDM AND P1.SMBPOGN_TERM_CODE_EFF <= SMRSSUB_TERM_CODE_EFF)
		LEFT JOIN SMBPOGN P0 ON SMRSSUB_PIDM = P0.SMBPOGN_PIDM
							AND P0.SMBPOGN_TERM_CODE_EFF = (SELECT MIN(P2.SMBPOGN_TERM_CODE_EFF) FROM SMBPOGN P2
															WHERE P2.SMBPOGN_PIDM = SMRSSUB_PIDM AND P2.SMBPOGN_TERM_CODE_EFF >= SMRSSUB_TERM_CODE_EFF)
		LEFT JOIN SMBSOTK ON SMRSSUB_PIDM = SMBSOTK_PIDM AND SMRSSUB_TERM_CODE_EFF = SMBSOTK_TERM_CODE_EFF AND SMBSOTK_TABLE_NAME = 'SMRSSUB'
		LEFT JOIN SPRIDEN U ON SUBSTR(SMBSOTK_USER,2) = U.SPRIDEN_ID AND U.SPRIDEN_CHANGE_IND IS NULL
WHERE SMRSSUB_CREDITS IS NOT NULL OR SMRSSUB_TERM_CODE_EFF <> NVL(P.SMBPOGN_TERM_CODE_EFF,P0.SMBPOGN_TERM_CODE_EFF)
;