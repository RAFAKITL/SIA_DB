--PROCEDIMIENTO ara mostrar la informacion de los usuarios (no id) Tabla Usuarios_General
CREATE PROCEDURE MuestraUsuariosTotales
AS
BEGIN
	SELECT 
			NU.Desc_Nombre_Usuario,
			EB.Desc_Estatus_Bloqueo,
			ED.Desc_Estatus_Deshabilitado,
			CE.Desc_Correo_Electronico,
			UA.Desc_Unidad_Academica,
			C.Desc_Cargo,
			NT.Desc_Numero_Telefono,
			RDS.Desc_Rol,
			DE.Desc_DependenciasEvaluadas,
			G.Desc_Grado
	FROM Usuario_General UG
	JOIN Nombre_Usuarios NU ON UG.id_NombreUsuario = NU.ID_NombreUsuario
	JOIN Estatus_Bloqueado EB ON UG.id_EstatusBloqueo = EB.ID_EstatusBloqueo
	JOIN Estatus_Deshabilitado ED ON UG.id_EstatusDeshabilitado = ED.ID_EstatusDeshabilitado
	JOIN Correo_Electronico CE ON UG.id_CorreoElectronico = CE.ID_CorreoElectronico
	JOIN UnidadesAcademicas UA ON UG.id_UnidadAcademica = UA.ID_UnidadAcademica
	JOIN Cargos C ON UG.id_Cargo = C.ID_Cargo
	JOIN Numero_Telefono NT ON UG.id_NumeroTelefono = NT.ID_NumeroTelefono
	JOIN Rol_Dentro_Del_Sistema RDS ON UG.id_Rol = RDS.ID_Rol
	JOIN Dependencias_Evaluadas DE ON UG.id_DependenciasEvaluadas = DE.ID_DependenciasEvaluadas
	JOIN Grado G ON UG.id_Grado = G.ID_Grado
END;
