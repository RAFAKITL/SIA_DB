CREATE TABLE [dbo].[DFIE_EventosAcademicosListado] (
    [ID_EventosAcademicos]       INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NO]                    VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_DPR]                   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_EventoAcademicoDFIE]     INT           NULL,
    [Desc_NombreAccionFormativa] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_FechaInicio]           VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_FechaFin]              VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Fecha]                      VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]               INT           NULL,
    [id_Anio]                    INT           NULL,
    [id_Usuario]                 INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_EventosAcademicos] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_EventoAcademicoDFIE]) REFERENCES [dbo].[DFIE_EventosAcademicos] ([ID_EventosAcademicosDFIE]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

