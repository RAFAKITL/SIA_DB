CREATE PROCEDURE MuestraEstadoDocumentoNombre
    @NombreDocumento varchar(255)
AS
BEGIN
    DECLARE @Estado varchar(255);

    -- Obtener el estado del documento
    SELECT @Estado = ES.Desc_EstadoSemaforo
    FROM Documento D
    LEFT JOIN EstadosSemaforo ES ON D.id_EstadoActual = ES.ID_EstadosSemaforo
    WHERE D.Desc_TituloDocumento = @NombreDocumento;

    -- Verificar si el estado es NULL y retornar la columna con el alias unificado
    IF @Estado IS NULL
    BEGIN
        SELECT 'No Capturado' AS Estado;
    END
    ELSE
    BEGIN
        SELECT @Estado AS Estado;
    END
END;