--PROCEDIMIENTO UPDATE a la unidad academica del usuario general Tabla Usuario_General

CREATE PROCEDURE ActualizacionUnidadAcademicaUsuario
	@correo varchar(255),
	@SiglasUnidadAcademica varchar(255)
AS
	BEGIN
		UPDATE Usuario_General 
		SET id_UnidadAcademica = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica)
		WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo)
	END;
