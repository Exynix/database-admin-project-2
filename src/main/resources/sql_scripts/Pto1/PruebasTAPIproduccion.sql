--1)Probando insertar registros
BEGIN
    Produccion2_TAPI.insert_record(1, 1500.50, 4500.75, 5, 3, 10);
    Produccion2_TAPI.insert_record(2, 2000.00, 6000.00, 8, 2, 15);
    Produccion2_TAPI.insert_record(3, 1800.25, 5500.50, 3, 4, 20);
END;
/
--Viendolos
SELECT * FROM Temp_Produccion2 ORDER BY id;

--2)Modificar Registros
EXEC Produccion2_TAPI.update_record(2, 2500.75, 6500.25, 12, 3, 18);

--Mostrarlo
SELECT * FROM Temp_Produccion2 WHERE id = 2;

--3) Eliminar un registro
EXEC Produccion2_TAPI.delete_record(3);

-- Verificar que ya no existe
SELECT * FROM Temp_Produccion2 WHERE id = 3;

--4)Insertar 5000 registros aleatorios
EXEC Produccion2_TAPI.insert_random_records;

-- Verificar cantidad de registros
SELECT COUNT(*) FROM Temp_Produccion2;

--Ver alguno al azar
SELECT * FROM Temp_Produccion2 SAMPLE(10) WHERE ROWNUM <= 5;

--5) Eliminar todos los registros
EXEC Produccion2_TAPI.delete_all_records;

