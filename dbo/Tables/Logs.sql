CREATE TABLE [dbo].[Logs] (
    [ID_Log]                  INT           IDENTITY (1, 1) NOT NULL,
    [Desc_FechaHora]          DATETIME      DEFAULT ('2000-01-01 00:00:00') NOT NULL,
    [Desc_NombreServidor]     VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_DireccionIPCliente] VARCHAR (255) DEFAULT ('000.000.000.00') NOT NULL,
    [Desc_NavegadorCliente]   VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_IdiomaNavegador]    VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_NombreUsuario]      VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Cargo]              VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Unidad]             VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Dependecia]         VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Correo]             VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Telefono]           VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_Accion]             VARCHAR (255) DEFAULT (' ') NOT NULL,
    [Desc_DescripcionAccion]  VARCHAR (255) DEFAULT (' ') NOT NULL,
    [anio]                    INT           DEFAULT ((2000)) NOT NULL,
    [mes]                     INT           DEFAULT ((1)) NOT NULL,
    [dia]                     INT           DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID_Log] ASC)
);

