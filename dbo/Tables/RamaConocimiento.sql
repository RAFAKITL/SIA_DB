CREATE TABLE [dbo].[RamaConocimiento] (
    [ID_RamaConocimiento] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NombreRama]     VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_SiglasRama]     VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_RamaConocimiento] ASC),
    UNIQUE NONCLUSTERED ([Desc_NombreRama] ASC),
    UNIQUE NONCLUSTERED ([Desc_SiglasRama] ASC)
);

