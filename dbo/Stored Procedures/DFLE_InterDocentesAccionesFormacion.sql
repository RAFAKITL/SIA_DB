CREATE PROCEDURE DFLE_InterDocentesAccionesFormacion
    @SiglasCENLEX varchar(255),
    @anio INT,
    @id_Trimestre INT,
    @Final varchar(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TablaLenguasUA TABLE(
        Lengua VARCHAR(255) NOT NULL DEFAULT '',
        
        CenlexHombres INT NOT NULL DEFAULT 0,
        CenlexMujeres INT NOT NULL DEFAULT 0,
        CenlexTotal INT NOT NULL DEFAULT 0
    );

    DECLARE @Identificadores TABLE(
        Lengua varchar(255) NOT NULL DEFAULT ' ',

        IdentificadorRegistro INT NOT NULL DEFAULT 0
    );

    DECLARE @ContadorLenguas INT = 1;
    DECLARE @CenlexHombres INT = 0; 
    DECLARE @CenlexMujeres INT = 0;

    IF @Final = 'FINAL'
        BEGIN
            SET @ContadorLenguas = 1;
            WHILE @ContadorLenguas <= (SELECT COUNT(*) FROM DFLE_Idiomas)
                BEGIN

                    SET @CenlexHombres = ISNULL((SELECT Desc_Hombres 
                                                    FROM DFLE_DocentesAccionesFormativas
                                                    WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE Siglas = @SiglasCENLEX)  
                                                    AND id_Idioma = @ContadorLenguas
                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_Trimestre = @id_Trimestre), 0);
                    
                    SET @CenlexMujeres = ISNULL((SELECT Desc_Mujeres 
                                                    FROM DFLE_DocentesAccionesFormativas 
                                                    WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE Siglas = @SiglasCENLEX)  
                                                    AND id_Idioma = @ContadorLenguas
                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_Trimestre = @id_Trimestre), 0);

                    INSERT INTO @TablaLenguasUA(
                        Lengua,
                        CenlexHombres,
                        CenlexMujeres,
                        CenlexTotal
                    )VALUES(
                        (SELECT Desc_Idioma 
                        FROM DFLE_Idiomas
                        WHERE ID_Idioma = @ContadorLenguas),
                        @CenlexHombres,
                        @CenlexMujeres,
                        (@CenlexHombres + @CenlexMujeres)
                    );

                    INSERT INTO @Identificadores(
                        Lengua,
                        IdentificadorRegistro
                    )VALUES(
                        (SELECT Desc_Idioma 
                        FROM DFLE_Idiomas
                        WHERE ID_Idioma = @ContadorLenguas),
                        ISNULL(((SELECT ID_DocentesAccionesFormativas
                        FROM DFLE_DocentesAccionesFormativas
                        WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                FROM UnidadesAcademicas 
                                                WHERE Siglas = @SiglasCENLEX)  
                        AND id_Idioma = @ContadorLenguas
                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                        AND id_Trimestre = @id_Trimestre)), 0)
                    )

                    SET @ContadorLenguas = @ContadorLenguas + 1;
                END
        END
    ELSE
        BEGIN
            SET @ContadorLenguas = 1;
            WHILE @ContadorLenguas <= (SELECT COUNT(*) FROM DFLE_Idiomas)
                BEGIN

                    SET @CenlexHombres = ISNULL((SELECT Desc_Hombres 
                                                    FROM DFLE_DocentesAccionesFormativas_Temporal
                                                    WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE Siglas = @SiglasCENLEX)  
                                                    AND id_Idioma = @ContadorLenguas
                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_Trimestre = @id_Trimestre), 0);
                    
                    SET @CenlexMujeres = ISNULL((SELECT Desc_Mujeres 
                                                    FROM DFLE_DocentesAccionesFormativas_Temporal
                                                    WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE Siglas = @SiglasCENLEX)  
                                                    AND id_Idioma = @ContadorLenguas
                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_Trimestre = @id_Trimestre), 0);

                    INSERT INTO @TablaLenguasUA(
                        Lengua,
                        CenlexHombres,
                        CenlexMujeres,
                        CenlexTotal
                    )VALUES(
                        (SELECT Desc_Idioma 
                        FROM DFLE_Idiomas
                        WHERE ID_Idioma = @ContadorLenguas),
                        @CenlexHombres,
                        @CenlexMujeres,
                        (@CenlexHombres + @CenlexMujeres)
                    );

                    INSERT INTO @Identificadores(
                        Lengua,
                        IdentificadorRegistro
                    )VALUES(
                        (SELECT Desc_Idioma 
                        FROM DFLE_Idiomas
                        WHERE ID_Idioma = @ContadorLenguas),
                        (ISNULL((SELECT ID_DocentesAccionesFormativas
                                FROM DFLE_DocentesAccionesFormativas_Temporal
                                WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                        FROM UnidadesAcademicas 
                                                        WHERE Siglas = @SiglasCENLEX)  
                                AND id_Idioma = @ContadorLenguas
                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                AND id_Trimestre = @id_Trimestre), 0))
                    )

                    SET @ContadorLenguas = @ContadorLenguas + 1;
                END
        END

    SELECT * FROM @TablaLenguasUA
    SELECT * FROM @Identificadores
END
