CREATE TABLE [dbo].[Programas_Unidades_Aprendizaje] (
    [id_ProgramaAcademico] INT NULL,
    [id_UnidadAprendizaje] INT NULL,
    FOREIGN KEY ([id_ProgramaAcademico]) REFERENCES [dbo].[ProgramaAcademico] ([ID_ProgramaAcademico]),
    FOREIGN KEY ([id_UnidadAprendizaje]) REFERENCES [dbo].[UnidadAprendizaje] ([ID_UnidadAprendizaje])
);

