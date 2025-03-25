-- Author: Jesus Perez Gonzalez ESCOM
CREATE PROCEDURE SAC_InsertRegistroLicenciasConGoceDeSueldo
    @CantidadHombres INT,
    @CantidadMujeres INT,
    @SiglasUnidadAcademica VARCHAR(255),
    @Estado VARCHAR(255),
    @Origen VARCHAR(255),
    @FormatoSAC VARCHAR(255),
    @Fecha VARCHAR(255),
    @id_Trimestre INT,
    @Anio INT,
    @CorreoUsuario VARCHAR(255),
    @GuardarEnviar VARCHAR(7),
    @ID_Registro INT
AS
BEGIN
    IF @GuardarEnviar = 'Guardar'
    BEGIN
        IF (SELECT ID_RegistroLicenciasConGoceDeSueldoSAC
            FROM SAC_RegistroLicenciasConGoceDeSueldo_Temporal
            WHERE ID_RegistroLicenciasConGoceDeSueldoSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroLicenciasConGoceDeSueldo_Temporal(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_EstadoLCGSSAC,
                id_Origen,
                id_FormatoSAC,
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
                    (SELECT ID_EstadoLCGSSAC
                        FROM SAC_EstadoLCGS
                        WHERE Desc_EstadoLCGSSAC = @Estado),
                    (SELECT ID_OriginSAC
                        FROM SAC_Origen
                        WHERE Desc_OriginSAC = @Origen),
                    (SELECT ID_Formato
                        FROM Formatos
                        WHERE Desc_NombreDocumento = @FormatoSAC),
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
            UPDATE SAC_RegistroLicenciasConGoceDeSueldo_Temporal
            SET
                Desc_Hombres = @CantidadHombres,
                Desc_Mujeres = @CantidadMujeres,
                id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica 
                                        FROM UnidadesAcademicas
                                        WHERE Siglas = @SiglasUnidadAcademica),
                id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC
                                    FROM SAC_EstadoLCGS
                                    WHERE Desc_EstadoLCGSSAC = @Estado),
                id_Origen = (SELECT ID_OriginSAC
                            FROM SAC_Origen
                            WHERE Desc_OriginSAC = @Origen),
                id_FormatoSAC = (SELECT ID_Formato
                                FROM Formatos
                                WHERE Desc_NombreDocumento = @FormatoSAC),
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
            WHERE ID_RegistroLicenciasConGoceDeSueldoSAC = @ID_Registro;
        END
    END
    ELSE
    BEGIN
        IF (SELECT ID_RegistroLicenciasConGoceDeSueldoSAC
            FROM SAC_RegistroLicenciasConGoceDeSueldo_Temporal
            WHERE ID_RegistroLicenciasConGoceDeSueldoSAC = @ID_Registro) IS NULL
        BEGIN
            INSERT INTO SAC_RegistroLicenciasConGoceDeSueldo(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_EstadoLCGSSAC,
                id_Origen,
                id_FormatoSAC,
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
                    (SELECT ID_EstadoLCGSSAC
                        FROM SAC_EstadoLCGS
                        WHERE Desc_EstadoLCGSSAC = @Estado),
                    (SELECT ID_OriginSAC
                        FROM SAC_Origen
                        WHERE Desc_OriginSAC = @Origen),
                    (SELECT ID_Formato
                        FROM Formatos
                        WHERE Desc_NombreDocumento = @FormatoSAC),
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
            INSERT INTO SAC_RegistroLicenciasConGoceDeSueldo(
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_EstadoLCGSSAC,
                id_Origen,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario) 
            SELECT
                Desc_Hombres,
                Desc_Mujeres,
                id_UnidadAcademicaSAC,
                id_EstadoLCGSSAC,
                id_Origen,
                id_FormatoSAC,
                Fecha,
                id_Trimestre,
                id_Anio,
                id_Usuario
            FROM SAC_RegistroLicenciasConGoceDeSueldo_Temporal
            WHERE ID_RegistroLicenciasConGoceDeSueldoSAC = @ID_Registro;

            DELETE FROM SAC_RegistroLicenciasConGoceDeSueldo_Temporal
            WHERE ID_RegistroLicenciasConGoceDeSueldoSAC = @ID_Registro;
        END
    END
END