-- Formato 2: Unidades Académicas que cuentan con CELEX COMPARATIVO
CREATE PROCEDURE DFLE_UACelexComparativo
    @anio INT,
    @id_Trimestre INT

AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PeriodoAnterior INT
    DECLARE @PeriodoActual INT
    DECLARE @VariacionPorcentual DECIMAL(5, 2)
    DECLARE @Justificacion NVARCHAR(MAX)

    DECLARE @NMS VARCHAR(255) = 'NIVEL MEDIO SUPERIOR' COLLATE Latin1_General_CI_AI;
    DECLARE @NS VARCHAR(255) = 'NIVEL SUPERIOR' COLLATE Latin1_General_CI_AI;
    DECLARE @CIR VARCHAR(255) = 'UNIDADES ACADÉMICAS DE INVESTIGACIÓN CIENTÍFICA Y TECNOLÓGICA' COLLATE Latin1_General_CI_AI;
    DECLARE @UAVDR VARCHAR(255) = 'UNIDADES ACADÉMICAS DE VINCULACION Y DESARROLLO REGIONAL' COLLATE Latin1_General_CI_AI;
    DECLARE @CIITA VARCHAR(255) = 'UNIDADES ACADÉMICAS DE INNOVACION E INTEGRACION DE TECNOLOGÍAS AVANZADAS' COLLATE Latin1_General_CI_AI;

    DECLARE @Comparativo TABLE (
        ID_Comparativo INT IDENTITY(1,1),
        NivelUnidad VARCHAR(255),
        PeriodoAnterior INT NOT NULL DEFAULT 0,
        PeriodoActual INT NOT NULL DEFAULT 0,
        VariacionPorcentual VARCHAR(10) NOT NULL DEFAULT ' ',
        Justificacion NVARCHAR(MAX) NOT NULL DEFAULT ' '
    )

    INSERT INTO @Comparativo (
        NivelUnidad
    )VALUES(
        @NMS
    ),
    (
        @NS
    ),
    (
        @CIR
    ),
    (
        @UAVDR
    ),
    (
        @CIITA
    );

    DECLARE @UA TABLE(
        ID_UnidadAcademica INT IDENTITY(1,1),
        SiglasUnidad varchar(255)
    )

    DECLARE @contadorTipoUA INT = 1;
    WHILE @contadorTipoUA <= (SELECT COUNT(ID_Comparativo) FROM @Comparativo)
    BEGIN
        DECLARE @TipoUAActual varchar(255) = (SELECT NivelUnidad 
                                            FROM @Comparativo   
                                            WHERE ID_Comparativo = @contadorTipoUA )
        DELETE FROM @UA
        INSERT INTO @UA (SiglasUnidad)
        (SELECT Siglas 
        FROM UnidadesAcademicas 
        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                        FROM TipoUnidadAcademica 
                                        WHERE Desc_TipoUnidadAcademica = @TipoUAActual))

        DECLARE @AcumuladoActual INT = 0;
        DECLARE @AcumuladoAnterior INT = 0;
        DECLARE @contadorUA INT = 1;

        WHILE @contadorUA <= (SELECT COUNT(ID_UnidadAcademica) FROM @UA) 
        BEGIN
            DECLARE @SiglasUAActual varchar(255) = (SELECT SiglasUnidad 
                                            FROM @UA 
                                            WHERE ID_UnidadAcademica = @contadorUA)
            SET @AcumuladoActual = @AcumuladoActual + CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUAActual) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = @id_Trimestre) THEN 1 ELSE 0 END;
            SET @AcumuladoAnterior = @AcumuladoAnterior + CASE WHEN EXISTS(SELECT * 
                                                            FROM DFLE_AlumnosEnsenanzaLenguas 
                                                            WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                        FROM UnidadesAcademicas 
                                                                                        WHERE Siglas = @SiglasUAActual) 
                                                            AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio - 1)
                                                            AND id_Trimestre = @id_Trimestre) THEN 1 ELSE 0 END;
            SET @contadorUA = @contadorUA + 1;
        END;
        SET @Justificacion = ISNULL((SELECT Desc_Justificacion 
                            FROM DFLE_JustificacionesUACelex 
                            WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                            AND id_Trimestre = @id_Trimestre
                            AND id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                        FROM TipoUnidadAcademica
                                                        WHERE Desc_TipoUnidadAcademica = @TipoUAActual)), '');

        UPDATE @Comparativo 
        SET PeriodoActual = @AcumuladoActual,
            PeriodoAnterior = @AcumuladoAnterior,
            @VariacionPorcentual = CASE WHEN @AcumuladoAnterior != 0
            THEN (@AcumuladoActual - @AcumuladoAnterior) * 100 / @AcumuladoAnterior
            ELSE ' ' END,
            Justificacion = @Justificacion
        WHERE ID_Comparativo = @contadorTipoUA
        SET @contadorTipoUA = @contadorTipoUA + 1;
    END;

    SELECT NivelUnidad,
            PeriodoAnterior,
            PeriodoActual,
            VariacionPorcentual,
            Justificacion 
    FROM @Comparativo
END;

