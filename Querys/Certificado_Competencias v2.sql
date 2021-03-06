--Certificado_Competencias_Detalle_
SELECT FACULTAD, PROGRAMA, PERIODO_CATALOGO, CAMPUS, CERTIFICADO, ID_ESTUDIANTE, ESTUDIANTE, ITEM, CURSO_CERTIFICACION, CURSO_APROBADO
	, REFERENCIA, NOTA, SEMESTRE, RETENCION, CORREO_INSTITUCIONAL, CARGO_1, AUTORIDAD_1, CARGO_2, AUTORIDAD_2 FROM (
SELECT DISTINCT C.SMBPOGN_COLL_CODE AS FACULTAD, C.SMBAOGN_PROGRAM AS PROGRAMA, C.SMBAOGN_TERM_CODE_EFF AS PERIODO_CATALOGO, C.SMBPOGN_CAMP_CODE AS CAMPUS	--, SMBAOGN_PIDM
	, TRIM( MAX(CASE WHEN SMRACMT_PRNT_CODE = 'LNAME1' THEN SMRACMT_TEXT END) OVER(PARTITION BY SMRACMT_AREA, SMRACMT_TERM_CODE_EFF)
			|| MAX(CASE WHEN SMRACMT_PRNT_CODE = 'LNAME2' THEN SMRACMT_TEXT ELSE ' ' END) OVER(PARTITION BY SMRACMT_AREA, SMRACMT_TERM_CODE_EFF) ) AS CERTIFICADO
	, C.SPRIDEN_ID AS ID_ESTUDIANTE, C.SPRIDEN_LAST_NAME ||', '|| C.SPRIDEN_FIRST_NAME AS ESTUDIANTE
	--, C.SMBAOGN_REQUEST_NO AS SOLICITUD, C.SMBPOGN_ACTIVITY_DATE, C.SMRDOUS_COMPLIANCE_ORDER AS ITEM
	, ROW_NUMBER() OVER(PARTITION BY C.SMBAOGN_PROGRAM, C.SMBAOGN_TERM_CODE_EFF, C.SMBAOGN_PIDM ORDER BY D.SMRACAA_SEQNO/*, C.SMRDOUS_COMPLIANCE_ORDER*/) AS ITEM
	, D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW ||' - '|| SCBCRSE_TITLE AS CURSO_CERTIFICACION
	, C.SMRDOUS_SUBJ_CODE || C.SMRDOUS_CRSE_NUMB ||' - '|| C.SMRDOUS_TITLE AS CURSO_APROBADO
	, CASE 
		WHEN D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW = C.SMRDOUS_SUBJ_CODE||C.SMRDOUS_CRSE_NUMB AND SUBSTR(C.SMRDOUS_GRDE_CODE,1,1) = 'C' THEN 'EL MISMO CURSO, CONVALIDADO'
		WHEN D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW = C.SMRDOUS_SUBJ_CODE||C.SMRDOUS_CRSE_NUMB THEN 'EL MISMO CURSO'
		WHEN D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW = C.SCREQIV_SUBJ_CODE_EQIV||C.SCREQIV_CRSE_NUMB_EQIV AND SUBSTR(C.SMRDOUS_GRDE_CODE,1,1) = 'C' THEN 'CURSO EQUIVALENTE, CONVALIDADO'
		WHEN D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW = C.SCREQIV_SUBJ_CODE_EQIV||C.SCREQIV_CRSE_NUMB_EQIV THEN 'CURSO EQUIVALENTE'
		WHEN D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW = C.SMRSSUB_SUBJ_CODE_REQ||C.SMRSSUB_CRSE_NUMB_REQ AND SUBSTR(C.SMRDOUS_GRDE_CODE,1,1) = 'C' THEN 'CURSO SUSTITUTO, CONVALIDADO'
		WHEN D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW = C.SMRSSUB_SUBJ_CODE_REQ||C.SMRSSUB_CRSE_NUMB_REQ THEN 'CURSO SUSTITUTO'
		ELSE 'CURSO CUMPLIDO POR AJUSTE DE CAPP' END AS REFERENCIA
	, C.SMRDOUS_GRDE_CODE AS NOTA, C.SMRDOUS_TERM_CODE AS SEMESTRE
	, MAX(CASE 
		WHEN D1.SMRACAA_SUBJ_CODE||D1.SMRACAA_CRSE_NUMB_LOW = C.SMRDOUS_SUBJ_CODE||C.SMRDOUS_CRSE_NUMB AND SUBSTR(C.SMRDOUS_GRDE_CODE,1,1) = 'C' THEN NULL
		WHEN D1.SMRACAA_SUBJ_CODE||D1.SMRACAA_CRSE_NUMB_LOW = C.SMRDOUS_SUBJ_CODE||C.SMRDOUS_CRSE_NUMB THEN 'EL MISMO CURSO'
		ELSE NULL END) OVER(PARTITION BY C.SMBAOGN_PROGRAM, C.SMBAOGN_TERM_CODE_EFF, C.SMBAOGN_PIDM) AS CURSO_CAPSTONE
	, SPRHOLD_HLDD_CODE AS RETENCION, C.SPRIDEN_ID || '@upn.pe' AS CORREO_INSTITUCIONAL
	, CASE C.SMBPOGN_COLL_CODE
		WHEN 'IN' THEN 'Decano'
		WHEN 'NE' THEN 'Decano'
		WHEN 'AR' THEN 'Decano'
		WHEN 'SA' THEN 'Decana ( e )'
		WHEN 'CO' THEN 'Decana'
		WHEN 'DE' THEN 'Decano'
		ELSE NULL END AS CARGO_1
	, CASE C.SMBPOGN_COLL_CODE
		WHEN 'IN' THEN 'Jose N. Gonzales Quijano'
		WHEN 'NE' THEN 'Augusto F. Caceres Rosell'
		WHEN 'AR' THEN 'Jose Ignacio Pacheco Diaz'
		WHEN 'SA' THEN 'Patricia N. Piscoya Angeles'
		WHEN 'CO' THEN 'Patricia L. Sanchez Urrego'
		WHEN 'DE' THEN 'Alberto Villanueva Eslava'
		ELSE NULL END AS AUTORIDAD_1
	, 'Vicerrector Acad�mico' AS CARGO_2, 'Jose N. Gonzales Quijano' AS AUTORIDAD_2	
FROM ( SELECT DISTINCT SMBPOGN_COLL_CODE, SMBAOGN_PROGRAM, SMBAOGN_TERM_CODE_EFF, SMBPOGN_CAMP_CODE, SMBAOGN_PIDM, SPRIDEN_ID, SPRIDEN_LAST_NAME, SPRIDEN_FIRST_NAME, SMBAOGN_REQUEST_NO
			, SMBPOGN_ACTIVITY_DATE, SMBAOGN_AREA, SMRDOUS_COMPLIANCE_ORDER, SMRDOUS_SUBJ_CODE, SMRDOUS_CRSE_NUMB, SMRDOUS_TITLE, SMRDOUS_GRDE_CODE, SMRDOUS_TERM_CODE
			, MIN(SMRDOUS_TERM_CODE) OVER(PARTITION BY SMRDOUS_PIDM, SMRDOUS_REQUEST_NO, SMRDOUS_AREA) AS MIN_SMRDOUS_TERM_CODE
			, MAX(SMRDOUS_TERM_CODE) OVER(PARTITION BY SMRDOUS_PIDM, SMRDOUS_REQUEST_NO, SMRDOUS_AREA) AS MAX_SMRDOUS_TERM_CODE
			, SCREQIV_SUBJ_CODE_EQIV, SCREQIV_CRSE_NUMB_EQIV, SMRSSUB_SUBJ_CODE_REQ, SMRSSUB_CRSE_NUMB_REQ
		FROM SMBAOGN A
				INNER JOIN SMRDOUS ON SMBAOGN_PIDM = SMRDOUS_PIDM AND SMBAOGN_REQUEST_NO = SMRDOUS_REQUEST_NO AND SMBAOGN_AREA = SMRDOUS_AREA
				INNER JOIN SMBPOGN B ON SMBAOGN_PIDM = SMBPOGN_PIDM AND SMBAOGN_REQUEST_NO = SMBPOGN_REQUEST_NO
										AND B.SMBPOGN_REQUEST_NO = (SELECT MAX(B1.SMBPOGN_REQUEST_NO) FROM SMBPOGN B1
																	WHERE B1.SMBPOGN_PIDM = B.SMBPOGN_PIDM AND B1.SMBPOGN_PROGRAM = B.SMBPOGN_PROGRAM)
				INNER JOIN SPRIDEN ON SMBAOGN_PIDM = SPRIDEN_PIDM AND SPRIDEN_CHANGE_IND IS NULL
				LEFT JOIN ( SELECT SMRACAA_AREA, SMRACAA_TERM_CODE_EFF, SCREQIV_SUBJ_CODE, SCREQIV_CRSE_NUMB, SCREQIV_SUBJ_CODE_EQIV, SCREQIV_CRSE_NUMB_EQIV
							FROM SMRACAA, SCREQIV
							WHERE SMRACAA_SUBJ_CODE = SCREQIV_SUBJ_CODE_EQIV AND SMRACAA_CRSE_NUMB_LOW = SCREQIV_CRSE_NUMB_EQIV
								AND SMRACAA_TERM_CODE_EFF BETWEEN SCREQIV_START_TERM AND SCREQIV_END_TERM AND SMRACAA_AREA LIKE '%-CERT'
							) E ON SMRDOUS_SUBJ_CODE = SCREQIV_SUBJ_CODE AND SMRDOUS_CRSE_NUMB = SCREQIV_CRSE_NUMB AND SMRDOUS_AREA = SMRACAA_AREA AND SMRDOUS_TERM_CODE_EFF = SMRACAA_TERM_CODE_EFF
				LEFT JOIN SMRSSUB ON SMRDOUS_PIDM = SMRSSUB_PIDM AND SMRDOUS_SUBJ_CODE = SMRSSUB_SUBJ_CODE_SUB AND SMRDOUS_CRSE_NUMB = SMRSSUB_CRSE_NUMB_SUB
		WHERE SMBAOGN_MET_IND = 'Y' AND SMBAOGN_AREA LIKE '%-CERT'
			AND A.SMBAOGN_REQUEST_NO = (SELECT MAX(A1.SMBAOGN_REQUEST_NO) FROM SMBAOGN A1
										WHERE A1.SMBAOGN_PIDM = A.SMBAOGN_PIDM AND A1.SMBAOGN_PROGRAM = A.SMBAOGN_PROGRAM AND A1.SMBAOGN_AREA LIKE '%-CERT')
	)C
		LEFT JOIN SMRACAA D ON C.SMBAOGN_AREA = D.SMRACAA_AREA AND C.SMBAOGN_TERM_CODE_EFF = D.SMRACAA_TERM_CODE_EFF
							AND (C.SMRDOUS_SUBJ_CODE||C.SMRDOUS_CRSE_NUMB = D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW
									OR C.SCREQIV_SUBJ_CODE_EQIV||C.SCREQIV_CRSE_NUMB_EQIV = D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW
									OR C.SMRSSUB_SUBJ_CODE_REQ||C.SMRSSUB_CRSE_NUMB_REQ = D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW)
		LEFT JOIN SMRACAA D1 ON C.SMBAOGN_AREA = D1.SMRACAA_AREA AND C.SMBAOGN_TERM_CODE_EFF = D1.SMRACAA_TERM_CODE_EFF AND C.SMRDOUS_SUBJ_CODE||C.SMRDOUS_CRSE_NUMB = D1.SMRACAA_SUBJ_CODE||D1.SMRACAA_CRSE_NUMB_LOW
								AND D1.SMRACAA_SEQNO = (SELECT MAX(D2.SMRACAA_SEQNO) FROM SMRACAA D2
														WHERE D2.SMRACAA_AREA = D1.SMRACAA_AREA AND D2.SMRACAA_TERM_CODE_EFF = D1.SMRACAA_TERM_CODE_EFF)
		LEFT JOIN SCBCRSE E ON D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW = SCBCRSE_SUBJ_CODE||SCBCRSE_CRSE_NUMB
							AND E.SCBCRSE_EFF_TERM = (SELECT MAX(E1.SCBCRSE_EFF_TERM) FROM SCBCRSE E1
														WHERE E1.SCBCRSE_SUBJ_CODE||E1.SCBCRSE_CRSE_NUMB = D.SMRACAA_SUBJ_CODE||D.SMRACAA_CRSE_NUMB_LOW AND E1.SCBCRSE_EFF_TERM <= D.SMRACAA_TERM_CODE_EFF)
		LEFT JOIN SMRACMT ON C.SMBAOGN_AREA = SMRACMT_AREA AND C.SMBAOGN_TERM_CODE_EFF = SMRACMT_TERM_CODE_EFF AND SMRACMT_PRNT_CODE = 'LNAME1'
		LEFT JOIN SPRHOLD ON C.SMBAOGN_PIDM = SPRHOLD_PIDM AND SPRHOLD_HLDD_CODE = 'SD' AND SYSDATE BETWEEN SPRHOLD_FROM_DATE AND SPRHOLD_TO_DATE
WHERE ((SUBSTR(C.MIN_SMRDOUS_TERM_CODE,4,1) = 4 AND C.MIN_SMRDOUS_TERM_CODE >= '218434') OR (SUBSTR(C.MIN_SMRDOUS_TERM_CODE,4,1) = 5 AND C.MIN_SMRDOUS_TERM_CODE >= '218533')) --AND SPRHOLD_PIDM IS NULL
	AND C.MAX_SMRDOUS_TERM_CODE IN ('220413','220513')	--2020-1
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('220402','220502')	--2020-0
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('219435','219534')	--2019-2
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('219413','219414','219513','219514')	--2019-1
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('219402','219501')	--2019-0
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('218434','218533')	--2018-2
--ORDER BY C.SMBPOGN_COLL_CODE, C.SMBAOGN_PROGRAM, C.SMBAOGN_TERM_CODE_EFF, C.SMBPOGN_CAMP_CODE, C.SPRIDEN_ID, 8
)
WHERE CURSO_CAPSTONE IS NOT NULL
ORDER BY FACULTAD, PROGRAMA, PERIODO_CATALOGO, CAMPUS, ID_ESTUDIANTE, ITEM
;

