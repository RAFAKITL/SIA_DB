--PROCEDMIENTO UPDATE al numero de telefono del usuario general Tabla NumeroTelefono
CREATE PROCEDURE ActualizacionNumeroTelefonoUsuario
	@Telefono varchar(255),
	@correo varchar(255)
AS
	BEGIN
		UPDATE Numero_Telefono
		SET Desc_Numero_Telefono = @Telefono
		WHERE ID_NumeroTelefono = (SELECT id_NumeroTelefono FROM Usuario_General WHERE id_NumeroTelefono =
								(SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo));
	END;
