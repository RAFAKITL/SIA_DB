CREATE PROCEDURE DFLE_JustificacionesTotales
    @NumeroFormato INT,
    @id_Trimestre INT,
    @Anio INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Desc_Justificacion 
    FROM DFLE_JustificacionesTotalesFormatos
    WHERE id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                        FROM Formatos 
                                        WHERE Desc_NumeroFormato = @NumeroFormato)
    AND id_Trimestre = @id_Trimestre
    AND id_Anio = (SELECT ID_Anio 
                    FROM Anio 
                    WHERE Desc_Anio = @Anio)
END