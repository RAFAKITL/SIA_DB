﻿CREATE PROCEDURE DFLE_MuestraSiglasTipoUnidadAcademica
AS 
BEGIN
    SELECT 'NMS' AS TipoUnidadAcademica UNION ALL
    SELECT 'NS' UNION ALL
    SELECT 'C INV' UNION ALL
    SELECT 'UAVDR' UNION ALL
    SELECT 'CIITA' UNION ALL
    SELECT 'UAAE' UNION ALL
    SELECT 'TOTAL' ;
END
