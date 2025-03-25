CREATE PROCEDURE SAC_ProgramaReconocimientoValidezOficial_Estadistico
    @Anio INT,
    @Trimestre INT
AS
BEGIN
    -- SET NOCOUNT ON;
    DECLARE @TablaReconocimiento TABLE(
        ID_TablaReconocimiento INT IDENTITY(1,1),
        Estado VARCHAR(255) NOT NULL DEFAULT '',
        Unidad_Academica VARCHAR(255) NOT NULL DEFAULT '',
        Carrera VARCHAR(255) NOT NULL DEFAULT '',
        id_TipoUnidadAcademica INT NOT NULL DEFAULT 0,
        Modalidad VARCHAR(255) NOT NULL DEFAULT '',
        Vigencia VARCHAR(255) NOT NULL DEFAULT '',
        Programa_Academico VARCHAR(255) NOT NULL DEFAULT ''
    );
    INSERT INTO @TablaReconocimiento(Estado, Unidad_Academica, Carrera, id_TipoUnidadAcademica, Modalidad, Vigencia, Programa_Academico)
    SELECT
    Estado, 
    Unidad_Academica, 
    Carrera, 
    id_TipoUnidadAcademica, 
    Modalidad, 
    Vigencia, 
    Programa_Academico
    FROM SAC_ProgramaReconocimientoValidezOficial
    WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
    AND id_Trimestre = @Trimestre

    SELECT s.ID_TablaReconocimiento AS 'NO',
            s.Estado, 
            s.Unidad_Academica, 
            s.Carrera,
            u.Desc_TipoUnidadAcademica AS NivelEducativo,              
            s.Modalidad,
            s.Vigencia,
            s.Programa_Academico
    FROM @TablaReconocimiento s
    JOIN TipoUnidadAcademica u
    ON s.id_TipoUnidadAcademica = u.ID_TipoUnidadAcademica
END


