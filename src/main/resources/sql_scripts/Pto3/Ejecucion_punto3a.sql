-- Ejecutar el proceso secuencial (punto 3a)
SET SERVEROUTPUT ON;
BEGIN
    Admin_Produccion.ejecutar_proceso_secuencial();
END;
/

-- Ejecutar y verificar resultados
EXEC Admin_Produccion.ejecutar_proceso_secuencial();

-- Verificar registros en las tablas
SELECT 'Produccion' AS tabla, COUNT(*) AS total FROM Produccion
UNION ALL
SELECT 'Produccion2' AS tabla, COUNT(*) AS total FROM Produccion2;
-- Ambos deben mostrar 5000 registros.