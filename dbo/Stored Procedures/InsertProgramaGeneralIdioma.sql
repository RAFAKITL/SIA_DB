CREATE PROCEDURE InsertProgramaGeneralIdioma
    @ProgramaGeneral BIT,
    @UnidadAcademica VARCHAR(255),
    @Idioma VARCHAR(255),
    @Fecha VARCHAR(255),
    @Trimestre VARCHAR(255),
    @Anio INT,
    @CorreoUsuario VARCHAR(255),
    @GuardarEnviar VARCHAR(7),
    @ID_Registro INT
AS BEGIN
    IF @GuardarEnviar = 'Guardar'
    BEGIN
    IF (SELECT ID_ProgramaGeneralIdiomaDFLE FROM DFLE_ProgramaGeneralIdioma_Temporal WHERE ID_ProgramaGeneralIdiomaDFLE = @ID_Registro) IS NULL
        BEGIN
                INSERT INTO DFLE_ProgramaGeneralIdioma_Temporal(
                    Desc_ProgramaGeneral,
                    id_UnidadAcademica,
                    id_Idioma,
                    Fecha,
                    id_Trimestre,
                    id_Anio,
                    id_Usuario)
                VALUES(
                    @ProgramaGeneral,
                    (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @UnidadAcademica),
                    (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                    @Fecha,
                    @Trimestre,
                    (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                    (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario))
                )
            END
            ELSE
            BEGIN
                UPDATE DFLE_ProgramaGeneralIdioma_Temporal
                SET
                    Desc_ProgramaGeneral = @ProgramaGeneral,
                    id_UnidadAcademica = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @UnidadAcademica),
                    id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                    Fecha = @Fecha,
                    id_Trimestre = @Trimestre,
                    id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                    id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario))
                    WHERE ID_ProgramaGeneralIdiomaDFLE = @ID_Registro
            END
        END
        ELSE
        BEGIN
            IF (SELECT ID_ProgramaGeneralIdiomaDFLE FROM DFLE_ProgramaGeneralIdioma_Temporal WHERE ID_ProgramaGeneralIdiomaDFLE = @ID_Registro) IS NULL
            BEGIN
                INSERT INTO DFLE_ProgramaGeneralIdioma(
                    Desc_ProgramaGeneral,
                    id_UnidadAcademica,
                    id_Idioma,
                    Fecha,
                    id_Trimestre,
                    id_Anio,
                    id_Usuario)
                VALUES(
                    @ProgramaGeneral,
                    (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @UnidadAcademica),
                    (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                    @Fecha,
                    @Trimestre,
                    (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                    (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario))
                )
            END
            ELSE
            BEGIN
                INSERT INTO DFLE_ProgramaGeneralIdioma(
                    Desc_ProgramaGeneral,
                    id_UnidadAcademica,
                    id_Idioma,
                    Fecha,
                    id_Trimestre,
                    id_Anio,
                    id_Usuario)
                SELECT
                    Desc_ProgramaGeneral,
                    id_UnidadAcademica,
                    id_Idioma,
                    Fecha,
                    id_Trimestre,
                    id_Anio,
                    id_Usuario
                FROM DFLE_ProgramaGeneralIdioma_Temporal
                WHERE ID_ProgramaGeneralIdiomaDFLE = @ID_Registro;

                DELETE FROM DFLE_ProgramaGeneralIdioma_Temporal
                WHERE ID_ProgramaGeneralIdiomaDFLE = @ID_Registro
            END
        END
    END