CREATE TABLE [dbo].[Cargos] (
    [ID_Cargo]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Cargo] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_Cargo] ASC)
);

