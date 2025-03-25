-- Formato 13, 14, 15, 16 Estimulo al desempeno docente vigentes en el periodo NMS, NS, C INV, UACA
CREATE PROCEDURE SAC_EstimuloDocente
    @SiglasTipoUnidadAcademica varchar(255),
    @Anio INT,
    @id_Trimestre INT
AS
BEGIN
    DECLARE @EstimuloAlDesempenioDocente TABLE(
        UnidadAcademica varchar(50),

        PrimeroHombres varchar(10) NOT NULL DEFAULT ' ',
        PrimeroMujeres varchar(10) NOT NULL DEFAULT ' ',
        PrimeroTotal varchar(10) NOT NULL DEFAULT ' ',
        
        SegundoHombres varchar(10) NOT NULL DEFAULT ' ',
        SegundoMujeres varchar(10) NOT NULL DEFAULT ' ',
        SegundoTotal varchar(10) NOT NULL DEFAULT ' ',
        
        TerceroHombres varchar(10) NOT NULL DEFAULT ' ',
        TerceroMujeres varchar(10) NOT NULL DEFAULT ' ',
        TerceroTotal varchar(10) NOT NULL DEFAULT ' ',
        
        CuartoHombres varchar(10) NOT NULL DEFAULT ' ',
        CuartoMujeres varchar(10) NOT NULL DEFAULT ' ',
        CuartoTotal varchar(10) NOT NULL DEFAULT ' ',
        
        QuintoHombres varchar(10) NOT NULL DEFAULT ' ',
        QuintoMujeres varchar(10) NOT NULL DEFAULT ' ',
        QuintoTotal varchar(10) NOT NULL DEFAULT ' ',
        
        SextoHombres varchar(10) NOT NULL DEFAULT ' ',
        SextoMujeres varchar(10) NOT NULL DEFAULT ' ', 
        SextoTotal varchar(10) NOT NULL DEFAULT ' ',
        
        SeptimoHombres varchar(10) NOT NULL DEFAULT ' ',
        SeptimoMujeres varchar(10) NOT NULL DEFAULT ' ',
        SeptimoTotal varchar(10) NOT NULL DEFAULT ' ',
        
        OctavoHombres varchar(10) NOT NULL DEFAULT ' ',
        OctavoMujeres varchar(10) NOT NULL DEFAULT ' ',
        OctavoTotal varchar(10) NOT NULL DEFAULT ' ',
        
        NovenoHombres varchar(10) NOT NULL DEFAULT ' ',
        NovenoMujeres varchar(10) NOT NULL DEFAULT ' ',
        NovenoTotal varchar(10) NOT NULL DEFAULT ' ',

        TotalHombres varchar(10) NOT NULL DEFAULT ' ',
        TotalMujeres varchar(10) NOT NULL DEFAULT ' ',
        TotalTotal varchar(10) NOT NULL DEFAULT ' ',

        MontoPagado varchar(10) NOT NULL DEFAULT ' '
    );

    --Variables por periodo
    DECLARE @Hombres INT = 0;
    DECLARE @Mujeres INT = 0;
    DECLARE @Total INT = 0;

    --Varianbles totales por unidad academica (suma de periodos)
    DECLARE @TotalHombresUnidad INT = 0;
    DECLARE @TotalMujeresUnidad INT = 0;
    DECLARE @TotalTotalUnidad INT = 0;

    --Variables totales por rama (Suma unidades academicas por periodo)
    DECLARE @TotalHombresRama1 INT = 0;
    DECLARE @TotalMujeresRama1 INT = 0;
    DECLARE @TotalRama1 INT = 0;
    DECLARE @TotalHombresRama2 INT = 0;
    DECLARE @TotalMujeresRama2 INT = 0;
    DECLARE @TotalRama2 INT = 0;
    DECLARE @TotalHombresRama3 INT = 0;
    DECLARE @TotalMujeresRama3 INT = 0;
    DECLARE @TotalRama3 INT = 0;
    DECLARE @TotalHombresRama4 INT = 0;
    DECLARE @TotalMujeresRama4 INT = 0;
    DECLARE @TotalRama4 INT = 0;
    DECLARE @TotalHombresRama5 INT = 0;
    DECLARE @TotalMujeresRama5 INT = 0;
    DECLARE @TotalRama5 INT = 0;
    DECLARE @TotalHombresRama6 INT = 0;
    DECLARE @TotalMujeresRama6 INT = 0;
    DECLARE @TotalRama6 INT = 0;
    DECLARE @TotalHombresRama7 INT = 0;
    DECLARE @TotalMujeresRama7 INT = 0;
    DECLARE @TotalRama7 INT = 0;
    DECLARE @TotalHombresRama8 INT = 0;
    DECLARE @TotalMujeresRama8 INT = 0;
    DECLARE @TotalRama8 INT = 0;
    DECLARE @TotalHombresRama9 INT = 0;
    DECLARE @TotalMujeresRama9 INT = 0;
    DECLARE @TotalRama9 INT = 0;
    DECLARE @TotalTotalHombres INT = 0;
    DECLARE @TotalTotalMujeres INT = 0;
    DECLARE @TotalTotalTotal INT = 0;
    DECLARE @MontoTotal MONEY = 0;

    -- Montos pagados, obtenidos de otra tabla
    DECLARE @MontoPagado varchar(100) = 0;

    -- Declaraciones iniciales de variables contadores
    DECLARE @ContadorUA INT = 1;
    DECLARE @ContadorRama INT = 1;
    DECLARE @ContadorPeriodo INT = 1;

    -- Obtenemos las ramas totales (numero) para el tipo de unidad academica actual
    DECLARE @RamasTotales INT = ISNULL((SELECT 
                                            COUNT(DISTINCT(RC.Desc_SiglasRama))
                                        FROM UnidadesAcademicas UA
                                        JOIN RamaConocimiento RC ON UA.id_RamaConocimiento = RC.ID_RamaConocimiento
                                        WHERE UA.id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                                        FROM TipoUnidadAcademica 
                                                                        WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica)), 0)

    -- Tabla para guardar las ramas que corresponden al tipo que se ha pedido 
    -- se manejaran ID para simplificar el proceso de busqueda
    DECLARE @RamasPorTipo TABLE (
        ID_Numeral INT IDENTITY(1,1),
        id_RamaConocimiento INT
    );
    
    CREATE TABLE #UnidadesPorRama (
            ID_Numeral INT IDENTITY(1,1),
            SiglasUnidad varchar(25) COLLATE Latin1_General_CI_AI
    );
    
    INSERT INTO @RamasPorTipo(
        id_RamaConocimiento
    )SELECT 
        DISTINCT(id_RamaConocimiento)
    FROM UnidadesAcademicas 
    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica);
    
    SET @ContadorRama = 1;
    WHILE @ContadorRama <= @RamasTotales
        BEGIN
            DECLARE @id_RamaActual INT = (SELECT id_RamaConocimiento 
                                            FROM @RamasPorTipo
                                            WHERE ID_Numeral = @ContadorRama);
            
            INSERT INTO #UnidadesPorRama(
                SiglasUnidad
            )SELECT
                Siglas
            FROM UnidadesAcademicas
            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                FROM TipoUnidadAcademica 
                                WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica) 
            AND id_RamaConocimiento = @id_RamaActual;

            SET @ContadorUA = 1;
            WHILE @ContadorUA <= (SELECT COUNT(*) FROM #UnidadesPorRama)
                BEGIN
                    DECLARE @UnidadActual varchar(25) = (SELECT SiglasUnidad 
                                                        FROM #UnidadesPorRama
                                                        WHERE ID_Numeral = @ContadorUA);
                    
                    SET @TotalHombresUnidad = 0;
                    SET @TotalMujeresUnidad = 0;
                    SET @TotalTotalUnidad = 0;

                    SET @ContadorPeriodo = 1;
                    WHILE @ContadorPeriodo <= 9
                        BEGIN
                            SET @Hombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                            FROM SAC_RegistroEstimulosAlDesempenioDocente
                                            WHERE id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @UnidadActual)
                                            AND Desc_PeriodoSAC = @ContadorPeriodo
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @Anio)
                                            AND id_Trimestre = @id_Trimestre), 0);

                            SET @Mujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                            FROM SAC_RegistroEstimulosAlDesempenioDocente
                                            WHERE id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @UnidadActual)
                                            AND Desc_PeriodoSAC = @ContadorPeriodo
                                            AND id_Anio = (SELECT ID_Anio
                                                            FROM Anio
                                                            WHERE Desc_Anio = @Anio)
                                            AND id_Trimestre = @id_Trimestre), 0);

                            SET @Total = @Hombres + @Mujeres;

                            SET @MontoPagado = ISNULL((SELECT SUM(Desc_MontoPagado) 
                                                        FROM SAC_RegistroEDDMontosPagados
                                                        WHERE id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica
                                                                                        FROM UnidadesAcademicas
                                                                                        WHERE Siglas = @UnidadActual)
                                                        AND id_Anio = (SELECT ID_Anio
                                                                        FROM Anio
                                                                        WHERE Desc_Anio = @Anio)
                                                        AND id_Trimestre = @id_Trimestre), 0)
                            
                            SET @TotalHombresUnidad = @TotalHombresUnidad + @Hombres;
                            SET @TotalMujeresUnidad = @TotalMujeresUnidad + @Mujeres;
                            SET @TotalTotalUnidad = @TotalTotalUnidad + @Total;

                            IF @ContadorPeriodo = 1
                                BEGIN
                                    INSERT INTO @EstimuloAlDesempenioDocente(
                                        UnidadAcademica,
                                        PrimeroHombres,
                                        PrimeroMujeres,
                                        PrimeroTotal,
                                        MontoPagado
                                    )VALUES(
                                        @UnidadActual,
                                        @Hombres,
                                        @Mujeres,
                                        @Total,
                                        @MontoPagado
                                    );
                                END
                            ELSE IF @ContadorPeriodo = 2
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET SegundoHombres = @Hombres,
                                    SegundoMujeres = @Mujeres,
                                    SegundoTotal = @Total
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                            ELSE IF @ContadorPeriodo = 3
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET TerceroHombres = @Hombres,
                                    TerceroMujeres = @Mujeres,
                                    TerceroTotal = @Total
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                            ELSE IF @ContadorPeriodo = 4
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET CuartoHombres = @Hombres,
                                    CuartoMujeres = @Mujeres,
                                    CuartoTotal = @Total
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                            ELSE IF @ContadorPeriodo = 5
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET QuintoHombres = @Hombres,
                                    QuintoMujeres = @Mujeres,
                                    QuintoTotal = @Total
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                            ELSE IF @ContadorPeriodo = 6
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET SextoHombres = @Hombres,
                                    SextoMujeres = @Mujeres,
                                    SextoTotal = @Total
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                            ELSE IF @ContadorPeriodo = 7
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET SeptimoHombres = @Hombres,
                                    SeptimoMujeres = @Mujeres,
                                    SeptimoTotal = @Total
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                            ELSE IF @ContadorPeriodo = 8
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET OctavoHombres = @Hombres,
                                    OctavoMujeres = @Mujeres,
                                    OctavoTotal = @Total
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                            ELSE IF @ContadorPeriodo = 9
                            BEGIN
                                UPDATE @EstimuloAlDesempenioDocente
                                SET NovenoHombres = @Hombres,
                                    NovenoMujeres = @Mujeres,
                                    NovenoTotal = @Total,
                                    TotalHombres = @TotalHombresUnidad,
                                    TotalMujeres = @TotalMujeresUnidad,
                                    TotalTotal = @TotalTotalUnidad
                                WHERE UnidadAcademica = @UnidadActual;
                            END
                        SET @ContadorPeriodo = @ContadorPeriodo + 1;
                        END
                    SET @ContadorUA = @ContadorUA + 1;
                END

            SET @TotalHombresRama1 = ISNULL((SELECT SUM(CAST(PrimeroHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama1 = ISNULL((SELECT SUM(CAST(PrimeroMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama1 = ISNULL((SELECT SUM(CAST(PrimeroTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            
            SET @TotalHombresRama2 = ISNULL((SELECT SUM(CAST(SegundoHombres AS INT))
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama2 = ISNULL((SELECT SUM(CAST(SegundoMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama2 = ISNULL((SELECT SUM(CAST(SegundoTotal AS INT))
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);

            SET @TotalHombresRama3 = ISNULL((SELECT SUM(CAST(TerceroHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama3 = ISNULL((SELECT SUM(CAST(TerceroMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama3 = ISNULL((SELECT SUM(CAST(TerceroTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            
            SET @TotalHombresRama4 = ISNULL((SELECT SUM(CAST(CuartoHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama4 = ISNULL((SELECT SUM(CAST(CuartoMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama4 = ISNULL((SELECT SUM(CAST(CuartoTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            PRINT @TotalHombresRama5
            SET @TotalHombresRama5 = ISNULL((SELECT SUM(CAST(QuintoHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama5 = ISNULL((SELECT SUM(CAST(QuintoMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama5 = ISNULL((SELECT SUM(CAST(QuintoTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            PRINT @TotalHombresRama5;
            SET @TotalHombresRama6 = ISNULL((SELECT SUM(CAST(SextoHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama6 = ISNULL((SELECT SUM(CAST(SextoMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama6 = ISNULL((SELECT SUM(CAST(SextoTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);

            SET @TotalHombresRama7 = ISNULL((SELECT SUM(CAST(SeptimoHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama7 = ISNULL((SELECT SUM(CAST(SeptimoMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama7 = ISNULL((SELECT SUM(CAST(SeptimoTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            
            SET @TotalHombresRama8 = ISNULL((SELECT SUM(CAST(OctavoHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama8 = ISNULL((SELECT SUM(CAST (OctavoMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama8 = ISNULL((SELECT SUM(CAST(OctavoTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            
            SET @TotalHombresRama9 = ISNULL((SELECT SUM(CAST(NovenoHombres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalMujeresRama9 = ISNULL((SELECT SUM(CAST(NovenoMujeres AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalRama9 = ISNULL((SELECT SUM(CAST(NovenoTotal AS INT)) 
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);

            SET @TotalTotalHombres = ISNULL((SELECT SUM(CAST(TotalHombres AS INT))
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalTotalMujeres = ISNULL((SELECT SUM(CAST(TotalMujeres AS INT))
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            SET @TotalTotalTotal = ISNULL((SELECT SUM(CAST(TotalTotal AS INT))
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);
            
            SET @MontoTotal = ISNULL((SELECT SUM(CAST(MontoPagado AS MONEY))
                                            FROM @EstimuloAlDesempenioDocente
                                            WHERE UnidadAcademica IN (SELECT SiglasUnidad 
                                                                    FROM #UnidadesPorRama)), 0);

            INSERT INTO @EstimuloAlDesempenioDocente
            VALUES(
                CONCAT('SUBTOTAL RAMA ', (SELECT TOP(1) Desc_SiglasRama FROM RamaConocimiento WHERE ID_RamaConocimiento = @id_RamaActual)),
                @TotalHombresRama1,
                @TotalMujeresRama1,
                @TotalRama1,
                @TotalHombresRama2,
                @TotalMujeresRama2,
                @TotalRama2,
                @TotalHombresRama3,
                @TotalMujeresRama3,
                @TotalRama3,
                @TotalHombresRama4,
                @TotalMujeresRama4,
                @TotalRama4,
                @TotalHombresRama5,
                @TotalMujeresRama5,
                @TotalRama5,
                @TotalHombresRama6,
                @TotalMujeresRama6,
                @TotalRama6,
                @TotalHombresRama7,
                @TotalMujeresRama7,
                @TotalRama7,
                @TotalHombresRama8,
                @TotalMujeresRama8,
                @TotalRama8,
                @TotalHombresRama9,
                @TotalMujeresRama9,
                @TotalRama9,
                @TotalTotalHombres,
                @TotalTotalMujeres,
                @TotalTotalTotal,
                @MontoTotal
            );

            DELETE FROM #UnidadesPorRama;
            DBCC CHECKIDENT ("#UnidadesPorRama", RESEED,0);
            SET @ContadorRama = @ContadorRama + 1;
        END
    SELECT * FROM @EstimuloAlDesempenioDocente
END