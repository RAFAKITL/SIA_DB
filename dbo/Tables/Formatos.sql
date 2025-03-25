CREATE TABLE [dbo].[Formatos] (
    [ID_Formato]             INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NumeroFormato]     INT           DEFAULT ('0') NOT NULL,
    [Desc_Clave]             VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_NombreDocumento]   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_DependenciaEvaluada] INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_Formato] ASC),
    FOREIGN KEY ([id_DependenciaEvaluada]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas])
);

