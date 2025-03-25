CREATE TABLE [dbo].[Rol_Dentro_Del_Sistema] (
    [ID_Rol]         INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Rol]       VARCHAR (255) DEFAULT (' ') NULL,
    [id_Dependencia] INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_Rol] ASC),
    FOREIGN KEY ([id_Dependencia]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas])
);

