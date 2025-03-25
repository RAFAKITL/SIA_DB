CREATE TABLE [dbo].[EntidadFederativa] (
    [ID_EntidadFederativa]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_EntidadFederativa] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_EntidadFederativa] ASC)
);

