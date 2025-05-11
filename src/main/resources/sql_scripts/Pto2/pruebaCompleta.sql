-- Ejecutar prueba completa
SET SERVEROUTPUT ON;
BEGIN
    Admin_Produccion.probar_procesos_completos();
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error en prueba completa: ' || SQLERRM);
END;
/