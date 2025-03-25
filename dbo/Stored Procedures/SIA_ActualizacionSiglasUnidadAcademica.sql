CREATE PROCEDURE SIA_ActualizacionSiglasUnidadAcademica
    @AntiguasSiglasUnidadAcademica varchar(255),
    @NuevasSiglasUnidadAcademica varchar(255)
AS
BEGIN
    DECLARE @ID_UnidadAcademica INT = (SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @AntiguasSiglasUnidadAcademica);
    IF (SELECT ID_Auditora FROM AuditoraSiglasUnidadAcademica WHERE id_UnidadAcademica = @ID_UnidadAcademica) IS NULL
        BEGIN
            INSERT INTO AuditoraSiglasUnidadAcademica(
                id_UnidadAcademica,
                Desc_ValorAntiguo,
                FechaCambio
            )VALUES(
                @ID_UnidadAcademica,
                @AntiguasSiglasUnidadAcademica,
                GETDATE()
            );
        END
    ELSE
        BEGIN
            UPDATE AuditoraSiglasUnidadAcademica
            SET Desc_ValorAntiguo = @AntiguasSiglasUnidadAcademica,
                FechaCambio = GETDATE()
            WHERE id_UnidadAcademica = @ID_UnidadAcademica;
        END

    UPDATE UnidadesAcademicas
    SET Siglas = @NuevasSiglasUnidadAcademica
    WHERE Siglas = @AntiguasSiglasUnidadAcademica;
END