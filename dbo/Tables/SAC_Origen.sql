CREATE TABLE [dbo].[SAC_Origen] (
    [ID_OriginSAC]   INT           IDENTITY (1, 1) NOT NULL,
    [Desc_OriginSAC] VARCHAR (255) DEFAULT (' ') NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_OriginSAC] ASC)
);

