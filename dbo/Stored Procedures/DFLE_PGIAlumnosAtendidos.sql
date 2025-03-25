--Numero de Formato: 13 Usuarios atendidos en enseñanza de lenguas extranjeras. Programa General Institucional
CREATE PROCEDURE DFLE_PGIAlumnosAtendidos
    @SiglasUnidadAcademica varchar(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @PGIAlumnosAtendidos TABLE(
        PGI VARCHAR(10) NOT NULL DEFAULT '',
        Idioma VARCHAR(255) NOT NULL DEFAULT '',

        IntroductorioH VARCHAR(255) NOT NULL DEFAULT ' ',
        IntroductorioM VARCHAR(255) NOT NULL DEFAULT ' ',
        IntroductorioT VARCHAR(255) NOT NULL DEFAULT ' ',
        BasicoH VARCHAR(255) NOT NULL DEFAULT ' ',
        BasicoM VARCHAR(255) NOT NULL DEFAULT ' ',
        BasicoT VARCHAR(255) NOT NULL DEFAULT ' ',
        IntermedioH VARCHAR(255) NOT NULL DEFAULT ' ',
        IntermedioM VARCHAR(255) NOT NULL DEFAULT ' ',
        IntermedioT VARCHAR(255) NOT NULL DEFAULT ' ',
        AvanzadoH VARCHAR(255) NOT NULL DEFAULT ' ',
        AvanzadoM VARCHAR(255) NOT NULL DEFAULT ' ',
        AvanzadoT VARCHAR(255) NOT NULL DEFAULT ' ',
        SuperiorH VARCHAR(255) NOT NULL DEFAULT ' ',
        SuperiorM VARCHAR(255) NOT NULL DEFAULT ' ',
        SuperiorT VARCHAR(255) NOT NULL DEFAULT ' ',

        PobAtendidaH VARCHAR(255) NOT NULL DEFAULT ' ',
        PobAtendidaM VARCHAR(255) NOT NULL DEFAULT ' ',

        Total VARCHAR(255) NOT NULL DEFAULT ' '
    );

    INSERT INTO @PGIAlumnosAtendidos(PGI, Idioma)
    SELECT Desc_PGI, Desc_Idioma 
    FROM DFLE_Idiomas
    WHERE Desc_PGI != ' ';

    DECLARE @Desc_Hombres INT = 0;
    DECLARE @Desc_Mujeres INT = 0;
    DECLARE @Total INT = 0;

    DECLARE @PA_Hombres INT = 0;
    DECLARE @PA_Mujeres INT = 0;

    DECLARE @Total_global INT = 0;
    
    DECLARE @ContadorIdiomas INT = 1;
    WHILE @ContadorIdiomas <= (SELECT COUNT(*) FROM DFLE_Idiomas)
    BEGIN

        DECLARE @ContadorCompetencia INT = 1;
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

            SET @Total = @Desc_Hombres + @Desc_Mujeres;
            SET @PA_Hombres = @PA_Hombres + @Desc_Hombres;
            SET @PA_Mujeres = @PA_Mujeres + @Desc_Mujeres;

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
                                WHERE ID_Idioma = @ContadorIdiomas)
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
                                WHERE ID_Idioma = @ContadorIdiomas)
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
                                WHERE ID_Idioma = @ContadorIdiomas)
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
                                WHERE ID_Idioma = @ContadorIdiomas)
            END
            ELSE IF @ContadorCompetencia = 5
            BEGIN
                SET @Total_global = @PA_Hombres + @PA_Mujeres;
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
                    SuperiorT = CAST(@Total AS VARCHAR(10)),
                    PobAtendidaH = CAST(@PA_Hombres AS VARCHAR(10)),
                    PobAtendidaM = CAST(@PA_Mujeres AS VARCHAR(10)),
                    Total = CAST(@Total_global AS VARCHAR(10))
                WHERE Idioma = (SELECT Desc_Idioma 
                                FROM DFLE_Idiomas
                                WHERE ID_Idioma = @ContadorIdiomas)
            END
            
            SET @ContadorCompetencia = @ContadorCompetencia + 1;
        END

        SET @PA_Hombres = 0;
        SET @PA_Mujeres = 0;
        SET @ContadorIdiomas = @ContadorIdiomas + 1;
    END

    SELECT * FROM @PGIAlumnosAtendidos
END