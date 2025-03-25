CREATE TABLE [dbo].[Unidades_Academicas_Programas] (
    [id_Unidad]   INT NULL,
    [id_Programa] INT NULL,
    FOREIGN KEY ([id_Programa]) REFERENCES [dbo].[ProgramaAcademico] ([ID_ProgramaAcademico]),
    FOREIGN KEY ([id_Unidad]) REFERENCES [dbo].[UnidadesAcademicas] ([ID_UnidadAcademica])
);

