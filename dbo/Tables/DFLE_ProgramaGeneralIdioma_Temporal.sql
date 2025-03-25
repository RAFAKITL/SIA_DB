CREATE TABLE [dbo].[DFLE_ProgramaGeneralIdioma_Temporal] (
    [ID_ProgramaGeneralIdiomaDFLE] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_ProgramaGeneral]         BIT           DEFAULT ((0)) NOT NULL,
    [id_UnidadAcademica]           INT           NULL,
    [id_Idioma]                    INT           NULL,
    [Fecha]                        VARCHAR (255) DEFAULT (' ') NULL,
    [id_Trimestre]                 INT           NULL,
    [id_Anio]                      INT           NULL,
    [id_Usuario]                   INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_ProgramaGeneralIdiomaDFLE] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_Idioma]) REFERENCES [dbo].[DFLE_Idiomas] ([ID_Idioma]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

