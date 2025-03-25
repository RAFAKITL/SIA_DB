CREATE TABLE [dbo].[ClavesAPI] (
    [ID_ClavesAPI] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Clave]   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Hash]    VARCHAR (512) DEFAULT (' ') NOT NULL,
    [Desc_Salt]    VARCHAR (512) DEFAULT (' ') NOT NULL,
    [Funcion]      VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_ClavesAPI] ASC)
);

