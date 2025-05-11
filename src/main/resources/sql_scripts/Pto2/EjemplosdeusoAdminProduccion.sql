-- Activar salida por consola
SET SERVEROUTPUT ON SIZE 1000000;

-- Ejemplo 1: Limpiar y cargar datos en un solo proceso
BEGIN
    -- 1. Limpiar tablas del modelo
    Admin_Produccion.limpiar_datos_modelo;

    -- 2. Borrar e insertar datos random en tabla temporal
    Produccion2_TAPI.delete_all_records;
    Produccion2_TAPI.insert_random_records;

    -- 3. Cargar datos desde la tabla temporal
    Admin_Produccion.cargar_datos_desde_temp;

    -- 4. Verificar conteo de registros
    DECLARE
        v_prod NUMBER;
        v_prod2 NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_prod FROM Produccion;
        SELECT COUNT(*) INTO v_prod2 FROM Produccion2;

        DBMS_OUTPUT.PUT_LINE('=== TOTAL DE REGISTROS ===');
        DBMS_OUTPUT.PUT_LINE('Produccion: ' || v_prod || ' registros');
        DBMS_OUTPUT.PUT_LINE('Produccion2: ' || v_prod2 || ' registros');
    END;
END;
/
