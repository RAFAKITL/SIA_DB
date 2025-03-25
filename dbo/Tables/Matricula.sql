CREATE TABLE [dbo].[Matricula] (
    [Desc_Anio_Periodo]     INT           DEFAULT ((0)) NOT NULL,
    [Desc_Semestre_Periodo] INT           DEFAULT ((0)) NOT NULL,
    [Desc_Sexo]             VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Semestre]         VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Turno]            VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Datos]            INT           DEFAULT (' ') NOT NULL,
    [id_UnidadAcademica]    INT           NULL,
    [id_ProgramaAcademico]  INT           NULL,
    FOREIGN KEY ([id_ProgramaAcademico]) REFERENCES [dbo].[ProgramaAcademico] ([ID_ProgramaAcademico]),
    FOREIGN KEY ([id_UnidadAcademica]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica])
);

