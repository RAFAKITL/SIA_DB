--Formato 10: Procedimiento para retornar la informacion a la interfaz que representa el formato 10
CREATE PROCEDURE DFLE_InterEnsenanzaLenguasUA
    @TipoUnidadAcademica VARCHAR(255),
    @UnidadAcademica VARCHAR(255),
    @Anio INT,
    @id_Trimestre INT,
    @Final varchar(15)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NMS VARCHAR(255) = 'MEDIO SUPERIOR';
    DECLARE @NS VARCHAR(255) = 'SUPERIOR';
    DECLARE @PG VARCHAR(255) = 'POSTGRADO';
    DECLARE @EG VARCHAR(255) = 'EGRESADOS';
    DECLARE @EM VARCHAR(255) = 'EMPLEADOS';
    DECLARE @GEN VARCHAR(255) = 'No aplica';

    DECLARE @EnsenanzaLenguas TABLE(
    ID_Lengua INT IDENTITY (1,1),
    Lengua VARCHAR(255));
    INSERT INTO @EnsenanzaLenguas
    SELECT Desc_Idioma FROM DFLE_Idiomas;

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
        
        PGHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        PGMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        PGTotal VARCHAR(255) NOT NULL DEFAULT '0'
        
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
    DECLARE @Contador INT = 1;

    DECLARE @TablaIden TABLE( 
        Idioma VARCHAR(255),   
        Ident_NMS INT NOT NULL DEFAULT 0,
        Ident_NS INT NOT NULL DEFAULT 0,
        Ident_POS INT NOT NULL DEFAULT 0,
        Ident_EG INT NOT NULL DEFAULT 0,
        Ident_EI INT NOT NULL DEFAULT 0,
        Ident_PG INT NOT NULL DEFAULT 0
);

    DECLARE @Ident_NMS INT = 0;
    DECLARE @Ident_NS INT = 0;
    DECLARE @Ident_POS INT = 0;
    DECLARE @Ident_EG INT = 0;
    DECLARE @Ident_EI INT = 0;
    DECLARE @Ident_PG INT = 0;

    IF @Final = 'FINAL'
        BEGIN
            SET @Contador = 1;
            WHILE @Contador <= (SELECT COUNT(*) FROM @EnsenanzaLenguas) 
                BEGIN
                    SET @NMSHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NMS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @NMSMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NMS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);
            
                    SET @NSHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @NSMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @POSHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @PG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @POSMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @PG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);       


                    SET @EGHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @EGMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @EIHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EM )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @EIMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EM )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @PGHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @GEN )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @PGMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @GEN )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

            
                    INSERT INTO @PoblacionAtendida 
                    VALUES(
                    (SELECT Lengua FROM @EnsenanzaLenguas WHERE ID_Lengua = @Contador),
                    CASE WHEN @NMSHombres = 0 
                        THEN 0
                        ELSE CAST(@NMSHombres AS VARCHAR(255)) 
                        END,
                
                        CASE WHEN @NMSMujeres = 0 
                        THEN 0
                        ELSE CAST(@NMSMujeres AS VARCHAR(255)) 
                        END,
                        @NMSHombres + @NMSMujeres,

                        CASE WHEN @NSHombres = 0 
                        THEN 0
                        ELSE CAST(@NSHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @NSMujeres = 0 
                        THEN 0
                        ELSE CAST(@NSMujeres AS VARCHAR(255)) 
                        END,
                        @NSHombres + @NSMujeres,

                        CASE WHEN @POSHombres = 0 
                        THEN 0 
                        ELSE CAST(@POSHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @POSMujeres = 0 
                        THEN 0
                        ELSE CAST(@POSMujeres AS VARCHAR(255)) 
                        END,
                        @POSHombres + @POSMujeres,

                        CASE WHEN @EGHombres = 0 
                        THEN 0
                        ELSE CAST(@EGHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @EGMujeres = 0 
                        THEN 0
                        ELSE CAST(@EGMujeres AS VARCHAR(255)) 
                        END,
                        @EGHombres + @EGMujeres,

                        CASE WHEN @EIHombres = 0 
                        THEN 0
                        ELSE CAST(@EIHombres AS VARCHAR(255)) 
                        END,
                
                        CASE WHEN @EIMujeres = 0 
                        THEN 0
                        ELSE CAST(@EIMujeres AS VARCHAR(255)) 
                        END,
                        @EIHombres + @EIMujeres,
                        CASE WHEN @PGHombres = 0 
                        THEN 0 
                        ELSE CAST(@PGHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @PGMujeres = 0 
                        THEN 0
                        ELSE CAST(@PGMujeres AS VARCHAR(255)) 
                        END,
                        @PGHombres + @PGMujeres
                    )
                    SET @Contador = @Contador + 1;
                END

                INSERT INTO @TablaIden(Idioma)
                SELECT Lengua FROM @EnsenanzaLenguas;
                SET @Contador = 1;
                WHILE @Contador <= (SELECT COUNT(*) FROM @EnsenanzaLenguas)
                BEGIN
                    SET @Ident_NMS = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NMS)),0);
            
                    SET @Ident_NS = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NS)),0);
                                                
                    SET @Ident_POS = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @PG)),0);

                    SET @Ident_EG = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EG)),0);


                    SET @Ident_EI = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EM)),0);


                    SET @Ident_PG = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @GEN)),0);

                        UPDATE @TablaIden
                        SET Ident_NMS = @Ident_NMS,
                                Ident_NS = @Ident_NS,
                                Ident_POS = @Ident_POS,
                                Ident_EG = @Ident_EG,
                                Ident_EI = @Ident_EI,
                                Ident_PG = @Ident_PG
                        WHERE Idioma = (SELECT Lengua FROM @EnsenanzaLenguas WHERE ID_Lengua = @Contador);
                        SET @Contador = @Contador + 1;
                END
        END
    ELSE
        BEGIN
            SET @Contador = 1;
            WHILE @Contador <= (SELECT COUNT(*) FROM @EnsenanzaLenguas) 
                BEGIN
                    SET @NMSHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NMS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @NMSMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NMS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);
            
                    SET @NSHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @NSMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NS )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @POSHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @PG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @POSMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @PG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);       


                    SET @EGHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @EGMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EG )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @EIHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EM )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @EIMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EM )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @PGHombres = ISNULL((SELECT Desc_Hombres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @GEN )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

                    SET @PGMujeres = ISNULL((SELECT Desc_Mujeres FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                        AND id_Trimestre = @id_Trimestre
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @GEN )
                        AND id_UnidadAcademica = (SELECT id_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador), 0);

            
                    INSERT INTO @PoblacionAtendida 
                    VALUES(
                    (SELECT Lengua FROM @EnsenanzaLenguas WHERE ID_Lengua = @Contador),
                    CASE WHEN @NMSHombres = 0 
                        THEN 0
                        ELSE CAST(@NMSHombres AS VARCHAR(255)) 
                        END,
                
                        CASE WHEN @NMSMujeres = 0 
                        THEN 0
                        ELSE CAST(@NMSMujeres AS VARCHAR(255)) 
                        END,
                        @NMSHombres + @NMSMujeres,

                        CASE WHEN @NSHombres = 0 
                        THEN 0
                        ELSE CAST(@NSHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @NSMujeres = 0 
                        THEN 0
                        ELSE CAST(@NSMujeres AS VARCHAR(255)) 
                        END,
                        @NSHombres + @NSMujeres,

                        CASE WHEN @POSHombres = 0 
                        THEN 0 
                        ELSE CAST(@POSHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @POSMujeres = 0 
                        THEN 0
                        ELSE CAST(@POSMujeres AS VARCHAR(255)) 
                        END,
                        @POSHombres + @POSMujeres,

                        CASE WHEN @EGHombres = 0 
                        THEN 0
                        ELSE CAST(@EGHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @EGMujeres = 0 
                        THEN 0
                        ELSE CAST(@EGMujeres AS VARCHAR(255)) 
                        END,
                        @EGHombres + @EGMujeres,

                        CASE WHEN @EIHombres = 0 
                        THEN 0
                        ELSE CAST(@EIHombres AS VARCHAR(255)) 
                        END,
                
                        CASE WHEN @EIMujeres = 0 
                        THEN 0
                        ELSE CAST(@EIMujeres AS VARCHAR(255)) 
                        END,
                        @EIHombres + @EIMujeres,
                        CASE WHEN @PGHombres = 0 
                        THEN 0 
                        ELSE CAST(@PGHombres AS VARCHAR(255)) 
                        END,
                        CASE WHEN @PGMujeres = 0 
                        THEN 0
                        ELSE CAST(@PGMujeres AS VARCHAR(255)) 
                        END,
                        @PGHombres + @PGMujeres
                    )
                    SET @Contador = @Contador + 1;
                END

                INSERT INTO @TablaIden(Idioma)
                SELECT Lengua FROM @EnsenanzaLenguas;
                SET @Contador = 1;
                WHILE @Contador <= (SELECT COUNT(*) FROM @EnsenanzaLenguas)
                BEGIN
                    SET @Ident_NMS = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NMS)),0);
            
                    SET @Ident_NS = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @NS)),0);
                                                
                    SET @Ident_POS = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @PG)),0);

                    SET @Ident_EG = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EG)),0);


                    SET @Ident_EI = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @EM)),0);


                    SET @Ident_PG = ISNULL((SELECT ID_CantidadesAlumnos
                        FROM DFLE_AlumnosEnsenanzaLenguas_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio) 
                        AND id_Trimestre = @id_Trimestre
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @UnidadAcademica)
                        AND id_Idioma = @Contador
                        AND id_NivelEducativo = (SELECT id_NivelEducativo 
                                                FROM DFLE_NivelEducativo 
                                                WHERE Desc_NivelEducativo = @GEN)),0);

                        UPDATE @TablaIden
                        SET Ident_NMS = @Ident_NMS,
                                Ident_NS = @Ident_NS,
                                Ident_POS = @Ident_POS,
                                Ident_EG = @Ident_EG,
                                Ident_EI = @Ident_EI,
                                Ident_PG = @Ident_PG
                        WHERE Idioma = (SELECT Lengua FROM @EnsenanzaLenguas WHERE ID_Lengua = @Contador);
                        SET @Contador = @Contador + 1;
                END
        END

    SELECT * FROM @PoblacionAtendida;
    SELECT * FROM @TablaIden;
END

