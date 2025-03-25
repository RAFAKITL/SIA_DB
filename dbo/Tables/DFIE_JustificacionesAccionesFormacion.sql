CREATE TABLE [dbo].[DFIE_JustificacionesAccionesFormacion] (
    [ID_Justificacion]       INT            IDENTITY (1, 1) NOT NULL,
    [Desc_Justificacion]     NVARCHAR (MAX) DEFAULT ('') NOT NULL,
    [id_AccionFormativaDFIE] INT            NULL,
    [id_FormatoDFIE]         INT            NULL,
    [id_TipoComunidadDFIE]   INT            NULL,
    [Fecha]                  VARCHAR (255)  DEFAULT (' ') NOT NULL,
    [id_Trimestre]           INT            NULL,
    [id_Anio]                INT            NULL,
    [id_Usuario]             INT            NULL,
    PRIMARY KEY CLUSTERED ([ID_Justificacion] ASC),
    FOREIGN KEY ([id_AccionFormativaDFIE]) REFERENCES [dbo].[DFIE_AccionesFormativas] ([ID_AccionFormativaDFIE]),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_FormatoDFIE]) REFERENCES [dbo].[Formatos] ([ID_Formato]),
    FOREIGN KEY ([id_TipoComunidadDFIE]) REFERENCES [dbo].[DFIE_TipoComunidad] ([ID_TipoComunidadDFIE]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

