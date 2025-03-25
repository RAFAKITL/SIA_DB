CREATE TABLE [dbo].[DFIE_JustificacionesEventosAcademicos_Historico] (
    [ID_Justificacion]       INT            IDENTITY (1, 1) NOT NULL,
    [Desc_Justificacion]     NVARCHAR (MAX) DEFAULT ('') NOT NULL,
    [id_EventoAcademicoDFIE] INT            NULL,
    [Fecha]                  VARCHAR (255)  DEFAULT (' ') NOT NULL,
    [id_Trimestre]           INT            NULL,
    [id_Anio]                INT            NULL,
    [id_Usuario]             INT            NULL,
    PRIMARY KEY CLUSTERED ([ID_Justificacion] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_EventoAcademicoDFIE]) REFERENCES [dbo].[DFIE_EventosAcademicos] ([ID_EventosAcademicosDFIE]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