--Certificado_Competencias_Resumen_
SELECT SPBPERS_LEGAL_NAME AS NOMBRES_APELLIDOS, C.SPRIDEN_ID AS CODIGO_MATRICULA
	, TRIM(MAX(CASE WHEN SMRPCMT_PRNT_CODE = 'LNAME1' THEN SMRPCMT_TEXT END) || MAX(CASE WHEN SMRPCMT_PRNT_CODE = 'LNAME2' THEN SMRPCMT_TEXT ELSE ' ' END)) AS NOMBRE_CARRERA
	, TRIM(MAX(CASE WHEN SMRACMT_PRNT_CODE = 'LNAME1' THEN SMRACMT_TEXT END) || MAX(CASE WHEN SMRACMT_PRNT_CODE = 'LNAME2' THEN SMRACMT_TEXT ELSE ' ' END)) AS NOMBRE_CERTIFICACION
	, STVCAMP_DESC AS NOMBRE_CAMPUS, C.SMBPOGN_COLL_CODE AS FACULTAD
	, CASE C.SMBPOGN_COLL_CODE
		WHEN 'IN' THEN 'Jose N. Gonzales Quijano'
		WHEN 'NE' THEN 'Augusto F. Caceres Rosell'
		WHEN 'AR' THEN 'Jose Ignacio Pacheco Diaz'
		WHEN 'SA' THEN 'Patricia N. Piscoya Angeles'
		WHEN 'CO' THEN 'Patricia L. Sanchez Urrego'
		WHEN 'DE' THEN 'Alberto Villanueva Eslava'
		ELSE NULL END AS NOMBRE_DECANO
	, CASE C.SMBPOGN_COLL_CODE
		WHEN 'IN' THEN 'Decano'
		WHEN 'NE' THEN 'Decano'
		WHEN 'AR' THEN 'Decano'
		WHEN 'SA' THEN 'Decana ( e )'
		WHEN 'CO' THEN 'Decana'
		WHEN 'DE' THEN 'Decano'
		ELSE NULL END AS CARGO_DECANO
	, CASE C.SMBPOGN_COLL_CODE 
		WHEN 'NE' THEN 'IMAGEN_F_DEC_NEGOCIOS' 
		WHEN 'IN' THEN 'IMAGEN_F_DEC_INGENIERIA' 
		WHEN 'DE' THEN 'IMAGEN_F_DEC_DERECHO' 
		WHEN 'CO' THEN 'IMAGEN_F_DEC_COMUNICACIONES' 
		WHEN 'AR' THEN 'IMAGEN_F_DEC_ARQUITECTURA Y DISE�O' 
		WHEN 'SA' THEN 'IMAGEN_F_DEC_CIENCIAS DE LA SALUD' 
		ELSE NULL END AS NOMBRE_FIRMA_DECANO
	, 'Patricia C. Somocurcio Donet' AS NOMBRE_DIRECTORA, 'Directora de Secretar�a Acad�mica' AS CARGO_DIRECTORA
	, 'Jose N. Gonzales Quijano' AS NOMBRE_VICERRECTOR, 'Vicerrector Acad�mico' AS CARGO_VICERRECTOR
	, CASE SUBSTR(:MES,1,2)
		WHEN '01' THEN 'enero'
		WHEN '02' THEN 'febrero'
		WHEN '03' THEN 'marzo'
		WHEN '04' THEN 'abril'
		WHEN '05' THEN 'mayo'
		WHEN '06' THEN 'junio'
		WHEN '07' THEN 'julio'
		WHEN '08' THEN 'agosto'
		WHEN '09' THEN 'setiembre'
		WHEN '10' THEN 'octubre'
		WHEN '11' THEN 'noviemnre'
		WHEN '12' THEN 'diciembre'
		ELSE NULL END ||' de '|| SUBSTR(:ANIO,1,4) AS MES_ANIO
	, C.SPRIDEN_ID || '@upn.pe' AS CORREO_INSTITUCIONAL
