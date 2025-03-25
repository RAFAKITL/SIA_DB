CREATE TABLE [dbo].[DFIE_RegistroAccionesFormacion] (
    [ID_RegistroAccionesFormacion]           INT           IDENTITY (1, 1) NOT NULL,
    [Desc_No]                                VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_IDAccionFormacion]                 VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_DependenciaPolitecnicaSolicitante] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_AccionFormacion]                   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_CUR]                               VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_TipoAccionFormacion]               VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Modalidad]                         VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_FinalidadFormacion]                  INT           NULL,
    [Desc_AreaFormacion]                     VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_SubArea]                           VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_DirigidoA]                         INT           DEFAULT ((0)) NOT NULL,
    [Fecha]                                  VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]                           INT           NULL,
    [id_Anio]                                INT           NULL,
    [id_Usuario]                             INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_RegistroAccionesFormacion] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_FinalidadFormacion]) REFERENCES [dbo].[DFIE_FinalidadFormacion] ([ID_FinalidadFormacion]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

