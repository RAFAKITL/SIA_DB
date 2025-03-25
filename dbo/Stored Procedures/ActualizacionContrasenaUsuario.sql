-- PROCEDIMIENTO UPDATE contraseÃ±a del usuario general Tabla ContrasenaHash
CREATE PROCEDURE ActualizacionContrasenaUsuario
	@correo varchar(255),
	@Nvacontrasena varchar(255)
AS
	BEGIN
		UPDATE Contrasena_Hash
		SET Desc_Contrasena_Hash = @Nvacontrasena
		WHERE ID_ContrasenaHash = (SELECT id_ContrasenaHash FROM Usuario_General WHERE id_CorreoElectronico =
                        (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo))
	END;	