FROM ( SELECT DISTINCT SMBPOGN_COLL_CODE, SMBAOGN_PROGRAM, SMBAOGN_TERM_CODE_EFF, SMBPOGN_CAMP_CODE, SMBAOGN_PIDM, SPRIDEN_ID, SPRIDEN_LAST_NAME, SPRIDEN_FIRST_NAME, SMBAOGN_REQUEST_NO
			, SMBPOGN_ACTIVITY_DATE, SMBAOGN_AREA, SMRDOUS_COMPLIANCE_ORDER, SMRDOUS_SUBJ_CODE, SMRDOUS_CRSE_NUMB, SMRDOUS_TITLE, SMRDOUS_GRDE_CODE, SMRDOUS_TERM_CODE
			, MIN(SMRDOUS_TERM_CODE) OVER(PARTITION BY SMRDOUS_PIDM, SMRDOUS_REQUEST_NO, SMRDOUS_AREA) AS MIN_SMRDOUS_TERM_CODE
			, MAX(SMRDOUS_TERM_CODE) OVER(PARTITION BY SMRDOUS_PIDM, SMRDOUS_REQUEST_NO, SMRDOUS_AREA) AS MAX_SMRDOUS_TERM_CODE
			, SCREQIV_SUBJ_CODE_EQIV, SCREQIV_CRSE_NUMB_EQIV, SMRSSUB_SUBJ_CODE_REQ, SMRSSUB_CRSE_NUMB_REQ
		FROM SMBAOGN A
				INNER JOIN SMRDOUS ON SMBAOGN_PIDM = SMRDOUS_PIDM AND SMBAOGN_REQUEST_NO = SMRDOUS_REQUEST_NO AND SMBAOGN_AREA = SMRDOUS_AREA
				INNER JOIN SMBPOGN B ON SMBAOGN_PIDM = SMBPOGN_PIDM AND SMBAOGN_REQUEST_NO = SMBPOGN_REQUEST_NO
										AND B.SMBPOGN_REQUEST_NO = (SELECT MAX(B1.SMBPOGN_REQUEST_NO) FROM SMBPOGN B1
																	WHERE B1.SMBPOGN_PIDM = B.SMBPOGN_PIDM AND B1.SMBPOGN_PROGRAM = B.SMBPOGN_PROGRAM)
				INNER JOIN SPRIDEN ON SMBAOGN_PIDM = SPRIDEN_PIDM AND SPRIDEN_CHANGE_IND IS NULL
				LEFT JOIN ( SELECT SMRACAA_AREA, SMRACAA_TERM_CODE_EFF, SCREQIV_SUBJ_CODE, SCREQIV_CRSE_NUMB, SCREQIV_SUBJ_CODE_EQIV, SCREQIV_CRSE_NUMB_EQIV
							FROM SMRACAA, SCREQIV
							WHERE SMRACAA_SUBJ_CODE = SCREQIV_SUBJ_CODE_EQIV AND SMRACAA_CRSE_NUMB_LOW = SCREQIV_CRSE_NUMB_EQIV
								AND SMRACAA_TERM_CODE_EFF BETWEEN SCREQIV_START_TERM AND SCREQIV_END_TERM AND SMRACAA_AREA LIKE '%-CERT'
							) E ON SMRDOUS_SUBJ_CODE = SCREQIV_SUBJ_CODE AND SMRDOUS_CRSE_NUMB = SCREQIV_CRSE_NUMB AND SMRDOUS_AREA = SMRACAA_AREA AND SMRDOUS_TERM_CODE_EFF = SMRACAA_TERM_CODE_EFF
				LEFT JOIN SMRSSUB ON SMRDOUS_PIDM = SMRSSUB_PIDM AND SMRDOUS_SUBJ_CODE = SMRSSUB_SUBJ_CODE_SUB AND SMRDOUS_CRSE_NUMB = SMRSSUB_CRSE_NUMB_SUB
		WHERE SMBAOGN_MET_IND = 'Y' AND SMBAOGN_AREA LIKE '%-CERT'
			AND A.SMBAOGN_REQUEST_NO = (SELECT MAX(A1.SMBAOGN_REQUEST_NO) FROM SMBAOGN A1
										WHERE A1.SMBAOGN_PIDM = A.SMBAOGN_PIDM AND A1.SMBAOGN_PROGRAM = A.SMBAOGN_PROGRAM AND A1.SMBAOGN_AREA LIKE '%-CERT')
	)C
		LEFT JOIN SMRACMT ON C.SMBAOGN_AREA = SMRACMT_AREA AND C.SMBAOGN_TERM_CODE_EFF = SMRACMT_TERM_CODE_EFF AND SMRACMT_PRNT_CODE IN ('LNAME1','LNAME2')
		LEFT JOIN SMRPCMT D ON C.SMBAOGN_PROGRAM = SMRPCMT_PROGRAM AND SMRPCMT_PRNT_CODE IN ('LNAME1','LNAME2')
							AND D.SMRPCMT_TERM_CODE_EFF = (SELECT MAX(D1.SMRPCMT_TERM_CODE_EFF) FROM SMRPCMT D1
															WHERE SMRPCMT_PROGRAM = C.SMBAOGN_PROGRAM AND SMRPCMT_TERM_CODE_EFF <= C.SMBAOGN_TERM_CODE_EFF AND SMRPCMT_PRNT_CODE IN ('LNAME1','LNAME2'))
		LEFT JOIN SPRHOLD ON C.SMBAOGN_PIDM = SPRHOLD_PIDM AND SPRHOLD_HLDD_CODE = 'SD' AND SYSDATE BETWEEN SPRHOLD_FROM_DATE AND SPRHOLD_TO_DATE
		LEFT JOIN SPBPERS ON C.SMBAOGN_PIDM = SPBPERS_PIDM
		LEFT JOIN STVCAMP ON C.SMBPOGN_CAMP_CODE = STVCAMP_CODE
