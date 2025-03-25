-- Numero de Formato: 11 DOCENTES DE LENGUAS QUE PARTICIPAN EN ACCIONES DE FORMACIÓN
CREATE PROCEDURE DFLE_DocentesAccionesFormacion  
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CenlexSantoTomas VARCHAR(255)= 'CENLEX UST'
    DECLARE @CenlexZacatenco VARCHAR(255)= 'CENLEX Zacatenco'
    DECLARE @TablaLenguasUA TABLE(
        Lengua VARCHAR(255) NOT NULL DEFAULT '',
        
        CenlexSantoTomasH INT NOT NULL DEFAULT 0,
        CenlexSantoTomasM INT NOT NULL DEFAULT 0,
        CenlexSantoTomasTotal INT NOT NULL DEFAULT 0,

        CenlexZacatencoH INT NOT NULL DEFAULT 0,
        CenlexZacatencoM INT NOT NULL DEFAULT 0,
        CenlexZacatencoTotal INT NOT NULL DEFAULT 0,

        SubTotalH INT NOT NULL DEFAULT 0,
        SubTotalM INT NOT NULL DEFAULT 0,
        Total INT NOT NULL DEFAULT 0
    );
    INSERT INTO @TablaLenguasUA(Lengua) SELECT Desc_Idioma FROM DFLE_Idiomas;

    DECLARE @ContadorLenguas INT = 1;

    DECLARE @CenlexSantoTomasH INT = 0;
    DECLARE @CenlexZacatencoM INT = 0; 
    DECLARE @CenlexZacatencoH INT = 0;
    DECLARE @CenlexSantoTomasM INT = 0;
    


    WHILE @ContadorLenguas <= (SELECT COUNT(*) FROM DFLE_Idiomas)
    BEGIN
        SET @CenlexSantoTomasH = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_DocentesAccionesFormativas 
                                        WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE Siglas = @CenlexSantoTomas)  
                                        AND id_Idioma = @ContadorLenguas
                                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);

        SET @CenlexSantoTomasM = ISNULL((SELECT SUM(Desc_Mujeres) 
                                        FROM DFLE_DocentesAccionesFormativas 
                                        WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE Siglas = @CenlexSantoTomas)  
                                        AND id_Idioma = @ContadorLenguas
                                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);

        SET @CenlexZacatencoH = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM DFLE_DocentesAccionesFormativas 
                                        WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE Siglas = @CenlexZacatenco)  
                                        AND id_Idioma = @ContadorLenguas
                                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);

        SET @CenlexZacatencoM = ISNULL((SELECT SUM(Desc_Mujeres) 
                                        FROM DFLE_DocentesAccionesFormativas 
                                        WHERE id_UnidadCenlex = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE Siglas = @CenlexZacatenco)  
                                        AND id_Idioma = @ContadorLenguas
                                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre), 0);
        UPDATE @TablaLenguasUA
        SET CenlexSantoTomasH = @CenlexSantoTomasH,
            CenlexSantoTomasM = @CenlexSantoTomasM,
            CenlexSantoTomasTotal = @CenlexSantoTomasH + @CenlexSantoTomasM,
            
            CenlexZacatencoH = @CenlexZacatencoH,
            CenlexZacatencoM = @CenlexZacatencoM,
            CenlexZacatencoTotal = @CenlexZacatencoH + @CenlexZacatencoM,

            SubTotalH = @CenlexSantoTomasH + @CenlexZacatencoH,
            SubTotalM = @CenlexSantoTomasM + @CenlexZacatencoM,

            Total = (@CenlexSantoTomasH + @CenlexSantoTomasM) + (@CenlexZacatencoH + @CenlexZacatencoM)
        WHERE Lengua = (SELECT Desc_Idioma FROM DFLE_Idiomas WHERE ID_Idioma = @ContadorLenguas);
    SET @ContadorLenguas = @ContadorLenguas + 1;
    END
    
    SELECT * FROM @TablaLenguasUA
    UNION ALL
    SELECT 
        'Total Cenlex',
        SUM(CenlexSantoTomasH),
        SUM(CenlexSantoTomasM),
        SUM(CenlexSantoTomasTotal),
        SUM(CenlexZacatencoH),
        SUM(CenlexZacatencoM),
        SUM(CenlexZacatencoTotal),
        SUM(SubTotalH),
        SUM(SubTotalM),
        SUM(Total)
    FROM @TablaLenguasUA;
END


