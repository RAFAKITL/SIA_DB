﻿CREATE PROCEDURE CreacionRegistro_FAESIndicadoresExtra
	@Ejefundamental VARCHAR (255),
	@ProyectoInstitucional VARCHAR (255),
	@Clave VARCHAR (255),
	@Accion VARCHAR (255),
	@NombreIndicador VARCHAR (255),
	@MetodoCalculo VARCHAR (255),
	@IndicadorMeta VARCHAR (255),
	@V1Trim1 VARCHAR (255),
	@V1Trim2 VARCHAR (255),
	@V1Trim3 VARCHAR (255),
	@V1Trim4 VARCHAR (255),
	@V2Trim1 VARCHAR (255),
	@V2Trim2 VARCHAR (255),
	@V2Trim3 VARCHAR (255),
	@V2Trim4 VARCHAR (255),
	@Fecha VARCHAR (255),
	@SiglasDependencia VARCHAR (255),
	@CorreoUsuario VARCHAR (255),
	@Trimestre VARCHAR (255),
	@Anio VARCHAR (255)
AS 
BEGIN 
	INSERT INTO FAES_IndicadoresExtra(
		EjeFundamental,
		ProjectoInstitucional,
		Clave_Indicador,
		AccionInstitucional,
		NombreIndicador,
		MetodoCalculo,
		IndicadorMeta2024,
		PRIMER_TRIM,
		SEGUNDO_TRIM,
		TERCER_TRIM,
		CUARTO_TRIM,
		PRIMER_TRIMV2,
		SEGUNDO_TRIMV2,
		TERCER_TRIMV2,
		CUARTO_TRIMV2,
		Fecha,
		id_DependenciasEvaluadas,
		id_Usuario,
		id_Trimestre,
		id_Anio		
		)
	VALUES (
		@Ejefundamental,
		@ProyectoInstitucional,
		@Clave,
		@Accion,
		@NombreIndicador,
		@MetodoCalculo,
		@IndicadorMeta,
		@V1Trim1,
		@V1Trim2,
		@V1Trim3,
		@V1Trim4,
		@V2Trim1,
		@V2Trim2,
		@V2Trim3,
		@V2Trim4,
		@Fecha,
		(SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia),
		(SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario)),
		@Trimestre,
		(SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
	)
END;