WHERE ((SUBSTR(C.MIN_SMRDOUS_TERM_CODE,4,1) = 4 AND C.MIN_SMRDOUS_TERM_CODE >= '218434') OR (SUBSTR(C.MIN_SMRDOUS_TERM_CODE,4,1) = 5 AND C.MIN_SMRDOUS_TERM_CODE >= '218533')) AND SPRHOLD_PIDM IS NULL
	AND C.MAX_SMRDOUS_TERM_CODE IN ('220413','220513')	--2020-1
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('220402','220502')	--2020-0
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('219435','219534')	--2019-2
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('219413','219414','219513','219514')	--2019-1
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('219402','219501')	--2019-0
	--AND C.MAX_SMRDOUS_TERM_CODE IN ('218434','218533')	--2018-2
GROUP BY SPBPERS_LEGAL_NAME, C.SPRIDEN_ID, STVCAMP_DESC, C.SMBPOGN_COLL_CODE
	, CASE C.SMBPOGN_COLL_CODE
		WHEN 'IN' THEN 'Jose N. Gonzales Quijano'
		WHEN 'NE' THEN 'Augusto F. Caceres Rosell'
		WHEN 'AR' THEN 'Jose Ignacio Pacheco Diaz'
		WHEN 'SA' THEN 'Patricia N. Piscoya Angeles'
		WHEN 'CO' THEN 'Patricia L. Sanchez Urrego'
		WHEN 'DE' THEN 'Alberto Villanueva Eslava'
		ELSE NULL END
	, CASE C.SMBPOGN_COLL_CODE
		WHEN 'IN' THEN 'Decano'
		WHEN 'NE' THEN 'Decano'
		WHEN 'AR' THEN 'Decano'
		WHEN 'SA' THEN 'Decana ( e )'
		WHEN 'CO' THEN 'Decana'
		WHEN 'DE' THEN 'Decano'
		ELSE NULL END
	, CASE C.SMBPOGN_COLL_CODE 
		WHEN 'NE' THEN 'IMAGEN_F_DEC_NEGOCIOS' 
		WHEN 'IN' THEN 'IMAGEN_F_DEC_INGENIERIA' 
		WHEN 'DE' THEN 'IMAGEN_F_DEC_DERECHO' 
		WHEN 'CO' THEN 'IMAGEN_F_DEC_COMUNICACIONES' 
		WHEN 'AR' THEN 'IMAGEN_F_DEC_ARQUITECTURA Y DISE�O' 
		WHEN 'SA' THEN 'IMAGEN_F_DEC_CIENCIAS DE LA SALUD' 
		ELSE NULL END
	, 'Patricia C. Somocurcio Donet', 'Directora de Secretar�a Acad�mica'
	, 'Jose N. Gonzales Quijano', 'Vicerrector Acad�mico'
	, CASE SUBSTR(:MES,1,2)
		WHEN '01' THEN 'enero'
		WHEN '02' THEN 'febrero'
		WHEN '03' THEN 'marzo'
		WHEN '04' THEN 'abril'
		WHEN '05' THEN 'mayo'
		WHEN '06' THEN 'junio'
		WHEN '07' THEN 'julio'
		WHEN '08' THEN 'agosto'
		WHEN '09' THEN 'setiembre'
		WHEN '10' THEN 'octubre'
		WHEN '11' THEN 'noviemnre'
		WHEN '12' THEN 'diciembre'
		ELSE NULL END ||' de '|| SUBSTR(:ANIO,1,4)
	, C.SPRIDEN_ID || '@upn.pe'
ORDER BY 6, 3, 5, 2
;

--Validar_Nombres_Certificados_
SELECT SMRPAAP_PROGRAM, SMRPAAP_TERM_CODE_EFF, SMRPAAP_AREA, SMRACMT_ACTIVITY_DATE, SMRACMT_TEXT, SMRACMT_PRNT_CODE
FROM SMRPAAP, SMRACMT
WHERE SMRPAAP_AREA = SMRACMT_AREA(+) AND SMRPAAP_TERM_CODE_EFF = SMRACMT_TERM_CODE_EFF(+)
	AND SMRPAAP_AREA LIKE '%-CERT'
ORDER BY SMRACMT_ACTIVITY_DATE DESC, SMRPAAP_PROGRAM, SMRPAAP_TERM_CODE_EFF
;
