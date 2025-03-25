CREATE TABLE [dbo].[DFIE_AccionesFormativas] (
    [ID_AccionFormativaDFIE]     INT           IDENTITY (1, 1) NOT NULL,
    [Desc_NombreAccionFormativa] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_AccionFormativaDFIE] ASC),
    UNIQUE NONCLUSTERED ([Desc_NombreAccionFormativa] ASC)
);

