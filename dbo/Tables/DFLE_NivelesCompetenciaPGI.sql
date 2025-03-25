CREATE TABLE [dbo].[DFLE_NivelesCompetenciaPGI] (
    [ID_CompetenciaPGI]        INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NivelCompetenciaPGI] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_CompetenciaPGI] ASC)
);

