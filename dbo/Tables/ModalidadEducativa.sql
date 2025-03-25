CREATE TABLE [dbo].[ModalidadEducativa] (
    [ID_ModalidadEducativa]         INT           IDENTITY (1, 1) NOT NULL,
    [Desc_ModalidadEducativa]       VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_SiglasModalidadEducativa] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_ModalidadEducativa] ASC),
    UNIQUE NONCLUSTERED ([Desc_ModalidadEducativa] ASC),
    UNIQUE NONCLUSTERED ([Desc_SiglasModalidadEducativa] ASC)
);

