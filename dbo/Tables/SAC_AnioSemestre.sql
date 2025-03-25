CREATE TABLE [dbo].[SAC_AnioSemestre] (
    [ID_AnioSemestreSAC]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_AnioSemestreSAC] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_AnioSemestreSAC] ASC)
);

