/*
Se crea el package body
*/
create or replace PACKAGE BODY PKG_SUMATIVA_SEMANA8 AS

  /*
    Este procedimiento se encarga de grabar los errores que se producen en la ejecución segun lo solicitado. Usa la secuencia para grabar el correlativo del error.
  */ 
  PROCEDURE P_GRABAR_ERROR(P_RUTINA_ERROR ERROR_CALC.RUTINA_ERROR%TYPE, P_DESCRIP_ERROR ERROR_CALC.DESCRIP_ERROR%TYPE, P_DESCRIP_USER ERROR_CALC.DESCRIP_USER%TYPE) AS
  BEGIN
    INSERT INTO ERROR_CALC(CORREL_ERROR, RUTINA_ERROR, DESCRIP_ERROR, DESCRIP_USER) VALUES (SEQ_ERROR.NEXTVAL, P_RUTINA_ERROR, P_DESCRIP_ERROR, P_DESCRIP_USER); 
  END P_GRABAR_ERROR;

  /*
    Esta funcion recupera el promedio de todas las ventas de un año pasado como parámetro
  */ 
  FUNCTION F_GET_VENTAS_ANUAL(P_YEAR NUMBER) RETURN NUMBER AS
  BEGIN
        select 
                round(avg(b.monto_total_boleta),0) INTO V_VENTAS_ANUALES
        from boleta b
        where b.fecha between   '01-01-' ||to_char(P_YEAR) and
                                '31-12' || to_char(P_YEAR);       
    RETURN V_VENTAS_ANUALES;
  END F_GET_VENTAS_ANUAL;

END PKG_SUMATIVA_SEMANA8;