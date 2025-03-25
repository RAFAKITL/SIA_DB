CREATE TABLE [dbo].[DFLE_NivelesCompetencia] (
    [ID_Competencia]        INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NivelCompetencia] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_Competencia] ASC)
);

