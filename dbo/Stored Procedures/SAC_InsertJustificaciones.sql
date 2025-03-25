CREATE PROCEDURE SAC_InsertJustificaciones
    @Desc_Justificacion varchar(255),
    @SiglasTipoUnidadAcademica varchar(255),
    @NombreProgramaApoyo varchar(255),
    @NumeroFormatoSAC INT,
    @Fecha varchar(255),
    @id_Trimestre INT,
    @Anio INT,
    @CorreoUsuario varchar(255),
    @GuardarEnviar varchar(7),
    @ID_Registro INT
AS
BEGIN
    IF @GuardarEnviar = 'Guardar'
    BEGIN
        IF (SELECT ID_JustificacionesSAC
            FROM SAC_Justificaciones_Temporal
            WHERE ID_JustificacionesSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_Justificaciones_Temporal(
                Desc_Justificacion,
                id_TipoUnidadAcademicaSAC,
                id_ProgramaApoyoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            VALUES (
                @Desc_Justificacion,
                (SELECT ID_TipoUnidadAcademica 
                FROM TipoUnidadAcademica
                WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica),
                (SELECT ID_ProgramaApoyoSAC
                FROM SAC_ProgramaApoyo
                WHERE Desc_ProgramaApoyoSAC = @NombreProgramaApoyo),
                (SELECT ID_Formato 
                    FROM Formatos
                    WHERE Desc_NumeroFormato = @NumeroFormatoSAC
                    AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas 
                                                    FROM Dependencias_Evaluadas
                                                    WHERE Desc_SiglasDependencia = 'SAC')),
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
            UPDATE SAC_Justificaciones_Temporal
            SET
                Desc_Justificacion = @Desc_Justificacion,
                id_TipoUnidadAcademicaSAC = (SELECT ID_TipoUnidadAcademica 
                                        FROM TipoUnidadAcademica
                                        WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica),
                id_ProgramaApoyoSAC = (SELECT ID_ProgramaApoyoSAC
                                        FROM SAC_ProgramaApoyo
                                        WHERE Desc_ProgramaApoyoSAC = @NombreProgramaApoyo),
                id_FormatoSAC = (SELECT ID_Formato 
                                FROM Formatos
                                WHERE Desc_NumeroFormato = @NumeroFormatoSAC
                                AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas 
                                                                FROM Dependencias_Evaluadas
                                                                WHERE Desc_SiglasDependencia = 'SAC')),
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
            WHERE ID_JustificacionesSAC = @ID_Registro;
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_JustificacionesSAC
            FROM SAC_Justificaciones_Temporal
            WHERE ID_JustificacionesSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_Justificaciones(
                Desc_Justificacion,
                id_TipoUnidadAcademicaSAC,
                id_ProgramaApoyoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            VALUES (
                @Desc_Justificacion,
                (SELECT ID_TipoUnidadAcademica 
                FROM TipoUnidadAcademica
                WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica),
                (SELECT ID_ProgramaApoyoSAC
                FROM SAC_ProgramaApoyo
                WHERE Desc_ProgramaApoyoSAC = @NombreProgramaApoyo),
                (SELECT ID_Formato 
                    FROM Formatos
                    WHERE Desc_NumeroFormato = @NumeroFormatoSAC
                    AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas 
                                                    FROM Dependencias_Evaluadas
                                                    WHERE Desc_SiglasDependencia = 'SAC')),
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
            INSERT INTO SAC_Justificaciones(
                Desc_Justificacion,
                id_TipoUnidadAcademicaSAC,
                id_ProgramaApoyoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            SELECT
                Desc_Justificacion,
                id_TipoUnidadAcademicaSAC,
                id_ProgramaApoyoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM SAC_Justificaciones_Temporal
            WHERE ID_JustificacionesSAC = @ID_Registro;

            DELETE FROM SAC_Justificaciones_Temporal
            WHERE ID_JustificacionesSAC = @ID_Registro;
        END
    END
END