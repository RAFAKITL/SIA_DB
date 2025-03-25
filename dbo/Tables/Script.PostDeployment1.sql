/*
Plantilla de script posterior a la implementación							
--------------------------------------------------------------------------------------
 Este archivo contiene instrucciones de SQL que se anexarán al script de compilación.		
 Use la sintaxis de SQLCMD para incluir un archivo en el script posterior a la implementación.			
 Ejemplo:      :r .\miArchivo.sql								
 Use la sintaxis de SQLCMD para hacer referencia a una variable en el script posterior a la implementación.		
 Ejemplo:      :setvar TableName miTabla							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- Verifica si la tabla tiene datos antes de insertar
IF NOT EXISTS (SELECT 1 FROM [dbo].[A_TablaPrueba])
BEGIN
    BULK INSERT [dbo].[A_TablaPrueba]
FROM '$(SqlDataRoot)\Data\A_TablaPrueba.csv'
WITH 
(
    DATAFILETYPE = 'char',           -- Asume que el archivo es de tipo char
    FIELDTERMINATOR = ',',           -- Delimitador de campos
    ROWTERMINATOR = '0x0d0a',            -- Delimitador de filas (ajústalo si es necesario)
    FIRSTROW = 2,                    -- Salta la fila de encabezado
    CODEPAGE = '65001'               -- Para archivos en UTF-8 sin BOM
);
END

