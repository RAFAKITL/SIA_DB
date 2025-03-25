-- Numero de Formato: 15 Usuarios atendidos Programa General
CREATE PROCEDURE DFLE_UsuariosAtendidosProgGen
    @SiglasTipoUnidadAcademica VARCHAR(255),
    @SiglasTipoRama VARCHAR(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UsuariosAtendidosUnidad TABLE(
        UnidadAcademica VARCHAR(255),
       
        PGIIH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIIM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIIT INT NOT NULL DEFAULT 0,

        PGIAH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIAM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIAT INT NOT NULL DEFAULT 0,

        PGIJH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIJM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIJT INT NOT NULL DEFAULT 0,

        PGIKH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIKM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIKT INT NOT NULL DEFAULT 0,

        PGIPH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIPM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIPT INT NOT NULL DEFAULT 0,
        
        PGILSMH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGILSMM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGILSMT INT NOT NULL DEFAULT 0,

        PGIFH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIFM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIFT INT NOT NULL DEFAULT 0,

        PGIEH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIEM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIET INT NOT NULL DEFAULT 0,

        PGICH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGICM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGICT INT NOT NULL DEFAULT 0,

        PGIHH VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIHM VARCHAR(10) NOT NULL DEFAULT ' ',
        PGIHT INT NOT NULL DEFAULT 0,

        PobAtendidaH INT NOT NULL DEFAULT 0,
        PobAtendidaM INT NOT NULL DEFAULT 0,
        PobAtendidaT INT NOT NULL DEFAULT 0
    );

    DECLARE @PGI TABLE(
        ID_PGI INT IDENTITY(1, 1),
        PGI_Idioma VARCHAR(255) NOT NULL DEFAULT ''
    );

    INSERT INTO @PGI (PGI_Idioma)
    VALUES ('INGLÉS'),
            ('ALEMÁN'),
            ('JAPONÉS'),
            ('COREANO'),
            ('PORTUGUÉS'),
            ('SEÑAS MEXICANAS'),
            ('FRANCÉS'),
            ('ESPAÑOL'),
            ('CHINO-MANDARÍN'),
            ('HINDI');

    DECLARE @UnidadesAcademicas TABLE(
        ID_UnidadesAcademicas INT IDENTITY(1, 1),
        SiglasUnidad VARCHAR(255)
    );

    INSERT INTO @UnidadesAcademicas (
        SiglasUnidad
    ) SELECT Siglas 
        FROM UnidadesAcademicas
        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                        FROM TipoUnidadAcademica
                                        WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica)
        AND id_RamaConocimiento = (SELECT ID_RamaConocimiento 
                                    FROM RamaConocimiento
                                    WHERE Desc_SiglasRama = @SiglasTipoRama);

    DECLARE @Desc_Hombres INT = 0;
    DECLARE @Desc_Mujeres INT = 0;
    DECLARE @Total INT = 0;

    DECLARE @TotalHombres INT = 0;
    DECLARE @TotalMujeres INT = 0;

    DECLARE @SiglasActual VARCHAR(255);
    DECLARE @IdiomaActual VARCHAR(255);

    DECLARE @ContadorUA INT = 1;
    WHILE @ContadorUA <= (SELECT COUNT(*) FROM @UnidadesAcademicas)
    BEGIN
        SET @SiglasActual = (SELECT SiglasUnidad
                            FROM @UnidadesAcademicas
                            WHERE ID_UnidadesAcademicas = @ContadorUA);

        INSERT INTO @UsuariosAtendidosUnidad(
            UnidadAcademica
        ) VALUES (
            @SiglasActual
        );

        DECLARE @ContadorIdioma INT = 1;
        WHILE @ContadorIdioma <= (SELECT COUNT(*) 
                                FROM DFLE_Idiomas
                                WHERE Desc_PGI <> '')
        BEGIN
            SET @IdiomaActual = (SELECT PGI_Idioma 
                                FROM @PGI
                                WHERE ID_PGI = @ContadorIdioma);

            SET @Desc_Hombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                FROM DFLE_AlumnosLenguasPGI
                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                            FROM UnidadesAcademicas
                                                            WHERE Siglas = @SiglasActual)
                                AND id_Idioma = (SELECT ID_Idioma
                                                FROM DFLE_Idiomas
                                                WHERE Desc_Idioma = @IdiomaActual)
                                AND id_Trimestre = @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);

            SET @Desc_Mujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                FROM DFLE_AlumnosLenguasPGI
                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                            FROM UnidadesAcademicas
                                                            WHERE Siglas = @SiglasActual)
                                AND id_Idioma = (SELECT ID_Idioma
                                                FROM DFLE_Idiomas
                                                WHERE Desc_Idioma = @IdiomaActual)
                                AND id_Trimestre = @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);
            SET @Total = @Desc_Hombres + @Desc_Mujeres;
            SET @TotalHombres = @TotalHombres + @Desc_Hombres;
            SET @TotalMujeres = @TotalMujeres + @Desc_Mujeres;

            IF @ContadorIdioma = 1
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIIH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIIM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIIT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 2
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIAH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIAM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIAT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 3
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIJH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIJM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIJT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 4
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIKH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIKM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIKT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 5
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIPH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIPM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIPT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 6
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGILSMH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGILSMM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGILSMT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 7
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIFH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIFM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIFT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 8
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIEH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIEM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIET = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 9
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGICH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGICM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGICT = @Total
                WHERE UnidadAcademica = @SiglasActual
            END
            ELSE IF @ContadorIdioma = 10
            BEGIN
                UPDATE @UsuariosAtendidosUnidad
                SET PGIHH = CASE WHEN @Desc_Hombres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Hombres AS VARCHAR(10))
                            END,
                    PGIHM = CASE WHEN @Desc_Mujeres = 0 THEN
                                ' '
                            ELSE
                                CAST(@Desc_Mujeres AS VARCHAR(10))
                            END,
                    PGIHT = @Total,
                    PobAtendidaH = @TotalHombres,
                    PobAtendidaM = @TotalMujeres,
                    PobAtendidaT = @TotalHombres + @TotalMujeres
                WHERE UnidadAcademica = @SiglasActual
            END

            SET @ContadorIdioma = @ContadorIdioma + 1;
        END

        SET @TotalHombres = 0;
        SET @TotalMujeres = 0;

        SET @ContadorUA = @ContadorUA + 1;
    END

    SELECT * FROM @UsuariosAtendidosUnidad
END
