--PROCEDIMIENTO SELECT a los estatus de deshabilitado para la lista desplegable que se realizara para seleccionar uno EstatusDeshabilitado *****
CREATE PROCEDURE MuestraEstatusDeshabilitado
AS
BEGIN
	SELECT Desc_Estatus_Deshabilitado FROM Estatus_Deshabilitado
END;