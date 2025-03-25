CREATE PROCEDURE InsertAlumnosLenguasPGI
    @CantidadHombres INT,
    @CantidadMujeres INT,
    @SiglasUnidadAcademica varchar(255),
    @Idioma varchar(255),
    @Competencia varchar(255),
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
        IF (SELECT ID_AlumnosLenguasPGI FROM DFLE_AlumnosLenguasPGI_Temporal WHERE ID_AlumnosLenguasPGI = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_AlumnosLenguasPGI_Temporal(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademica,
                id_Idioma,
                id_CompetenciaPGI,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @CantidadHombres,
                @CantidadMujeres,
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                (SELECT ID_CompetenciaPGI FROM DFLE_NivelesCompetenciaPGI WHERE Desc_NivelCompetenciaPGI = @Competencia),
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            )
        END
        ELSE
        BEGIN
            UPDATE DFLE_AlumnosLenguasPGI_Temporal
            SET Desc_Hombres = @CantidadHombres,
                Desc_Mujeres = @CantidadMujeres,
                id_UnidadAcademica = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                id_CompetenciaPGI = (SELECT ID_CompetenciaPGI FROM DFLE_NivelesCompetenciaPGI WHERE Desc_NivelCompetenciaPGI = @Competencia),
                Fecha = @Fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            WHERE ID_AlumnosLenguasPGI = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_AlumnosLenguasPGI FROM DFLE_AlumnosLenguasPGI_Temporal WHERE ID_AlumnosLenguasPGI = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_AlumnosLenguasPGI(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademica,
                id_Idioma,
                id_CompetenciaPGI,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @CantidadHombres,
                @CantidadMujeres,
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                (SELECT ID_CompetenciaPGI FROM DFLE_NivelesCompetenciaPGI WHERE Desc_NivelCompetenciaPGI = @Competencia),
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            )
        END
        ELSE
        BEGIN
            INSERT INTO DFLE_AlumnosLenguasPGI(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademica,
                id_Idioma,
                id_CompetenciaPGI,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            SELECT
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademica,
                id_Idioma,
                id_CompetenciaPGI,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM DFLE_AlumnosLenguasPGI_Temporal
            WHERE ID_AlumnosLenguasPGI = @ID_Registro

            DELETE FROM DFLE_AlumnosLenguasPGI_Temporal
            WHERE ID_AlumnosLenguasPGI = @ID_Registro
        END
    END
END