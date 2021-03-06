--BdPeriodos_
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
	    AND SYSDATE BETWEEN SOBPTRM_START_DATE-8 AND SOBPTRM_END_DATE+10
	;
SPOOL OFF