--PROCEDIMIENTO UPDATE al EstatusDeshabilitado del usuario general Tabla Usuario_General
CREATE PROCEDURE ActualizacionEstatusDeshabilitadoUsuario
    @correo varchar(255),
	@Status varchar(255)
AS
	BEGIN
		UPDATE  Usuario_General 
		SET id_EstatusDeshabilitado = (SELECT ID_EstatusDeshabilitado FROM Estatus_Deshabilitado WHERE Desc_Estatus_Deshabilitado = @Status )
		WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo) 
	END;