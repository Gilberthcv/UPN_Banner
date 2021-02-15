--GLBEXTR_

/*1.- Limpiar Seleccion de Poblacion.*/

select * from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'GRUPO_PDN'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'U310600957';

delete from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'GRUPO_PDN'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'U310600957';
    
/*2.- Se debe cargar una selección de población con los ID del archivo completo que envié el usuario.*/

update glbextr
set glbextr_key = gb_common.f_get_pidm(glbextr_key)
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'GRUPO_PDN'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'U310600957';

select * from glbextr
where glbextr_application = 'STUDENT'
    AND glbextr_selection = 'GRUPO_PDN'
    AND glbextr_creator_id = 'S100060791'
    AND glbextr_user_id = 'U310600957';

--COMMIT

--NOTA: ENVIAR RESULTADO DE ESTE SCRIPT POR CORREO A USUARIO 
