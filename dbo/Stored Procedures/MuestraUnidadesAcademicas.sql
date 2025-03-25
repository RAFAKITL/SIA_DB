-- PROCEDMIENTO SELECT de todas las unidades academicas a elegir para la lista despleganble que se realizara para la seleccion de una Tabla UnidadesAcademicas*****
CREATE PROCEDURE MuestraUnidadesAcademicas
AS
	BEGIN
  	SELECT Siglas, Desc_Unidad_Academica FROM UnidadesAcademicas
	END;
