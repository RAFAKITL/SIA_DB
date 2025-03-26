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
    FROM '/Catalogos_SIA/A_TablaPrueba.csv'
    WITH 
    (
        DATAFILETYPE = 'char',
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0d0a',
        FIRSTROW = 2
    );
END


