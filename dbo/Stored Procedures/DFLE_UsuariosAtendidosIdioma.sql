-- Numero de Formato: 14 Usuarios atendidos por idioma
CREATE PROCEDURE DFLE_UsuariosAtendidosIdioma
    @SiglasTipoUnidadAcademica VARCHAR(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @UsuariosAtendidosUnidad TABLE(
        UnidadAcademica VARCHAR(255),

        InglesH VARCHAR(255) NOT NULL DEFAULT ' ',
        InglesM VARCHAR(255) NOT NULL DEFAULT ' ',
        FrancesH VARCHAR(255) NOT NULL DEFAULT ' ',
        FrancesM VARCHAR(255) NOT NULL DEFAULT ' ',
        AlemanH VARCHAR(255) NOT NULL DEFAULT ' ',
        AlemanM VARCHAR(255) NOT NULL DEFAULT ' ',
        ItalianoH VARCHAR(255) NOT NULL DEFAULT ' ',
        ItalianoM VARCHAR(255) NOT NULL DEFAULT ' ',
        JaponesH VARCHAR(255) NOT NULL DEFAULT ' ',
        JaponesM VARCHAR(255) NOT NULL DEFAULT ' ',
        ChinoH VARCHAR(255) NOT NULL DEFAULT ' ',
        ChinoM VARCHAR(255) NOT NULL DEFAULT ' ',
        PortuguesH VARCHAR(255) NOT NULL DEFAULT ' ',
        PortuguesM VARCHAR(255) NOT NULL DEFAULT ' ',
        RusoH VARCHAR(255) NOT NULL DEFAULT ' ',
        RusoM VARCHAR(255) NOT NULL DEFAULT ' ',
        NahuatlH VARCHAR(255) NOT NULL DEFAULT ' ',
        NahuatlM VARCHAR(255) NOT NULL DEFAULT ' ',
        EspanolH VARCHAR(255) NOT NULL DEFAULT ' ',
        EspanolM VARCHAR(255) NOT NULL DEFAULT ' ',
        SenasH VARCHAR(255) NOT NULL DEFAULT ' ',
        SenasM VARCHAR(255) NOT NULL DEFAULT ' ',
        CoreanoH VARCHAR(255) NOT NULL DEFAULT ' ',
        CoreanoM VARCHAR(255) NOT NULL DEFAULT ' ',
        HindiH VARCHAR(255) NOT NULL DEFAULT ' ',
        HindiM VARCHAR(255) NOT NULL DEFAULT ' ',

        Total INT DEFAULT 0
    );
    INSERT INTO @UsuariosAtendidosUnidad(UnidadAcademica)
    SELECT Siglas 
    FROM UnidadesAcademicas
    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica);
  
    DECLARE @InglesH INT = 0;
    DECLARE @InglesM INT = 0;
    DECLARE @FrancesH INT = 0;
    DECLARE @FrancesM INT = 0;
    DECLARE @AlemanH INT = 0;
    DECLARE @AlemanM INT = 0;
    DECLARE @ItalianoH INT = 0; 
    DECLARE @ItalianoM INT = 0;
    DECLARE @JaponesH INT = 0; 
    DECLARE @JaponesM INT = 0;
    DECLARE @ChinoH INT = 0;
    DECLARE @ChinoM INT = 0; 
    DECLARE @PortuguesH INT = 0;
    DECLARE @PortuguesM INT = 0;
    DECLARE @RusoH INT =0;
    DECLARE @RusoM INT =0;
    DECLARE @NahuatlH INT = 0;
    DECLARE @NahuatlM INT =0; 
    DECLARE @EspanolH INT =0;
    DECLARE @EspanolM INT =0;
    DECLARE @SenasH INT =0;
    DECLARE @SenasM INT =0;
    DECLARE @CoreanoH INT =0;
    DECLARE @CoreanoM INT =0;
    DECLARE @HindiH INT =0;
    DECLARE @HindiM INT =0;

    DECLARE @UnidadesAcademicas TABLE(
        Id_UnidadAcademica INT IDENTITY(1,1),
        SiglasUnidadAcademica VARCHAR(255)
    );
    INSERT INTO @UnidadesAcademicas
    SELECT Siglas
    FROM UnidadesAcademicas
    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica);
    
    DECLARE @NumUA INT  = (SELECT COUNT(*) 
                            FROM UnidadesAcademicas 
                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                            FROM TipoUnidadAcademica 
                                                            WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica));
    DECLARE @ContadorUA INT = 1;

    WHILE @ContadorUA <= @NumUA
    BEGIN
        SET @InglesH = ISNULL((SELECT SUM(Desc_Hombres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT ID_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'INGLÉS')), 0);
        SET @InglesM = ISNULL((SELECT SUM(Desc_Mujeres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT ID_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT ID_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'INGLÉS')), 0);

        SET @FrancesH = ISNULL((SELECT SUM(Desc_Hombres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'FRANCÉS')), 0);
        SET @FrancesM = ISNULL((SELECT SUM(Desc_Mujeres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'FRANCÉS')), 0);

        SET @AlemanH = ISNULL((SELECT SUM(Desc_Hombres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'ALEMÁN')), 0);
        SET @AlemanM = ISNULL((SELECT SUM(Desc_Mujeres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'ALEMÁN')), 0);    
 
        SET @ItalianoH = ISNULL((SELECT SUM(Desc_Hombres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'ITALIANO')), 0);        
        SET @ItalianoM = ISNULL((SELECT SUM(Desc_Mujeres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'ITALIANO')), 0);     

        SET @JaponesH = ISNULL((SELECT SUM(Desc_Hombres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'JAPONÉS')), 0); 
        SET @JaponesM = ISNULL((SELECT SUM(Desc_Mujeres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'JAPONÉS')), 0); 

        SET @ChinoH = ISNULL((SELECT SUM(Desc_Hombres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'CHINO-MANDARÍN')), 0); 

        SET @ChinoH = ISNULL((SELECT SUM(Desc_Mujeres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'CHINO-MANDARÍN')), 0); 
        SET @PortuguesH = ISNULL((SELECT SUM(Desc_Hombres)
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'PORTUGUÉS')), 0);

        SET @PortuguesM = ISNULL((SELECT SUM(Desc_Mujeres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'PORTUGUÉS')), 0);
                                                                                                                                        
        SET @RusoH = ISNULL((SELECT SUM(Desc_Hombres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'RUSO')), 0);

        SET @RusoM = ISNULL((SELECT SUM(Desc_Mujeres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'RUSO')), 0);

        SET @NahuatlH =  ISNULL((SELECT SUM(Desc_Hombres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'NAHUATL')), 0);

        SET @NahuatlM = ISNULL((SELECT SUM(Desc_Mujeres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'NAHUATL')), 0);

        SET @EspanolH = ISNULL((SELECT SUM(Desc_Hombres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'ESPAÑOL')), 0);

        SET @EspanolM = ISNULL((SELECT SUM(Desc_Mujeres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'ESPAÑOL')), 0);

        SET @SenasH = ISNULL((SELECT SUM(Desc_Hombres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'SEÑAS')), 0);                                                                 
                                                                                                                                                                                                                                                                        
        SET @SenasM = ISNULL((SELECT SUM(Desc_Mujeres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'SEÑAS MEXICANAS')), 0);

        SET @CoreanoH = ISNULL((SELECT SUM(Desc_Hombres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'COREANO')), 0);

        SET @CoreanoM = ISNULL((SELECT SUM(Desc_Mujeres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'COREANO')), 0);  

        SET @HindiH = ISNULL((SELECT SUM(Desc_Hombres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'HINDI')), 0);      

        SET @HindiM = ISNULL((SELECT SUM(Desc_Mujeres) 
                             FROM DFLE_AlumnosEnsenanzaLenguas
                             WHERE Id_UnidadAcademica = (SELECT Id_UnidadAcademica
                                                         FROM UnidadesAcademicas
                                                         WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                                         FROM @UnidadesAcademicas
                                                                         WHERE Id_UnidadAcademica = @ContadorUA))
                                                         AND Id_Trimestre = @id_Trimestre
                                                         AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                         AND id_Idioma = (SELECT Id_Idioma
                                                                         FROM DFLE_Idiomas
                                                                         WHERE Desc_Idioma = 'HINDI')), 0);

        UPDATE @UsuariosAtendidosUnidad
        SET InglesH =  CASE WHEN @InglesH = 0 
            THEN ' ' 
            ELSE CAST(@InglesH AS VARCHAR(255)) 
            END,
            InglesM = CASE WHEN @InglesM = 0 
            THEN ' ' 
            ELSE CAST(@InglesM AS VARCHAR(255)) 
            END,
            FrancesH = CASE WHEN @FrancesH = 0 
            THEN ' ' 
            ELSE CAST(@FrancesH AS VARCHAR(255)) 
            END,
            FrancesM = CASE WHEN @FrancesM = 0 
            THEN ' ' 
            ELSE CAST(@FrancesM AS VARCHAR(255)) 
            END,
            AlemanH = CASE WHEN @AlemanH = 0 
            THEN ' ' 
            ELSE CAST(@AlemanH AS VARCHAR(255)) 
            END,
            AlemanM = CASE WHEN @AlemanM = 0 
            THEN ' ' 
            ELSE CAST(@AlemanM AS VARCHAR(255)) 
            END,
            ItalianoH =  CASE WHEN @ItalianoH = 0 
            THEN ' ' 
            ELSE CAST(@ItalianoH AS VARCHAR(255)) 
            END,
            
            ItalianoM = CASE WHEN @ItalianoM = 0 
            THEN ' ' 
            ELSE CAST(@ItalianoM AS VARCHAR(255)) 
            END,
            
            JaponesH = CASE WHEN @JaponesH = 0 
            THEN ' ' 
            ELSE CAST(@JaponesH AS VARCHAR(255)) 
            END,
            
            JaponesM = CASE WHEN @JaponesM = 0 
            THEN ' ' 
            ELSE CAST(@JaponesM AS VARCHAR(255)) 
            END,
            ChinoH =  CASE WHEN @ChinoH = 0 
            THEN ' ' 
            ELSE CAST(@ChinoH AS VARCHAR(255)) 
            END,
            ChinoM = CASE WHEN @ChinoM = 0 
            THEN ' ' 
            ELSE CAST(@ChinoM AS VARCHAR(255)) 
            END,
            PortuguesH = CASE WHEN @PortuguesH = 0 
            THEN ' ' 
            ELSE CAST(@PortuguesH AS VARCHAR(255)) 
            END,
            PortuguesM = CASE WHEN @PortuguesM = 0 
            THEN ' ' 
            ELSE CAST(@PortuguesM AS VARCHAR(255)) 
            END,
            RusoH =  CASE WHEN @RusoH = 0 
            THEN ' ' 
            ELSE CAST(@RusoH AS VARCHAR(255)) 
            END,
            RusoM = CASE WHEN @RusoM = 0 
            THEN ' ' 
            ELSE CAST(@RusoM AS VARCHAR(255)) 
            END,
            NahuatlH = CASE WHEN @NahuatlH = 0 
            THEN ' ' 
            ELSE CAST(@NahuatlH AS VARCHAR(255)) 
            END,
            NahuatlM = CASE WHEN @NahuatlM = 0 
            THEN ' ' 
            ELSE CAST(@NahuatlM AS VARCHAR(255)) 
            END,
            EspanolH = CASE WHEN @EspanolH = 0 
            THEN ' ' 
            ELSE CAST(@EspanolH AS VARCHAR(255)) 
            END,
            EspanolM = CASE WHEN @EspanolM = 0 
            THEN ' ' 
            ELSE CAST(@EspanolM AS VARCHAR(255)) 
            END,
            SenasH = CASE WHEN @SenasH = 0 
            THEN ' ' 
            ELSE CAST(@SenasH AS VARCHAR(255)) 
            END,
            SenasM = CASE WHEN @SenasM = 0 
            THEN ' ' 
            ELSE CAST(@SenasM AS VARCHAR(255)) 
            END,
            CoreanoH = CASE WHEN @CoreanoH = 0 
            THEN ' ' 
            ELSE CAST(@CoreanoH AS VARCHAR(255)) 
            END,
            CoreanoM = CASE WHEN @CoreanoM = 0 
            THEN ' ' 
            ELSE CAST(@CoreanoM AS VARCHAR(255)) 
            END,
            HindiH = CASE WHEN @HindiH = 0 
            THEN ' ' 
            ELSE CAST(@HindiH AS VARCHAR(255)) 
            END,
            HindiM = CASE WHEN @HindiM = 0 
            THEN ' ' 
            ELSE CAST(@HindiM AS VARCHAR(255)) 
            END,
            Total = @InglesH + @InglesM + @FrancesH + @FrancesM + @AlemanH + @AlemanM 
            + @ItalianoH + @ItalianoM + @JaponesH + @JaponesM + @ChinoH + @ChinoM 
            + @PortuguesH + @PortuguesM + @RusoH + @RusoM + @NahuatlH + @NahuatlM 
            + @EspanolH + @EspanolM + @SenasH + @SenasM + @CoreanoH + @CoreanoM + @HindiH + @HindiM
        WHERE UnidadAcademica = (SELECT Siglas
                                 FROM UnidadesAcademicas
                                 WHERE Siglas = (SELECT SiglasUnidadAcademica
                                                 FROM @UnidadesAcademicas
                                                 WHERE Id_UnidadAcademica = @ContadorUA));
                                                                                                                                                                                              
        SET @ContadorUA = @ContadorUA + 1;
    END
    
    SELECT * FROM @UsuariosAtendidosUnidad;
END
