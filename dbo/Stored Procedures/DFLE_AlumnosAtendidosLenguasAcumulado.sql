-- Numero de Formato: 8 ALUMNOS ATENDIDOS EN LENGUAS 2_DFLE_4T_2025.xlsx
CREATE PROCEDURE DFLE_AlumnosAtendidosLenguasAcumulado
    @anio INT, 
    @id_Trimestre INT,
    @Acumulado VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CenlexSantoTomas VARCHAR(255)= 'CENLEX UST'
    DECLARE @CenlexZacatenco VARCHAR(255)= 'CENLEX Zacatenco'

     DECLARE @TablaLenguasUA TABLE(
        Idioma VARCHAR(255) NOT NULL DEFAULT '',
        
        CenlexH INT NOT NULL DEFAULT 0,
        CenlexM INT NOT NULL DEFAULT 0,
        CenlexTotal INT NOT NULL DEFAULT 0,

        CelexH INT NOT NULL DEFAULT 0,
        CelexM INT NOT NULL DEFAULT 0,
        CelexTotal INT NOT NULL DEFAULT 0,

        SubTotalH INT NOT NULL DEFAULT 0,
        SubTotalM INT NOT NULL DEFAULT 0,
        Total INT NOT NULL DEFAULT 0
    );
    INSERT INTO @TablaLenguasUA(Idioma) 
    SELECT Desc_Idioma FROM DFLE_Idiomas;
    
    DECLARE @ContadorLenguas INT =1;

    DECLARE @CenlexH INT = 0;
    DECLARE @CenlexM INT = 0;
    DECLARE @CenlexTotal INT = 0;

    DECLARE @CelexH INT = 0;
    DECLARE @CelexM INT = 0;
    DECLARE @CelexTotal INT = 0;

    DECLARE @SubTotalH INT = 0;
    DECLARE @SubTotalM INT = 0;
    DECLARE @Total INT = 0;

    WHILE @ContadorLenguas <= (SELECT COUNT(*) FROM @TablaLenguasUA)
    BEGIN
        IF @Acumulado = 'NO ACUMULADO'
        BEGIN
            SET @CenlexH = ISNULL((SELECT SUM(Desc_Hombres) 
                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                            WHERE id_UnidadAcademica IN ((SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexSantoTomas), 
                                                                        (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexZacatenco))
                                            AND id_Idioma = @ContadorLenguas
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @id_Trimestre), 0);
            SET @CenlexM = ISNULL((SELECT SUM(Desc_Mujeres) 
                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                            WHERE id_UnidadAcademica IN ((SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexSantoTomas), 
                                                                        (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexZacatenco))
                                            AND id_Idioma = @ContadorLenguas
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @id_Trimestre), 0);
            SET @CenlexTotal = @CenlexH + @CenlexM;

            SET @CelexH = ISNULL((SELECT SUM(Desc_Hombres) 
                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                            WHERE id_UnidadAcademica NOT IN ((SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexSantoTomas), 
                                                                        (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexZacatenco))
                                            AND id_Idioma = @ContadorLenguas
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @id_Trimestre), 0);
            SET @CelexM = ISNULL((SELECT SUM(Desc_Mujeres) 
                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                            WHERE id_UnidadAcademica NOT IN ((SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexSantoTomas), 
                                                                        (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexZacatenco))
                                            AND id_Idioma = @ContadorLenguas
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @id_Trimestre), 0);
            SET @CelexTotal = @CelexH + @CelexM;
            
            UPDATE @TablaLenguasUA
            SET CenlexH = @CenlexH,
                CenlexM = @CenlexM,
                CenlexTotal = @CenlexTotal,
                CelexH = @CelexH,
                CelexM = @CelexM,
                CelexTotal = @CelexTotal,
                SubTotalH = @CenlexH + @CelexH,
                SubTotalM = @CenlexM + @CelexM,
                Total = @CenlexTotal + @CelexTotal
            WHERE Idioma = (SELECT Desc_Idioma FROM DFLE_Idiomas WHERE ID_Idioma = @ContadorLenguas);

            SET @ContadorLenguas = @ContadorLenguas + 1;
        END
        ELSE
        BEGIN
            SET @CenlexH = ISNULL((SELECT SUM(Desc_Hombres) 
                                    FROM DFLE_AlumnosEnsenanzaLenguas
                                    WHERE id_UnidadAcademica IN ((SELECT ID_UnidadAcademica
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @CenlexSantoTomas), 
                                                                (SELECT ID_UnidadAcademica
                                                                FROM UnidadesAcademicas
                                                                WHERE Siglas = @CenlexZacatenco))
                                    AND id_Idioma = @ContadorLenguas
                                    AND id_Anio = (SELECT ID_Anio
                                                    FROM Anio
                                                    WHERE Desc_Anio = @anio)), 0);
            SET @CenlexM = ISNULL((SELECT SUM(Desc_Mujeres) 
                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                            WHERE id_UnidadAcademica IN ((SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexSantoTomas), 
                                                                        (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexZacatenco))
                                            AND id_Idioma = @ContadorLenguas
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @anio)), 0);
            SET @CenlexTotal = @CenlexH + @CenlexM;

            SET @CelexH = ISNULL((SELECT SUM(Desc_Hombres) 
                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                            WHERE id_UnidadAcademica NOT IN ((SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexSantoTomas), 
                                                                        (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexZacatenco))
                                            AND id_Idioma = @ContadorLenguas
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @anio)), 0);
            SET @CelexM = ISNULL((SELECT SUM(Desc_Mujeres) 
                                            FROM DFLE_AlumnosEnsenanzaLenguas
                                            WHERE id_UnidadAcademica NOT IN ((SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexSantoTomas), 
                                                                        (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @CenlexZacatenco))
                                            AND id_Idioma = @ContadorLenguas
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @anio)), 0);
            SET @CelexTotal = @CelexH + @CelexM;
            
            UPDATE @TablaLenguasUA
            SET CenlexH = @CenlexH,
                CenlexM = @CenlexM,
                CenlexTotal = @CenlexTotal,
                CelexH = @CelexH,
                CelexM = @CelexM,
                CelexTotal = @CelexTotal,
                SubTotalH = @CenlexH + @CelexH,
                SubTotalM = @CenlexM + @CelexM,
                Total = @CenlexTotal + @CelexTotal
            WHERE Idioma = (SELECT Desc_Idioma FROM DFLE_Idiomas WHERE ID_Idioma = @ContadorLenguas);

            SET @ContadorLenguas = @ContadorLenguas + 1;
        END
    END

    SELECT * FROM @TablaLenguasUA
    /*UNION ALL
    SELECT
        'TOTAL',
        ISNULL(SUM(CenlexH), 0),
        ISNULL(SUM(CenlexM), 0),
        ISNULL(SUM(CenlexTotal), 0),
        ISNULL(SUM(CelexH), 0),
        ISNULL(SUM(CelexM), 0),
        ISNULL(SUM(CelexTotal), 0),
        ISNULL(SUM(SubTotalH), 0),
        ISNULL(SUM(SubTotalM), 0),
        ISNULL(SUM(Total), 0)
    FROM @TablaLenguasUA;
    */
END