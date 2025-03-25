--PROCEDIMIENTO SELECT a los roles dentro del sistema para la lista desplegable Tabla Rol_Dentro_Del_Sistema
-- con base en la Dependencia Evaluada a la que responden *****
CREATE PROCEDURE MuestraRolDentroDelSistema
    @SiglasDependencia varchar(255)
AS
BEGIN
	SELECT Desc_Rol FROM Rol_Dentro_Del_Sistema
    WHERE id_Dependencia = (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia)
END;