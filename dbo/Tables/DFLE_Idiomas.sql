CREATE TABLE [dbo].[DFLE_Idiomas] (
    [ID_Idioma]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Idioma] VARCHAR (255) DEFAULT (' ') NULL,
    [Desc_PGI]    VARCHAR (10)  DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_Idioma] ASC)
);

