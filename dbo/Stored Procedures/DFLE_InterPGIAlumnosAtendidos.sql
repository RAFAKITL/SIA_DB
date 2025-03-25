CREATE PROCEDURE DFLE_InterPGIAlumnosAtendidos
    @SiglasUnidadAcademica VARCHAR(255),
    @anio INT,
    @id_Trimestre INT,
    @Final VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PGIAlumnosAtendidos TABLE(
        PGI VARCHAR(10) NOT NULL DEFAULT '',
        Idioma VARCHAR(255) NOT NULL DEFAULT '',

        IntroductorioH INT NOT NULL DEFAULT 0,
        IntroductorioM INT NOT NULL DEFAULT 0,
        IntroductorioT INT NOT NULL DEFAULT 0,
        BasicoH INT NOT NULL DEFAULT 0,
        BasicoM INT NOT NULL DEFAULT 0,
        BasicoT INT NOT NULL DEFAULT 0,
        IntermedioH INT NOT NULL DEFAULT 0,
        IntermedioM INT NOT NULL DEFAULT 0,
        IntermedioT INT NOT NULL DEFAULT 0,
        AvanzadoH INT NOT NULL DEFAULT 0,
        AvanzadoM INT NOT NULL DEFAULT 0,
        AvanzadoT INT NOT NULL DEFAULT 0,
        SuperiorH INT NOT NULL DEFAULT 0,
        SuperiorM INT NOT NULL DEFAULT 0,
        SuperiorT INT NOT NULL DEFAULT 0
    );

    DECLARE @Identificadores TABLE(
        PGI VARCHAR(10) NOT NULL DEFAULT '',
        Idioma VARCHAR(255) NOT NULL DEFAULT '',

        IdentificadorIntroductorio INT NOT NULL DEFAULT 0,
        IdentificadorBasico INT NOT NULL DEFAULT 0,
        IdentificadorIntermedio INT NOT NULL DEFAULT 0,
        IdentificadorAvanzado INT NOT NULL DEFAULT 0,
        IdentificadorSuperior INT NOT NULL DEFAULT 0
    );

    DECLARE @Identificador INT;
    DECLARE @Desc_Hombres INT = 0;
    DECLARE @Desc_Mujeres INT = 0;
    DECLARE @Total INT = 0;
    
    DECLARE @ContadorIdiomas INT = 1;

    DECLARE @ContadorCompetencia INT = 1;

    IF @Final = 'FINAL'
    BEGIN
        INSERT INTO @PGIAlumnosAtendidos(PGI, Idioma)
        SELECT Desc_PGI, Desc_Idioma 
        FROM DFLE_Idiomas
        WHERE Desc_PGI != ' ';

        INSERT INTO @Identificadores(PGI, Idioma)
        SELECT Desc_PGI, Desc_Idioma 
        FROM DFLE_Idiomas
        WHERE Desc_PGI != ' ';

        WHILE @ContadorIdiomas <= (SELECT COUNT(*) FROM DFLE_Idiomas)
        BEGIN
            SET @ContadorCompetencia = 1;
            WHILE @ContadorCompetencia <= (SELECT COUNT(*) 
                                            FROM DFLE_NivelesCompetenciaPGI)
            BEGIN
                SET @Desc_Hombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @SiglasUnidadAcademica)
                                    AND id_Idioma = @ContadorIdiomas
                                    AND id_CompetenciaPGI = @ContadorCompetencia
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio
                                                    WHERE Desc_Anio = @anio)), 0);

                SET @Desc_Mujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @SiglasUnidadAcademica)
                                    AND id_Idioma = @ContadorIdiomas
                                    AND id_CompetenciaPGI = @ContadorCompetencia
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio
                                                    WHERE Desc_Anio = @anio)), 0);

                SET @Identificador = ISNULL((SELECT ID_AlumnosLenguasPGI
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @SiglasUnidadAcademica)
                                    AND id_Idioma = @ContadorIdiomas
                                    AND id_CompetenciaPGI = @ContadorCompetencia
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio
                                                    WHERE Desc_Anio = @anio)), 0);

                SET @Total = @Desc_Hombres + @Desc_Mujeres;

                IF @ContadorCompetencia = 1
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        IntroductorioH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        IntroductorioM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        IntroductorioT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);


                    UPDATE @Identificadores
                    SET
                        IdentificadorIntroductorio = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 2
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        BasicoH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        BasicoM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        BasicoT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorBasico = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 3
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        IntermedioH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        IntermedioM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        IntermedioT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorIntermedio = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 4
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        AvanzadoH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        AvanzadoM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        AvanzadoT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorAvanzado = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 5
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        SuperiorH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        SuperiorM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        SuperiorT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorSuperior = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                SET @ContadorCompetencia = @ContadorCompetencia + 1;
            END

        SET @ContadorIdiomas = @ContadorIdiomas + 1;
        END
    END
    ELSE
    BEGIN
        INSERT INTO @PGIAlumnosAtendidos(PGI, Idioma)
        SELECT Desc_PGI, Desc_Idioma 
        FROM DFLE_Idiomas
        WHERE Desc_PGI != ' ';

        INSERT INTO @Identificadores(PGI, Idioma)
        SELECT Desc_PGI, Desc_Idioma 
        FROM DFLE_Idiomas
        WHERE Desc_PGI != ' ';

        WHILE @ContadorIdiomas <= (SELECT COUNT(*) FROM DFLE_Idiomas)
        BEGIN
            SET @ContadorCompetencia = 1;
            WHILE @ContadorCompetencia <= (SELECT COUNT(*) 
                                            FROM DFLE_NivelesCompetenciaPGI)
            BEGIN
                SET @Desc_Hombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                    FROM DFLE_AlumnosLenguasPGI_Temporal
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @SiglasUnidadAcademica)
                                    AND id_Idioma = @ContadorIdiomas
                                    AND id_CompetenciaPGI = @ContadorCompetencia
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio
                                                    WHERE Desc_Anio = @anio)), 0);

                SET @Desc_Mujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                    FROM DFLE_AlumnosLenguasPGI_Temporal
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @SiglasUnidadAcademica)
                                    AND id_Idioma = @ContadorIdiomas
                                    AND id_CompetenciaPGI = @ContadorCompetencia
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio
                                                    WHERE Desc_Anio = @anio)), 0);

                SET @Identificador = ISNULL((SELECT ID_AlumnosLenguasPGI
                                    FROM DFLE_AlumnosLenguasPGI_Temporal
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @SiglasUnidadAcademica)
                                    AND id_Idioma = @ContadorIdiomas
                                    AND id_CompetenciaPGI = @ContadorCompetencia
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio
                                                    WHERE Desc_Anio = @anio)), 0);

                SET @Total = @Desc_Hombres + @Desc_Mujeres;

                IF @ContadorCompetencia = 1
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        IntroductorioH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        IntroductorioM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        IntroductorioT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);


                    UPDATE @Identificadores
                    SET
                        IdentificadorIntroductorio = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 2
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        BasicoH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        BasicoM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        BasicoT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorBasico = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 3
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        IntermedioH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        IntermedioM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        IntermedioT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorIntermedio = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 4
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        AvanzadoH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        AvanzadoM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        AvanzadoT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorAvanzado = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                ELSE IF @ContadorCompetencia = 5
                BEGIN
                    UPDATE @PGIAlumnosAtendidos
                    SET
                        SuperiorH = CASE WHEN @Desc_Hombres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Hombres AS VARCHAR(10))
                                    END,
                        SuperiorM = CASE WHEN @Desc_Mujeres = 0
                                    THEN ' '
                                    ELSE CAST(@Desc_Mujeres AS VARCHAR(10))
                                    END,
                        SuperiorT = CAST(@Total AS VARCHAR(10))
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);

                    UPDATE @Identificadores
                    SET
                        IdentificadorSuperior = @Identificador
                    WHERE Idioma = (SELECT Desc_Idioma 
                                    FROM DFLE_Idiomas
                                    WHERE ID_Idioma = @ContadorIdiomas);
                END
                SET @ContadorCompetencia = @ContadorCompetencia + 1;
            END

        SET @ContadorIdiomas = @ContadorIdiomas + 1;
        END
    END

    SELECT * FROM @PGIAlumnosAtendidos
    SELECT * FROM @Identificadores
END