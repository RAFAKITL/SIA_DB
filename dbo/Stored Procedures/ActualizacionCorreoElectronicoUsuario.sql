--PROCEDIMIENTO UPDATE al correo electronico del usuario general (no sabemos si esto es sano, no lo creo) tabla Correo_Electronico
 CREATE PROCEDURE ActualizacionCorreoElectronicoUsuario
	@Correoactual varchar(255),
	@correonuevo varchar(255)
AS
	BEGIN
		UPDATE Correo_Electronico
		SET Desc_Correo_Electronico = @Correoactual
		WHERE Desc_Correo_Electronico = @correonuevo

	END;