CREATE TABLE [dbo].[DFLE_AccionesFormativas] (
    [ID_RegistroFormato12DFLE] INT            IDENTITY (1, 1) NOT NULL,
    [Desc_Tipo_Accion]         NVARCHAR (MAX) DEFAULT (' ') NOT NULL,
    [Desc_AccionFormativa]     NVARCHAR (MAX) COLLATE Latin1_General_CI_AI DEFAULT (' ') NOT NULL,
    [Desc_Modalidad]           VARCHAR (5)    NOT NULL,
    [id_Idioma]                INT            NULL,
    [id_UnidadAcademica]       INT            NULL,
    [Desc_Hombres]             INT            DEFAULT ((0)) NOT NULL,
    [Desc_Mujeres]             INT            DEFAULT ((0)) NOT NULL,
    [Fecha]                    VARCHAR (255)  DEFAULT (' ') NULL,
    [id_Trimestre]             INT            NULL,
    [id_Anio]                  INT            NULL,
    [id_Usuario]               INT            NULL,
    PRIMARY KEY CLUSTERED ([ID_RegistroFormato12DFLE] ASC),
    CHECK ([Desc_Modalidad]='MIXTA' OR [Desc_Modalidad]='NESC' OR [Desc_Modalidad]='ESC'),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_Idioma]) REFERENCES [dbo].[DFLE_Idiomas] ([ID_Idioma]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

