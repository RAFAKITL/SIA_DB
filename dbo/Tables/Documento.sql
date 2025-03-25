CREATE TABLE [dbo].[Documento] (
    [ID_Documento]           INT           IDENTITY (1, 1) NOT NULL,
    [Desc_TituloDocumento]   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_FechaCreacion]     VARCHAR (255) DEFAULT ('2000-01-01') NOT NULL,
    [id_EstadoActual]        INT           NULL,
    [id_DependenciaEvaluada] INT           NULL,
    [id_Trimestre]           INT           NULL,
    [id_Anio]                INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_Documento] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_DependenciaEvaluada]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas]),
    FOREIGN KEY ([id_EstadoActual]) REFERENCES [dbo].[EstadosSemaforo] ([ID_EstadosSemaforo]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre])
);

