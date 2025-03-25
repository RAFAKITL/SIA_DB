--PROCEDIMIENTO UPDATE al EstatusBloqueo del usuario general Tabla Usuario_General
 CREATE PROCEDURE ActualizacionEstatusBloqueoUsuario
	@correo varchar(255),
	@Status varchar(255)
AS
BEGIN
 	UPDATE Usuario_General
	SET id_EstatusBloqueo = (SELECT ID_EstatusBloqueo FROM Estatus_Bloqueado WHERE Desc_Estatus_Bloqueo =  @Status)
	WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico= @correo) 
END;