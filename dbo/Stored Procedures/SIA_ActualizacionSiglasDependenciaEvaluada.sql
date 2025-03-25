CREATE PROCEDURE SIA_ActualizacionSiglasDependenciaEvaluada
    @AntiguasSiglasDependenciasEvaluadas varchar(255),
    @NuevasSiglasDependenciasEvaluadas varchar(255)
AS
BEGIN
    DECLARE @ID_DependenciaEvaluada INT = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @AntiguasSiglasDependenciasEvaluadas);
    IF (SELECT ID_Auditora FROM AuditoraSiglasDependenciasEvaluadas WHERE id_DependenciaEvaluada = @ID_DependenciaEvaluada) IS NULL
        BEGIN
            INSERT INTO AuditoraSiglasDependenciasEvaluadas(
                id_DependenciaEvaluada,
                Desc_ValorAntiguo,
                FechaCambio
            )VALUES(
                @ID_DependenciaEvaluada,
                @AntiguasSiglasDependenciasEvaluadas,
                GETDATE()
            );
        END
    ELSE
        BEGIN
            UPDATE AuditoraSiglasDependenciasEvaluadas
            SET Desc_ValorAntiguo = @AntiguasSiglasDependenciasEvaluadas,
                FechaCambio = GETDATE()
            WHERE id_DependenciaEvaluada = @ID_DependenciaEvaluada;
        END

    UPDATE Dependencias_Evaluadas
    SET Desc_SiglasDependencia = @NuevasSiglasDependenciasEvaluadas
    WHERE Desc_SiglasDependencia = @AntiguasSiglasDependenciasEvaluadas;
END