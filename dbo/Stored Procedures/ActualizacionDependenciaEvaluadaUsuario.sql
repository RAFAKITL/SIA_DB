--PROCEDIMIENTO UPDATE a la dependencia evaluada del usuario Tabla Usuario_General
CREATE PROCEDURE ActualizacionDependenciaEvaluadaUsuario
	@correo varchar(255),
	@Siglas varchar(255)
AS
	BEGIN
		UPDATE Usuario_General 
		SET id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @Siglas)
		WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @correo)
	END;