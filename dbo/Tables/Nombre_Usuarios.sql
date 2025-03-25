CREATE TABLE [dbo].[Nombre_Usuarios] (
    [ID_NombreUsuario]    INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Nombre_Usuario] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_NombreUsuario] ASC),
    UNIQUE NONCLUSTERED ([Desc_Nombre_Usuario] ASC)
);

