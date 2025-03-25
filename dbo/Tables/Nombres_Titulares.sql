CREATE TABLE [dbo].[Nombres_Titulares] (
    [ID_NombreTitular]    INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Nombre_Titular] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_NombreTitular] ASC),
    UNIQUE NONCLUSTERED ([Desc_Nombre_Titular] ASC)
);

