/*
Script de implementación para SIA_Pruebas

Una herramienta generó este código.
Los cambios realizados en este archivo podrían generar un comportamiento incorrecto y se perderán si
se vuelve a generar el código.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar SqlDataRoot "D:\choyt\Documents\InnovacionTecnologicaPolitecnica\Registro_Versiones\SIA\SIA_Database\dbo"
:setvar DatabaseName "SIA_Pruebas"
:setvar DefaultFilePrefix "SIA_Pruebas"
:setvar DefaultDataPath "D:\choyt\ArchivosProgramas\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "D:\choyt\ArchivosProgramas\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detectar el modo SQLCMD y deshabilitar la ejecución del script si no se admite el modo SQLCMD.
Para volver a habilitar el script después de habilitar el modo SQLCMD, ejecute lo siguiente:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'El modo SQLCMD debe estar habilitado para ejecutar correctamente este script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
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

GO

GO
PRINT N'Actualización completada.';


GO
