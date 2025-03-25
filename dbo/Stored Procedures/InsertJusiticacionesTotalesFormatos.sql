CREATE PROCEDURE InsertJusiticacionesTotalesFormatos
    @Justicacion NVARCHAR(MAX),
    @NumeroFormatoDFLE INT,
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
        IF (SELECT ID_JustificacionesTotalesFormatos FROM DFLE_JustificacionesTotalesFormatos_Temporal WHERE ID_JustificacionesTotalesFormatos = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_JustificacionesTotalesFormatos_Temporal(
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @Justicacion,
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @NumeroFormatoDFLE AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
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
            UPDATE DFLE_JustificacionesTotalesFormatos_Tempora
            SET Desc_Justificacion = @Justicacion,
                id_FormatoAutoevaluacion = (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @NumeroFormatoDFLE AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
                Fecha = @fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            WHERE ID_JustificacionesTotalesFormatos = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_JustificacionesTotalesFormatos FROM DFLE_JustificacionesTotalesFormatos_Temporal WHERE ID_JustificacionesTotalesFormatos = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_JustificacionesTotalesFormatos(
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @Justicacion,
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @NumeroFormatoDFLE AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = 'DFLE')),
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
            INSERT INTO DFLE_JustificacionesTotalesFormatos(
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            SELECT
                Desc_Justificacion,
                id_FormatoAutoevaluacion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM DFLE_JustificacionesTotalesFormatos_Temporal
            WHERE ID_JustificacionesTotalesFormatos = @ID_Registro

            DELETE FROM DFLE_JustificacionesTotalesFormatos_Temporal 
            WHERE ID_JustificacionesTotalesFormatos = @ID_Registro
        END
    END
END



