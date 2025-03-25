CREATE PROCEDURE Eliminar_FAESIndicadoresExtra
	@Anio VARCHAR (255),
	@Trimestre VARCHAR (255),
	@SiglasDependencia VARCHAR (255),
	@Clave VARCHAR (255)
AS 
BEGIN 
	DELETE FROM FAES_IndicadoresExtra 
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_DependenciasEvaluadas = @SiglasDependencia)
	AND Clave_Indicador = @Clave
END
