CREATE PROCEDURE DFLE_InterUACelexSupervisadas
    @SiglasTipoUnidadAcademico VARCHAR(255),
    @Anio INT,
    @Final VARCHAR(255)
AS
BEGIN   
    SET NOCOUNT ON;
    DECLARE @TablaUnidadesAcademicas TABLE (
        UnidadAcademica VARCHAR(255),
        ID_UnidadAcademica INT IDENTITY (1,1)
    );
    INSERT INTO @TablaUnidadesAcademicas 
        SELECT 
            Siglas
        FROM
            UnidadesAcademicas
        WHERE
            id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademico); 

    DECLARE @TablaSupervision TABLE(
        SiglasUA VARCHAR(255),
        TrimestreUno INT NOT NULL DEFAULT 0,
        TrimestreDos INT NOT NULL DEFAULT 0,
        TrimestreTres INT NOT NULL DEFAULT 0,
        TrimestreCuatro INT NOT NULL DEFAULT 0,

        Total INT NOT NULL DEFAULT 0
    )
    INSERT INTO @TablaSupervision(SiglasUA)
        SELECT 
            Siglas
        FROM
            UnidadesAcademicas
        WHERE
            id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademico);
    DECLARE @TablaIDs TABLE(
            SiglasUA VARCHAR(255),
            Ident_TrimestreUno INT,
            Ident_TrimestreDos INT,
            Ident_TrimestreTres INT,
            Ident_TrimestreCuatro INT
    );
    INSERT INTO @TablaIDs(SiglasUA)
        SELECT 
            Siglas
        FROM
            UnidadesAcademicas
        WHERE
            id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademico);

    DECLARE @SiglasUA VARCHAR(255);
    DECLARE @contadorUA INT = 1;
    DECLARE @TrimeUno INT = 0;
    DECLARE @TrimeDos INT = 0;
    DECLARE @TrimeTres INT = 0;
    DECLARE @TrimeCuatro INT = 0;
    DECLARE @Total INT = 0;

    DECLARE @IdentUno INT = 0;
    DECLARE @IdentDos INT = 0;
    DECLARE @IdentTres INT = 0;
    DECLARE @IdentCuatro INT = 0;

    IF @Final = 'FINAL'
    BEGIN
        WHILE @contadorUA <= (SELECT COUNT(*) FROM @TablaUnidadesAcademicas)
        BEGIN 
            SET @SiglasUA = (SELECT UnidadAcademica FROM @TablaUnidadesAcademicas WHERE ID_UnidadAcademica = @contadorUA);

            SET @TrimeUno = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 1
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @TrimeDos = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 2
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @TrimeTres = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 3
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @TrimeCuatro = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 4
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);

            SET @Total = @TrimeUno + @TrimeDos + @TrimeTres + @TrimeCuatro;
            SET @contadorUA = @contadorUA + 1;

            UPDATE @TablaSupervision
                SET SiglasUA = @SiglasUA,
                    TrimestreUno = @TrimeUno,
                    TrimestreDos = @TrimeDos,
                    TrimestreTres = @TrimeTres,
                    TrimestreCuatro = @TrimeCuatro,
                    Total = @Total
                WHERE SiglasUA = @SiglasUA;    
        END
        
        --****************************************************************************--
        SET @contadorUA = 1;
        WHILE @contadorUA <= (SELECT COUNT(*) FROM @TablaUnidadesAcademicas)
        BEGIN 
            SET @SiglasUA = (SELECT UnidadAcademica FROM @TablaUnidadesAcademicas WHERE ID_UnidadAcademica = @contadorUA);

            SET @IdentUno = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 1
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @IdentDos = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 2
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @IdentTres = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 3
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @IdentCuatro = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex 
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 4
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @contadorUA = @contadorUA + 1;

            UPDATE @TablaIDs
                SET Ident_TrimestreUno = @IdentUno,
                    Ident_TrimestreDos = @IdentDos,
                    Ident_TrimestreTres = @IdentTres,
                    Ident_TrimestreCuatro = @IdentCuatro
                WHERE SiglasUA = @SiglasUA;    
        END
    END
    ELSE
    BEGIN
        WHILE @contadorUA <= (SELECT COUNT(*) FROM @TablaUnidadesAcademicas)
        BEGIN 
            SET @SiglasUA = (SELECT UnidadAcademica FROM @TablaUnidadesAcademicas WHERE ID_UnidadAcademica = @contadorUA);

            SET @TrimeUno = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 1
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @TrimeDos = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 2
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @TrimeTres = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 3
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @TrimeCuatro = ISNULL((SELECT TOP(1) TRIM_UNO_Supervicion
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 4
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);

            SET @Total = @TrimeUno + @TrimeDos + @TrimeTres + @TrimeCuatro;
            SET @contadorUA = @contadorUA + 1;

            UPDATE @TablaSupervision
                SET SiglasUA = @SiglasUA,
                    TrimestreUno = @TrimeUno,
                    TrimestreDos = @TrimeDos,
                    TrimestreTres = @TrimeTres,
                    TrimestreCuatro = @TrimeCuatro,
                    Total = @Total
                WHERE SiglasUA = @SiglasUA;    
        END
        
        --****************************************************************************--
        SET @contadorUA = 1;
        WHILE @contadorUA <= (SELECT COUNT(*) FROM @TablaUnidadesAcademicas)
        BEGIN 
            SET @SiglasUA = (SELECT UnidadAcademica FROM @TablaUnidadesAcademicas WHERE ID_UnidadAcademica = @contadorUA);

            SET @IdentUno = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 1
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @IdentDos = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 2
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @IdentTres = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 3
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @IdentCuatro = ISNULL((SELECT TOP(1) ID_SupervicionCelex
                        FROM DFLE_SupervicionCelex_Temporal
                        WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                        AND id_Trimestre = 4
                        AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas =  @SiglasUA)),0);
            SET @contadorUA = @contadorUA + 1;

            UPDATE @TablaIDs
                SET Ident_TrimestreUno = @IdentUno,
                    Ident_TrimestreDos = @IdentDos,
                    Ident_TrimestreTres = @IdentTres,
                    Ident_TrimestreCuatro = @IdentCuatro
                WHERE SiglasUA = @SiglasUA;    
        END
    END
    
    --****************************************************************************--
    SELECT * FROM @TablaSupervision;
    SELECT * FROM @TablaIDs;

END
