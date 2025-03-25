CREATE TABLE [dbo].[recuperacionContra] (
    [id]               INT           IDENTITY (1, 1) NOT NULL,
    [clave_temporal]   VARCHAR (255) NOT NULL,
    [palabra_random]   VARCHAR (255) NOT NULL,
    [fecha]            VARCHAR (255) NOT NULL,
    [hora_creacion]    VARCHAR (255) NOT NULL,
    [hora_vencimiento] VARCHAR (255) NOT NULL,
    [id_correo]        INT           NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([id_correo]) REFERENCES [dbo].[Correo_Electronico] ([ID_CorreoElectronico])
);

