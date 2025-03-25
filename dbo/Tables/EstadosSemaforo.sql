CREATE TABLE [dbo].[EstadosSemaforo] (
    [ID_EstadosSemaforo]  INT           IDENTITY (1, 1) NOT NULL,
    [Desc_EstadoSemaforo] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [ColorEstado]         VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_EstadosSemaforo] ASC)
);

