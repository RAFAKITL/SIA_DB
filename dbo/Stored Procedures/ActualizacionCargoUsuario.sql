--PROCEDIMIENTO UPDATE al cargo del usuario general Tabla Cargos
CREATE PROCEDURE ActualizacionCargoUsuario
	@correo varchar(255),
	@Cargo varchar(255)
AS
	BEGIN
	UPDATE Cargos
	SET Desc_Cargo = @Cargo 
	WHERE ID_Cargo = (SELECT id_Cargo FROM Usuario_General WHERE id_CorreoElectronico =
					(SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo))
	END;
