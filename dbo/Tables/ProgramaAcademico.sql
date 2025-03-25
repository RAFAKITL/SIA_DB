CREATE TABLE [dbo].[ProgramaAcademico] (
    [ID_ProgramaAcademico]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_ProgramaAcademico] VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Calidad]           VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Duracion]          VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_PrimerRegistro]    VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_UltimoRegistro]    VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_En_Operacion]      VARCHAR (255) DEFAULT (' ') NOT NULL,
    [id_TipoUnidadAcademica] INT           NULL,
    [id_RamaConocimiento]    INT           NULL,
    [id_ModalidadEducativa]  INT           NULL,
    PRIMARY KEY CLUSTERED ([ID_ProgramaAcademico] ASC),
    FOREIGN KEY ([id_ModalidadEducativa]) REFERENCES [dbo].[ModalidadEducativa] ([ID_ModalidadEducativa]),
    FOREIGN KEY ([id_RamaConocimiento]) REFERENCES [dbo].[RamaConocimiento] ([ID_RamaConocimiento]),
    FOREIGN KEY ([id_TipoUnidadAcademica]) REFERENCES [dbo].[TipoUnidadAcademica] ([ID_TipoUnidadAcademica]),
    UNIQUE NONCLUSTERED ([Desc_ProgramaAcademico] ASC)
);

