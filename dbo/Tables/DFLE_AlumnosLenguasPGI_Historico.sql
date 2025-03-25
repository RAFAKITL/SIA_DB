CREATE TABLE [dbo].[DFLE_AlumnosLenguasPGI_Historico] (
    [ID_AlumnosLenguasPGI] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Hombres]         INT           DEFAULT ((0)) NOT NULL,
    [Desc_Mujeres]         INT           DEFAULT ((0)) NOT NULL,
    [id_UnidadAcademica]   INT           NULL,
    [id_Idioma]            INT           NULL,
    [id_CompetenciaPGI]    INT           NULL,
    [Fecha]                VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]         INT           NULL,
    [id_Anio]              INT           NULL,
    [id_Usuario]           INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_AlumnosLenguasPGI] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_CompetenciaPGI]) REFERENCES [dbo].[DFLE_NivelesCompetenciaPGI] ([ID_CompetenciaPGI]),
    FOREIGN KEY ([id_Idioma]) REFERENCES [dbo].[DFLE_Idiomas] ([ID_Idioma]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

