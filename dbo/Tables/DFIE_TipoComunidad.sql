CREATE TABLE [dbo].[DFIE_TipoComunidad] (
    [ID_TipoComunidadDFIE]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_TipoComunidadDFIE] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_TipoComunidadDFIE] ASC),
    UNIQUE NONCLUSTERED ([Desc_TipoComunidadDFIE] ASC)
);

