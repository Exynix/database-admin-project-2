DROP PACKAGE BODY Produccion2_TAPI;
DROP PACKAGE Produccion2_TAPI;

CREATE OR REPLACE PACKAGE Produccion2_TAPI AS
    -- a. Eliminar un registro
    PROCEDURE delete_record(p_id IN NUMBER);
    
    -- b. Modificar un registro
    PROCEDURE update_record(
        p_id IN NUMBER,
        p_costo_produccion IN NUMBER,
        p_cop_ventas IN NUMBER,
        p_producto_id IN NUMBER,
        p_region_id IN NUMBER,
        p_periodo_id IN NUMBER
    );
    
    -- c. Insertar un registro
    PROCEDURE insert_record(
        p_id IN NUMBER,
        p_costo_produccion IN NUMBER,
        p_cop_ventas IN NUMBER,
        p_producto_id IN NUMBER,
        p_region_id IN NUMBER,
        p_periodo_id IN NUMBER
    );
    
    -- d. Insertar 5000 registros random
    PROCEDURE insert_random_records;
    
    -- e. Eliminar todos los registros (truncate)
    PROCEDURE delete_all_records;
    
END Produccion2_TAPI;
/

CREATE OR REPLACE PACKAGE BODY Produccion2_TAPI AS
    
    -- a. Eliminar un registro
    PROCEDURE delete_record(p_id IN NUMBER) IS
    BEGIN
        DELETE FROM Temp_Produccion2 WHERE id = p_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Registro con ID ' || p_id || ' eliminado correctamente.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error al eliminar registro: ' || SQLERRM);
    END delete_record;
    
    -- b. Modificar un registro
    PROCEDURE update_record(
        p_id IN NUMBER,
        p_costo_produccion IN NUMBER,
        p_cop_ventas IN NUMBER,
        p_producto_id IN NUMBER,
        p_region_id IN NUMBER,
        p_periodo_id IN NUMBER
    ) IS
    BEGIN
        UPDATE Temp_Produccion2
        SET 
            costo_produccion = p_costo_produccion,
            cop_ventas = p_cop_ventas,
            Productoid_producto = p_producto_id,
            Regionid = p_region_id,
            periodoid = p_periodo_id
        WHERE id = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No se encontró el registro con ID ' || p_id);
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Registro con ID ' || p_id || ' actualizado correctamente.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error al actualizar registro: ' || SQLERRM);
    END update_record;
    
    -- c. Insertar un registro
    PROCEDURE insert_record(
        p_id IN NUMBER,
        p_costo_produccion IN NUMBER,
        p_cop_ventas IN NUMBER,
        p_producto_id IN NUMBER,
        p_region_id IN NUMBER,
        p_periodo_id IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Temp_Produccion2 (
            id, costo_produccion, cop_ventas, 
            Productoid_producto, Regionid, periodoid
        ) VALUES (
            p_id, p_costo_produccion, p_cop_ventas,
            p_producto_id, p_region_id, p_periodo_id
        );
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Registro con ID ' || p_id || ' insertado correctamente.');
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error: Ya existe un registro con ID ' || p_id);
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error al insertar registro: ' || SQLERRM);
    END insert_record;
    
    -- d. Insertar 5000 registros random
    PROCEDURE insert_random_records IS
        v_max_id NUMBER;
    BEGIN
        SELECT NVL(MAX(id), 0) INTO v_max_id FROM Temp_Produccion2;
        
        FOR i IN 1..5000 LOOP
            INSERT INTO Temp_Produccion2 (
                id, costo_produccion, cop_ventas, 
                Productoid_producto, Regionid, periodoid
            ) VALUES (
                v_max_id + i,
                ROUND(DBMS_RANDOM.VALUE(1000, 5000)),  -- Costo producción
                ROUND(DBMS_RANDOM.VALUE(2000, 10000)), -- COP ventas
                TRUNC(DBMS_RANDOM.VALUE(1, 101)),      -- Producto ID
                TRUNC(DBMS_RANDOM.VALUE(1, 11)),       -- Región ID
                TRUNC(DBMS_RANDOM.VALUE(1, 101))       -- Periodo ID
            );
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('5000 registros aleatorios insertados correctamente.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error al insertar registros aleatorios: ' || SQLERRM);
    END insert_random_records;
    
    -- e. Eliminar todos los registros (truncate)
    PROCEDURE delete_all_records IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE Temp_Produccion2';
        DBMS_OUTPUT.PUT_LINE('Todos los registros han sido eliminados (TRUNCATE).');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error al truncar la tabla: ' || SQLERRM);
    END delete_all_records;
    
END Produccion2_TAPI;
/