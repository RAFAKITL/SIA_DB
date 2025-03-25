CREATE TABLE [dbo].[Estatus_Bloqueado] (
    [ID_EstatusBloqueo]    INT IDENTITY (1, 1) NOT NULL,
    [Desc_Estatus_Bloqueo] BIT DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([ID_EstatusBloqueo] ASC)
);

