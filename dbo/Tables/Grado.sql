CREATE TABLE [dbo].[Grado] (
    [ID_Grado]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Grado] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_Grado] ASC)
);

