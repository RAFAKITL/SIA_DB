CREATE PROCEDURE DFLE_ComplementoEnsenanzaLenguasUA
    @SiglasUnidadAcademica VARCHAR(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        SUM(COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0)) AS TOTAL,
        SUM(CASE WHEN i.ID_Idioma = 1 THEN 
                COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'INGLÉS',
        SUM(CASE WHEN i.ID_Idioma = 2 THEN 
                COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'FRANCÉS',
        SUM(CASE WHEN i.ID_Idioma = 3 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'ALEMÁN',
        SUM(CASE WHEN i.ID_Idioma = 4 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'ITALIANO',
        SUM(CASE WHEN i.ID_Idioma = 5 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'JAPONÉS',
        SUM(CASE WHEN i.ID_Idioma = 6 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'CHINO-MANDARÍN',
        SUM(CASE WHEN i.ID_Idioma = 7 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'PORTUGUÉS',
        SUM(CASE WHEN i.ID_Idioma = 8 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'RUSO',
        SUM(CASE WHEN i.ID_Idioma = 9 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'NÁHUATL',
        SUM(CASE WHEN i.ID_Idioma = 10 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'ESPAÑOL',
        SUM(CASE WHEN i.ID_Idioma = 11 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'SEÑAS MEXICANAS',
        SUM(CASE WHEN i.ID_Idioma = 12 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'COREANO',
        SUM(CASE WHEN i.ID_Idioma = 13 THEN 
            COALESCE(Desc_Hombres, 0) + COALESCE(Desc_Mujeres, 0) 
            ELSE 0 
            END) AS 'HINDI'
    FROM DFLE_AlumnosEnsenanzaLenguas d
    JOIN DFLE_Idiomas i ON d.id_Idioma = i.ID_Idioma
    WHERE d.id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                FROM UnidadesAcademicas
                                WHERE Siglas = @SiglasUnidadAcademica)
    AND d.id_Anio = (SELECT ID_Anio 
                    FROM Anio
                    WHERE Desc_Anio = @anio)
    AND d.id_Trimestre = @id_Trimestre
END