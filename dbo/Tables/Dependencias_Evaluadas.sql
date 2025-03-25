CREATE TABLE [dbo].[Dependencias_Evaluadas] (
    [ID_DependenciasEvaluadas]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_DependenciasEvaluadas] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_SiglasDependencia]     VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Logo]                  VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_DependenciasEvaluadas] ASC)
);

