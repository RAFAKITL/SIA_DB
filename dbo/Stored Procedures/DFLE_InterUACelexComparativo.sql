--Procedimiento para la interfaz que representa el ingreso de informacion del formato 2

CREATE PROCEDURE DFLE_InterUACelexComparativo
    @TipoUnidadAcademica varchar(255),
    @anio INT,
    @id_Trimestre INT,
    @Final VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PeriodoAnterior INT
    DECLARE @PeriodoActual INT
    DECLARE @VariacionPorcentual DECIMAL(5, 2)
    DECLARE @Justificacion NVARCHAR(MAX)

    DECLARE @Comparativo TABLE (
        PeriodoAnterior INT NOT NULL DEFAULT 0,
        PeriodoActual INT NOT NULL DEFAULT 0,
        VariacionPorcentual VARCHAR(10) NOT NULL DEFAULT ' ',
        Justificacion NVARCHAR(MAX) NOT NULL DEFAULT ' '
    );

    DECLARE @Identificadores TABLE(
        IdentificadorJustificacion INT
    );

    DECLARE @UA TABLE(
        ID_UnidadAcademica INT IDENTITY(1,1),
        SiglasUnidad varchar(255)
    );

    INSERT INTO @UA (
        SiglasUnidad
    )SELECT Siglas 
    FROM UnidadesAcademicas 
    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @TipoUnidadAcademica);

    DECLARE @AcumuladoActual INT = 0;
    DECLARE @AcumuladoAnterior INT = 0;
    DECLARE @contadorUA INT = 1;

    DECLARE @SiglasUAActual varchar(255) = '';

    IF @Final = 'FINAL'
    BEGIN
        WHILE @contadorUA <= (SELECT COUNT(ID_UnidadAcademica) FROM @UA) 
        BEGIN
            SET @SiglasUAActual = (SELECT SiglasUnidad 
                                                    FROM @UA 
                                                    WHERE ID_UnidadAcademica = @contadorUA)
            SET @AcumuladoActual = @AcumuladoActual + CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUAActual) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = 2) THEN 1 ELSE 0 END;
            SET @AcumuladoAnterior = @AcumuladoAnterior + CASE WHEN EXISTS(SELECT * 
                                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                                            WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                        FROM UnidadesAcademicas 
                                                                                        WHERE Siglas = @SiglasUAActual) 
                                                            AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio - 1)
                                                            AND id_Trimestre = 2) THEN 1 ELSE 0 END;
            SET @contadorUA = @contadorUA + 1;
        END;
        
        SET @Justificacion = ISNULL((SELECT TOP(1) Desc_Justificacion 
                                FROM DFLE_JustificacionesUACelex 
                                WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                                AND id_Trimestre = @id_Trimestre
                                AND id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                            FROM TipoUnidadAcademica
                                                            WHERE Desc_SiglasTipo = @TipoUnidadAcademica)), ' ');

        INSERT INTO @Identificadores(
            IdentificadorJustificacion
        )SELECT ID_JustificacionesUACelex 
        FROM DFLE_JustificacionesUACelex 
        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
        AND id_Trimestre = @id_Trimestre
        AND id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica
                                    WHERE Desc_SiglasTipo = @TipoUnidadAcademica);

        SET @VariacionPorcentual = CASE WHEN @AcumuladoAnterior != 0
                                    THEN (@AcumuladoActual - @AcumuladoAnterior) * 100 / @AcumuladoAnterior
                                    ELSE ' ' END;

        INSERT INTO @Comparativo(
            PeriodoAnterior,
            PeriodoActual,
            VariacionPorcentual,
            Justificacion
        )VALUES(
            @AcumuladoAnterior,
            @AcumuladoActual,
            @VariacionPorcentual,
            @Justificacion
        );
    END
    ELSE
    BEGIN
        WHILE @contadorUA <= (SELECT COUNT(ID_UnidadAcademica) FROM @UA) 
        BEGIN
            SET @SiglasUAActual = (SELECT SiglasUnidad 
                                                    FROM @UA 
                                                    WHERE ID_UnidadAcademica = @contadorUA)
            SET @AcumuladoActual = @AcumuladoActual + CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUAActual) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = 2) THEN 1 ELSE 0 END;
            SET @AcumuladoAnterior = @AcumuladoAnterior + CASE WHEN EXISTS(SELECT * 
                                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                                            WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                        FROM UnidadesAcademicas 
                                                                                        WHERE Siglas = @SiglasUAActual) 
                                                            AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio - 1)
                                                            AND id_Trimestre = 2) THEN 1 ELSE 0 END;
            SET @contadorUA = @contadorUA + 1;
        END;
        
        SET @Justificacion = ISNULL((SELECT TOP(1) Desc_Justificacion 
                                FROM DFLE_JustificacionesUACelex_Temporal
                                WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                                AND id_Trimestre = @id_Trimestre
                                AND id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                            FROM TipoUnidadAcademica
                                                            WHERE Desc_SiglasTipo = @TipoUnidadAcademica)), ' ');

        INSERT INTO @Identificadores(
            IdentificadorJustificacion
        )SELECT ID_JustificacionesUACelex 
        FROM DFLE_JustificacionesUACelex_Temporal
        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
        AND id_Trimestre = @id_Trimestre
        AND id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica
                                    WHERE Desc_SiglasTipo = @TipoUnidadAcademica);

        SET @VariacionPorcentual = CASE WHEN @AcumuladoAnterior != 0
                                    THEN (@AcumuladoActual - @AcumuladoAnterior) * 100 / @AcumuladoAnterior
                                    ELSE ' ' END;

        INSERT INTO @Comparativo(
            PeriodoAnterior,
            PeriodoActual,
            VariacionPorcentual,
            Justificacion
        )VALUES(
            @AcumuladoAnterior,
            @AcumuladoActual,
            @VariacionPorcentual,
            @Justificacion
        );
    END

    SELECT * FROM @Comparativo
    SELECT * FROM @Identificadores
END
