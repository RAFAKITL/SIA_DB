CREATE PROCEDURE SAC_InsertRegistroEDDMontosPagados
    @Desc_MontoPagado INT,
    @SiglasUnidadAcademica varchar(255),
    @NumeroFormato INT,
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
        IF (SELECT ID_RegistroEDDMontosPagadosSAC FROM SAC_RegistroEDDMontosPagados_Temporal WHERE ID_RegistroEDDMontosPagadosSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroEDDMontosPagados_Temporal(
                Desc_MontoPagado,
                id_UnidadAcademicaSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @Desc_MontoPagado,
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @NumeroFormato AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                                                        FROM Dependencias_Evaluadas
                                                                                                                        WHERE Desc_SiglasDependencia = 'SAC')),
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            );
        END
        ELSE
        BEGIN
            UPDATE SAC_RegistroEDDMontosPagados_Temporal
            SET Desc_MontoPagado = @Desc_MontoPagado,
                id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                id_FormatoSAC = (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @NumeroFormato AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas 
                                                                                                                        FROM Dependencias_Evaluadas
                                                                                                                        WHERE Desc_DependenciasEvaluadas = 'SAC')),
                Fecha = @Fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            WHERE ID_RegistroEDDMontosPagadosSAC = @ID_Registro;
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_RegistroEDDMontosPagadosSAC FROM SAC_RegistroEDDMontosPagados_Temporal WHERE ID_RegistroEDDMontosPagadosSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroEDDMontosPagados(
                Desc_MontoPagado,
                id_UnidadAcademicaSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @Desc_MontoPagado,
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @NumeroFormato AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                                                        FROM Dependencias_Evaluadas
                                                                                                                        WHERE Desc_SiglasDependencia = 'SAC')),
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            );
        END
        ELSE
        BEGIN
            INSERT INTO SAC_RegistroEDDMontosPagados(
                Desc_MontoPagado,
                id_UnidadAcademicaSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )SELECT
                Desc_MontoPagado,
                id_UnidadAcademicaSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM SAC_RegistroEDDMontosPagados_Temporal
            WHERE ID_RegistroEDDMontosPagadosSAC = @ID_Registro;

            DELETE FROM SAC_RegistroEDDMontosPagados_Temporal WHERE ID_RegistroEDDMontosPagadosSAC = @ID_Registro;
        END
    END
END