CREATE TABLE [dbo].[DFIE_EventosAcademicos] (
    [ID_EventosAcademicosDFIE]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NombreEventoAcademico] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_EventosAcademicosDFIE] ASC),
    UNIQUE NONCLUSTERED ([Desc_NombreEventoAcademico] ASC)
);

