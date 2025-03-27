CREATE TABLE [dbo].[UnidadesAcademicas] (
    [ID_UnidadAcademica]     INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Unidad_Academica]  VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Siglas]                 VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Clave]                  VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Fecha_Fundacion]   DATE          DEFAULT ('2008-11-11') NOT NULL,
    [id_Entidad_Federativa]  INT           NULL,
    [id_TipoUnidadAcademica] INT           NULL,
    [id_RamaConocimiento]    INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_UnidadAcademica] ASC),
    FOREIGN KEY ([id_Entidad_Federativa]) REFERENCES [dbo].[EntidadFederativa] ([ID_EntidadFederativa]),
    FOREIGN KEY ([id_RamaConocimiento]) REFERENCES [dbo].[RamaConocimiento] ([ID_RamaConocimiento]),
    FOREIGN KEY ([id_TipoUnidadAcademica]) REFERENCES [dbo].[TipoUnidadAcademica] ([ID_TipoUnidadAcademica]),
    UNIQUE NONCLUSTERED ([Desc_Unidad_Academica] ASC)
);

