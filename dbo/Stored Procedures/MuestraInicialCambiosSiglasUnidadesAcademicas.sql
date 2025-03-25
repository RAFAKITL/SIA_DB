CREATE PROCEDURE MuestraInicialCambiosSiglasUnidadesAcademicas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ASUA.Desc_ValorAntiguo AS SiglasAntiguas,
            UA.Siglas AS SiglasNuevas 
    FROM UnidadesAcademicas UA
    RIGHT JOIN AuditoraSiglasUnidadAcademica ASUA ON UA.ID_UnidadAcademica = ASUA.id_UnidadAcademica
END