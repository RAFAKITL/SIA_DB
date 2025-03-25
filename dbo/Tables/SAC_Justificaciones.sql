CREATE TABLE [dbo].[SAC_Justificaciones] (
    [ID_JustificacionesSAC]     INT            IDENTITY (1, 1) NOT NULL,
    [Desc_Justificacion]        NVARCHAR (MAX) DEFAULT (' ') NOT NULL,
    [id_TipoUnidadAcademicaSAC] INT            NULL,
    [id_ProgramaApoyoSAC]       INT            NULL,
    [id_FormatoSAC]             INT            NULL,
    [Fecha]                     VARCHAR (255)  DEFAULT (' ') NOT NULL,
    [id_Trimestre]              INT            NULL,
    [id_Anio]                   INT            NULL,
    [id_Usuario]                INT            NULL,
    PRIMARY KEY CLUSTERED ([ID_JustificacionesSAC] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_FormatoSAC]) REFERENCES [dbo].[Formatos] ([ID_Formato]),
    FOREIGN KEY ([id_ProgramaApoyoSAC]) REFERENCES [dbo].[SAC_ProgramaApoyo] ([ID_ProgramaApoyoSAC]),
    FOREIGN KEY ([id_TipoUnidadAcademicaSAC]) REFERENCES [dbo].[TipoUnidadAcademica] ([ID_TipoUnidadAcademica]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

