CREATE TABLE [dbo].[DFIE_FechasCorte] (
    [ID_FechasCorteDFIE] INT  IDENTITY (1, 1) NOT NULL,
    [Desc_FechaCorte]    DATE DEFAULT ('1901-01-01') NOT NULL,
    [id_Trimestre]       INT  NULL,
    [id_Anio]            INT  NULL,
    PRIMARY KEY CLUSTERED ([ID_FechasCorteDFIE] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre])
);

