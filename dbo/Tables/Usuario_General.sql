﻿CREATE TABLE [dbo].[Usuario_General] (
    [ID_Usuario]               INT IDENTITY (1, 1) NOT NULL,
    [id_NombreUsuario]         INT NULL,
    [id_ContrasenaHash]        INT NULL,
    [id_PalabraAleatoria]      INT NULL,
    [id_EstatusBloqueo]        INT NULL,
    [id_EstatusDeshabilitado]  INT NULL,
    [id_CorreoElectronico]     INT NULL,
    [id_UnidadAcademica]       INT NULL,
    [id_Cargo]                 INT NULL,
    [id_NumeroTelefono]        INT NULL,
    [id_Rol]                   INT NULL,
    [id_DependenciasEvaluadas] INT NULL,
    [id_Grado]                 INT NULL,
    PRIMARY KEY CLUSTERED ([ID_Usuario] ASC),
    FOREIGN KEY ([id_Cargo]) REFERENCES [dbo].[Cargos] ([ID_Cargo]),
    FOREIGN KEY ([id_ContrasenaHash]) REFERENCES [dbo].[Contrasena_Hash] ([ID_ContrasenaHash]),
    FOREIGN KEY ([id_CorreoElectronico]) REFERENCES [dbo].[Correo_Electronico] ([ID_CorreoElectronico]),
    FOREIGN KEY ([id_DependenciasEvaluadas]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas]),
    FOREIGN KEY ([id_EstatusBloqueo]) REFERENCES [dbo].[Estatus_Bloqueado] ([ID_EstatusBloqueo]),
    FOREIGN KEY ([id_EstatusDeshabilitado]) REFERENCES [dbo].[Estatus_Deshabilitado] ([ID_EstatusDeshabilitado]),
    FOREIGN KEY ([id_Grado]) REFERENCES [dbo].[Grado] ([ID_Grado]),
    FOREIGN KEY ([id_NombreUsuario]) REFERENCES [dbo].[Nombre_Usuarios] ([ID_NombreUsuario]),
    FOREIGN KEY ([id_NumeroTelefono]) REFERENCES [dbo].[Numero_Telefono] ([ID_NumeroTelefono]),
    FOREIGN KEY ([id_PalabraAleatoria]) REFERENCES [dbo].[Palabra_Aleatoria] ([ID_PalabraAleatoria]),
    FOREIGN KEY ([id_Rol]) REFERENCES [dbo].[Rol_Dentro_Del_Sistema] ([ID_Rol]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica])
);

