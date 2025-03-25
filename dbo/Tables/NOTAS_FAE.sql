CREATE TABLE [dbo].[NOTAS_FAE] (
    [ID_NOTAS_FAE]             INT           IDENTITY (1, 1) NOT NULL,
    [Notas]                    VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Tipo_Resumen]             VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Fecha]                    VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Area_Operativa]           VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_DependenciasEvaluadas] INT           NULL,
    [id_Usuario]               INT           NULL,
    [id_Trimestre]             INT           NULL,
    [id_Anio]                  INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_NOTAS_FAE] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_DependenciasEvaluadas]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

