--Matriculas_Ambos_Niveles
SELECT SFRSTCR_PIDM, SPRIDEN_ID, SPRIDEN_LAST_NAME ||', '|| SPRIDEN_FIRST_NAME AS ESTUDIANTE, SFRSTCR_TERM_CODE
FROM SFRSTCR
		INNER JOIN SPRIDEN ON SFRSTCR_PIDM = SPRIDEN_PIDM AND SPRIDEN_CHANGE_IND IS NULL
WHERE SFRSTCR_TERM_CODE IN ('220435','220534')
GROUP BY SFRSTCR_PIDM, SPRIDEN_ID, SPRIDEN_LAST_NAME ||', '|| SPRIDEN_FIRST_NAME, SFRSTCR_TERM_CODE
HAVING COUNT(DISTINCT SFRSTCR_TERM_CODE) > 1
ORDER BY SFRSTCR_PIDM, SFRSTCR_TERM_CODE
;