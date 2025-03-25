CREATE TABLE [dbo].[DFLE_NivelEducativo] (
    [ID_NivelEducativo]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NivelEducativo] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_NivelEducativo] ASC)
);

