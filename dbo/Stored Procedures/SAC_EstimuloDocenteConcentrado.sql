-- Formato 17 Estimulo al desempeno Docente vigentes en el periodo Concentrado 
CREATE PROCEDURE SAC_EstimuloDocenteConcentrado
    @Anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @EstimulosDocentesConcentrado TABLE(
        Nivel varchar(255),
        PrimeroHombres INT NOT NULL DEFAULT 0,
        PrimeroMujeres INT NOT NULL DEFAULT 0,
        PrimeroTotal INT NOT NULL DEFAULT 0,
        
        SegundoHombres INT NOT NULL DEFAULT 0,
        SegundoMujeres INT NOT NULL DEFAULT 0,
        SegundoTotal INT NOT NULL DEFAULT 0,
        
        TerceroHombres INT NOT NULL DEFAULT 0,
        TerceroMujeres INT NOT NULL DEFAULT 0,
        TerceroTotal INT NOT NULL DEFAULT 0,
        
        CuartoHombres INT NOT NULL DEFAULT 0,
        CuartoMujeres INT NOT NULL DEFAULT 0,
        CuartoTotal INT NOT NULL DEFAULT 0,
        
        QuintoHombres INT NOT NULL DEFAULT 0,
        QuintoMujeres INT NOT NULL DEFAULT 0,
        QuintoTotal INT NOT NULL DEFAULT 0,
        
        SextoHombres INT NOT NULL DEFAULT 0,
        SextoMujeres INT NOT NULL DEFAULT 0, 
        SextoTotal INT NOT NULL DEFAULT 0,
        
        SeptimoHombres INT NOT NULL DEFAULT 0,
        SeptimoMujeres INT NOT NULL DEFAULT 0,
        SeptimoTotal INT NOT NULL DEFAULT 0,
        
        OctavoHombres INT NOT NULL DEFAULT 0,
        OctavoMujeres INT NOT NULL DEFAULT 0,
        OctavoTotal INT NOT NULL DEFAULT 0,
        
        NovenoHombres INT NOT NULL DEFAULT 0,
        NovenoMujeres INT NOT NULL DEFAULT 0,
        NovenoTotal INT NOT NULL DEFAULT 0,

        TotalHombres INT NOT NULL DEFAULT 0,
        TotalMujeres INT NOT NULL DEFAULT 0,
        TotalTotal INT NOT NULL DEFAULT 0,

        MontoPagado INT NOT NULL DEFAULT 0
    );

    DECLARE @PrimerTotalHombres INT = 0;
    DECLARE @PrimerTotalMujeres INT = 0;
    DECLARE @PrimerTotalTotal INT = 0;

    DECLARE @SegundoTotalHombres INT = 0;
    DECLARE @SegundoTotalMujeres INT = 0;
    DECLARE @SegundoTotalTotal INT = 0;

    DECLARE @TerceroTotalHombres INT = 0;
    DECLARE @TerceroTotalMujeres INT = 0;
    DECLARE @TerceroTotalTotal INT = 0;

    DECLARE @CuartoTotalHombres INT = 0;
    DECLARE @CuartoTotalMujeres INT = 0;
    DECLARE @CuartoTotalTotal INT = 0;

    DECLARE @QuintoTotalHombres INT = 0;
    DECLARE @QuintoTotalMujeres INT = 0;
    DECLARE @QuintoTotalTotal INT = 0;

    DECLARE @SextoTotalHombres INT = 0;
    DECLARE @SextoTotalMujeres INT = 0;
    DECLARE @SextoTotalTotal INT = 0;

    DECLARE @SeptimoTotalHombres INT = 0;
    DECLARE @SeptimoTotalMujeres INT = 0;
    DECLARE @SeptimoTotalTotal INT = 0;

    DECLARE @OctavoTotalHombres INT = 0;
    DECLARE @OctavoTotalMujeres INT = 0;
    DECLARE @OctavoTotalTotal INT = 0;

    DECLARE @NovenoTotalHombres INT = 0;
    DECLARE @NovenoTotalMujeres INT = 0;
    DECLARE @NovenoTotalTotal INT = 0;

    DECLARE @TotalHombresNiveles INT = 0;
    DECLARE @TotalMujeresNiveles INT = 0;
    DECLARE @TotalTotalNiveles INT = 0;

    DECLARE @TotalMontoPagado INT = 0;

    DECLARE @Hombres INT = 0;
    DECLARE @Mujeres INT = 0;
    DECLARE @Total INT = 0;

    DECLARE @TotalHombres INT = 0;
    DECLARE @TotalMujeres INT = 0;
    DECLARE @TotalTotal INT = 0;

    DECLARE @MontoPagado MONEY = 0;

    DECLARE @NivelActual varchar(50);
    DECLARE @ContadorPeriodo INT = 1;
    
    --Declaración de niveles
    DECLARE @TablaNiveles TABLE(
        ID_Numeral INT IDENTITY(1, 1),
        TipoUnidadAcademica varchar(50)
    );

    INSERT INTO @TablaNiveles(
        TipoUnidadAcademica
    )VALUES
    ('NMS'),
    ('NS'),
    ('C INV'),
    ('UACA');

    DECLARE @NMS varchar(50) = 'MEDIO SUPERIOR';
    DECLARE @NS varchar(50) = 'SUPERIOR Y POSGRADO';
    DECLARE @CINV varchar(50) = 'CENTROS DE INVESTIGACIÓN';
    DECLARE @UACA varchar(50) = 'ÁREA CENTRAL';
    
    DECLARE @ContadorNivel INT = 1;
    WHILE @ContadorNivel <= (SELECT COUNT(*) FROM @TablaNiveles)
        BEGIN

            SET @TotalHombres = 0;
            SET @TotalMujeres = 0;
            SET @TotalTotal = 0;
            SET @NivelActual = (SELECT TipoUnidadAcademica FROM @TablaNiveles WHERE ID_Numeral = @ContadorNivel);

            INSERT INTO @EstimulosDocentesConcentrado(
                Nivel
            )VALUES(
                @NivelActual
            );

            SET @ContadorPeriodo = 1;
            WHILE @ContadorPeriodo <= 9
            BEGIN
                SET @Hombres = ISNULL((SELECT SUM(Desc_Hombres)
                                        FROM SAC_RegistroEstimulosAlDesempenioDocente
                                        WHERE Desc_PeriodoSAC = @ContadorPeriodo
                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas 
                                                                    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                                                                    FROM TipoUnidadAcademica 
                                                                                                    WHERE Desc_SiglasTipo = @NivelActual))
                                        AND id_Anio = (SELECT ID_Anio 
                                                        FROM Anio 
                                                        WHERE Desc_Anio = @Anio)
                                        AND id_Trimestre = @id_Trimestre), 0);
                
                SET @Mujeres = ISNULL((SELECT SUM(Desc_Mujeres)
                                        FROM SAC_RegistroEstimulosAlDesempenioDocente
                                        WHERE Desc_PeriodoSAC = @ContadorPeriodo
                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas 
                                                                    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                                                                    FROM TipoUnidadAcademica 
                                                                                                    WHERE Desc_SiglasTipo = @NivelActual))
                                        AND id_Anio = (SELECT ID_Anio 
                                                        FROM Anio 
                                                        WHERE Desc_Anio = @Anio)
                                        AND id_Trimestre = @id_Trimestre), 0);
                
                SET @MontoPagado = ISNULL((SELECT SUM(Desc_MontoPagado)
                                        FROM SAC_RegistroEDDMontosPagados
                                        WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas 
                                                                    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                                                                    FROM TipoUnidadAcademica 
                                                                                                    WHERE Desc_SiglasTipo = @NivelActual))
                                        AND id_Anio = (SELECT ID_Anio 
                                                        FROM Anio 
                                                        WHERE Desc_Anio = @Anio)
                                        AND id_Trimestre = @id_Trimestre), 0);

                SET @Total = @Hombres + @Mujeres;

                SET @TotalHombres = @TotalHombres + @Hombres;
                SET @TotalMujeres = @TotalMujeres + @Mujeres;
                SET @TotalTotal = @TotalTotal + @Total;

                IF @ContadorPeriodo = 1
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET PrimeroHombres = @Hombres,
                    PrimeroMujeres = @Mujeres,
                    PrimeroTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 2
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET SegundoHombres = @Hombres,
                    SegundoMujeres = @Mujeres,
                    SegundoTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 3
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET TerceroHombres = @Hombres,
                    TerceroMujeres = @Mujeres,
                    TerceroTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 4
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET CuartoHombres = @Hombres,
                    CuartoMujeres = @Mujeres,
                    CuartoTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 5
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET QuintoHombres = @Hombres,
                    QuintoMujeres = @Mujeres,
                    QuintoTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 6
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET SextoHombres = @Hombres,
                    SextoMujeres = @Mujeres,
                    SextoTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 7
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET SeptimoHombres = @Hombres,
                    SeptimoMujeres = @Mujeres,
                    SeptimoTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 8
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET OctavoHombres = @Hombres,
                    OctavoMujeres = @Mujeres,
                    OctavoTotal = @Total
                    WHERE Nivel = @NivelActual;
                END
                ELSE IF @ContadorPeriodo = 9
                BEGIN
                    UPDATE @EstimulosDocentesConcentrado
                    SET
                        NovenoHombres = @Hombres,
                        NovenoMujeres = @Mujeres,
                        NovenoTotal = @Total,
                        MontoPagado = @MontoPagado,
                        TotalHombres = @TotalHombres,
                        TotalMujeres = @TotalMujeres,
                        TotalTotal = @TotalTotal
                    WHERE Nivel = @NivelActual;
                END
                SET @ContadorPeriodo = @ContadorPeriodo + 1;
            END
            SET @ContadorNivel = @ContadorNivel + 1;
        END

    SET @PrimerTotalHombres = ISNULL((SELECT SUM(PrimeroHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @PrimerTotalMujeres = ISNULL((SELECT SUM(PrimeroMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @PrimerTotalTotal = ISNULL((SELECT SUM(PrimeroTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @SegundoTotalHombres = ISNULL((SELECT SUM(SegundoHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @SegundoTotalMujeres = ISNULL((SELECT SUM(SegundoMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @SegundoTotalTotal = ISNULL((SELECT SUM(SegundoTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @TerceroTotalHombres = ISNULL((SELECT SUM(TerceroHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @TerceroTotalMujeres = ISNULL((SELECT SUM(TerceroMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @TerceroTotalTotal = ISNULL((SELECT SUM(TerceroTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @CuartoTotalHombres = ISNULL((SELECT SUM(CuartoHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @CuartoTotalMujeres = ISNULL((SELECT SUM(CuartoMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @CuartoTotalTotal = ISNULL((SELECT SUM(CuartoTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @QuintoTotalHombres = ISNULL((SELECT SUM(QuintoHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @QuintoTotalMujeres = ISNULL((SELECT SUM(QuintoMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @QuintoTotalTotal = ISNULL((SELECT SUM(QuintoTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @SextoTotalHombres = ISNULL((SELECT SUM(SextoHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @SextoTotalMujeres = ISNULL((SELECT SUM(SextoMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @SextoTotalTotal = ISNULL((SELECT SUM(SextoTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @SeptimoTotalHombres = ISNULL((SELECT SUM(SeptimoHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @SeptimoTotalMujeres = ISNULL((SELECT SUM(SeptimoMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @SeptimoTotalTotal = ISNULL((SELECT SUM(SeptimoTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @OctavoTotalHombres = ISNULL((SELECT SUM(OctavoHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @OctavoTotalMujeres = ISNULL((SELECT SUM(OctavoMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @OctavoTotalTotal = ISNULL((SELECT SUM(OctavoTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @NovenoTotalHombres = ISNULL((SELECT SUM(NovenoHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @NovenoTotalMujeres = ISNULL((SELECT SUM(NovenoMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @NovenoTotalTotal = ISNULL((SELECT SUM(NovenoTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @TotalHombresNiveles = ISNULL((SELECT SUM(TotalHombres) FROM @EstimulosDocentesConcentrado), 0);
    SET @TotalMujeresNiveles = ISNULL((SELECT SUM(TotalMujeres) FROM @EstimulosDocentesConcentrado), 0);
    SET @TotalTotalNiveles = ISNULL((SELECT SUM(TotalTotal) FROM @EstimulosDocentesConcentrado), 0);
    SET @TotalMontoPagado = ISNULL((SELECT SUM(MontoPagado) FROM @EstimulosDocentesConcentrado), 0);

    INSERT INTO @EstimulosDocentesConcentrado
    VALUES(
        'TOTAL',
        @PrimerTotalHombres,
        @PrimerTotalMujeres,
        @PrimerTotalTotal,
        @SegundoTotalHombres,
        @SegundoTotalMujeres,
        @SegundoTotalTotal,
        @TerceroTotalHombres,
        @TerceroTotalMujeres,
        @TerceroTotalTotal,
        @CuartoTotalHombres,
        @CuartoTotalMujeres,
        @CuartoTotalTotal,
        @QuintoTotalHombres,
        @QuintoTotalMujeres,
        @QuintoTotalTotal,
        @SextoTotalHombres,
        @SextoTotalMujeres,
        @SextoTotalTotal,
        @SeptimoTotalHombres,
        @SeptimoTotalMujeres,
        @SeptimoTotalTotal,
        @OctavoTotalHombres,
        @OctavoTotalMujeres,
        @OctavoTotalTotal,
        @NovenoTotalHombres,
        @NovenoTotalMujeres,
        @NovenoTotalTotal,
        @TotalHombresNiveles,
        @TotalMujeresNiveles,
        @TotalTotalNiveles,
        @TotalMontoPagado
    );
    
    UPDATE @EstimulosDocentesConcentrado
    SET
        Nivel = @NMS
    WHERE Nivel = 'NMS';

    UPDATE @EstimulosDocentesConcentrado
    SET
        Nivel = @NS
    WHERE Nivel = 'NS';

    UPDATE @EstimulosDocentesConcentrado
    SET
        Nivel = @CINV
    WHERE Nivel = 'C INV';

    UPDATE @EstimulosDocentesConcentrado
    SET
        Nivel = @UACA
    WHERE Nivel = 'UACA';

    SELECT * FROM @EstimulosDocentesConcentrado
END