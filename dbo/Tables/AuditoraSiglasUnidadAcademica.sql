CREATE TABLE [dbo].[AuditoraSiglasUnidadAcademica] (
    [ID_Auditora]        INT           IDENTITY (1, 1) NOT NULL,
    [id_UnidadAcademica] INT           NULL,
    [Desc_ValorAntiguo]  VARCHAR (255) NULL,
    [FechaCambio]        VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ID_Auditora] ASC),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica])
);

