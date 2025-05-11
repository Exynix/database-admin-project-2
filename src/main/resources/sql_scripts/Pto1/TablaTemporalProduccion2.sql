
CREATE GLOBAL TEMPORARY TABLE Temp_Produccion2 (
  id                  NUMBER(10) NOT NULL, 
  costo_produccion    NUMBER(15,2) NOT NULL, 
  cop_ventas          NUMBER(15,2) NOT NULL, 
  Productoid_producto NUMBER(10) NOT NULL, 
  Regionid            NUMBER(10) NOT NULL, 
  periodoid           NUMBER(10) NOT NULL
) ON COMMIT PRESERVE ROWS;

INSERT INTO Temp_Produccion2
SELECT * FROM Produccion2;


SELECT COUNT(*) FROM Temp_Produccion2;