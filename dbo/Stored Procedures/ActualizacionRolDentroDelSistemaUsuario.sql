--PROCEDIMIENTO UPDATE al rol de dento del sistema Tabla Usuario General
CREATE PROCEDURE ActualizacionRolDentroDelSistemaUsuario
	@Rol varchar(255),
	@Correo varchar(255)
AS
	BEGIN	
		UPDATE Usuario_General 
		SET id_Rol = (SELECT ID_Rol FROM Rol_Dentro_Del_Sistema WHERE Desc_Rol = @Rol) 
		WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo)
	END;
