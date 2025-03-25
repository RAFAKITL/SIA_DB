CREATE TABLE [dbo].[DFIE_EventosAcademicosParticipantes_Historico] (
    [ID_EventoAcademicoParticipantes] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Hombres]                    INT           DEFAULT ((0)) NOT NULL,
    [Desc_Mujeres]                    INT           DEFAULT ((0)) NOT NULL,
    [id_UnidadAcademica]              INT           NULL,
    [id_EventoAcademicoDFIE]          INT           NULL,
    [Fecha]                           VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]                    INT           NULL,
    [id_Anio]                         INT           NULL,
    [id_Usuario]                      INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_EventoAcademicoParticipantes] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_EventoAcademicoDFIE]) REFERENCES [dbo].[DFIE_EventosAcademicos] ([ID_EventosAcademicosDFIE]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

