CREATE TABLE [dbo].[SAC_ProgramaReconocimientoValidezOficial_Historico] (
    [ID_ProgramaReconocimientoValidezOficial] INT           IDENTITY (1, 1) NOT NULL,
    [Estado]                                  VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Unidad_Academica]                        VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Carrera]                                 VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_TipoUnidadAcademica]                  INT           NULL,
    [Modalidad]                               VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Vigencia]                                VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Programa_Academico]                      VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Fecha]                                   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]                            INT           NULL,
    [id_Anio]                                 INT           NULL,
    [id_Usuario]                              INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_ProgramaReconocimientoValidezOficial] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_TipoUnidadAcademica]) REFERENCES [dbo].[TipoUnidadAcademica] ([ID_TipoUnidadAcademica]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

