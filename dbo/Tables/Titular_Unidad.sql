CREATE TABLE [dbo].[Titular_Unidad] (
    [ID_Titular]               INT IDENTITY (1, 1) NOT NULL,
    [id_NombreTitular]         INT NULL,
    [id_Cargo]                 INT NULL,
    [id_NumeroTelefono]        INT NULL,
    [id_CorreoElectronico]     INT NULL,
    [id_UnidadAcademica]       INT NULL,
    [id_DependenciasEvaluadas] INT NULL,
    [id_Grado]                 INT NULL,
    PRIMARY KEY CLUSTERED ([ID_Titular] ASC),
    FOREIGN KEY ([id_Cargo]) REFERENCES [dbo].[Cargos] ([ID_Cargo]),
    FOREIGN KEY ([id_CorreoElectronico]) REFERENCES [dbo].[Correo_Electronico] ([ID_CorreoElectronico]),
    FOREIGN KEY ([id_DependenciasEvaluadas]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas]),
    FOREIGN KEY ([id_Grado]) REFERENCES [dbo].[Grado] ([ID_Grado]),
    FOREIGN KEY ([id_NombreTitular]) REFERENCES [dbo].[Nombres_Titulares] ([ID_NombreTitular]),
    FOREIGN KEY ([id_NumeroTelefono]) REFERENCES [dbo].[Numero_Telefono] ([ID_NumeroTelefono]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica])
);

