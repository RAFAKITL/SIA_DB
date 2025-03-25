--Formato 10: Enseñanza de lenguas Unidades Académicas
CREATE PROCEDURE DFLE_EnsenanzaLenguasUA
    @SiglasUnidadAcademica VARCHAR(255),
    @Competencia VARCHAR(255),
    @anio INT,
    @id_Trimestre INT,
    @Total varchar(15)
AS 
BEGIN
    SET NOCOUNT ON;
    DECLARE @Idiomas TABLE (
        Idioma VARCHAR(255),
        ID_Idioma INT IDENTITY (1,1)
    );
    INSERT INTO @Idiomas (
        Idioma
        )SELECT 
            Desc_Idioma
        FROM
            DFLE_Idiomas
    
    DECLARE @contadorIdioma INT = 1;

    DECLARE @PoblacionAtendida TABLE (
        Idioma VARCHAR(255),
        NMSHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        NMSMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        NMSTotal VARCHAR(255) NOT NULL DEFAULT '0',

        NSHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        NSMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        NSTotal VARCHAR(255) NOT NULL DEFAULT '0',
        
        POSHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        POSMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        POSTotal VARCHAR(255) NOT NULL DEFAULT '0',
        
        EGHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        EGMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        EGTotal VARCHAR(255) NOT NULL DEFAULT '0',
        
        EIHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        EIMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        EITotal VARCHAR(255) NOT NULL DEFAULT '0',
        
        SUBHombres VARCHAR(255) NOT NULL DEFAULT '0',
        SUBMujeres VARCHAR(255) NOT NULL DEFAULT '0',
        SUBTotal VARCHAR(255) NOT NULL DEFAULT '0',
        
        PGHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        PGMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        PGTotal VARCHAR(255) NOT NULL DEFAULT '0',
        
        PAHombres VARCHAR(255) NOT NULL DEFAULT '0',
        PAMujeres VARCHAR(255) NOT NULL DEFAULT '0',
        PATotal VARCHAR(255) NOT NULL DEFAULT '0'
    );
    
    DECLARE @NMSHombres INT;
    DECLARE @NMSMujeres INT;
    DECLARE @NSHombres INT;
    DECLARE @NSMujeres INT;
    DECLARE @POSHombres INT;
    DECLARE @POSMujeres INT;
    DECLARE @EGHombres INT;
    DECLARE @EGMujeres INT;
    DECLARE @EIHombres INT;
    DECLARE @EIMujeres INT;
    DECLARE @PGHombres INT;
    DECLARE @PGMujeres INT;




    WHILE @contadorIdioma <= (SELECT COUNT(*) FROM @Idiomas)  
    BEGIN
        IF @Total = 'NO TOTAL'
        BEGIN
            SET @NMSHombres = ISNULL((SELECT Desc_Hombres 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'MEDIO SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);
            
            SET @NMSMujeres = ISNULL((SELECT Desc_Mujeres
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'MEDIO SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);

            SET @NSHombres = ISNULL((SELECT Desc_Hombres 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @NSMujeres = ISNULL((SELECT Desc_Mujeres 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @POSHombres = ISNULL((SELECT Desc_Hombres 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'POSGRADO')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);
            SET @POSMujeres  = ISNULL((SELECT Desc_Mujeres
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'POSGRADO')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EGHombres  = ISNULL((SELECT Desc_Hombres 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EGRESADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EGMujeres  = ISNULL((SELECT Desc_Mujeres
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EGRESADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EIHombres  = ISNULL((SELECT Desc_Hombres 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EMPLEADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EIMujeres  = ISNULL((SELECT Desc_Mujeres
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EMPLEADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            
            SET @PGHombres  = ISNULL((SELECT Desc_Hombres 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'No aplica')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @PGMujeres  =ISNULL( (SELECT Desc_Mujeres
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'No aplica')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Competencia = (SELECT ID_Competencia 
                                                            FROM DFLE_NivelesCompetencia 
                                                            WHERE Desc_NivelCompetencia = @Competencia) 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

        END
        ELSE
        BEGIN
            SET @NMSHombres  = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'MEDIO SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);
            
            SET @NMSMujeres  = ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'MEDIO SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);

            SET @NSHombres  = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @NSMujeres  = ISNULL((SELECT SUM(Desc_Mujeres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'SUPERIOR')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @POSHombres  = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'POSGRADO')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);
            SET @POSMujeres  = ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'POSGRADO')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EGHombres  = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EGRESADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EGMujeres  = ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EGRESADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EIHombres  = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EMPLEADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @EIMujeres  = ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'EMPLEADOS')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            
            SET @PGHombres  = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'No aplica')

                                        AND id_Idioma = @contadorIdioma 
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);

            SET @PGMujeres  =ISNULL( (SELECT SUM(Desc_Mujeres)
                                        FROM DFLE_AlumnosEnsenanzaLenguas 
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas
                                                                    WHERE Siglas = @SiglasUnidadAcademica) 
                                        AND id_NivelEducativo = (SELECT ID_NivelEducativo FROM DFLE_NivelEducativo 
                                                                WHERE Desc_NivelEducativo = 'No aplica')

                                        AND id_Idioma = @contadorIdioma  
                                        AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio 
                                                    WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre),0);
        END;

        INSERT INTO @PoblacionAtendida (
            NMSHombres,
            NMSMujeres,
            NMSTotal,
            NSHombres,
            NSMujeres,
            NSTotal,
            POSHombres,
            POSMujeres,
            POSTotal,
            EGHombres,
            EGMujeres,
            EGTotal,
            EIHombres,
            EIMujeres,
            EITotal,
            SUBHombres,
            SUBMujeres,
            SUBTotal,
            PGHombres,
            PGMujeres,
            PGTotal,
            PAHombres,
            PAMujeres,
            PATotal,
            Idioma
        )VALUES(
            
            CASE WHEN @NMSHombres = 0 
            THEN ' ' 
            ELSE CAST(@NMSHombres AS VARCHAR(255)) 
            END,
           
            CASE WHEN @NMSMujeres = 0 
            THEN ' ' 
            ELSE CAST(@NMSMujeres AS VARCHAR(255)) 
            END,
            @NMSHombres + @NMSMujeres,

            CASE WHEN @NSHombres = 0 
            THEN ' ' 
            ELSE CAST(@NSHombres AS VARCHAR(255)) 
            END,
            CASE WHEN @NSMujeres = 0 
            THEN ' ' 
            ELSE CAST(@NSMujeres AS VARCHAR(255)) 
            END,
            @NSHombres + @NSMujeres,

            CASE WHEN @POSHombres = 0 
            THEN ' ' 
            ELSE CAST(@POSHombres AS VARCHAR(255)) 
            END,
            CASE WHEN @POSMujeres = 0 
            THEN ' ' 
            ELSE CAST(@POSMujeres AS VARCHAR(255)) 
            END,
            @POSHombres + @POSMujeres,

            CASE WHEN @EGHombres = 0 
            THEN ' ' 
            ELSE CAST(@EGHombres AS VARCHAR(255)) 
            END,
            CASE WHEN @EGMujeres = 0 
            THEN ' ' 
            ELSE CAST(@EGMujeres AS VARCHAR(255)) 
            END,
            @EGHombres + @EGMujeres,

            CASE WHEN @EIHombres = 0 
            THEN ' ' 
            ELSE CAST(@EIHombres AS VARCHAR(255)) 
            END,
           
            CASE WHEN @EIMujeres = 0 
            THEN ' ' 
            ELSE CAST(@EIMujeres AS VARCHAR(255)) 
            END,
            @EIHombres + @EIMujeres,


            @NMSHombres + @NSHombres + @POSHombres + @EGHombres + @EIHombres,
            @NMSMujeres + @NSMujeres + @POSMujeres + @EGMujeres + @EIMujeres,
            @NMSHombres + @NSHombres + @POSHombres + @EGHombres + @EIHombres + @NMSMujeres + @NSMujeres + @POSMujeres + @EGMujeres + @EIMujeres,

            CASE WHEN @PGHombres = 0 
            THEN ' ' 
            ELSE CAST(@PGHombres AS VARCHAR(255)) 
            END,
            CASE WHEN @PGMujeres = 0 
            THEN ' ' 
            ELSE CAST(@PGMujeres AS VARCHAR(255)) 
            END,
            @PGHombres + @PGMujeres,

            @NMSHombres + @NSHombres + @POSHombres + @EGHombres + @EIHombres + @PGHombres,
            @NMSMujeres + @NSMujeres + @POSMujeres + @EGMujeres + @EIMujeres + @PGMujeres,

            @NMSHombres + @NSHombres + @POSHombres + @EGHombres + @EIHombres + @PGHombres + @NMSMujeres + @NSMujeres + @POSMujeres + @EGMujeres + @EIMujeres + @PGMujeres,
            (SELECT Idioma FROM @Idiomas WHERE ID_Idioma = @contadorIdioma)
        )
        SET @contadorIdioma = @contadorIdioma + 1;
    END
    SELECT * FROM @PoblacionAtendida
END

        
        
