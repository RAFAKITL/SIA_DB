CREATE TABLE [dbo].[Numero_Telefono] (
    [ID_NumeroTelefono]    INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Numero_Telefono] VARCHAR (255) DEFAULT (' ') NULL,
    PRIMARY KEY CLUSTERED ([ID_NumeroTelefono] ASC)
);

