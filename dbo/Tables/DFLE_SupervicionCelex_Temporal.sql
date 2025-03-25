CREATE TABLE [dbo].[DFLE_SupervicionCelex_Temporal] (
    [ID_SupervicionCelex]  INT           IDENTITY (1, 1) NOT NULL,
    [id_UnidadAcademica]   INT           NULL,
    [TRIM_UNO_Supervicion] BIT           DEFAULT ((0)) NULL,
    [Fecha]                VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]         INT           NULL,
    [id_Anio]              INT           NULL,
    [id_Usuario]           INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_SupervicionCelex] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

