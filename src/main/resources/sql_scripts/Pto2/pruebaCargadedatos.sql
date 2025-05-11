-- Ejecutar carga de datos
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Iniciando carga de datos...');
    Admin_Produccion.cargar_datos_desde_temp();
    DBMS_OUTPUT.PUT_LINE('Carga de datos completada');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error durante carga: ' || SQLERRM);
END;
/