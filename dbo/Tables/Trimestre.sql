CREATE TABLE [dbo].[Trimestre] (
    [ID_Trimestre]          INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Trimestre]        VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_PeriodoTrimestre] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_Trimestre] ASC),
    UNIQUE NONCLUSTERED ([Desc_PeriodoTrimestre] ASC),
    UNIQUE NONCLUSTERED ([Desc_Trimestre] ASC)
);

