CREATE TABLE [dbo].[TipoUnidadAcademica] (
    [ID_TipoUnidadAcademica]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_TipoUnidadAcademica] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_SiglasTipo]          VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_TipoUnidadAcademica] ASC),
    UNIQUE NONCLUSTERED ([Desc_SiglasTipo] ASC),
    UNIQUE NONCLUSTERED ([Desc_TipoUnidadAcademica] ASC)
);

