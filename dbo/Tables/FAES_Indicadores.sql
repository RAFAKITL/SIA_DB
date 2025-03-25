CREATE TABLE [dbo].[FAES_Indicadores] (
    [ID_FAES_Indicadores]      INT           IDENTITY (1, 1) NOT NULL,
    [Clave_Indicador]          VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Variable]                 VARCHAR (255) DEFAULT (' ') NOT NULL,
    [PRIMER_TRIM]              VARCHAR (255) DEFAULT (' ') NOT NULL,
    [SEGUNDO_TRIM]             VARCHAR (255) DEFAULT (' ') NOT NULL,
    [TERCER_TRIM]              VARCHAR (255) DEFAULT (' ') NOT NULL,
    [CUARTO_TRIM]              VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Fecha]                    VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_DependenciasEvaluadas] INT           NULL,
    [id_Usuario]               INT           NULL,
    [id_Trimestre]             INT           NULL,
    [id_Anio]                  INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_FAES_Indicadores] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_DependenciasEvaluadas]) REFERENCES [dbo].[Dependencias_Evaluadas] ([ID_DependenciasEvaluadas]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

