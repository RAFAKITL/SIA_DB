CREATE TABLE [dbo].[UnidadAprendizaje] (
    [ID_UnidadAprendizaje]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_UnidadAprendizaje] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_RamaConocimiento]    INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_UnidadAprendizaje] ASC),
    FOREIGN KEY ([id_RamaConocimiento]) REFERENCES [dbo].[RamaConocimiento] ([ID_RamaConocimiento]),
    UNIQUE NONCLUSTERED ([Desc_UnidadAprendizaje] ASC)
);

