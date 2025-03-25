-- Formato 18 Estimulo al desempeno docente acumulado vigentes
-- Autor: Kitl Hernández Jesús Rafael
CREATE PROCEDURE SAC_EstimuloDocenteAcumulado
    @Anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @EstimuloDocenteAcumulado TABLE(
        Nivel varchar(255),

        PrimerEDDHombres varchar(255) NOT NULL DEFAULT ' ',
        PrimerEDDMujeres varchar(255) NOT NULL DEFAULT ' ',
        PrimerEDDTotal varchar(255) NOT NULL DEFAULT ' ',
        PrimerMonto varchar(255) NOT NULL DEFAULT ' ',

        SegundoEDDHombres varchar(255) NOT NULL DEFAULT ' ',
        SegundoEDDMujeres varchar(255) NOT NULL DEFAULT ' ',
        SegundoEDDTotal varchar(255) NOT NULL DEFAULT ' ',
        SegundoMonto varchar(255) NOT NULL DEFAULT ' ',

        TercerEDDHombres varchar(255) NOT NULL DEFAULT ' ',
        TercerEDDMujeres varchar(255) NOT NULL DEFAULT ' ',
        TercerEDDTotal varchar(255) NOT NULL DEFAULT ' ',
        TercerMonto varchar(255) NOT NULL DEFAULT ' ',

        CuartoEDDHombres varchar(255) NOT NULL DEFAULT ' ',
        CuartoEDDMujeres varchar(255) NOT NULL DEFAULT ' ',
        CuartoEDDTotal varchar(255) NOT NULL DEFAULT ' ',
        CuartoMonto varchar(255) NOT NULL DEFAULT ' ',

        CifrasEDDHombres varchar(255) NOT NULL DEFAULT ' ',
        CifrasEDDMujeres varchar(255) NOT NULL DEFAULT ' ',
        CifrasEDDTotal varchar(255) NOT NULL DEFAULT ' ',
        CifrasMonto varchar(255) NOT NULL DEFAULT ' '
    );

    DECLARE @EDDHombres INT;
    DECLARE @EDDMujeres INT;
    DECLARE @EDDTotal INT;
    DECLARE @Monto MONEY;

    DECLARE @CifrasEDDHombres INT;
    DECLARE @CifrasEDDMujeres INT;
    DECLARE @CifrasEDDTotal INT;
    DECLARE @CifrasMonto MONEY;

    DECLARE @NivelActual varchar(255);
    DECLARE @ContadorNivel INT = 1;
    DECLARE @ContadorTrimestre INT = 1;

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

    SET @ContadorNivel = 1;
    WHILE @ContadorNivel <= (SELECT COUNT(*) FROM @TablaNiveles)
        BEGIN
            SET @NivelActual = (SELECT TipoUnidadAcademica FROM @TablaNiveles WHERE ID_Numeral = @ContadorNivel);
            SET @CifrasEDDHombres = 0;
            SET @CifrasEDDMujeres = 0;
            SET @CifrasEDDTotal = 0;
            SET @CifrasMonto = 0;

            INSERT INTO @EstimuloDocenteAcumulado(
                Nivel
            )VALUES(
                @NivelActual
            );
            
            SET @ContadorTrimestre = 1;
            WHILE @ContadorTrimestre <= @id_Trimestre
                BEGIN
                    SET @EDDHombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM SAC_RegistroEstimulosAlDesempenioDocente
                                        WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                                                                        FROM TipoUnidadAcademica 
                                                                                                        WHERE Desc_SiglasTipo = @NivelActual))
                                        AND id_Anio = (SELECT ID_Anio 
                                                        FROM Anio
                                                        WHERE Desc_Anio = @Anio)
                                        AND id_Trimestre = @ContadorTrimestre), 0);

                    SET @EDDMujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                        FROM SAC_RegistroEstimulosAlDesempenioDocente
                                        WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                                                                        FROM TipoUnidadAcademica 
                                                                                                        WHERE Desc_SiglasTipo = @NivelActual))
                                        AND id_Anio = (SELECT ID_Anio 
                                                        FROM Anio
                                                        WHERE Desc_Anio = @Anio)
                                        AND id_Trimestre = @ContadorTrimestre), 0);

                    SET @EDDTotal = ISNULL((@EDDHombres + @EDDMujeres), 0);
                    
                    SET @Monto = ISNULL((SELECT SUM(Desc_MontoPagado)
                                    FROM SAC_RegistroEDDMontosPagados
                                    WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                                                                                        FROM TipoUnidadAcademica 
                                                                                                        WHERE Desc_SiglasTipo = @NivelActual))
                                    AND id_Anio = (SELECT ID_Anio 
                                                    FROM Anio
                                                    WHERE Desc_Anio = @Anio)
                                    AND id_Trimestre = @ContadorTrimestre), 0);

                    SET @CifrasEDDHombres = CASE WHEN @EDDTotal > @CifrasEDDTotal
                                            THEN @EDDHombres
                                            ELSE @CifrasEDDHombres
                                            END;
                    
                    SET @CifrasEDDMujeres = CASE WHEN @EDDTotal > @CifrasEDDTotal
                                            THEN @EDDMujeres
                                            ELSE @CifrasEDDMujeres
                                            END;
                    
                    SET @CifrasEDDTotal = CASE WHEN @EDDTotal > @CifrasEDDTotal
                                            THEN @EDDTotal
                                            ELSE @CifrasEDDTotal
                                            END;

                    SET @CifrasMonto = @CifrasMonto + @Monto;
                    
                    IF @ContadorTrimestre = 1
                        BEGIN
                            UPDATE @EstimuloDocenteAcumulado
                            SET PrimerEDDHombres = @EDDHombres,
                                PrimerEDDMujeres = @EDDMujeres,
                                PrimerEDDTotal = @EDDTotal,
                                PrimerMonto = @Monto
                            WHERE Nivel = @NivelActual;
                        END
                    ELSE IF @ContadorTrimestre = 2
                        BEGIN
                            UPDATE @EstimuloDocenteAcumulado
                            SET SegundoEDDHombres = @EDDHombres,
                                SegundoEDDMujeres = @EDDMujeres,
                                SegundoEDDTotal = @EDDTotal,
                                SegundoMonto = @Monto
                            WHERE Nivel = @NivelActual;
                        END
                    ELSE IF @ContadorTrimestre = 3
                        BEGIN
                            UPDATE @EstimuloDocenteAcumulado
                            SET TercerEDDHombres = @EDDHombres,
                                TercerEDDMujeres = @EDDMujeres,
                                TercerEDDTotal = @EDDTotal,
                                TercerMonto = @Monto
                            WHERE Nivel = @NivelActual;
                        END
                    ELSE IF @ContadorTrimestre = 4
                        BEGIN
                            UPDATE @EstimuloDocenteAcumulado
                            SET CuartoEDDHombres = @EDDHombres,
                                CuartoEDDMujeres = @EDDMujeres,
                                CuartoEDDTotal = @EDDTotal,
                                CuartoMonto = @Monto
                            WHERE Nivel = @NivelActual;
                        END

                    SET @ContadorTrimestre = @ContadorTrimestre + 1;
                END
            
            UPDATE @EstimuloDocenteAcumulado
            SET CifrasEDDHombres = @CifrasEDDHombres,
                CifrasEDDMujeres = @CifrasEDDMujeres,
                CifrasEDDTotal = @CifrasEDDTotal,
                CifrasMonto = @CifrasMonto
            WHERE Nivel = @NivelActual;
            
            SET @ContadorNivel = @ContadorNivel + 1;
        END

    INSERT INTO @EstimuloDocenteAcumulado
    VALUES(
        'TOTAL',
        ISNULL((SELECT SUM(CAST(PrimerEDDHombres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(PrimerEDDMujeres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(PrimerEDDTotal AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(PrimerMonto AS MONEY)) FROM @EstimuloDocenteAcumulado), 0),

        ISNULL((SELECT SUM(CAST(SegundoEDDHombres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(SegundoEDDMujeres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(SegundoEDDTotal AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(SegundoMonto AS MONEY)) FROM @EstimuloDocenteAcumulado), 0),

        ISNULL((SELECT SUM(CAST(TercerEDDHombres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(TercerEDDMujeres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(TercerEDDTotal AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(TercerMonto AS MONEY)) FROM @EstimuloDocenteAcumulado), 0),

        ISNULL((SELECT SUM(CAST(CuartoEDDHombres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(CuartoEDDMujeres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(CuartoEDDTotal AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(CuartoMonto AS MONEY)) FROM @EstimuloDocenteAcumulado), 0),

        ISNULL((SELECT SUM(CAST(CifrasEDDHombres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(CifrasEDDMujeres AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(CifrasEDDTotal AS INT)) FROM @EstimuloDocenteAcumulado), 0),
        ISNULL((SELECT SUM(CAST(CifrasMonto AS MONEY)) FROM @EstimuloDocenteAcumulado), 0)
    );

    UPDATE @EstimuloDocenteAcumulado
    SET
        Nivel = @NMS
    WHERE Nivel = 'NMS';

    UPDATE @EstimuloDocenteAcumulado
    SET
        Nivel = @NS
    WHERE Nivel = 'NS';

    UPDATE @EstimuloDocenteAcumulado
    SET
        Nivel = @CINV
    WHERE Nivel = 'C INV';

    UPDATE @EstimuloDocenteAcumulado
    SET
        Nivel = @UACA
    WHERE Nivel = 'UACA';

    SELECT * FROM @EstimuloDocenteAcumulado
END