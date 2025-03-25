CREATE PROCEDURE DFLE_MuestraUnidadesAcademicas
AS
BEGIN    
    SELECT Desc_Unidad_Academica, Siglas FROM UnidadesAcademicas
    WHERE id_TipoUnidadAcademica IN (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_TipoUnidadAcademica IN ('NIVEL MEDIO SUPERIOR',
                                    'NIVEL SUPERIOR',
                                    'UNIDADES ACADÉMICAS DE INVESTIGACIÓN CIENTÍFICA Y TECNOLÓGICA',
                                    'UNIDADES ACADÉMICAS DE VINCULACION Y DESARROLLO REGIONAL',
                                    'UNIDADES ACADÉMICAS DE INNOVACION E INTEGRACION DE TECNOLOGÍAS AVANZADAS',
                                    'UNIDADES ACADÉMICAS DE APOYO EDUCATIVO'));
END
