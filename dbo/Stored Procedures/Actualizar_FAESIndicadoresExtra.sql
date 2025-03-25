CREATE PROCEDURE Actualizar_FAESIndicadoresExtra
	@Anio VARCHAR (255),
	@Trimestre VARCHAR (255),
	@SiglasDependencia VARCHAR (255),
	@Clave VARCHAR (255),
	@NewV1Trim1 VARCHAR (255),
	@NewV1Trim2 VARCHAR (255),
	@NewV1Trim3 VARCHAR (255),
	@NewV1Trim4 VARCHAR (255),
	@NewV2Trim1 VARCHAR (255),
	@NewV2Trim2 VARCHAR (255),
	@NewV2Trim3 VARCHAR (255),
	@NewV2Trim4 VARCHAR (255)
	
AS 
BEGIN
	UPDATE FAES_IndicadoresExtra
	SET PRIMER_TRIM = @NewV1Trim1 
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave

	UPDATE FAES_IndicadoresExtra
	SET SEGUNDO_TRIM = @NewV1Trim2
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave

	UPDATE FAES_IndicadoresExtra
	SET TERCER_TRIM = @NewV1Trim3
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave

	UPDATE FAES_IndicadoresExtra
	SET CUARTO_TRIM = @NewV1Trim4
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave

--------------------------------------------------------------------------------------------------------------------------------------------------
	UPDATE FAES_IndicadoresExtra
	SET PRIMER_TRIMV2 = @NewV2Trim1
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave

	UPDATE FAES_IndicadoresExtra
	SET SEGUNDO_TRIMV2 = @NewV2Trim2
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave

	UPDATE FAES_IndicadoresExtra
	SET TERCER_TRIMV2 = @NewV2Trim3
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave

	UPDATE FAES_IndicadoresExtra
	SET CUARTO_TRIMV2 = @NewV2Trim4
	WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND id_Trimestre = @Trimestre
	AND id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
	AND Clave_Indicador = @Clave
END