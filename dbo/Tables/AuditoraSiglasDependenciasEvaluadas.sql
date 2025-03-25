CREATE TABLE [dbo].[AuditoraSiglasDependenciasEvaluadas] (
    [ID_Auditora]            INT           IDENTITY (1, 1) NOT NULL,
    [id_DependenciaEvaluada] INT           NULL,
    [Desc_ValorAntiguo]      VARCHAR (255) NULL,
    [FechaCambio]            VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ID_Auditora] ASC),
    FOREIGN KEY ([id_DependenciaEvaluada]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas])
);

