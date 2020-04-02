
/*1.- Se debe cargar una selección de población con los ID del archivo completo que envié el usuario.*/

select * from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

update glbextr
set glbextr_key = gb_common.f_get_pidm(glbextr_key)
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

delete from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

/*2.- De la base cargada se deben excluir los que tienen retención RA vigente.*/

SELECT * FROM GLBEXTR
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100'
    AND glbextr_key in (select SPRHOLD_PIDM from SPRHOLD
                         where SPRHOLD_HLDD_CODE = 'RA'
                             AND (TRUNC(SYSDATE) >= TRUNC(SPRHOLD_FROM_DATE)
                             AND TRUNC(SYSDATE) < TRUNC(SPRHOLD_TO_DATE)));

DELETE FROM GLBEXTR
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100'
    AND glbextr_key in (select SPRHOLD_PIDM from SPRHOLD
                        where SPRHOLD_HLDD_CODE = 'RA'
                            AND (TRUNC(SYSDATE) >= TRUNC(SPRHOLD_FROM_DATE)
                            AND TRUNC(SYSDATE) < TRUNC(SPRHOLD_TO_DATE)));

/*3.- Seleccionar los registros que tienen retención AR vigente y que se encuentran en nuestra selección.*/

select * from SPRHOLD
where SPRHOLD_HLDD_CODE = 'AR'
    AND (TRUNC(SYSDATE) >= TRUNC(SPRHOLD_FROM_DATE)
    AND TRUNC(SYSDATE) < TRUNC(SPRHOLD_TO_DATE))
    AND SPRHOLD_PIDM IN (SELECT GLBEXTR_KEY FROM GLBEXTR
                        where glbextr_application = 'STUDENT'
                            AND glbextr_selection = 'ALUMNOS_EG'
                            AND glbextr_creator_id = 'S100060791'
                            AND glbextr_user_id = 'S310600100');

/*4.- Una vez identificados los registros finalizaremos la retención (La Fecha SPRHOLD_FROM_DATE será de acuerdo al día de ejecución)*/

UPDATE SPRHOLD
SET SPRHOLD_TO_DATE = SYSDATE--TO_DATE('02-04-2020','DD-MM-YYYY') 
where SPRHOLD_HLDD_CODE = 'AR'
    AND (TRUNC(SYSDATE) >= TRUNC(SPRHOLD_FROM_DATE)
    AND TRUNC(SYSDATE) < TRUNC(SPRHOLD_TO_DATE))
    AND SPRHOLD_PIDM IN (SELECT GLBEXTR_KEY FROM GLBEXTR
                        where glbextr_application = 'STUDENT'
                            AND glbextr_selection = 'ALUMNOS_EG'
                            AND glbextr_creator_id = 'S100060791'
                            AND glbextr_user_id = 'S310600100');

/*5.- Validar que ya no existen retenciones AR vigentes esto se verifica porque el script debe arrojar 0 registros.*/

select * from SPRHOLD
where SPRHOLD_HLDD_CODE = 'AR'
    and (TRUNC(SYSDATE) >= TRUNC(SPRHOLD_FROM_DATE)
    AND TRUNC(SYSDATE) < TRUNC(SPRHOLD_TO_DATE))
    AND SPRHOLD_PIDM IN (SELECT GLBEXTR_KEY FROM GLBEXTR
                        where glbextr_application = 'STUDENT'
                            AND glbextr_selection = 'ALUMNOS_EG'
                            AND glbextr_creator_id = 'S100060791'
                            AND glbextr_user_id = 'S310600100');

/*6.- Una vez realizada la validación se debe proceder a ejecutar el siguiente INSERT*/

INSERT INTO SPRHOLD A (A.SPRHOLD_PIDM
    , A.SPRHOLD_HLDD_CODE
    , A.SPRHOLD_USER
    , A.SPRHOLD_FROM_DATE
    , A.SPRHOLD_TO_DATE
    , A.SPRHOLD_RELEASE_IND
    , A.SPRHOLD_ACTIVITY_DATE
    , A.SPRHOLD_DATA_ORIGIN)
SELECT glbextr_key
    , 'RA'
    , USER c3
    , SYSDATE c4
    , TO_DATE('20991231','YYYYMMDD') c5
    , 'N' c6
    , SYSDATE c7
    , 'MASI' c8
FROM glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

/*7.-Validar que los registros de nuestra selección quedaron con retención RA vigente*/

select GB_COMMON.F_GET_ID(SPRHOLD_PIDM), C.*
from SPRHOLD
where SPRHOLD_HLDD_CODE = 'RA'
    AND (TRUNC(SYSDATE) >= TRUNC(SPRHOLD_FROM_DATE)
    AND TRUNC(SYSDATE) < TRUNC(SPRHOLD_TO_DATE))
    AND SPRHOLD_PIDM IN (SELECT GLBEXTR_KEY FROM GLBEXTR
                        where glbextr_application = 'STUDENT'
                            AND glbextr_selection = 'ALUMNOS_EG'
                            AND glbextr_creator_id = 'S100060791'
                            AND glbextr_user_id = 'S310600100');

--NOTA: ENVIAR RESULTADO DE ESTE SCRIPT POR CORREO A USUARIO 
