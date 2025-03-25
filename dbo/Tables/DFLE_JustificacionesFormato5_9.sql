CREATE TABLE [dbo].[DFLE_JustificacionesFormato5_9] (
    [ID_JustificacionesFormato5_9] INT            IDENTITY (1, 1) NOT NULL,
    [Desc_Justificacion]           NVARCHAR (MAX) DEFAULT (' ') NOT NULL,
    [id_FormatoAutoevaluacion]     INT            NULL,
    [id_Idioma]                    INT            NULL,
    [Fecha]                        VARCHAR (255)  DEFAULT (' ') NULL,
    [id_Trimestre]                 INT            NULL,
    [id_Anio]                      INT            NULL,
    [id_Usuario]                   INT            NULL,
    PRIMARY KEY CLUSTERED ([ID_JustificacionesFormato5_9] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_FormatoAutoevaluacion]) REFERENCES [dbo].[Formatos] ([ID_Formato]),
    FOREIGN KEY ([id_Idioma]) REFERENCES [dbo].[DFLE_Idiomas] ([ID_Idioma]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

