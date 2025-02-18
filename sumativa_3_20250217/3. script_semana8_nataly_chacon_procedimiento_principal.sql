  /*
    Este procedimiento es el principal, y recive como parámetro el año y el mes a ser ejecutados para el calculo de la liquidacion de empleados.
    Para ello declara un cursor que recupera todos los empleados recuperando sus datos para ser procesados, se incluye la sumatoria de sus ventas del año procesado y anteriores (este punto esta pesimamente redactado en las instrucciones)
  */ 
create or replace PROCEDURE P_PRINCIPAL(P_AGNO NUMBER, P_MES NUMBER) AS
  --Cursor que recorre todos los empleados vendedores recuperando ademas la suma de sus ventas del ultimo año movil
  CURSOR C_EMPLEADOS IS 
        SELECT e.RUN_EMPLEADO, (INITCAP(e.NOMBRE) || '  ' || INITCAP(e.PATERNO)) as NOMBRE_EMPLEADO, e.SUELDO_BASE, e.TIPO_EMPLEADO, sum(b.MONTO_TOTAL_BOLETA) as TOTAL_VENTA_EMPLEADO 
        FROM EMPLEADO e
        LEFT JOIN BOLETA b on b.run_empleado = e.run_empleado
        where e.tipo_empleado = 5 -- solo empleados vendedores
        and b.fecha >=  ('01-' || (case when P_MES < 10 then '0' || TO_CHAR(P_MES) else TO_CHAR(P_MES) END) || TO_CHAR(P_AGNO-1)) AND b.fecha < ('01-' || (case when P_MES < 10 then '0' || TO_CHAR(P_MES) else TO_CHAR(P_MES) END) || TO_CHAR(P_AGNO)) --ventas de 1 año movil
        GROUP BY e.RUN_EMPLEADO, e.NOMBRE, e.PATERNO, e.SUELDO_BASE, e.TIPO_EMPLEADO;
  V_VENTA_ANUAL NUMBER; -- variable para almacenar la venta anual
  V_ASIG_ESPECIAL NUMBER; -- variable para almacenar la asignacion especial por años del trabajador en caso de cumplor la condicion de las ventas
  V_ASIG_ESTUDIOS NUMBER; -- variable para almacenar la asignacion por escolaridad del trabajador
  V_PORCENTAJE NUMBER(5,5):=0.17; --variable que tiene el procentahe de ventas que es un 7%
  BEGIN 
    EXECUTE IMMEDIATE 'TRUNCATE TABLE LIQUIDACION_EMPLEADO'; -- se limpia tabla para procesar varias veces
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ERROR_CALC'; -- se limpia tabla para procesar varias veces
    V_VENTA_ANUAL:=PKG_SUMATIVA_SEMANA8.F_GET_VENTAS_ANUAL(P_AGNO-1); -- se obtiene las ventas del año anterior
    FOR E in C_EMPLEADOS LOOP -- para cada empleado
        V_ASIG_ESPECIAL:=0;
        V_ASIG_ESTUDIOS:=0;
        IF e.TIPO_EMPLEADO = 5 then -- si es vendedor
            V_ASIG_ESTUDIOS:= ROUND(E.SUELDO_BASE * (GET_PORC_ESTUDIOS(E.RUN_EMPLEADO)/100),0); -- se asigna variable con asignacion por estudios

            if E.TOTAL_VENTA_EMPLEADO * V_PORCENTAJE > V_VENTA_ANUAL  then -- en caso que el 17% de la venta del empleado sea mayor a la venta anual del año anterior
                V_ASIG_ESPECIAL:= ROUND(E.SUELDO_BASE * (GET_PORC_ANTIGUEDAD(E.RUN_EMPLEADO)/100),0); -- se asgina varibale con asignacion por antigueadad
             end if;

        end if;
        --se inserta registro LIQUIDACION_EMPLEADO en la base de datos
        INSERT INTO LIQUIDACION_EMPLEADO(MES,ANNO,RUN_EMPLEADO,NOMBRE_EMPLEADO,SUELDO_BASE,ASIG_ESPECIAL,ASIG_ESTUDIOS,TOTAL_HABERES) VALUES (P_MES, P_AGNO, E.RUN_EMPLEADO, E.NOMBRE_EMPLEADO, E.SUELDO_BASE, V_ASIG_ESPECIAL, V_ASIG_ESTUDIOS, E.SUELDO_BASE + V_ASIG_ESPECIAL + V_ASIG_ESTUDIOS);
    END LOOP;

  END P_PRINCIPAL;