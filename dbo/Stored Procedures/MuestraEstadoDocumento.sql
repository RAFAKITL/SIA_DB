CREATE PROCEDURE MuestraEstadoDocumento
    @SiglasDependencia varchar(255),
    @Anio varchar(4),
    @Trimestre INT
AS
    BEGIN
        SELECT D.Desc_TituloDocumento,
                ES.Desc_EstadoSemaforo
        FROM Documento D
        JOIN EstadosSemaforo ES ON D.id_EstadoActual = ES.ID_EstadosSemaforo
        WHERE D.id_DependenciaEvaluada = (
            SELECT ID_DependenciasEvaluadas 
            FROM Dependencias_Evaluadas
            WHERE Desc_SiglasDependencia = @SiglasDependencia
        )
        AND D.id_Anio = (
            SELECT ID_Anio 
            FROM Anio
            WHERE Desc_Anio = @Anio
        )
        AND D.id_Trimestre = @Trimestre
    END;