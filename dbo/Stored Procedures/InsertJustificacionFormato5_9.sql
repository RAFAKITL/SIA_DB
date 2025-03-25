CREATE PROCEDURE InsertJustificacionFormato5_9
    @Justificacion nvarchar(max),
    @Formato INT,
    @Idioma varchar(255),
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
        IF(SELECT ID_JustificacionesFormato5_9 FROM DFLE_JustificacionesFormato5_9_Temporal WHERE ID_JustificacionesFormato5_9 = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_JustificacionesFormato5_9_Temporal(
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                id_Idioma,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            VALUES(
                @Justificacion,
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @Formato AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
                (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                @fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            )
        END
        ELSE
        BEGIN
            UPDATE DFLE_JustificacionesFormato5_9_Temporal
            SET Desc_Justificacion = @Justificacion,
                id_FormatoAutoevaluacion = (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @Formato AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
                id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                Fecha = @fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            WHERE ID_JustificacionesFormato5_9 = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_JustificacionesFormato5_9 FROM DFLE_JustificacionesFormato5_9_Temporal WHERE ID_JustificacionesFormato5_9 = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_JustificacionesFormato5_9(
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                id_Idioma,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            VALUES(
                @Justificacion,
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @Formato AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
                (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                @fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            )
        END
        ELSE
        BEGIN
            INSERT INTO DFLE_JustificacionesFormato5_9(
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                id_Idioma,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            SELECT
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                id_Idioma,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM DFLE_JustificacionesFormato5_9_Temporal
            WHERE ID_JustificacionesFormato5_9 = @ID_Registro

            DELETE FROM DFLE_JustificacionesFormato5_9_Temporal 
            WHERE ID_JustificacionesFormato5_9 = @ID_Registro
        END
    END
END