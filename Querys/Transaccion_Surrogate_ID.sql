SELECT DISTINCT 
    GB_COMMON.F_GET_ID(TBRACCD_PIDM)
    --, TBRACCD_PIDM
    , TBRACCD_TRAN_NUMBER
    , TBRACCD_SURROGATE_ID
FROM TBRACCD
WHERE TBRACCD_PIDM = GB_COMMON.F_GET_PIDM('N00261078')  --ID
    --AND TBRACCD_TRAN_NUMBER IN (17,18,19);
    AND TBRACCD_TRAN_NUMBER >= 1 AND TBRACCD_TRAN_NUMBER <= 38;

---------------------------------------------------------------
--Seleccion de poblacion
select * from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

delete from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

select * from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

update glbextr
set glbextr_key = gb_common.f_get_pidm(SUBSTR(GLBEXTR_KEY,1,INSTR(GLBEXTR_KEY,'|',1,1)-1)) ||'|'|| SUBSTR(GLBEXTR_KEY,INSTR(GLBEXTR_KEY,'|',1,1)+1)
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

select * from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'ALUMNOS_EG'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'S310600100';

SELECT DISTINCT 
    GB_COMMON.F_GET_ID(TBRACCD_PIDM)
    --, TBRACCD_PIDM
    , TBRACCD_TRAN_NUMBER
    , TBRACCD_SURROGATE_ID
FROM TBRACCD, GLBEXTR
WHERE TBRACCD_PIDM = SUBSTR(GLBEXTR_KEY,1,INSTR(GLBEXTR_KEY,'|',1,1)-1)
    AND TBRACCD_TRAN_NUMBER = SUBSTR(GLBEXTR_KEY,INSTR(GLBEXTR_KEY,'|',1,1)+1)
ORDER BY 1, 2;
