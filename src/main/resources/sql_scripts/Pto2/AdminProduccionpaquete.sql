create or replace PACKAGE Admin_Produccion AS
  
    PROCEDURE limpiar_datos_modelo;
    PROCEDURE cargar_datos_desde_temp;
    PROCEDURE probar_procesos_completos;
    PROCEDURE ejecutar_proceso_secuencial; -- Punto 3A
    PROCEDURE ejecutar_proceso_3B;         -- Punto 3B
    
END Admin_Produccion;

/

CREATE OR REPLACE PACKAGE BODY admin_produccion AS

    PROCEDURE limpiar_datos_modelo IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE Produccion2';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE Produccion';
        dbms_output.put_line('Todas las tablas del modelo han sido limpiadas');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error al limpiar tablas: ' || sqlerrm);
            RAISE;
    END limpiar_datos_modelo;

    PROCEDURE cargar_datos_desde_temp IS
        v_count NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO v_count
        FROM
            temp_produccion2;

        IF v_count = 0 THEN
            dbms_output.put_line('Advertencia: La tabla temporal está vacía');
            RETURN;
        END IF;
        INSERT INTO produccion2 (
            id,
            costo_produccion,
            cop_ventas,
            productoid_producto,
            regionid,
            periodoid
        )
            SELECT
                id,
                costo_produccion,
                cop_ventas,
                productoid_producto,
                regionid,
                periodoid
            FROM
                temp_produccion2;

        INSERT INTO produccion (
            id,
            costo_produccion,
            cop_ventas,
            productoid_producto,
            regionid,
            periodoid
        )
            SELECT
                id,
                costo_produccion,
                cop_ventas,
                productoid_producto,
                regionid,
                periodoid
            FROM
                temp_produccion2;

        COMMIT;
        dbms_output.put_line('Datos cargados exitosamente. Registros transferidos: ' || v_count);
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            dbms_output.put_line('Error al cargar datos: ' || sqlerrm);
            RAISE;
    END cargar_datos_desde_temp;

    PROCEDURE probar_procesos_completos IS
    BEGIN
        dbms_output.put_line('=== INICIO DE PRUEBA ===');
        dbms_output.put_line('Paso 1: Limpiando tablas del modelo...');
        limpiar_datos_modelo();
        dbms_output.put_line('Paso 2: Verificando tabla temporal...');
        DECLARE
            v_temp_count NUMBER;
        BEGIN
            SELECT
                COUNT(*)
            INTO v_temp_count
            FROM
                temp_produccion2;

            dbms_output.put_line('Registros en tabla temporal: ' || v_temp_count);
            IF v_temp_count = 0 THEN
                produccion2_tapi.insert_random_records();
                SELECT
                    COUNT(*)
                INTO v_temp_count
                FROM
                    temp_produccion2;

                dbms_output.put_line('Insertados '
                                     || v_temp_count
                                     || ' registros aleatorios');
            END IF;

        END;

        dbms_output.put_line('Paso 3: Cargando datos a tablas del modelo...');
        cargar_datos_desde_temp();
        dbms_output.put_line('Paso 4: Verificando resultados...');
        DECLARE
            v_prod_count  NUMBER;
            v_prod2_count NUMBER;
        BEGIN
            SELECT
                COUNT(*)
            INTO v_prod_count
            FROM
                produccion;

            SELECT
                COUNT(*)
            INTO v_prod2_count
            FROM
                produccion2;

            dbms_output.put_line('Registros en Produccion: ' || v_prod_count);
            dbms_output.put_line('Registros en Produccion2: ' || v_prod2_count);
        END;

        dbms_output.put_line('=== PRUEBA COMPLETADA ===');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error en prueba: ' || sqlerrm);
            ROLLBACK;
            RAISE;
    END probar_procesos_completos;

      --Punto 3a --

    PROCEDURE ejecutar_proceso_secuencial IS
    BEGIN
        dbms_output.put_line('=== INICIO DE PROCESO SECUENCIAL ===');

        -- i. Borrar tabla temporal
        dbms_output.put_line('Paso 1: Borrando tabla temporal...');
        produccion2_tapi.delete_all_records();

        -- ii. Insertar 5000 registros aleatorios
        dbms_output.put_line('Paso 2: Insertando datos aleatorios...');
        produccion2_tapi.insert_random_records();

        -- iii. Limpiar tablas del modelo
        dbms_output.put_line('Paso 3: Limpiando tablas del modelo...');
        limpiar_datos_modelo();

        -- iv. Cargar datos a las tablas del modelo
        dbms_output.put_line('Paso 4: Cargando datos...');
        cargar_datos_desde_temp();
        dbms_output.put_line('=== PROCESO COMPLETADO ===');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error en el proceso: ' || sqlerrm);
            ROLLBACK;
            RAISE;
    END ejecutar_proceso_secuencial;

    PROCEDURE ejecutar_proceso_3b IS
        v_count_temp  NUMBER;
        v_count_prod  NUMBER;
        v_count_prod2 NUMBER;
    BEGIN
        dbms_output.put_line('=== INICIO DE PROCESO 3B ===');
        
        -- Paso 1: Insertar registros aleatorios en la tabla temporal
        dbms_output.put_line('Paso 1: Insertando 5000 registros aleatorios en Temp_Produccion2...');
        produccion2_tapi.insert_random_records();
        
        -- Verificar inserción en temporal
        SELECT
            COUNT(*)
        INTO v_count_temp
        FROM
            temp_produccion2;

        dbms_output.put_line('Registros en Temp_Produccion2: ' || v_count_temp);
        
        -- Paso 2: Usar MERGE para cargar datos a las tablas del modelo
        dbms_output.put_line('Paso 2: Cargando datos a tablas del modelo usando MERGE...');
        
        -- MERGE para tabla Produccion
        MERGE INTO produccion p
        USING (
            SELECT
                id,
                costo_produccion,
                cop_ventas,
                productoid_producto,
                regionid,
                periodoid
            FROM
                temp_produccion2
        ) t ON ( p.id = t.id )
        WHEN MATCHED THEN UPDATE
        SET p.costo_produccion = t.costo_produccion,
            p.cop_ventas = t.cop_ventas,
            p.productoid_producto = t.productoid_producto,
            p.regionid = t.regionid,
            p.periodoid = t.periodoid
        WHEN NOT MATCHED THEN
        INSERT (
            id,
            costo_produccion,
            cop_ventas,
            productoid_producto,
            regionid,
            periodoid )
        VALUES
            ( t.id,
              t.costo_produccion,
              t.cop_ventas,
              t.productoid_producto,
              t.regionid,
              t.periodoid );
        
        -- MERGE para tabla Produccion2
        MERGE INTO produccion2 p2
        USING (
            SELECT
                id,
                costo_produccion,
                cop_ventas,
                productoid_producto,
                regionid,
                periodoid
            FROM
                temp_produccion2
        ) t ON ( p2.id = t.id )
        WHEN MATCHED THEN UPDATE
        SET p2.costo_produccion = t.costo_produccion,
            p2.cop_ventas = t.cop_ventas,
            p2.productoid_producto = t.productoid_producto,
            p2.regionid = t.regionid,
            p2.periodoid = t.periodoid
        WHEN NOT MATCHED THEN
        INSERT (
            id,
            costo_produccion,
            cop_ventas,
            productoid_producto,
            regionid,
            periodoid )
        VALUES
            ( t.id,
              t.costo_produccion,
              t.cop_ventas,
              t.productoid_producto,
              t.regionid,
              t.periodoid );

        COMMIT;
        
        -- Verificar resultados
        SELECT
            COUNT(*)
        INTO v_count_prod
        FROM
            produccion;

        SELECT
            COUNT(*)
        INTO v_count_prod2
        FROM
            produccion2;

        dbms_output.put_line('Registros en Produccion: ' || v_count_prod);
        dbms_output.put_line('Registros en Produccion2: ' || v_count_prod2);
        dbms_output.put_line('=== PROCESO 3B COMPLETADO ===');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error en ejecutar_proceso_3B: ' || sqlerrm);
            ROLLBACK;
            RAISE;
    END ejecutar_proceso_3b;

END admin_produccion;
/