--Procedimiento para el rellenado de la informacion temporal de la interfaz que representa al formato 9
CREATE PROCEDURE DFLE_InterPromedioAlumnosAtendidosComparativo
    @Idioma varchar(255),
    @anio INT,
    @id_Trimestre INT,
    @Final VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AlumnosAtendidosLenguasComparativo TABLE(
        AntCenlexH INT NOT NULL DEFAULT 0,
        AntCenlexM INT NOT NULL DEFAULT 0,
        AntCenlexTotal INT NOT NULL DEFAULT 0,

        AntCelexH INT NOT NULL DEFAULT 0,
        AntCelexM INT NOT NULL DEFAULT 0,
        AntCelexTotal INT NOT NULL DEFAULT 0,

        AnteriorTotal INT NOT NULL DEFAULT 0,

        ActCenlexH INT NOT NULL DEFAULT 0,
        ActCenlexM INT NOT NULL DEFAULT 0,
        ActCenlexTotal INT NOT NULL DEFAULT 0,

        ActCelexH INT NOT NULL DEFAULT 0,
        ActCelexM INT NOT NULL DEFAULT 0,
        ActCelexTotal INT NOT NULL DEFAULT 0,

        ActSubHombres INT NOT NULL DEFAULT 0,
        ActSubMujeres INT NOT NULL DEFAULT 0,
        ActualTotal INT NOT NULL DEFAULT 0,

        Variacion VARCHAR(255) NOT NULL DEFAULT ' ',

        Justificacion VARCHAR(255) NOT NULL DEFAULT ' '
    );

    DECLARE @Identificadores TABLE(
        IdentificadorJustificacion INT
    );

    DECLARE @CenlexSantoTomas VARCHAR(255) = 'CENLEX UST';
    DECLARE @CenlexZacatenco VARCHAR(255) = 'CENLEX Zacatenco';
    DECLARE @AnioAnterior INT = @anio - 1;

    DECLARE @AntCenlexH INT = 0;
    DECLARE @AntCenlexM INT = 0;
    DECLARE @AntCenlexTotal INT = 0;

    DECLARE @AntCelexH INT = 0;
    DECLARE @AntCelexM INT = 0;
    DECLARE @AntCelexTotal INT = 0;
    
    DECLARE @AnteriorTotal INT = 0;

    DECLARE @ActCenlexH INT = 0;
    DECLARE @ActCenlexM INT = 0;
    DECLARE @ActCenlexTotal INT = 0;

    DECLARE @ActCelexH INT = 0;
    DECLARE @ActCelexM INT = 0;
    DECLARE @ActCelexTotal INT = 0;

    DECLARE @ActSubHombres INT = 0;
    DECLARE @ActSubMujeres INT = 0;
    DECLARE @ActualTotal INT = 0;

    DECLARE @Variacion DECIMAL(10, 2) = 0;
    DECLARE @Justificacion VARCHAR(255) = '';

    DECLARE @ContadorTrimestres INT = 1;

    IF @Final = 'FINAL'
    BEGIN
        WHILE @ContadorTrimestres <= @id_Trimestre
        BEGIN
            -- CENLEX Anio Anterior
            SET @AntCenlexH = @AntCenlexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @AntCenlexM =  @AntCenlexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            -- CELEX Anio Anterior
            SET @AntCelexH = @AntCelexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @AntCelexM = @AntCelexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            -- CENLEX Anio Actual
            SET @ActCenlexH = @ActCenlexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @ActCenlexM = @ActCenlexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            -- CELEX Anio Actual
            SET @ActCelexH = @ActCelexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @ActCelexM = @ActCelexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            SET @ContadorTrimestres = @ContadorTrimestres + 1;
        END

        SET @AntCenlexTotal = @AntCenlexH + @AntCenlexM;
        SET @AntCelexTotal = @AntCelexH + @AntCelexM;
        SET @AnteriorTotal = @AntCenlexTotal + @AntCelexTotal;

        SET @ActCenlexTotal = @ActCenlexH + @ActCenlexM;
        SET @ActCelexTotal = @ActCelexH + @ActCelexM;
        SET @ActSubHombres = @ActCenlexH + @ActCelexH;
        SET @ActSubMujeres = @ActCenlexM + @ActCelexM;
        SET @ActualTotal = @ActCenlexTotal + @ActCelexTotal;

        SET @Variacion = CASE WHEN 
                        @AnteriorTotal <> 0 
                        THEN (((@ActualTotal - @AnteriorTotal) * 100) / @AnteriorTotal)
                        ELSE
                        0
                        END;
        SET @Justificacion = (SELECT Desc_Justificacion 
                            FROM DFLE_JustificacionesFormato5_9 
                            WHERE id_Anio = (SELECT ID_Anio
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)
                            AND id_Trimestre = @id_Trimestre
                            AND id_Idioma = (SELECT ID_Idioma 
                                            FROM DFLE_Idiomas
                                            WHERE Desc_Idioma = @Idioma)
                            AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                                            FROM Formatos
                                                            WHERE Desc_NumeroFormato = 9
                                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                        FROM Dependencias_Evaluadas
                                                                                        WHERE Desc_SiglasDependencia = 'DFLE')));

        INSERT INTO @AlumnosAtendidosLenguasComparativo
        VALUES(
            @AntCenlexH,
            @AntCenlexM,
            @AntCenlexTotal,
            @AntCelexH,
            @AntCelexM,
            @AntCelexTotal,
            @AnteriorTotal,
            @ActCenlexH,
            @ActCenlexM,
            @ActCenlexTotal,
            @ActCelexH,
            @ActCelexM,
            @ActCelexTotal,
            @ActSubHombres,
            @ActSubMujeres,
            @ActualTotal,
            CASE WHEN @AnteriorTotal = 0 AND @Variacion = 0
                            THEN ' ' 
                            ELSE CONCAT(@Variacion, '%')
                            END,
            ISNULL(@Justificacion, ' ')
        );

        INSERT INTO @Identificadores
        VALUES(
            (SELECT ID_JustificacionesFormato5_9 
            FROM DFLE_JustificacionesFormato5_9 
            WHERE id_Anio = (SELECT ID_Anio
                            FROM Anio
                            WHERE Desc_Anio = @anio)
            AND id_Trimestre = @id_Trimestre
            AND id_Idioma = (SELECT ID_Idioma 
                                        FROM DFLE_Idiomas
                                        WHERE Desc_Idioma = @Idioma)
            AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                            FROM Formatos
                                            WHERE Desc_NumeroFormato = 9
                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                        FROM Dependencias_Evaluadas
                                                                        WHERE Desc_SiglasDependencia = 'DFLE')))
        );
    END
    ELSE
    BEGIN
        WHILE @ContadorTrimestres <= @id_Trimestre
        BEGIN
            -- CENLEX Anio Anterior
            SET @AntCenlexH = @AntCenlexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @AntCenlexM =  @AntCenlexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            -- CELEX Anio Anterior
            SET @AntCelexH = @AntCelexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @AntCelexM = @AntCelexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            -- CENLEX Anio Actual
            SET @ActCenlexH = @ActCenlexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @ActCenlexM = @ActCenlexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                                        WHERE id_UnidadAcademica IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            -- CELEX Anio Actual
            SET @ActCelexH = @ActCelexH + ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            SET @ActCelexM = @ActCelexM + ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                                        WHERE id_UnidadAcademica NOT IN ((SELECT id_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexSantoTomas),  
                                                                    (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @CenlexZacatenco))
                                        AND id_Idioma = (SELECT ID_Idioma 
                                                        FROM DFLE_Idiomas
                                                        WHERE Desc_Idioma = @Idioma)
                                        AND id_Anio = (SELECT id_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @ContadorTrimestres), 0);
            
            SET @ContadorTrimestres = @ContadorTrimestres + 1;
        END

        SET @AntCenlexTotal = @AntCenlexH + @AntCenlexM;
        SET @AntCelexTotal = @AntCelexH + @AntCelexM;
        SET @AnteriorTotal = @AntCenlexTotal + @AntCelexTotal;

        SET @ActCenlexTotal = @ActCenlexH + @ActCenlexM;
        SET @ActCelexTotal = @ActCelexH + @ActCelexM;
        SET @ActSubHombres = @ActCenlexH + @ActCelexH;
        SET @ActSubMujeres = @ActCenlexM + @ActCelexM;
        SET @ActualTotal = @ActCenlexTotal + @ActCelexTotal;

        SET @Variacion = CASE WHEN 
                        @AnteriorTotal <> 0 
                        THEN (((@ActualTotal - @AnteriorTotal) * 100) / @AnteriorTotal)
                        ELSE
                        0
                        END;
        SET @Justificacion = (SELECT Desc_Justificacion 
                            FROM DFLE_JustificacionesFormato5_9_Temporal
                            WHERE id_Anio = (SELECT ID_Anio
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)
                            AND id_Trimestre = @id_Trimestre
                            AND id_Idioma = (SELECT ID_Idioma 
                                            FROM DFLE_Idiomas
                                            WHERE Desc_Idioma = @Idioma)
                            AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                                            FROM Formatos
                                                            WHERE Desc_NumeroFormato = 9
                                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                        FROM Dependencias_Evaluadas
                                                                                        WHERE Desc_SiglasDependencia = 'DFLE')));

        INSERT INTO @AlumnosAtendidosLenguasComparativo
        VALUES(
            @AntCenlexH,
            @AntCenlexM,
            @AntCenlexTotal,
            @AntCelexH,
            @AntCelexM,
            @AntCelexTotal,
            @AnteriorTotal,
            @ActCenlexH,
            @ActCenlexM,
            @ActCenlexTotal,
            @ActCelexH,
            @ActCelexM,
            @ActCelexTotal,
            @ActSubHombres,
            @ActSubMujeres,
            @ActualTotal,
            CASE WHEN @AnteriorTotal = 0 AND @Variacion = 0
                            THEN ' ' 
                            ELSE CONCAT(@Variacion, '%')
                            END,
            ISNULL(@Justificacion, ' ')
        );

        INSERT INTO @Identificadores
        VALUES(
            (SELECT ID_JustificacionesFormato5_9 
            FROM DFLE_JustificacionesFormato5_9_Temporal
            WHERE id_Anio = (SELECT ID_Anio
                            FROM Anio
                            WHERE Desc_Anio = @anio)
            AND id_Trimestre = @id_Trimestre
            AND id_Idioma = (SELECT ID_Idioma 
                                        FROM DFLE_Idiomas
                                        WHERE Desc_Idioma = @Idioma)
            AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                            FROM Formatos
                                            WHERE Desc_NumeroFormato = 9
                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                        FROM Dependencias_Evaluadas
                                                                        WHERE Desc_SiglasDependencia = 'DFLE')))
        );
    END
    
    SELECT * FROM @AlumnosAtendidosLenguasComparativo;
    SELECT * FROM @Identificadores;
END
