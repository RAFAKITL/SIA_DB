--PROCEDIMIENTO para ingresar un nuevo usuario Tabla Usuario_General
CREATE PROCEDURE CreacionUsuario 
	@NombreUsuario varchar(255), 
	@Contrasena varchar(255),
	@Palabra_Aleatoria varchar(255),
	@Correo_Electronico varchar(255),
	@SiglasUnidadAcademica varchar(255),
	@Cargo varchar(255),
	@Numero_Telefono varchar(255),
	@Rol varchar(255),
	@SiglasDependencia_Evaluada varchar(255),
	@Grado varchar(255)
AS
BEGIN
	INSERT INTO Nombre_Usuarios (Desc_Nombre_Usuario)
	VALUES (@NombreUsuario)

	INSERT INTO Contrasena_Hash (Desc_Contrasena_Hash)
	VALUES (@Contrasena)

	INSERT INTO Palabra_Aleatoria (Desc_Palabra_Aleatoria)
	VALUES (@Palabra_Aleatoria)

	INSERT INTO Correo_Electronico (Desc_Correo_Electronico)
	VALUES(@Correo_Electronico)

	INSERT INTO Numero_Telefono (Desc_Numero_Telefono) 
	VALUES (@Numero_Telefono);

	IF NOT EXISTS (SELECT ID_Grado FROM Grado WHERE Desc_Grado = @Grado)
		BEGIN
			INSERT INTO Grado(Desc_Grado)
			VALUES (@Grado)
        END

	IF NOT EXISTS (SELECT ID_Cargo FROM Cargos WHERE Desc_Cargo = @Cargo)
        BEGIN
            INSERT INTO Cargos(Desc_Cargo)
            VALUES (@Cargo)
        END

	INSERT INTO Usuario_General(id_NombreUsuario, 
								id_ContrasenaHash, 
								id_PalabraAleatoria, 
								id_EstatusBloqueo, 
								id_EstatusDeshabilitado, 
								id_CorreoElectronico, 
								id_UnidadAcademica, 
								id_Cargo, 
								id_NumeroTelefono, 
								id_Rol, 
								id_DependenciasEvaluadas,
								id_Grado)
	VALUES (
		(SELECT ID_NombreUsuario FROM Nombre_Usuarios WHERE Desc_Nombre_Usuario = @NombreUsuario), 
		(SELECT ID_ContrasenaHash FROM Contrasena_Hash WHERE Desc_Contrasena_Hash = @Contrasena), 
		(SELECT ID_PalabraAleatoria FROM Palabra_Aleatoria WHERE Desc_Palabra_Aleatoria = @Palabra_Aleatoria), 
		1, 
		1, 
		(SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @Correo_Electronico), 
		(SELECT ID_UnidadAcademica FROM UnidadesAcademicas WHERE Siglas = @SiglasUnidadAcademica),
		(SELECT ID_Cargo FROM Cargos WHERE Desc_Cargo = @Cargo), 
		(SELECT ID_NumeroTelefono FROM Numero_Telefono WHERE Desc_Numero_Telefono = @Numero_Telefono), 
		(SELECT ID_Rol FROM Rol_Dentro_Del_Sistema WHERE Desc_Rol = @Rol),
		(SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia_Evaluada),
		(SELECT ID_Grado FROM Grado WHERE Desc_Grado = @Grado))
END;
