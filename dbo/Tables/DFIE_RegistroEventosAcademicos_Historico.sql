CREATE TABLE [dbo].[DFIE_RegistroEventosAcademicos_Historico] (
    [ID_RegistroEventosAcademicos] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_DependenciaPolitecnica]  VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_NombreEventoAcademico]   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_CUR]                     VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_FechaInicioTermino]      VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_TipoEventoAcademico]     VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Finalidad]               VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_DirigidoA]               BIT           DEFAULT ((0)) NOT NULL,
    [Fecha]                        VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]                 INT           NULL,
    [id_Anio]                      INT           NULL,
    [id_Usuario]                   INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_RegistroEventosAcademicos] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

