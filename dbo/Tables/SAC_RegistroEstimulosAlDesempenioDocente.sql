﻿CREATE TABLE [dbo].[SAC_RegistroEstimulosAlDesempenioDocente] (
    [ID_RegistroEstimulosAlDesempenioDocenteSAC] INT           IDENTITY (1, 1) NOT NULL,
    [Desc_Hombres]                               INT           DEFAULT ((0)) NOT NULL,
    [Desc_Mujeres]                               INT           DEFAULT ((0)) NOT NULL,
    [id_UnidadAcademicaSAC]                      INT           NULL,
    [Desc_PeriodoSAC]                            INT           NULL,
    [id_FormatoSAC]                              INT           NULL,
    [Fecha]                                      VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_Trimestre]                               INT           NULL,
    [id_Anio]                                    INT           NULL,
    [id_Usuario]                                 INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_RegistroEstimulosAlDesempenioDocenteSAC] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_FormatoSAC]) REFERENCES [dbo].[Formatos] ([ID_Formato]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_UnidadAcademicaSAC]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

