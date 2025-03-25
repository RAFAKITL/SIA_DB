-- Autor: RAFAKITL

CREATE PROCEDURE SAC_InsertRegistroEstimulosAlDesempenioDocente
    @CantidadHombres varchar(255),
    @CantidadMujeres varchar(255),
    @SiglasUnidadAcademica varchar(255),
    @PeriodoSAC INT,
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
        IF (SELECT ID_RegistroEstimulosAlDesempenioDocenteSAC FROM SAC_RegistroEstimulosAlDesempenioDocente_Temporal WHERE ID_RegistroEstimulosAlDesempenioDocenteSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroEstimulosAlDesempenioDocente_Temporal(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                Desc_PeriodoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @CantidadHombres,
                @CantidadMujeres,
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                @PeriodoSAC,
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
            UPDATE SAC_RegistroEstimulosAlDesempenioDocente_Temporal
            SET Desc_Hombres = @CantidadHombres,
                Desc_Mujeres = @CantidadMujeres,
                id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                Desc_PeriodoSAC = @PeriodoSAC,
                id_FormatoSAC = (SELECT ID_Formato FROM Formatos WHERE Desc_NumeroFormato = @NumeroFormato AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                                                        FROM Dependencias_Evaluadas
                                                                                                                        WHERE Desc_SiglasDependencia = 'SAC')),
                Fecha = @Fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ));
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_RegistroEstimulosAlDesempenioDocenteSAC FROM SAC_RegistroEstimulosAlDesempenioDocente_Temporal WHERE ID_RegistroEstimulosAlDesempenioDocenteSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroEstimulosAlDesempenioDocente(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                Desc_PeriodoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @CantidadHombres,
                @CantidadMujeres,
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                @PeriodoSAC,
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
            INSERT INTO SAC_RegistroEstimulosAlDesempenioDocente(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                Desc_PeriodoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )SELECT
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                Desc_PeriodoSAC,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM SAC_RegistroEstimulosAlDesempenioDocente_Temporal
            WHERE ID_RegistroEstimulosAlDesempenioDocenteSAC = @ID_Registro;

            DELETE FROM SAC_RegistroEstimulosAlDesempenioDocente_Temporal
            WHERE ID_RegistroEstimulosAlDesempenioDocenteSAC = @ID_Registro;
        END
    END
END
