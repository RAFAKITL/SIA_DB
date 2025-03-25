CREATE TABLE [dbo].[Contrasena_Hash] (
    [ID_ContrasenaHash]    INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Contrasena_Hash] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_ContrasenaHash] ASC)
);

