--PROCEDIMIENTO Eliminacion de un usuario a partir del correo electronico
CREATE PROCEDURE EliminarUsuario 
	@correoelectronico varchar(255)

AS
BEGIN
    DECLARE @IDCORREO INT
    SET @IDCORREO = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico  = (@correoelectronico))

    DECLARE @IDNOMBREUSUARIO INT
    SET  @IDNOMBREUSUARIO = (SELECT id_NombreUsuario FROM Usuario_General WHERE id_CorreoElectronico = (@IDCORREO))

    DECLARE @IDCONTRASENA INT
    SET @IDCONTRASENA = (SELECT id_ContrasenaHash FROM Usuario_General WHERE id_CorreoElectronico = (@IDCORREO))

    DECLARE @IDPALABRAALEATORIA INT
    SET @IDPALABRAALEATORIA = (SELECT id_PalabraAleatoria FROM Usuario_General where id_CorreoElectronico  = (@IDCORREO))

    DECLARE @IDNUMEROTEL INT
    SET @IDNUMEROTEL = (SELECT id_NumeroTelefono FROM Usuario_General WHERE id_CorreoElectronico = (@IDCORREO))

    DELETE FROM Usuario_General WHERE id_CorreoElectronico = @IDCORREO
    DELETE FROM Nombre_Usuarios WHERE ID_NombreUsuario = @IDNOMBREUSUARIO
    DELETE FROM Contrasena_Hash WHERE ID_ContrasenaHash = @IDCONTRASENA
    DELETE FROM Palabra_Aleatoria WHERE ID_PalabraAleatoria = @IDPALABRAALEATORIA
    DELETE FROM Correo_Electronico WHERE ID_CorreoElectronico = @IDCORREO
    DELETE FROM Numero_Telefono  WHERE ID_NumeroTelefono = @IDNUMEROTEL
END;
