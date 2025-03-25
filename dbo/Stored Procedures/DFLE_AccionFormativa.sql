-- Numero de Formato:12 Acción formativa impartida a docentes de lenguas . ACUMULADO
CREATE PROCEDURE DFLE_AccionFormativa
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AccionFormativa TABLE (
        ID_AccionFormativa INT IDENTITY(1, 1),
        AccionFormacion VARCHAR(255) COLLATE Latin1_General_CI_AI,
        Total_HomMuj INT
    );

    INSERT INTO @AccionFormativa(
        AccionFormacion
    ) SELECT Desc_AccionFormativa 
        FROM DFLE_AccionesFormativas
            WHERE id_Trimestre = @id_Trimestre
            AND id_Anio = (SELECT ID_Anio 
                            FROM Anio
                            WHERE Desc_Anio = @anio);
    
    DECLARE @ContAcciones INT = 1;
    WHILE @ContAcciones <= ISNULL((SELECT COUNT(*) 
                            FROM @AccionFormativa),0) 
    BEGIN
        DECLARE @AccionActual VARCHAR(255) = (SELECT AccionFormacion 
                                                FROM @AccionFormativa
                                                WHERE ID_AccionFormativa = @ContAcciones);
        DECLARE @Hombres INT = 0;
        DECLARE @Mujeres INT = 0;

        SET @Hombres = (SELECT Desc_Hombres 
                        FROM DFLE_AccionesFormativas
                        WHERE Desc_AccionFormativa = @AccionActual
                        AND id_Trimestre = @id_Trimestre
                        AND id_Anio = (SELECT ID_Anio 
                                        FROM Anio
                                        WHERE Desc_Anio = @anio));
        SET @Mujeres = (SELECT Desc_Mujeres 
                        FROM DFLE_AccionesFormativas
                        WHERE Desc_AccionFormativa = @AccionActual
                        AND id_Trimestre = @id_Trimestre
                        AND id_Anio = (SELECT ID_Anio 
                                        FROM Anio
                                        WHERE Desc_Anio = @anio));
        UPDATE @AccionFormativa
        SET Total_HomMuj = @Hombres + @Mujeres
        WHERE ID_AccionFormativa = @ContAcciones;

    SET @ContAcciones = @ContAcciones + 1;
    END

    SELECT daf.Desc_Tipo_Accion,
            daf.Desc_AccionFormativa,
            daf.Desc_Modalidad,
            did.Desc_Idioma,
            UA.Siglas,
            daf.Desc_Hombres,
            daf.Desc_Mujeres,
            af.Total_HomMuj
    FROM DFLE_AccionesFormativas daf
    JOIN @AccionFormativa af ON daf.Desc_AccionFormativa = af.AccionFormacion
    JOIN DFLE_Idiomas did ON daf.id_Idioma = did.ID_Idioma
    JOIN UnidadesAcademicas UA ON daf.id_UnidadAcademica = UA.ID_UnidadAcademica
END
