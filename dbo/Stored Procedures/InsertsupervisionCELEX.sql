CREATE PROCEDURE InsertsupervisionCELEX
    @UnidadAcademica VARCHAR(255),
    @Supervision BIT,
    @Fecha VARCHAR(255),
    @id_Trimestre VARCHAR(255),
    @Anio INT,
    @CorreoUsuario VARCHAR(255),
    @GuardarEnviar VARCHAR(7),
    @ID_Registro INT
AS BEGIN
    IF @GuardarEnviar = 'Guardar'
    BEGIN
        IF (SELECT ID_SupervicionCelex FROM DFLE_SupervicionCelex_Temporal WHERE ID_SupervicionCelex = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_SupervicionCelex_Temporal(
                id_UnidadAcademica,
                TRIM_UNO_Supervicion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            VALUES(
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @UnidadAcademica),
                @Supervision,
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario))
                )
        END
        ELSE
        BEGIN
            UPDATE DFLE_SupervicionCelex_Temporal
            SET
                id_UnidadAcademica = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @UnidadAcademica),
                TRIM_UNO_Supervicion = @Supervision,
                Fecha = @Fecha,
                id_Trimestre = @id_Trimestre,
                id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                id_Usuario = (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario))
                WHERE ID_SupervicionCelex = @ID_Registro
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_SupervicionCelex FROM DFLE_SupervicionCelex_Temporal WHERE ID_SupervicionCelex = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO DFLE_SupervicionCelex(
                id_UnidadAcademica,
                TRIM_UNO_Supervicion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            VALUES(
                (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @UnidadAcademica),
                @Supervision,
                @Fecha,
                @id_Trimestre,
                (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio),
                (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario))
                )
        END
        ELSE
        BEGIN
            INSERT INTO DFLE_SupervicionCelex(
                id_UnidadAcademica,
                TRIM_UNO_Supervicion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario)
            SELECT
                id_UnidadAcademica,
                TRIM_UNO_Supervicion,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM DFLE_SupervicionCelex_Temporal
            WHERE ID_SupervicionCelex = @ID_Registro

            DELETE FROM DFLE_SupervicionCelex_Temporal
            WHERE ID_SupervicionCelex = @ID_Registro
        END
    END
END


