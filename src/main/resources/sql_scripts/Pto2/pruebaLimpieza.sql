-- Ejecutar limpieza
SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Iniciando limpieza de tablas...');
    Admin_Produccion.limpiar_datos_modelo();
    DBMS_OUTPUT.PUT_LINE('Limpieza completada');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error durante limpieza: ' || SQLERRM);
END;
/