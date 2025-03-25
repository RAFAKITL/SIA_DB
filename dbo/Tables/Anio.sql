CREATE TABLE [dbo].[Anio] (
    [ID_Anio]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Anio] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_Anio] ASC),
    UNIQUE NONCLUSTERED ([Desc_Anio] ASC)
);

