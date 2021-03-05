--BdNodos_
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