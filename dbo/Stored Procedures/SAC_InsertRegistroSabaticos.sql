CREATE PROCEDURE SAC_InsertRegistroSabaticos
    @CantidadHombres INT,
    @CantidadMujeres INT,
    @SiglasUnidadAcademica varchar(255),
    @NombreProgramaSabatico varchar(255),
    @NumeroFormatoSAC INT,
    @AnioSemestre varchar(255),
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
        IF (SELECT ID_RegistroSabaticosSAC
            FROM SAC_RegistroSabaticos_Temporal
            WHERE ID_RegistroSabaticosSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroSabaticos_Temporal(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_ProgramasSabaticoSAC,
                id_FormatoSAC,
                id_AnioSemestre,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario) 
                VALUES (
                    @CantidadHombres,
                    @CantidadMujeres,
                    (SELECT ID_UnidadAcademica 
                    FROM UnidadesAcademicas
                    WHERE Siglas = @SiglasUnidadAcademica),
                    (SELECT ID_ProgramasSabaticoSAC 
                    FROM SAC_ProgramasSabatico
                    WHERE Desc_ProgramasSabaticoSAC = @NombreProgramaSabatico),
                    (SELECT ID_Formato 
                    FROM Formatos
                    WHERE Desc_NumeroFormato = @NumeroFormatoSAC
                    AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas 
                                                    FROM Dependencias_Evaluadas
                                                    WHERE Desc_SiglasDependencia = 'SAC')),
                    (SELECT ID_AnioSemestreSAC
                    FROM SAC_AnioSemestre
                    WHERE Desc_AnioSemestreSAC = @AnioSemestre),
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
            UPDATE SAC_RegistroSabaticos_Temporal
            SET 
                Desc_Hombres = @CantidadHombres,
                Desc_Mujeres = @CantidadMujeres,
                id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica 
                                        FROM UnidadesAcademicas
                                        WHERE Siglas = @SiglasUnidadAcademica),
                id_ProgramasSabaticoSAC = (SELECT ID_ProgramasSabaticoSAC 
                                        FROM SAC_ProgramasSabatico
                                        WHERE Desc_ProgramasSabaticoSAC = @NombreProgramaSabatico),
                id_FormatoSAC = (SELECT ID_Formato 
                                FROM Formatos
                                WHERE Desc_NumeroFormato = @NumeroFormatoSAC
                                AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas 
                                                                FROM Dependencias_Evaluadas
                                                                WHERE Desc_SiglasDependencia = 'SAC')),
                id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                    FROM SAC_AnioSemestre
                                    WHERE Desc_AnioSemestreSAC = @AnioSemestre),
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
            WHERE ID_RegistroSabaticosSAC = @ID_Registro;
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_RegistroSabaticosSAC
            FROM SAC_RegistroSabaticos_Temporal
            WHERE ID_RegistroSabaticosSAC = @ID_Registro) IS NULL
        BEGIN
        INSERT INTO SAC_RegistroSabaticos(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_ProgramasSabaticoSAC,
                id_FormatoSAC,
                id_AnioSemestre,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario) 
                VALUES (
                    @CantidadHombres,
                    @CantidadMujeres,
                    (SELECT ID_UnidadAcademica 
                    FROM UnidadesAcademicas
                    WHERE Siglas = @SiglasUnidadAcademica),
                    (SELECT ID_ProgramasSabaticoSAC 
                    FROM SAC_ProgramasSabatico
                    WHERE Desc_ProgramasSabaticoSAC = @NombreProgramaSabatico),
                    (SELECT ID_Formato 
                    FROM Formatos
                    WHERE Desc_NumeroFormato = @NumeroFormatoSAC
                    AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas 
                                                    FROM Dependencias_Evaluadas
                                                    WHERE Desc_SiglasDependencia = 'SAC')),
                    (SELECT ID_AnioSemestreSAC
                    FROM SAC_AnioSemestre
                    WHERE Desc_AnioSemestreSAC = @AnioSemestre),
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
            INSERT INTO SAC_RegistroSabaticos(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_ProgramasSabaticoSAC,
                id_FormatoSAC,
                id_AnioSemestre,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            SELECT
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_ProgramasSabaticoSAC,
                id_FormatoSAC,
                id_AnioSemestre,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM SAC_RegistroSabaticos_Temporal
            WHERE ID_RegistroSabaticosSAC = @ID_Registro;

            DELETE FROM SAC_RegistroSabaticos_Temporal
            WHERE ID_RegistroSabaticosSAC = @ID_Registro;
        END
    END
END