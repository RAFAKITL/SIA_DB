--Numero de Formato: 6 Nivel de estudios en lenguas de la población atendida
CREATE PROCEDURE DFLE_NivelLenguasPoblacionAtendida
    @SiglasTipoUnidadAcademica varchar(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NivelEstudiosPoblacionAtendida TABLE (
        SiglasUA varchar(255),
        CuentaCelex varchar(1),

        MS_Basico varchar(10) NOT NULL DEFAULT ' ',
        MS_Intermedio varchar(10) NOT NULL DEFAULT ' ',
        MS_Avanzado varchar(10) NOT NULL DEFAULT ' ',
        MS_Superior varchar(10) NOT NULL DEFAULT ' ',

        Sup_Basico varchar(10) NOT NULL DEFAULT ' ',
        Sup_Intermedio varchar(10) NOT NULL DEFAULT ' ',
        Sup_Avanzado varchar(10) NOT NULL DEFAULT ' ',
        Sup_Superior varchar(10) NOT NULL DEFAULT ' ',

        Pos_Basico varchar(10) NOT NULL DEFAULT ' ',
        Pos_Intermedio varchar(10) NOT NULL DEFAULT ' ',
        Pos_Avanzado varchar(10) NOT NULL DEFAULT ' ',
        Pos_Superior varchar(10) NOT NULL DEFAULT ' ',

        Eg_Basico varchar(10) NOT NULL DEFAULT ' ',
        Eg_Intermedio varchar(10) NOT NULL DEFAULT ' ',
        Eg_Avanzado varchar(10) NOT NULL DEFAULT ' ',
        Eg_Superior varchar(10) NOT NULL DEFAULT ' ',

        Em_Basico varchar(10) NOT NULL DEFAULT ' ',
        Em_Intermedio varchar(10) NOT NULL DEFAULT ' ',
        Em_Avanzado varchar(10) NOT NULL DEFAULT ' ',
        Em_Superior varchar(10) NOT NULL DEFAULT ' ',

        PG_Basico varchar(10) NOT NULL DEFAULT ' ',
        PG_Intermedio varchar(10) NOT NULL DEFAULT ' ',
        PG_Avanzado varchar(10) NOT NULL DEFAULT ' ',
        PG_Superior varchar(10) NOT NULL DEFAULT ' ',

        Total INT NOT NULL DEFAULT 0
    );

    DECLARE @UnidadesAcademicas TABLE (
        ID_UnidadesAcademicas INT IDENTITY(1, 1),
        SiglasUnidad varchar(255)
    );

    INSERT INTO @UnidadesAcademicas (
        SiglasUnidad
    )SELECT Siglas 
    FROM UnidadesAcademicas 
    WHERE id_TipoUnidadAcademica = (
        SELECT ID_TipoUnidadAcademica 
        FROM TipoUnidadAcademica
        WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica
    );

    DECLARE @SiglasActual VARCHAR(255);
    DECLARE @ContadorUA INT = 1;
    WHILE @ContadorUA <= (SELECT COUNT(*) FROM @UnidadesAcademicas)
    BEGIN
        DECLARE @Total INT = 0;
        SET @SiglasActual = (SELECT SiglasUnidad 
                            FROM @UnidadesAcademicas
                            WHERE ID_UnidadesAcademicas = @ContadorUA)      
    
        DECLARE @CuentaCelex VARCHAR(1) = CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasActual) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = @id_Trimestre) THEN '1' ELSE ' ' END ;                                                               
        INSERT INTO @NivelEstudiosPoblacionAtendida (
            SiglasUA
        ) VALUES (
            @SiglasActual
        )

        UPDATE @NivelEstudiosPoblacionAtendida
        SET CuentaCelex = @CuentaCelex
        WHERE SiglasUA = @SiglasActual;

        DECLARE @ContadorNivelE int = 1;                                                        
        WHILE @ContadorNivelE <= (SELECT COUNT(*) FROM DFLE_NivelEducativo)
        BEGIN
            --DECLARE @TotalNivelComp VARCHAR(10);
            DECLARE @ContadorNivelC int = 1;
            WHILE  @ContadorNivelC <= (SELECT COUNT(*) FROM DFLE_NivelesCompetencia)
            BEGIN
                DECLARE @Hombres INT = (ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasActual)
                                        AND id_NivelEducativo = @ContadorNivelE
                                        AND id_Competencia = @ContadorNivelC), 0));
                DECLARE @Mujeres INT = (ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasActual)
                                        AND id_NivelEducativo = @ContadorNivelE
                                        AND id_Competencia = @ContadorNivelC), 0));
                IF @ContadorNivelE = 1
                BEGIN
                    IF @ContadorNivelC = 1
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET MS_Basico = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    ELSE IF @ContadorNivelC = 2
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET MS_Intermedio = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    ELSE IF @ContadorNivelC = 3
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET MS_Avanzado = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    ELSE IF @ContadorNivelC = 4
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET MS_Superior = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                END

                ELSE IF @ContadorNivelE = 2
                BEGIN
                    IF @ContadorNivelC = 1
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Sup_Basico = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 2
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Sup_Intermedio = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 3
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Sup_Avanzado = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 4
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Sup_Superior = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                END

                ELSE IF @ContadorNivelE = 3
                BEGIN
                    IF @ContadorNivelC = 1
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Pos_Basico = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 2
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Pos_Intermedio = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 3
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Pos_Avanzado = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 4
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Pos_Superior = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                END

                ELSE IF @ContadorNivelE = 4
                BEGIN
                    IF @ContadorNivelC = 1
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Eg_Basico = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 2
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Eg_Intermedio = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 3
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Eg_Avanzado = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 4
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Eg_Superior = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                END

                ELSE IF @ContadorNivelE = 5
                BEGIN
                    IF @ContadorNivelC = 1
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Em_Basico = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 2
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Em_Intermedio = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 3
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Em_Avanzado = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 4
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET Em_Superior = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                END

                ELSE IF @ContadorNivelE = 6
                BEGIN
                    IF @ContadorNivelC = 1
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET PG_Basico = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 2
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET PG_Intermedio = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 3
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET PG_Avanzado = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                    IF @ContadorNivelC = 4
                    BEGIN
                        UPDATE @NivelEstudiosPoblacionAtendida
                        SET PG_Superior = CASE WHEN ISNULL(@Hombres + @Mujeres, 0) = 0
                                        THEN ' '
                                        ELSE CAST(ISNULL(@Hombres + @Mujeres, 0) AS VARCHAR(10))
                                        END
                        WHERE SiglasUA = @SiglasActual
                    END
                END
                SET @Total = @Total + @Hombres + @Mujeres
                SET @ContadorNivelC = @ContadorNivelC + 1;
            END
            SET @ContadorNivelE = @ContadorNivelE + 1;
        END
        
        UPDATE @NivelEstudiosPoblacionAtendida
        SET Total = @Total
        WHERE SiglasUA = @SiglasActual;

        SET @ContadorUA = @ContadorUA + 1;
    END


    SET @CuentaCelex = (SELECT SUM(CAST(CuentaCelex AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @MSBasico VARCHAR(255) = (SELECT SUM(CAST(MS_Basico AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @MSIntermedio VARCHAR(255) = (SELECT SUM(CAST(MS_Intermedio AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @MSAvanzado VARCHAR(255) = (SELECT SUM(CAST(MS_Avanzado AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @MSSuperior VARCHAR(255) = (SELECT SUM(CAST(MS_Superior AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @SupBasico VARCHAR(255) = (SELECT SUM(CAST(Sup_Basico AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @SupIntermedio VARCHAR(255) = (SELECT SUM(CAST(Sup_Intermedio AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @SupAvanzado VARCHAR(255) = (SELECT SUM(CAST(Sup_Avanzado AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @SupSuperior VARCHAR(255) = (SELECT SUM(CAST(Sup_Superior AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PosBasico VARCHAR(255) = (SELECT SUM(CAST(Pos_Basico AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PosIntermedio VARCHAR(255) = (SELECT SUM(CAST(Pos_Intermedio AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PosAvanzado VARCHAR(255) = (SELECT SUM(CAST(Pos_Avanzado AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PosSuperior VARCHAR(255) = (SELECT SUM(CAST(Pos_Superior AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EgBasico VARCHAR(255) = (SELECT SUM(CAST(Eg_Basico AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EgIntermedio VARCHAR(255) = (SELECT SUM(CAST(Eg_Intermedio AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EgAvanzado VARCHAR(255) = (SELECT SUM(CAST(Eg_Avanzado AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EgSuperior VARCHAR(255) = (SELECT SUM(CAST(Eg_Superior AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EmBasico VARCHAR(255) = (SELECT SUM(CAST(Em_Basico AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EmIntermedio VARCHAR(255) = (SELECT SUM(CAST(Em_Intermedio AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EmAvanzado VARCHAR(255) = (SELECT SUM(CAST(Em_Avanzado AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @EmSuperior VARCHAR(255) = (SELECT SUM(CAST(Em_Superior AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PGBasico VARCHAR(255) = (SELECT SUM(CAST(PG_Basico AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PGIntermedio VARCHAR(255) = (SELECT SUM(CAST(PG_Intermedio AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PGAavanzado VARCHAR(255) = (SELECT SUM(CAST(PG_Avanzado AS INT)) FROM @NivelEstudiosPoblacionAtendida);
    DECLARE @PGSuperior VARCHAR(255) = (SELECT SUM(CAST(PG_Superior AS INT)) FROM @NivelEstudiosPoblacionAtendida);

    /*
    SELECT 
        CONCAT('Total' , ' ', @SiglasTipoUnidadAcademica) AS UnidadAcademica, 
        @CuentaCelex AS CuentaCelex,
        @MSBasico AS MS_Basico,
        @MSIntermedio AS MS_Intermedio,
        @MSAvanzado AS MS_Avanzado,
        @MSSuperior AS MS_Superior,
        @SupBasico AS Sup_Basico,
        @SupIntermedio AS Sup_Intermedio,
        @SupAvanzado AS Sup_Avanzado,
        @SupSuperior AS Sup_Superior,
        @PosBasico AS Pos_Basico,
        @PosIntermedio AS Pos_Intermedio,
        @PosAvanzado AS Pos_Avanzado,
        @PosSuperior AS Pos_Superior,
        @EgBasico AS Eg_Basico,
        @EgIntermedio AS Eg_Intermedio,
        @EgAvanzado AS Eg_Avanzado,
        @EgSuperior AS Eg_Superior,
        @EmBasico AS Em_Basico,
        @EmIntermedio AS Em_Intermedio,
        @EmAvanzado AS Em_Avanzado,
        @EmSuperior AS Em_Superior,
        @PGBasico AS PG_Basico,
        @PGIntermedio AS PG_Intermedio,
        @PGAavanzado AS PG_Avanzado,
        @PGSuperior AS PG_Superior,
        
        ISNULL(SUM(Total), ' ') AS Total
    FROM @NivelEstudiosPoblacionAtendida
    UNION ALL
    */
    SELECT * FROM @NivelEstudiosPoblacionAtendida
END
