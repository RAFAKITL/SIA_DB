CREATE TABLE [dbo].[SAC_ProgramasSabatico] (
    [ID_ProgramasSabaticoSAC]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_ProgramasSabaticoSAC] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Prioridad]            VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_ProgramasSabaticoSAC] ASC)
);

