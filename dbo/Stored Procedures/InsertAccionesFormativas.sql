CREATE PROCEDURE InsertAccionesFormativas
    @TipoAccion varchar(255),
    @AccionFormativa varchar(255),
    @Modalidad varchar(255),
    @Idioma varchar(255),
    @SiglasUnidadAcademica varchar(255),
    @CantidadHombres varchar(255),
    @CantidadMujeres varchar(255),
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
        IF (SELECT ID_RegistroFormato12DFLE FROM DFLE_AccionesFormativas_Temporal WHERE ID_RegistroFormato12DFLE = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_AccionesFormativas_Temporal(
                Desc_Tipo_Accion,
                Desc_AccionFormativa,
                Desc_Modalidad,
                id_Idioma,
                id_UnidadAcademica,
                Desc_Hombres,
                Desc_Mujeres,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @TipoAccion,
                @AccionFormativa,
                @Modalidad,
                (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                @CantidadHombres,
                @CantidadMujeres,
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
            UPDATE DFLE_AccionesFormativas_Temporal
            SET Desc_Tipo_Accion = @TipoAccion,
                Desc_AccionFormativa = @AccionFormativa,
                Desc_Modalidad = @Modalidad,
                id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                id_UnidadAcademica = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                Desc_Hombres = @CantidadHombres,
                Desc_Mujeres = @CantidadMujeres,
                Fecha = @Fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                    SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
                ))
            WHERE ID_RegistroFormato12DFLE = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_RegistroFormato12DFLE FROM DFLE_AccionesFormativas_Temporal WHERE ID_RegistroFormato12DFLE = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_AccionesFormativas(
                Desc_Tipo_Accion,
                Desc_AccionFormativa,
                Desc_Modalidad,
                id_Idioma,
                id_UnidadAcademica,
                Desc_Hombres,
                Desc_Mujeres,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )VALUES(
                @TipoAccion,
                @AccionFormativa,
                @Modalidad,
                (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = @Idioma),
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
                @CantidadHombres,
                @CantidadMujeres,
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
            INSERT INTO DFLE_AccionesFormativas(
                Desc_Tipo_Accion,
                Desc_AccionFormativa,
                Desc_Modalidad,
                id_Idioma,
                id_UnidadAcademica,
                Desc_Hombres,
                Desc_Mujeres,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            )
            SELECT
                Desc_Tipo_Accion,
                Desc_AccionFormativa,
                Desc_Modalidad,
                id_Idioma,
                id_UnidadAcademica,
                Desc_Hombres,
                Desc_Mujeres,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM DFLE_AccionesFormativas_Temporal
            WHERE ID_RegistroFormato12DFLE = @ID_Registro;

            DELETE FROM DFLE_AccionesFormativas_Temporal
            WHERE ID_RegistroFormato12DFLE = @ID_Registro
        END
    END
END
