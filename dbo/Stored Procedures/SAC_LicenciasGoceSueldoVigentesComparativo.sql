-- Jesus Perez 
-- Formato 27 - Licencias con goce de sueldo vigentes comparativo
CREATE PROCEDURE SAC_LicenciasGoceSueldoVigentesComparativo
    @Anio INT,
    @Trimestre INT
AS
BEGIN
    -- SET NOCOUNT ON;
    DECLARE @NACIONAL VARCHAR(100) = 'NACIONAL';
    DECLARE @EXTRANJERO VARCHAR(100) = 'EXTRANJERO';
    DECLARE @NMS VARCHAR(100) = 'NMS';
    DECLARE @NS VARCHAR(100) = 'NS';
    DECLARE @CINV VARCHAR(100) = 'C INV';
    DECLARE @AC VARCHAR(100) = 'UACA';
    DECLARE @LICENCIASGOCESUELDO VARCHAR(100) = 'LICENCIAS CON GOCE DE SUELDO';

    DECLARE @AnioAnterior INT = @Anio - 1;

    DECLARE @PerAntHomNac INT = 0;
    DECLARE @PerAntMujNac INT = 0;
    DECLARE @PerAntTotalNac INT = 0;
    DECLARE @PerAntHomExt INT = 0;
    DECLARE @PerAntMujExt INT = 0;
    DECLARE @PerAntTotalExt INT = 0;
    DECLARE @PerActHomNac INT = 0;
    DECLARE @PerActMujNac INT = 0;
    DECLARE @PerActTotalNac INT = 0;
    DECLARE @PerActHomExt INT = 0;
    DECLARE @PerActMujExt INT = 0;
    DECLARE @PerActTotalExt INT = 0;

    DECLARE @VariacionNacional DECIMAL(10, 2) = 0;
    DECLARE @VariacionExtranjero DECIMAL(10, 2) = 0;
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

    DECLARE @TablaLicenciasComparativo TABLE(
        Nivel VARCHAR(100),
        PerAntHomNac INT NOT NULL DEFAULT 0,
        PerAntMujNac INT  NOT NULL DEFAULT 0,
        PerAntTotalNac INT  NOT NULL DEFAULT 0,
        PerAntHomExt INT  NOT NULL DEFAULT 0,
        PerAntMujExt INT  NOT NULL DEFAULT 0,
        PerAntTotalExt INT  NOT NULL DEFAULT 0,
        
        PerActHomNac INT  NOT NULL DEFAULT 0,
        PerActMujNac INT  NOT NULL DEFAULT 0,
        PerActTotalNac INT  NOT NULL DEFAULT 0,
        PerActHomExt INT  NOT NULL DEFAULT 0,
        PerActMujExt INT  NOT NULL DEFAULT 0,
        PerActTotalExt INT  NOT NULL DEFAULT 0,

        VariacionNacional DECIMAL(10, 2) NOT NULL DEFAULT 0,
        VariacionExtranjero DECIMAL(10, 2) NOT NULL DEFAULT 0,
        Justificacion VARCHAR(255) NOT NULL DEFAULT ''
    );
    INSERT INTO @TablaLicenciasComparativo (Nivel)
    SELECT Desc_Nivel FROM @TablaNiveles;
    
    DECLARE @ContadorNivel INT = 1;
    WHILE @ContadorNivel <= (SELECT COUNT(*)FROM @TablaLicenciasComparativo)
    BEGIN
        SET @PerAntHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo 
                                                    WHERE id_Trimestre <= @Trimestre 
                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);

        SET @PerAntMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                    WHERE id_Trimestre <= @Trimestre 
                                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);

        SET @PerAntTotalNac = @PerAntHomNac + @PerAntMujNac;

        SET @PerAntHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                    WHERE id_Trimestre <= @Trimestre 
                                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);
        SET @PerAntMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                    WHERE id_Trimestre <= @Trimestre 
                                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);
        SET @PerAntTotalExt = @PerAntHomExt + @PerAntMujExt;

        SET @PerActHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                    WHERE id_Trimestre = @Trimestre 
                                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);
        SET @PerActMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                    WHERE id_Trimestre = @Trimestre 
                                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);
        SET @PerActTotalNac = @PerActHomNac + @PerActMujNac;

        SET @PerActHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                    WHERE id_Trimestre <= @Trimestre 
                                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);    
        SET @PerActMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                    WHERE id_Trimestre <= @Trimestre
                                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                    AND id_UnidadAcademicaSAC IN (SELECT id_UnidadAcademica 
                                                                                                    FROM UnidadesAcademicas 
                                                                                                    WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                                                                    FROM @TablaNiveles
                                                                                                                                    WHERE identificador = @ContadorNivel) )),0);
        SET @PerActTotalExt = @PerActHomExt + @PerActMujExt;

        SET @VariacionNacional = CASE WHEN @PerAntTotalNac = 0 THEN 0 ELSE ((@PerActTotalNac - @PerAntTotalNac) * 100.0) / @PerAntTotalNac END;
        SET @VariacionExtranjero = CASE WHEN @PerAntTotalExt = 0 THEN 0 ELSE ((@PerActTotalExt - @PerAntTotalExt) * 100.0) / @PerAntTotalExt END;

        SET @Justificacion = ISNULL((SELECT TOP 1 Desc_Justificacion 
                            FROM SAC_Justificaciones
                            WHERE id_Anio = (SELECT ID_Anio
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)
                            AND id_Trimestre = @Trimestre
                            AND id_TipoUnidadAcademicaSAC = (SELECT id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica
                                                                                            FROM @TablaNiveles
                                                                                            WHERE identificador = @ContadorNivel))
                            AND id_ProgramaApoyoSAC = (SELECT ID_ProgramaApoyoSAC
                                                        FROM SAC_ProgramaApoyo
                                                        WHERE Desc_ProgramaApoyoSAC = @LICENCIASGOCESUELDO)), '');

        UPDATE @TablaLicenciasComparativo
        SET PerAntHomNac = @PerAntHomNac,
            PerAntMujNac = @PerAntMujNac,
            PerAntTotalNac = @PerAntTotalNac,
            PerAntHomExt = @PerAntHomExt,
            PerAntMujExt = @PerAntMujExt,
            PerAntTotalExt = @PerAntTotalExt,
            PerActHomNac = @PerActHomNac,
            PerActMujNac = @PerActMujNac,
            PerActTotalNac = @PerActTotalNac,
            PerActHomExt = @PerActHomExt,
            PerActMujExt = @PerActMujExt,
            PerActTotalExt = @PerActTotalExt,
            VariacionNacional = @VariacionNacional,
            VariacionExtranjero = @VariacionExtranjero,
            Justificacion = @Justificacion
        WHERE Nivel = (SELECT Desc_Nivel FROM @TablaNiveles WHERE identificador = @ContadorNivel);
        SET @ContadorNivel = @ContadorNivel + 1;
    END

    SELECT * FROM @TablaLicenciasComparativo
    UNION ALL
    SELECT 'Total',
    SUM(PerAntHomNac),
    SUM(PerAntMujNac),
    SUM(PerAntTotalNac),
    SUM(PerAntHomExt),
    SUM(PerAntMujExt),
    SUM(PerAntTotalExt),
    SUM(PerActHomNac),
    SUM(PerActMujNac),
    SUM(PerActTotalNac),
    SUM(PerActHomExt),
    SUM(PerActMujExt),
    SUM(PerActTotalExt),
    @VariacionNacional,
    @VariacionExtranjero,
    @Justificacion
    FROM @TablaLicenciasComparativo;
END