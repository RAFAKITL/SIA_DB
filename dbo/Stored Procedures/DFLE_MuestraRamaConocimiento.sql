CREATE PROCEDURE DFLE_MuestraRamaConocimiento
AS
BEGIN
    SELECT Desc_NombreRama, Desc_SiglasRama FROM RamaConocimiento;
END