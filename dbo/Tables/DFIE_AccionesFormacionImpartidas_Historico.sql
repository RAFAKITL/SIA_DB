﻿CREATE TABLE [dbo].[DFIE_AccionesFormacionImpartidas_Historico] (
    [ID_AccionesFormacionImpartidas] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NO]                        VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_IDGrupo]                   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_DPR]                       VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_AccionFormativaDFIE]         INT           NULL,
    [Desc_NombreAccionFormativa]     VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_FinalidadFormacion]        VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_FechaInicio]               VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_FechaFin]                  VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_HombresRegistrados]        INT           DEFAULT ((0)) NOT NULL,
    [Desc_MujeresRegistradas]        INT           DEFAULT ((0)) NOT NULL,
    [Desc_HombresAcreditados]        INT           DEFAULT ((0)) NOT NULL,
    [Desc_MujeresAcreditados]        INT           DEFAULT ((0)) NOT NULL,
    [id_FormatoDFIE]                 INT           NULL,
    [Fecha]                          VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]                   INT           NULL,
    [id_Anio]                        INT           NULL,
    [id_Usuario]                     INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_AccionesFormacionImpartidas] ASC),
    FOREIGN KEY ([id_AccionFormativaDFIE]) REFERENCES [dbo].[DFIE_AccionesFormativas] ([ID_AccionFormativaDFIE]),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_FormatoDFIE]) REFERENCES [dbo].[Formatos] ([ID_Formato]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

