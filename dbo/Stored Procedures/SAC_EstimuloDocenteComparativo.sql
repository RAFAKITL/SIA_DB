-- Jesus Perez
-- Formato 19 Estimulo al desempeño docente comparativo
CREATE PROCEDURE SAC_EstimuloDocenteComparativo
    @anio INT,
    @trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @AnioAnterior INT = @anio - 1;
    DECLARE @NMS VARCHAR(100) = 'NMS';
    DECLARE @NS VARCHAR(100) = 'NS';
    DECLARE @CINV VARCHAR(100) = 'C INV';
    DECLARE @AC VARCHAR(100) = 'UACA';
    DECLARE @ProgramaApoyoSAC VARCHAR(100) = 'ESTÍMULO AL DESEMPEÑO DOCENTE';

    DECLARE @EDDAnteriorHom INT = 0;
    DECLARE @EDDAnteriorMuj INT = 0;
    DECLARE @EDDAnteriorTotal INT = 0;
    DECLARE @MontoAnterior INT = 0;

    DECLARE @EDDActualHom INT =0 ;
    DECLARE @EDDActualMuj INT =0 ;
    DECLARE @EDDActualTotal INT = 0;
    DECLARE @MontoActual INT = 0;

    DECLARE @VariacionEDD DECIMAL(10,2) = 0;
    DECLARE @VariacionMonto DECIMAL(10,2) = 0;
    DECLARE @Justificacion VARCHAR(255) = '';

    DECLARE @TablaNiveles TABLE(
    identificador INT IDENTITY(1,1),
    Nivel VARCHAR(255) NOT NULL DEFAULT '',
    Desc_Nivel VARCHAR(255) NOT NULL DEFAULT '',
    id_TipoUnidadAcademica INT NOT NULL DEFAULT 0
    )
    INSERT INTO @TablaNiveles (Nivel, Desc_Nivel)
    VALUES (@NMS, 'Medio Superior'), (@NS, 'Superior'), (@CINV, 'Centros de Investigación'), (@AC, 'Área Central');
    UPDATE @TablaNiveles 
    SET id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @NMS)
    WHERE Nivel = @NMS;
    UPDATE @TablaNiveles
    SET id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @NS)
    WHERE Nivel = @NS;
    UPDATE @TablaNiveles
    SET id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @CINV)
    WHERE Nivel = @CINV;
    UPDATE @TablaNiveles
    SET id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica FROM TipoUnidadAcademica WHERE Desc_SiglasTipo = @AC)
    WHERE Nivel = @AC;

    DECLARE @TablaEstimuloDocenteComparativo TABLE(
        Nivel VARCHAR(255),

        EDDAnteriorHom INT NOT NULL DEFAULT 0,
        EDDAnteriorMuj INT NOT NULL DEFAULT 0,
        EDDAnteriorTotal INT NOT NULL DEFAULT 0,
        MontoAnterior INT NOT NULL DEFAULT 0,
        
        EDDActualHom INT NOT NULL DEFAULT 0,
        EDDActualMuj INT NOT NULL DEFAULT 0,
        EDDActualTotal INT NOT NULL DEFAULT 0,
        MontoActual INT NOT NULL DEFAULT 0,

        VariacionEDD DECIMAL(10,2) NOT NULL DEFAULT 0,
        VariacionMonto DECIMAL(10,2) NOT NULL DEFAULT 0,
        Justificacion VARCHAR(255) NOT NULL DEFAULT ''
    );
    INSERT INTO @TablaEstimuloDocenteComparativo (Nivel)
    SELECT Desc_Nivel FROM @TablaNiveles;

    DECLARE @ContadorNivel INT = 1;
    WHILE @ContadorNivel <= (SELECT COUNT(*) FROM @TablaNiveles)
    BEGIN
        SET @EDDAnteriorHom = ISNULL( (SELECT SUM(Desc_Hombres)
                                                FROM SAC_RegistroEstimulosAlDesempenioDocente
                                                WHERE id_Trimestre <= @Trimestre 
                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);
        SET @EDDAnteriorMuj = ISNULL( (SELECT SUM(Desc_Mujeres)
                                                FROM SAC_RegistroEstimulosAlDesempenioDocente
                                                WHERE id_Trimestre <= @Trimestre 
                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);
        SET @EDDAnteriorTotal = @EDDAnteriorHom + @EDDAnteriorMuj;
        SET @MontoAnterior = ISNULL((SELECT SUM(Desc_MontoPagado)
                                        FROM SAC_RegistroEDDMontosPagados
                                        WHERE  id_Trimestre <= @Trimestre 
                                        AND id_Anio = (SELECT ID_Anio 
                                                        FROM Anio 
                                                        WHERE Desc_Anio = @AnioAnterior)
                                        AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas 
                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                    FROM @TablaNiveles
                                                                                                    WHERE identificador = @ContadorNivel) )), 0);

        SET @EDDActualHom = ISNULL( (SELECT SUM(Desc_Hombres)
                                        FROM SAC_RegistroEstimulosAlDesempenioDocente
                                        WHERE id_Trimestre <= @Trimestre 
                                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                        AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                FROM UnidadesAcademicas 
                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                FROM @TablaNiveles
                                                                                                                WHERE identificador = @ContadorNivel) )),0);

        SET @EDDActualMuj = ISNULL( (SELECT SUM(Desc_Mujeres)
                                        FROM SAC_RegistroEstimulosAlDesempenioDocente
                                        WHERE id_Trimestre <= @Trimestre 
                                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                        AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                FROM UnidadesAcademicas 
                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                FROM @TablaNiveles
                                                                                                                WHERE identificador = @ContadorNivel) )),0);
        SET @EDDActualTotal = @EDDActualHom + @EDDActualMuj;
        SET @MontoActual = ISNULL((SELECT SUM(Desc_MontoPagado)
                                        FROM SAC_RegistroEDDMontosPagados
                                        WHERE  id_Trimestre <= @Trimestre 
                                        AND id_Anio = (SELECT ID_Anio 
                                                        FROM Anio 
                                                        WHERE Desc_Anio = @anio)
                                        AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                    FROM UnidadesAcademicas 
                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                    FROM @TablaNiveles
                                                                                                    WHERE identificador = @ContadorNivel) )), 0);

        SET @VariacionEDD = CASE WHEN @EDDActualTotal = 0 THEN 0 ELSE (CAST(@EDDActualTotal AS DECIMAL(10,2)) - CAST(@EDDAnteriorTotal AS DECIMAL(10,2)))/CAST(@EDDAnteriorTotal AS DECIMAL(10,2))*100 END;
        SET @VariacionMonto = CASE WHEN @MontoActual = 0 THEN 0 ELSE (CAST(@MontoActual AS DECIMAL(10,2)) - CAST(@MontoAnterior AS DECIMAL(10,2)))/CAST(@MontoAnterior AS DECIMAL(10,2))*100 END;

        SET @Justificacion = ISNULL((SELECT TOP 1 Desc_Justificacion 
                            FROM SAC_Justificaciones
                            WHERE id_Anio = (SELECT ID_Anio
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)
                            AND id_Trimestre = @Trimestre
                            AND id_ProgramaApoyoSAC = (SELECT ID_ProgramaApoyoSAC
                                                        FROM SAC_ProgramaApoyo
                                                        WHERE Desc_ProgramaApoyoSAC = @ProgramaApoyoSAC)
                            AND id_TipoUnidadAcademicaSAC = (SELECT id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                            FROM @TablaNiveles
                                                                                            WHERE identificador = @ContadorNivel))), '');


        UPDATE @TablaEstimuloDocenteComparativo
        SET 
        EDDAnteriorHom = @EDDAnteriorHom,
        EDDAnteriorMuj = @EDDAnteriorMuj,
        EDDAnteriorTotal = @EDDAnteriorTotal,
        MontoAnterior = @MontoAnterior,
        EDDActualHom = @EDDActualHom,
        EDDActualMuj = @EDDActualMuj,
        EDDActualTotal = @EDDActualTotal,
        MontoActual = @MontoActual,
        VariacionEDD = @VariacionEDD,
        VariacionMonto = @VariacionMonto,
        Justificacion = @Justificacion
        WHERE Nivel = (SELECT Desc_Nivel FROM @TablaNiveles WHERE identificador = @ContadorNivel);

        SET @ContadorNivel = @ContadorNivel + 1;
    END
    SELECT * FROM @TablaEstimuloDocenteComparativo
    UNION ALL
    SELECT 
        'Total', 
        SUM(EDDAnteriorHom), 
        SUM(EDDAnteriorMuj), 
        SUM(EDDAnteriorTotal), 
        SUM(MontoAnterior),
        SUM(EDDActualHom),
        SUM(EDDActualMuj), 
        SUM(EDDActualTotal), 
        SUM(MontoActual),
        CAST(
            CASE 
                WHEN SUM(EDDAnteriorTotal) = 0 THEN 0 
                ELSE (SUM(EDDActualTotal) - SUM(EDDAnteriorTotal)) * 100.0 / NULLIF(SUM(EDDAnteriorTotal), 0) 
            END 
            AS DECIMAL(10,2)
        ),
        CAST(
            CASE 
                WHEN SUM(MontoAnterior) = 0 THEN 0 
                ELSE (SUM(MontoActual) - SUM(MontoAnterior)) * 100.0 / NULLIF(SUM(MontoAnterior), 0) 
            END 
            AS DECIMAL(10,2)
        ),        
        @Justificacion
    FROM @TablaEstimuloDocenteComparativo;

END
    