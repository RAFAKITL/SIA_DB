CREATE TABLE [dbo].[Estatus_Deshabilitado] (
    [ID_EstatusDeshabilitado]    INT IDENTITY (1, 1) NOT NULL,
    [Desc_Estatus_Deshabilitado] BIT DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([ID_EstatusDeshabilitado] ASC)
);

