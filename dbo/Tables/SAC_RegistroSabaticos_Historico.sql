CREATE TABLE [dbo].[SAC_RegistroSabaticos_Historico] (
    [ID_RegistroSabaticosSAC] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Hombres]            INT           DEFAULT ((0)) NOT NULL,
    [Desc_Mujeres]            INT           DEFAULT ((0)) NOT NULL,
    [id_UnidadAcademicaSAC]   INT           NULL,
    [id_ProgramasSabaticoSAC] INT           NULL,
    [id_FormatoSAC]           INT           NULL,
    [id_AnioSemestre]         INT           NULL,
    [Fecha]                   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]            INT           NULL,
    [id_Anio]                 INT           NULL,
    [id_Usuario]              INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_RegistroSabaticosSAC] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_AnioSemestre]) REFERENCES [dbo].[SAC_AnioSemestre] ([ID_AnioSemestreSAC]),
    FOREIGN KEY ([id_FormatoSAC]) REFERENCES [dbo].[Formatos] ([ID_Formato]),
    FOREIGN KEY ([id_ProgramasSabaticoSAC]) REFERENCES [dbo].[SAC_ProgramasSabatico] ([ID_ProgramasSabaticoSAC]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_UnidadAcademicaSAC]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

