CREATE PROCEDURE SAC_InsertRegistroCantidadesTipoLCGS
    @SiglasUnidadAcademica varchar(255),
    @NombreTipoEstudio varchar(255),
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
        IF (SELECT ID_RegistroCantidadesTipoLCGSSAC
            FROM SAC_RegistroCantidadesTipoLCGS_Temporal
            WHERE ID_RegistroCantidadesTipoLCGSSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroCantidadesTipoLCGS_Temporal(
                id_UnidadAcademicaSAC,
                id_TipoEstudioLCGSSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario) 
            VALUES (
                (SELECT ID_UnidadAcademica 
                FROM UnidadesAcademicas
                WHERE Siglas = @SiglasUnidadAcademica),
                (SELECT ID_TipoEstudioLCGSSAC 
                FROM SAC_TipoEstudioLCGS
                WHERE Desc_TipoEstudioLCGSSAC = @NombreTipoEstudio),
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
            UPDATE SAC_RegistroCantidadesTipoLCGS_Temporal
            SET
                id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica 
                                    FROM UnidadesAcademicas
                                    WHERE Siglas = @SiglasUnidadAcademica),
                id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC 
                                        FROM SAC_TipoEstudioLCGS
                                        WHERE Desc_TipoEstudioLCGSSAC = @NombreTipoEstudio),
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
            WHERE ID_RegistroCantidadesTipoLCGSSAC = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_RegistroCantidadesTipoLCGSSAC
            FROM SAC_RegistroCantidadesTipoLCGS
            WHERE ID_RegistroCantidadesTipoLCGSSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroCantidadesTipoLCGS(
                id_UnidadAcademicaSAC,
                id_TipoEstudioLCGSSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario) 
            VALUES (
                (SELECT ID_UnidadAcademica 
                FROM UnidadesAcademicas
                WHERE Siglas = @SiglasUnidadAcademica),
                (SELECT ID_TipoEstudioLCGSSAC 
                FROM SAC_TipoEstudioLCGS
                WHERE Desc_TipoEstudioLCGSSAC = @NombreTipoEstudio),
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
            INSERT INTO SAC_RegistroCantidadesTipoLCGS(
                id_UnidadAcademicaSAC,
                id_TipoEstudioLCGSSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            SELECT
                id_UnidadAcademicaSAC,
                id_TipoEstudioLCGSSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM SAC_RegistroCantidadesTipoLCGS_Temporal
            WHERE ID_RegistroCantidadesTipoLCGSSAC = @ID_Registro

            DELETE FROM SAC_RegistroCantidadesTipoLCGS_Temporal
            WHERE ID_RegistroCantidadesTipoLCGSSAC = @ID_Registro
        END
    END
END