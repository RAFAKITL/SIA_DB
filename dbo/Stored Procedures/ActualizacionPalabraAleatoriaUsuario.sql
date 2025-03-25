--PROCEDIMIENTO UPDATE a la palabra aleatoria del usuario general Tabla PalabraAleatoria
CREATE PROCEDURE ActualizacionPalabraAleatoriaUsuario
	@Palabra varchar(255),
	@correo varchar(255)

AS

	BEGIN
		UPDATE Palabra_Aleatoria
		SET Desc_Palabra_Aleatoria = @Palabra
		WHERE ID_PalabraAleatoria = (SELECT id_PalabraAleatoria FROM Usuario_General WHERE id_CorreoElectronico =
                        (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo))

	END;