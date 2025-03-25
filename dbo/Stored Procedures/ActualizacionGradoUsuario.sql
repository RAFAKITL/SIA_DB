--PROCEDIMIENTO UPDATE al Grado del usuario general Tabla Grados
CREATE PROCEDURE ActualizacionGradoUsuario
	@correo varchar(255),
	@Grado varchar(255)
	
AS
	BEGIN
		UPDATE Grado 
		SET Desc_Grado = @Grado
		WHERE ID_Grado = (SELECT id_Grado FROM Usuario_General WHERE id_CorreoElectronico = 
							(SELECT ID_CorreoElectronico  FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo))
	END;
