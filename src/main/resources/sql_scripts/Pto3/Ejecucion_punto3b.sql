-- Script de prueba para Admin_Produccion.ejecutar_proceso_3B

SET SERVEROUTPUT ON;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== INICIO DE PRUEBA PARA EJECUTAR_PROCESO_3B ===');
    
    -- 1. Limpiar tablas para prueba limpia
    DBMS_OUTPUT.PUT_LINE('Limpiando tablas...');
    Admin_Produccion.limpiar_datos_modelo();
    Produccion2_TAPI.delete_all_records();
    
    -- 2. Verificar estado inicial (debería estar vacío)
    DECLARE
        v_temp_count NUMBER;
        v_prod_count NUMBER;
        v_prod2_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_temp_count FROM Temp_Produccion2;
        SELECT COUNT(*) INTO v_prod_count FROM Produccion;
        SELECT COUNT(*) INTO v_prod2_count FROM Produccion2;
        
        DBMS_OUTPUT.PUT_LINE('Registros iniciales - Temp: ' || v_temp_count || 
                            ', Produccion: ' || v_prod_count || 
                            ', Produccion2: ' || v_prod2_count);
    END;
    
    -- 3. Ejecutar el nuevo procedimiento
    DBMS_OUTPUT.PUT_LINE('Ejecutando ejecutar_proceso_3B...');
    Admin_Produccion.ejecutar_proceso_3B();
    
    -- 4. Verificar resultados
    DECLARE
        v_temp_count NUMBER;
        v_prod_count NUMBER;
        v_prod2_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_temp_count FROM Temp_Produccion2;
        SELECT COUNT(*) INTO v_prod_count FROM Produccion;
        SELECT COUNT(*) INTO v_prod2_count FROM Produccion2;
        
        DBMS_OUTPUT.PUT_LINE('Registros finales - Temp: ' || v_temp_count || 
                            ', Produccion: ' || v_prod_count || 
                            ', Produccion2: ' || v_prod2_count);
        
        -- Verificación básica
        IF v_temp_count = 5000 AND v_prod_count = 5000 AND v_prod2_count = 5000 THEN
            DBMS_OUTPUT.PUT_LINE('PRUEBA EXITOSA: Todos los registros se transfirieron correctamente');
        ELSE
            DBMS_OUTPUT.PUT_LINE('PRUEBA FALLIDA: Los conteos no coinciden');
        END IF;
    END;
    
    DBMS_OUTPUT.PUT_LINE('=== FIN DE PRUEBA ===');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error durante la prueba: ' || SQLERRM);
        ROLLBACK;
END;
/