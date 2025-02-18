/*
Se crea triger que no permite la inserción o eliminación de registros de lunes a viernes    
*/ 
create or replace TRIGGER TRG_INSELIM 
BEFORE DELETE OR INSERT ON PRODUCTO
DECLARE
v_dia_semana number; -- variable para saber si es lunes(1), martes(2), miercoles(3), jueves (4), viernes (5)
BEGIN
    -- se asigna varibale con el valor del dia
    select to_number(TO_CHAR(TO_DATE(sysdate, 'DD/MM/YYYY'), 'D', 'NLS_DATE_LANGUAGE=SPANISH')) into v_dia_semana from dual;
    if v_dia_semana >= 1 AND v_dia_semana <= 5 then -- si es entre lunes y viernes
    case
        when inserting then -- en caso de estar insertando se lanbza error 20501
              RAISE_APPLICATION_ERROR( -20501 , 
                             'Tabla protegida para inserción' );
        when deleting then -- en caso de estar eliminando se lanbza error 20500
              RAISE_APPLICATION_ERROR( -20500 , 
                             'Tabla protegida para eliminacion' );
    end case;
    end if;
END;