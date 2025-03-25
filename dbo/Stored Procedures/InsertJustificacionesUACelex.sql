CREATE PROCEDURE InsertJustificacionesUACelex
    @Justificacion nvarchar(max),
    @SiglasNivelEducativo varchar(255),
    @fecha varchar(255),
    @id_Trimestre INT,
    @Anio INT,
    @CorreoUsuario varchar(255),
    @GuardarEnviar varchar(7),
    @ID_Registro INT
AS
BEGIN
    IF @GuardarEnviar = 'Guardar'
    BEGIN
        IF (SELECT ID_JustificacionesUACelex FROM DFLE_JustificacionesUACelex_Temporal WHERE ID_JustificacionesUACelex = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_JustificacionesUACelex_Temporal(
                Desc_Justificacion,
                id_TipoUnidadAcademica,
                Fecha,
                id_FormatoAutoevaluacion,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @Justificacion,
                (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @SiglasNivelEducativo),
                @fecha,
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = 2 AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            )
        END
        ELSE
        BEGIN
            UPDATE DFLE_JustificacionesUACelex_Temporal
            SET Desc_Justificacion = @Justificacion,
                id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @SiglasNivelEducativo),
                Fecha = @fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            WHERE ID_JustificacionesUACelex = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_JustificacionesUACelex FROM DFLE_JustificacionesUACelex_Temporal WHERE ID_JustificacionesUACelex = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_JustificacionesUACelex (
                Desc_Justificacion,
                id_TipoUnidadAcademica,
                Fecha,
                id_FormatoAutoevaluacion,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            VALUES(
                @Justificacion,
                (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @SiglasNivelEducativo),
                @fecha,
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = 2 AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario from Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
                )
        END
        ELSE
        BEGIN
            INSERT INTO DFLE_JustificacionesUACelex (
                Desc_Justificacion,
                id_TipoUnidadAcademica,
                Fecha,
                id_FormatoAutoevaluacion,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            SELECT
                Desc_Justificacion,
                id_TipoUnidadAcademica,
                Fecha,
                id_FormatoAutoevaluacion,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM DFLE_JustificacionesUACelex_Temporal
            WHERE ID_JustificacionesUACelex = @ID_Registro

            DELETE FROM DFLE_JustificacionesUACelex_Temporal
            WHERE ID_JustificacionesUACelex = @ID_Registro
        END
    END
END
