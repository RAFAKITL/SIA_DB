--PROCEDIMIENTO UPDATE nombre del usuario general Tabla Nombre_Usuarios
CREATE PROCEDURE ActualizacionNombreUsuario
	@correoelectronico varchar(255),
	@NuevoNombreUsuario varchar(255)
AS 
	BEGIN
		UPDATE Nombre_Usuarios 
		SET Desc_Nombre_Usuario = @NuevoNombreUsuario
		WHERE ID_NombreUsuario = (SELECT id_NombreUsuario FROM Usuario_General WHERE id_CorreoElectronico =
								(SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correoelectronico))
	END;
