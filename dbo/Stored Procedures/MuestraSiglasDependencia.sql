--PROCEDIMIENTO SELECT a la dependencia evaluada para la lista desplegable Tabla Dependencias_Evaluadas *******
CREATE PROCEDURE MuestraSiglasDependencia
AS
	BEGIN
	SELECT Desc_SiglasDependencia, Desc_DependenciasEvaluadas FROM Dependencias_Evaluadas
	END;