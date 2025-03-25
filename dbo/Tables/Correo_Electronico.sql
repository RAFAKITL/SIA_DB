CREATE TABLE [dbo].[Correo_Electronico] (
    [ID_CorreoElectronico]    INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Correo_Electronico] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_CorreoElectronico] ASC),
    UNIQUE NONCLUSTERED ([Desc_Correo_Electronico] ASC)
);

