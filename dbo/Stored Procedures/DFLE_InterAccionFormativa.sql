--Procedimiento para retornar informacion a la interfaz que representa el formato 12
CREATE PROCEDURE DFLE_InterAccionFormativa
    @anio INT,
    @id_Trimestre INT,
    @Final varchar(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @AccionFormativa TABLE (
                ID_AccionFormativa INT IDENTITY(1, 1),
                AccionFormacion VARCHAR(255) COLLATE Latin1_General_CI_AI,
                Total INT
    );

    DECLARE @Contador INT = 1;
    DECLARE @Hombres INT = 0;
    DECLARE @Mujeres INT = 0;
    DECLARE @AccionActual VARCHAR(255) = ' ';
    
    IF @Final = 'FINAL'
        BEGIN
            INSERT INTO @AccionFormativa(
                AccionFormacion
            ) SELECT Desc_AccionFormativa 
                FROM DFLE_AccionesFormativas
                    WHERE id_Trimestre = @id_Trimestre
                    AND id_Anio = (SELECT ID_Anio 
                                    FROM Anio
                                    WHERE Desc_Anio = @anio);
            SET  @Contador = 1;
            WHILE @Contador <= ISNULL((SELECT COUNT(*) FROM @AccionFormativa),0)
            BEGIN
                SET @AccionActual = (SELECT AccionFormacion 
                                                        FROM @AccionFormativa
                                                        WHERE ID_AccionFormativa = @Contador);

                SET @Hombres = (SELECT SUM(Desc_Hombres) 
                                FROM DFLE_AccionesFormativas
                                WHERE Desc_AccionFormativa = @AccionActual
                                AND id_Trimestre = @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio 
                                                FROM Anio
                                                WHERE Desc_Anio = @anio));

                SET @Mujeres = (SELECT SUM(Desc_Mujeres) 
                                FROM DFLE_AccionesFormativas
                                WHERE Desc_AccionFormativa = @AccionActual
                                AND id_Trimestre = @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio 
                                                FROM Anio
                                                WHERE Desc_Anio = @anio));
                UPDATE @AccionFormativa
                SET Total = @Hombres + @Mujeres
                WHERE ID_AccionFormativa = @Contador;      

                SET @Contador = @Contador + 1;
            END

            SELECT daf.Desc_Tipo_Accion,
                    daf.Desc_AccionFormativa,
                    daf.Desc_Modalidad,
                    did.Desc_Idioma,
                    UA.Siglas,
                    daf.Desc_Hombres,
                    daf.Desc_Mujeres,
                    af.Total
            FROM DFLE_AccionesFormativas daf
            JOIN @AccionFormativa af ON daf.Desc_AccionFormativa = af.AccionFormacion
            JOIN DFLE_Idiomas did ON daf.id_Idioma = did.ID_Idioma
            JOIN UnidadesAcademicas UA ON daf.id_UnidadAcademica = UA.ID_UnidadAcademica

            SELECT ID_RegistroFormato12DFLE FROM DFLE_AccionesFormativas
            WHERE id_Trimestre = @id_Trimestre
            AND id_Anio = (SELECT ID_Anio 
                            FROM Anio
                            WHERE Desc_Anio = @anio);
        END
    ELSE
    BEGIN
        INSERT INTO @AccionFormativa(
            AccionFormacion
        ) SELECT Desc_AccionFormativa 
            FROM DFLE_AccionesFormativas
                WHERE id_Trimestre = @id_Trimestre
                AND id_Anio = (SELECT ID_Anio 
                                FROM Anio
                                WHERE Desc_Anio = @anio);
        SET @Contador = 1;
        SET @Hombres = 0;
        SET @Mujeres = 0;
        WHILE @Contador <= ISNULL((SELECT COUNT(*) FROM @AccionFormativa),0)
        BEGIN
            SET @AccionActual = (SELECT AccionFormacion 
                                                    FROM @AccionFormativa
                                                    WHERE ID_AccionFormativa = @Contador);

            SET @Hombres = (SELECT SUM(Desc_Hombres) 
                            FROM DFLE_AccionesFormativas_Temporal
                            WHERE Desc_AccionFormativa = @AccionActual
                            AND id_Trimestre = @id_Trimestre
                            AND id_Anio = (SELECT ID_Anio 
                                            FROM Anio
                                            WHERE Desc_Anio = @anio));

            SET @Mujeres = (SELECT SUM(Desc_Mujeres) 
                            FROM DFLE_AccionesFormativas_Temporal
                            WHERE Desc_AccionFormativa = @AccionActual
                            AND id_Trimestre = @id_Trimestre
                            AND id_Anio = (SELECT ID_Anio 
                                            FROM Anio
                                            WHERE Desc_Anio = @anio));
            UPDATE @AccionFormativa
            SET Total = @Hombres + @Mujeres
            WHERE ID_AccionFormativa = @Contador;      

            SET @Contador = @Contador + 1;
        END

        SELECT daf.Desc_Tipo_Accion,
                daf.Desc_AccionFormativa,
                daf.Desc_Modalidad,
                did.Desc_Idioma,
                UA.Siglas,
                daf.Desc_Hombres,
                daf.Desc_Mujeres,
                af.Total
        FROM DFLE_AccionesFormativas daf
        JOIN @AccionFormativa af ON daf.Desc_AccionFormativa = af.AccionFormacion
        JOIN DFLE_Idiomas did ON daf.id_Idioma = did.ID_Idioma
        JOIN UnidadesAcademicas UA ON daf.id_UnidadAcademica = UA.ID_UnidadAcademica

        SELECT ID_RegistroFormato12DFLE FROM DFLE_AccionesFormativas_Temporal
        WHERE id_Trimestre = @id_Trimestre
        AND id_Anio = (SELECT ID_Anio 
                        FROM Anio
                        WHERE Desc_Anio = @anio);
    END
END
