--PROCEDIMIENTO SELECT  estatus de bloqueo para la lista desplegable que se realizara para seleccionar uno Tabla EstatusBloqueado
CREATE PROCEDURE MuestraEstatusBloqueo
AS
	BEGIN
		SELECT Desc_Estatus_Bloqueo FROM Estatus_Bloqueado
	END;