-- Formato 26 Licencias con goce de sueldo vigentes acumulado
CREATE PROCEDURE SAC_LicenciasGoceSueldoVigentesAcumulado
    @Anio INT,
    @Trimestre INT
AS
BEGIN
    DECLARE @NACIONAL VARCHAR(100) = 'NACIONAL';
    DECLARE @EXTRANJERO VARCHAR(100) = 'EXTRANJERO';
    DECLARE @NMS VARCHAR(100) = 'NMS';
    DECLARE @NS VARCHAR(100) = 'NS';
    DECLARE @CENTROSINVESTIGACION VARCHAR(100) = 'C INV';
    DECLARE @AREACENTRAL VARCHAR(100) = 'UACA';

    DECLARE @NMSHomNacional INT = 0;
    DECLARE @NMSMujNacional INT = 0;
    DECLARE @NMSHomExtranjero INT = 0;
    DECLARE @NMSMujExtranjero INT = 0;
    DECLARE @NSHomNacional INT = 0;
    DECLARE @NSMujNacional INT = 0;
    DECLARE @NSHomExtranjero INT = 0;
    DECLARE @NSMujExtranjero INT = 0;
    DECLARE @CIHomNacional INT = 0;
    DECLARE @CIMujNacional INT = 0;
    DECLARE @CIHomExtranjero INT = 0;
    DECLARE @CIMujExtranjero INT = 0;
    DECLARE @ACHomNacional INT = 0;
    DECLARE @ACMujNacional INT = 0;
    DECLARE @ACHomExtranjero INT = 0;
    DECLARE @ACMujExtranjero INT = 0;
    DECLARE @SubTotalHomNacional INT = 0;
    DECLARE @SubTotalMujNacional INT = 0;
    DECLARE @TotalNacional INT = 0;
    DECLARE @SubTotalHomExtranjero INT = 0;
    DECLARE @SubTotalMujExtranjero INT = 0;
    DECLARE @TotalExtranjero INT = 0;
    DECLARE @Total INT = 0;

    DECLARE @TablaLicenciasVigentesAcumulado TABLE(
        Periodo VARCHAR(100) NOT NULL DEFAULT '',
        NMSHomNacional INT NOT NULL DEFAULT 0,
        NMSMujNacional INT NOT NULL DEFAULT 0,
        NMSHomExtranjero INT NOT NULL DEFAULT 0,
        NMSMujExtranjero INT NOT NULL DEFAULT 0,

        NSHomNacional INT NOT NULL DEFAULT 0,
        NSMujNacional INT NOT NULL DEFAULT 0,
        NSHomExtranjero INT NOT NULL DEFAULT 0,
        NSMujExtranjero INT NOT NULL DEFAULT 0,

        CIHomNacional INT NOT NULL DEFAULT 0,
        CIMujNacional INT NOT NULL DEFAULT 0,
        CIHomExtranjero INT NOT NULL DEFAULT 0,
        CIMujExtranjero INT NOT NULL DEFAULT 0,

        ACHomNacional INT NOT NULL DEFAULT 0,
        ACMujNacional INT NOT NULL DEFAULT 0,
        ACHomExtranjero INT NOT NULL DEFAULT 0,
        ACMujExtranjero INT NOT NULL DEFAULT 0,

        SubTotalHomNacional INT NOT NULL DEFAULT 0,
        SubTotalMujNacional INT NOT NULL DEFAULT 0,
        TotalNacional INT NOT NULL DEFAULT 0,
        
        SubTotalHomExtranjero INT NOT NULL DEFAULT 0,
        SubTotalMujExtranjero INT NOT NULL DEFAULT 0,
        TotalExtranjero INT NOT NULL DEFAULT 0,

        Total INT NOT NULL DEFAULT 0
    )
    INSERT INTO @TablaLicenciasVigentesAcumulado (Periodo)
    SELECT Desc_PeriodoTrimestre FROM Trimestre WHERE ID_Trimestre <= @Trimestre;

    DECLARE @ContadorPeriodo INT = 1
    WHILE @ContadorPeriodo <= @Trimestre
    BEGIN

        SET @NMSHomNacional = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo 
                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NMS))),0);
        SET @NMSMujNacional = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo 
                                                        WHERE id_Trimestre = @ContadorPeriodo       
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NMS))),0);
        SET @NMSHomExtranjero = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)    
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NMS))),0);
        SET @NMSMujExtranjero = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)    
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NMS))),0);

        SET @NSHomNacional = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)        
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NS))),0);
        SET @NSMujNacional = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NS))),0);
        SET @NSHomExtranjero = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)    
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NS))),0);
        SET @NSMujExtranjero = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @NS))),0);
        SET @CIHomNacional = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)        
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @CENTROSINVESTIGACION))),0);
        SET @CIMujNacional = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @CENTROSINVESTIGACION))),0);
        SET @CIHomExtranjero = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @CENTROSINVESTIGACION))),0);
        SET @CIMujExtranjero = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @CENTROSINVESTIGACION))),0);
        SET @ACHomNacional = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                        WHERE id_Trimestre = @ContadorPeriodo   
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @AREACENTRAL))),0);
        SET @ACMujNacional = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                        AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                        AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                        AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @AREACENTRAL))),0);
        SET @ACHomExtranjero = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @AREACENTRAL))),0);
        SET @ACMujExtranjero = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                            WHERE id_Trimestre = @ContadorPeriodo
                                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                            AND id_Origen = (SELECT ID_OriginSAC From SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica FROM UnidadesAcademicas 
                                                                                                                WHERE id_TipoUnidadAcademica = (SELECT id_TipoUnidadAcademica 
                                                                                                                                                FROM TipoUnidadAcademica 
                                                                                                                                                WHERE Desc_SiglasTipo = @AREACENTRAL))),0);

        SET @SubTotalHomNacional = @NMSHomNacional + @NSHomNacional + @CIHomNacional + @ACHomNacional;
        SET @SubTotalMujNacional = @NMSMujNacional + @NSMujNacional + @CIMujNacional + @ACMujNacional;
        SET @TotalNacional = @SubTotalHomNacional + @SubTotalMujNacional;

        SET @SubTotalHomExtranjero = @NMSHomExtranjero + @NSHomExtranjero + @CIHomExtranjero + @ACHomExtranjero;
        SET @SubTotalMujExtranjero = @NMSMujExtranjero + @NSMujExtranjero + @CIMujExtranjero + @ACMujExtranjero;
        SET @TotalExtranjero = @SubTotalHomExtranjero + @SubTotalMujExtranjero;

        SET @Total = @TotalNacional + @TotalExtranjero;

        UPDATE @TablaLicenciasVigentesAcumulado
        SET NMSHomNacional = @NMSHomNacional,
            NMSMujNacional = @NMSMujNacional,
            NMSHomExtranjero = @NMSHomExtranjero,
            NMSMujExtranjero = @NMSMujExtranjero,
            NSHomNacional = @NSHomNacional,
            NSMujNacional = @NSMujNacional,
            NSHomExtranjero = @NSHomExtranjero,
            NSMujExtranjero = @NSMujExtranjero,
            CIHomNacional = @CIHomNacional,
            CIMujNacional = @CIMujNacional,
            CIHomExtranjero = @CIHomExtranjero,
            CIMujExtranjero = @CIMujExtranjero,
            ACHomNacional = @ACHomNacional,
            ACMujNacional = @ACMujNacional,
            ACHomExtranjero = @ACHomExtranjero,
            ACMujExtranjero = @ACMujExtranjero,
            SubTotalHomNacional = @SubTotalHomNacional,
            SubTotalMujNacional = @SubTotalMujNacional,
            TotalNacional = @TotalNacional,
            SubTotalHomExtranjero = @SubTotalHomExtranjero,
            SubTotalMujExtranjero = @SubTotalMujExtranjero,
            TotalExtranjero = @TotalExtranjero,
            Total = @Total
        WHERE Periodo = (SELECT Desc_PeriodoTrimestre FROM Trimestre WHERE ID_Trimestre = @ContadorPeriodo);

        SET @ContadorPeriodo = @ContadorPeriodo + 1;
    END
    SELECT * FROM @TablaLicenciasVigentesAcumulado
    UNION ALL
    SELECT 'CIFRAS AL PERIODO',
    SUM(NMSHomNacional), 
    SUM(NMSMujNacional), 
    SUM(NMSHomExtranjero), 
    SUM(NMSMujExtranjero),
    SUM(NSHomNacional), 
    SUM(NSMujNacional), 
    SUM(NSHomExtranjero), 
    SUM(NSMujExtranjero),
    SUM(CIHomNacional), 
    SUM(CIMujNacional), 
    SUM(CIHomExtranjero), 
    SUM(CIMujExtranjero),
    SUM(ACHomNacional), 
    SUM(ACMujNacional), 
    SUM(ACHomExtranjero), 
    SUM(ACMujExtranjero),
    SUM(SubTotalHomNacional), 
    SUM(SubTotalMujNacional), 
    SUM(TotalNacional),
    SUM(SubTotalHomExtranjero), 
    SUM(SubTotalMujExtranjero), 
    SUM(TotalExtranjero),
    SUM(Total)
    FROM @TablaLicenciasVigentesAcumulado;
    
END
