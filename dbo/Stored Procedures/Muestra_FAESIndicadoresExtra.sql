CREATE PROCEDURE Muestra_FAESIndicadoresExtra
	@Anio VARCHAR (255),
	@Trimestre INT,
	@SiglasDependencia VARCHAR (255)
AS 
BEGIN 
	SELECT
		IE.EjeFundamental,
		IE.ProjectoInstitucional,
		ISNULL(Clave_Indicador, 0),
		IE.AccionInstitucional,
		IE.NombreIndicador,
		IE.MetodoCalculo,
		ISNULL(IE.IndicadorMeta2024, 0),
		ISNULL(IE.PRIMER_TRIM, 0) AS PrimerTrimestreV1,
		ISNULL(IE.SEGUNDO_TRIM, 0)  AS SegundoTrimestreV1,
		ISNULL(IE.TERCER_TRIM, 0) AS TercerTrimestreV1,
		ISNULL(IE.CUARTO_TRIM, 0) AS CuartoTrimestreV1,
		ISNULL(IE.PRIMER_TRIM, 0) AS PrimerTrimestreV2,
		ISNULL(IE.SEGUNDO_TRIM, 0) AS SegundoTrimestreV2,
		ISNULL(IE.TERCER_TRIM, 0) AS TercerTrimestreV2,
		ISNULL(IE.CUARTO_TRIM, 0) AS CuartoTrimestreV2,
		IE.Fecha,
		DE.Desc_SiglasDependencia AS Desc_SiglasDependencia,
		IE.id_Trimestre,
		A.Desc_Anio AS Desc_Anio
	FROM FAES_IndicadoresExtra IE
	JOIN Dependencias_Evaluadas DE ON IE.id_DependenciasEvaluadas = DE.ID_DependenciasEvaluadas
	JOIN Anio A ON IE.id_Anio = A.ID_Anio
	WHERE IE.id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	AND IE.id_Trimestre = @Trimestre
	AND IE.id_DependenciasEvaluadas = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
END
