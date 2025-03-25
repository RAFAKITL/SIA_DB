CREATE PROCEDURE MuestraEstadosSemaforo
AS
    BEGIN
        SELECT Desc_EstadoSemaforo,
                ColorEstado
        FROM EstadosSemaforo
    END
