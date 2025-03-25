CREATE TABLE [dbo].[SeguimientoDocumentos] (
    [ID_SeguimientoDocumentos] INT            IDENTITY (1, 1) NOT NULL,
    [id_Documento]             INT            NULL,
    [id_Estado]                INT            NULL,
    [Desc_FechaCambio]         VARCHAR (255)  DEFAULT ('2000-01-01') NOT NULL,
    [id_Usuario]               INT            NULL,
    [Desc_Comentario]          NVARCHAR (MAX) DEFAULT (' ') NOT NULL,
    [id_Trimestre]             INT            NULL,
    [id_Anio]                  INT            NULL,
    PRIMARY KEY CLUSTERED ([ID_SeguimientoDocumentos] ASC),
    FOREIGN KEY ([id_Anio]) REFERENCES [dbo].[Anio] ([ID_Anio]),
    FOREIGN KEY ([id_Documento]) REFERENCES [dbo].[Documento] ([ID_Documento]),
    FOREIGN KEY ([id_Estado]) REFERENCES [dbo].[EstadosSemaforo] ([ID_EstadosSemaforo]),
    FOREIGN KEY ([id_Trimestre]) REFERENCES [dbo].[Trimestre] ([ID_Trimestre]),
    FOREIGN KEY ([id_Usuario]) REFERENCES [dbo].[Usuario_General] ([ID_Usuario])
);

