CREATE PROCEDURE MuestraInicialCambiosSiglasDependenciasEvaluadas
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ASDE.Desc_ValorAntiguo AS SiglasAntiguas,
            DE.Desc_SiglasDependencia AS SiglasNuevas 
    FROM Dependencias_Evaluadas DE
    RIGHT JOIN AuditoraSiglasDependenciasEvaluadas ASDE ON DE.Desc_SiglasDependencia = ASDE.id_DependenciaEvaluada
END