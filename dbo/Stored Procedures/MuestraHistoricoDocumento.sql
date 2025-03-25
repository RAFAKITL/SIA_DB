CREATE PROCEDURE MuestraHistoricoDocumento
    @TituloDocumento varchar(255)
AS 
    BEGIN 
        SELECT 
            ES.Desc_EstadoSemaforo,
            SD.Desc_FechaCambio,
            Desc_Comentario
        FROM SeguimientoDocumentos SD
        JOIN EstadosSemaforo ES ON SD.id_Estado = ES.ID_EstadosSemaforo
        WHERE SD.id_Documento = (
            SELECT ID_Documento 
            FROM Documento
            WHERE Desc_TituloDocumento = @TituloDocumento 
        )
    END