-- Author: Samuel Garcia
CREATE PROCEDURE SAC_InsertProgramaReconocimientoValidezOficial
    @Estado VARCHAR(255),
    @Unidad_Academica VARCHAR(255),
    @Carrera VARCHAR(255),
    @SiglasTipoUnidadAcademica VARCHAR(255),
    @Modalidad VARCHAR(255),
    @Vigencia VARCHAR(255),
    @Programa_Academico VARCHAR(255),
    @Fecha VARCHAR(255),
    @id_Trimestre INT,
    @Anio INT,
    @CorreoUsuario VARCHAR(255),
    @GuardarEnviar VARCHAR(7),
    @ID_Registro INT

AS
BEGIN
    IF @GuardarEnviar = 'Guardar'
    BEGIN
        IF(SELECT ID_ProgramaReconocimientoValidezOficial
            FROM SAC_ProgramaReconocimientoValidezOficial_Temporal
            WHERE ID_ProgramaReconocimientoValidezOficial = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_ProgramaReconocimientoValidezOficial_Temporal (
                Estado,
                Unidad_Academica,
                Carrera,
                id_TipoUnidadAcademica,
                Modalidad,
                Vigencia,
                Programa_Academico,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            VALUES (
                @Estado,
                @Unidad_Academica,
                @Carrera,
                (SELECT ID_TipoUnidadAcademica 
                FROM TipoUnidadAcademica
                WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica),
                @Modalidad,
                @Vigencia,
                @Programa_Academico,
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio 
                FROM Anio 
                WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario 
                FROM Usuario_General 
                WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico 
                                            FROM Correo_Electronico 
                                            WHERE Desc_Correo_Electronico = @CorreoUsuario))
            );
        END
        ELSE
        BEGIN
            UPDATE SAC_ProgramaReconocimientoValidezOficial_Temporal
            SET
                Estado = @Estado,
                Unidad_Academica = @Unidad_Academica,       
                Carrera = @Carrera,
                id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica),
                Modalidad = @Modalidad,
                Vigencia = @Vigencia,
                Programa_Academico = @Programa_Academico,
                Fecha = @Fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio 
                        FROM Anio 
                        WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario 
                            FROM Usuario_General 
                            WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico 
                                                        FROM Correo_Electronico 
                                                        WHERE Desc_Correo_Electronico = @CorreoUsuario))
            WHERE ID_ProgramaReconocimientoValidezOficial = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF(SELECT ID_ProgramaReconocimientoValidezOficial
            FROM SAC_ProgramaReconocimientoValidezOficial
            WHERE ID_ProgramaReconocimientoValidezOficial = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_ProgramaReconocimientoValidezOficial(
                Estado,
                Unidad_Academica,
                Carrera,
                id_TipoUnidadAcademica,
                Modalidad,
                Vigencia,
                Programa_Academico,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            VALUES (
                @Estado,
                @Unidad_Academica,
                @Carrera,
                (SELECT ID_TipoUnidadAcademica
                FROM TipoUnidadAcademica
                WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica),
                @Modalidad,
                @Vigencia,
                @Programa_Academico,
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio 
                FROM Anio 
                WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario
                FROM Usuario_General
                WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico
                                            FROM Correo_Electronico
                                            WHERE Desc_Correo_Electronico = @CorreoUsuario))
            );
        END
        ELSE
        BEGIN
            INSERT INTO SAC_ProgramaReconocimientoValidezOficial(
                Estado,
                Unidad_Academica,
                Carrera,
                id_TipoUnidadAcademica,
                Modalidad,
                Vigencia,
                Programa_Academico,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            SELECT
                Estado,
                Unidad_Academica,
                Carrera,    
                id_TipoUnidadAcademica,
                Modalidad,
                Vigencia,
                Programa_Academico,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM SAC_ProgramaReconocimientoValidezOficial_Temporal
            WHERE ID_ProgramaReconocimientoValidezOficial = @ID_Registro    

            DELETE FROM SAC_ProgramaReconocimientoValidezOficial_Temporal
            WHERE ID_ProgramaReconocimientoValidezOficial = @ID_Registro
        END
    END
END