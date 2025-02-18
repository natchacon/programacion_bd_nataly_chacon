/*
Se crea el package con la variable para almacenar el total de ventas anuales, con el procedimiento para grabar los errores, la funcion para recuperar las ventas anuales
*/
create or replace PACKAGE PKG_SUMATIVA_SEMANA8 AS
    V_VENTAS_ANUALES NUMBER(15):=0;
    PROCEDURE P_GRABAR_ERROR(P_RUTINA_ERROR ERROR_CALC.RUTINA_ERROR%TYPE, P_DESCRIP_ERROR ERROR_CALC.DESCRIP_ERROR%TYPE, P_DESCRIP_USER ERROR_CALC.DESCRIP_USER%TYPE);
    FUNCTION F_GET_VENTAS_ANUAL(P_YEAR NUMBER) RETURN NUMBER;
END PKG_SUMATIVA_SEMANA8;