CREATE TABLE [dbo].[Palabra_Aleatoria] (
    [ID_PalabraAleatoria]    INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Palabra_Aleatoria] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_PalabraAleatoria] ASC)
);

