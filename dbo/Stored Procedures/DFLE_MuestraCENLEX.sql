CREATE PROCEDURE DFLE_MuestraCENLEX
AS
BEGIN
    SELECT Siglas FROM UnidadesAcademicas
    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica
                                    WHERE Desc_SiglasTipo = 'UAAE')
END