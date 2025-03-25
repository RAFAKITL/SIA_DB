-- Author : Samuel Garcia ESCOM
-- Formato 20 Licencias Goce de Sueldo 
CREATE PROCEDURE SAC_LicenciasGoceSueldoNMS
    @SiglasTipoUnidadAcademica VARCHAR(255),
    @anio INT, 
    @id_Trimestre INT
AS
BEGIN
    DECLARE @ESPECIALIDAD VARCHAR (255) = 'ESPECIALIDAD';
    DECLARE @MAESTRIA VARCHAR (255) = 'MAESTRÍA';
    DECLARE @DOCTORADO VARCHAR (255) = 'DOCTORADO';
    DECLARE @ESTANCIA VARCHAR (255) = 'ESTANCIA DE INVESTIGACIÓN';
    DECLARE @NACIONAL VARCHAR (255) = 'NACIONAL';
    DECLARE @EXTRANJERO VARCHAR (255) = 'EXTRANJERO';
    DECLARE @LICENCASCONGOCE VARCHAR (255) = 'LICENCIAS CON GOCE DE SUELDO';
    DECLARE @AJUSTES VARCHAR (255) = 'AJUSTES';
    DECLARE @LIBERACIONES VARCHAR (255) = 'LIBERACIONES';
    DECLARE @CANCELACIONES VARCHAR (255) = 'CANCELACIONES';
    DECLARE @NO_LICENCIAS_OTORGADAS VARCHAR (255) = 'No. DE LICENCIAS OTORGADAS EN EL TRIMESTRE';
    DECLARE @NO_PRORROGAS_AUTORIZADAS VARCHAR (255) = 'No. DE PRÓRROGAS AUTORIZADAS EN EL TRIMESTRE';
    DECLARE @LICENCIAS_VIGENTES_ANTERIOR VARCHAR (255) = 'LICENCIAS VIGENTES AL PERIODO';

    DECLARE @PeriodoAnterior INT = CASE WHEN @id_Trimestre = 1 THEN 4 ELSE @id_Trimestre - 1 END
    DECLARE @AnioAnterior INT = CASE WHEN @id_Trimestre = 1 THEN @anio - 1 ELSE @anio END

    DECLARE @LicenciasVigentesAnteriorHomNac INT = 0
    DECLARE @LicenciasVigentesAnteriorMujNac INT = 0
    DECLARE @LicenciasVigentesAnteriorHomExt INT = 0
    DECLARE @LicenciasVigentesAnteriorMujExt INT = 0
    DECLARE @LicenciasVigentesAnteriorTot INT = 0

    DECLARE @SumLicenciasVigentesAnteriorHomNac INT;
    DECLARE @SumLicenciasVigentesAnteriorMujNac INT;
    DECLARE @SumLicenciasVigentesAnteriorHomExt INT;
    DECLARE @SumLicenciasVigentesAnteriorMujExt INT;
    DECLARE @SumLicenciasVigentesAnteriorTot INT;

    DECLARE @AjustesHomNac VARCHAR(255) = ''
    DECLARE @AjustesMujNac VARCHAR(255) = ''
    DECLARE @AjustesHomExt VARCHAR(255) = ''
    DECLARE @AjustesMujExt VARCHAR(255) = ''

    DECLARE @SumAjustesHomNac INT;
    DECLARE @SumAjustesMujNac INT;
    DECLARE @SumAjustesHomExt INT;
    DECLARE @SumAjustesMujExt INT;

    DECLARE @NoLicenciasOtorgadasHomNac VARCHAR(255) = ''
    DECLARE @NoLicenciasOtorgadasMujNac VARCHAR(255) = ''
    DECLARE @NoLicenciasOtorgadasHomExt VARCHAR(255) = ''
    DECLARE @NoLicenciasOtorgadasMujExt VARCHAR(255) = ''

    DECLARE @SumNoLicenciasOtorgadasHomNac INT;
    DECLARE @SumNoLicenciasOtorgadasMujNac INT;
    DECLARE @SumNoLicenciasOtorgadasHomExt INT;
    DECLARE @SumNoLicenciasOtorgadasMujExt INT;
    
    DECLARE @NoProrrogasAutorizadasHomNac VARCHAR(255) = ''
    DECLARE @NoProrrogasAutorizadasMujNac VARCHAR(255) = ''
    DECLARE @NoProrrogasAutorizadasHomExt VARCHAR(255) = ''
    DECLARE @NoProrrogasAutorizadasMujExt VARCHAR(255) = ''

    DECLARE @SumNoProrrogasAutorizadasHomNac INT;
    DECLARE @SumNoProrrogasAutorizadasMujNac INT;
    DECLARE @SumNoProrrogasAutorizadasHomExt INT;
    DECLARE @SumNoProrrogasAutorizadasMujExt INT;
    
    DECLARE @LiberacionesHomNac VARCHAR(255) = ''
    DECLARE @LiberacionesMujNac VARCHAR(255) = ''
    DECLARE @LiberacionesHomExt VARCHAR(255) = ''
    DECLARE @LiberacionesMujExt VARCHAR(255) = ''

    DECLARE @SumLiberacionesHomNac INT;
    DECLARE @SumLiberacionesMujNac INT;
    DECLARE @SumLiberacionesHomExt INT;
    DECLARE @SumLiberacionesMujExt INT;

    DECLARE @CancelacionesHomNac VARCHAR(255) = ''
    DECLARE @CancelacionesMujNac VARCHAR(255) = ''
    DECLARE @CancelacionesHomExt VARCHAR(255) = ''
    DECLARE @CancelacionesMujExt VARCHAR(255) = ''

    DECLARE @SumCancelacionesHomNac INT;
    DECLARE @SumCancelacionesMujNac INT;
    DECLARE @SumCancelacionesHomExt INT;
    DECLARE @SumCancelacionesMujExt INT;

    DECLARE @NoLicenciasVigentesActHomNac INT = 0
    DECLARE @NoLicenciasVigentesActMujNac INT = 0
    DECLARE @NoLicenciasVigentesActHomExt INT = 0
    DECLARE @NoLicenciasVigentesActMujExt INT = 0
    DECLARE @NoLicenciasVigentesActTot INT = 0

    DECLARE @SumNoLicenciasVigentesActHomNac INT;
    DECLARE @SumNoLicenciasVigentesActMujNac INT;
    DECLARE @SumNoLicenciasVigentesActHomExt INT;
    DECLARE @SumNoLicenciasVigentesActMujExt INT;
    DECLARE @SumNoLicenciasVigentesActTot INT;
    
    DECLARE @NoLicenciasVigentesActEstudioEspec VARCHAR(255) = ''
    DECLARE @NoLicenciasVigentesActEstudioMaest VARCHAR(255) = ''
    DECLARE @NoLicenciasVigentesActEstudioDoct VARCHAR(255) = ''
    DECLARE @NoLicenciasVigentesActEstudioEstan VARCHAR(255) = ''
    DECLARE @NoLicenciasVigentesActEstudioTot INT = 0

    DECLARE @SumNoLicenciasVigentesActEstudioEspec INT;
    DECLARE @SumNoLicenciasVigentesActEstudioMaest INT;
    DECLARE @SumNoLicenciasVigentesActEstudioDoct INT;
    DECLARE @SumNoLicenciasVigentesActEstudioEstan INT; 
    DECLARE @SumNoLicenciasVigentesActEstudioTot INT;


    DECLARE @TablaUnidadesRama TABLE(
        identificador INT IDENTITY(1,1),
        id_Unidad INT ,
        SiglasUnidadAcademica VARCHAR(255) NOT NULL DEFAULT '',
        Rama VARCHAR(255) NOT NULL DEFAULT ''
    )

    DECLARE @ResultadosFinales TABLE (
        Unidad VARCHAR(255),
        Rama VARCHAR(255),
        Orden INT
    )
  

    INSERT INTO @TablaUnidadesRama (id_Unidad,SiglasUnidadAcademica)
    SELECT ID_UnidadAcademica, Siglas
    FROM UnidadesAcademicas
    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica)

    UPDATE @TablaUnidadesRama
    SET Rama = (SELECT Desc_SiglasRama FROM RamaConocimiento WHERE ID_RamaConocimiento = 
        (SELECT id_RamaConocimiento FROM UnidadesAcademicas WHERE Siglas = SiglasUnidadAcademica));

    WITH CTE_RamasDistintas AS (
        SELECT DISTINCT Rama, 
            CASE 
                WHEN Rama IS NOT NULL THEN 'Total Rama ' + Rama 
                ELSE 'Total General'
            END AS NombreTotal
        FROM @TablaUnidadesRama
    ),
    CTE_Totales AS (
        SELECT 
            r.NombreTotal AS SiglasUnidadAcademica,
            r.Rama,
            COUNT(t.id_Unidad) AS Total
        FROM CTE_RamasDistintas r
        LEFT JOIN @TablaUnidadesRama t ON r.Rama = t.Rama
        GROUP BY r.NombreTotal, r.Rama
    ),
    CombinedData AS (
        SELECT 
            SiglasUnidadAcademica AS Unidad, 
            Rama,
            CASE WHEN SiglasUnidadAcademica LIKE 'Total%' THEN 2 ELSE 1 END AS Orden
        FROM @TablaUnidadesRama
        UNION ALL
        SELECT 
            SiglasUnidadAcademica AS Unidad,
            Rama, 
            2 AS Orden
        FROM CTE_Totales
    )
    INSERT INTO @ResultadosFinales
    SELECT Unidad, Rama, Orden
    FROM CombinedData;


    DECLARE @TablaLicenciasGoceSueldo TABLE
    (
        UnidadAcademica VARCHAR(255) NOT NULL DEFAULT '',

        LicenciasVigentesAnteriorHomNac INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorMujNac INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorHomExt INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorMujExt INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorTot INT NOT NULL DEFAULT 0,

        AjustesHomNac VARCHAR(255) NOT NULL DEFAULT '',
        AjustesMujNac VARCHAR(255) NOT NULL DEFAULT '',
        AjustesHomExt VARCHAR(255) NOT NULL DEFAULT '',
        AjustesMujExt VARCHAR(255) NOT NULL DEFAULT '',

        NoLicenciasOtorgadasHomNac VARCHAR(255) NOT NULL DEFAULT '',
        NoLicenciasOtorgadasMujNac VARCHAR(255) NOT NULL DEFAULT '',
        NoLicenciasOtorgadasHomExt VARCHAR(255) NOT NULL DEFAULT '',
        NoLicenciasOtorgadasMujExt VARCHAR(255) NOT NULL DEFAULT '',

        NoProrrogasAutorizadasHomNac VARCHAR(255) NOT NULL DEFAULT '',
        NoProrrogasAutorizadasMujNac VARCHAR(255) NOT NULL DEFAULT '',
        NoProrrogasAutorizadasHomExt VARCHAR(255) NOT NULL DEFAULT '',
        NoProrrogasAutorizadasMujExt VARCHAR(255) NOT NULL DEFAULT '',

        LiberacionesHomNac VARCHAR(255) NOT NULL DEFAULT '',
        LiberacionesMujNac VARCHAR(255) NOT NULL DEFAULT '',
        LiberacionesHomExt VARCHAR(255) NOT NULL DEFAULT '',
        LiberacionesMujExt VARCHAR(255) NOT NULL DEFAULT '',

        CancelacionesHomNac VARCHAR(255) NOT NULL DEFAULT '',
        CancelacionesMujNac VARCHAR(255) NOT NULL DEFAULT '',
        CancelacionesHomExt VARCHAR(255) NOT NULL DEFAULT '',
        CancelacionesMujExt VARCHAR(255) NOT NULL DEFAULT '',

        NoLicenciasVigentesActHomNac INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActMujNac INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActHomExt INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActMujExt INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActTot INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActEstudioEspec VARCHAR(255) NOT NULL DEFAULT '',
        NoLicenciasVigentesActEstudioMaest VARCHAR(255) NOT NULL DEFAULT '',
        NoLicenciasVigentesActEstudioDoct VARCHAR(255) NOT NULL DEFAULT '',
        NoLicenciasVigentesActEstudioEstan VARCHAR(255) NOT NULL DEFAULT '',
        NoLicenciasVigentesActEstudioTot INT NOT NULL DEFAULT 0,

        rama VARCHAR(255) NOT NULL DEFAULT '',
        Orden INT NOT NULL DEFAULT 0
    )
    INSERT INTO @TablaLicenciasGoceSueldo
    (UnidadAcademica, Rama, Orden)
    SELECT Unidad, Rama, Orden FROM @ResultadosFinales;
    DECLARE @ContadorUnidadesAcademicas INT = 1
 
    WHILE @ContadorUnidadesAcademicas <= (SELECT COUNT(*) FROM @TablaUnidadesRama)
    BEGIN
        SET @AjustesHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), '');

        SET @AjustesMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), '');
        
        SET @AjustesHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), '');
                                
        SET @AjustesMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), '');

        SET @NoLicenciasOtorgadasHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), '');

        SET @NoLicenciasOtorgadasMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), '');

        SET @NoLicenciasOtorgadasHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), '');

        SET @NoLicenciasOtorgadasMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), '');

        SET @NoProrrogasAutorizadasHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), '');

        SET @NoProrrogasAutorizadasMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), '');

        SET @NoProrrogasAutorizadasHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), '');

        SET @NoProrrogasAutorizadasMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), '');

        SET @LiberacionesHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), '');

        SET @LiberacionesMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), '');

        SET @LiberacionesHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), '');

        SET @LiberacionesMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), '');

        SET @CancelacionesHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), '');

        SET @CancelacionesMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), '');
                                
        SET @CancelacionesHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), '');
        SET @CancelacionesMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                    AND id_Trimestre = @id_Trimestre
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), '');
            
        SET @LicenciasVigentesAnteriorHomNac =  ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                                                        AND id_Trimestre = @PeriodoAnterior
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR)),0)
                                                + CASE WHEN @AjustesHomNac = '' THEN 0 ELSE CAST(@AjustesHomNac AS INT) END 
                                                + CASE WHEN @NoLicenciasOtorgadasHomNac = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasHomNac AS INT) END
                                                - CASE WHEN @LiberacionesHomNac = '' THEN 0 ELSE CAST(@LiberacionesHomNac AS INT) END 
                                                - CASE WHEN @CancelacionesHomNac = '' THEN 0 ELSE CAST(@CancelacionesHomNac AS INT) END
        SET @LicenciasVigentesAnteriorHomNac = CASE WHEN @LicenciasVigentesAnteriorHomNac < 0 THEN 0 ELSE @LicenciasVigentesAnteriorHomNac END

        SET @LicenciasVigentesAnteriorMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                                                        AND id_Trimestre = @PeriodoAnterior
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR)), 0)
                                                + CASE WHEN @AjustesMujNac = '' THEN 0 ELSE CAST(@AjustesMujNac AS INT) END
                                                + CASE WHEN @NoLicenciasOtorgadasMujNac = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasMujNac AS INT) END
                                                - CASE WHEN @LiberacionesMujNac = '' THEN 0 ELSE CAST(@LiberacionesMujNac AS INT) END
                                                - CASE WHEN @CancelacionesMujNac = '' THEN 0 ELSE CAST(@CancelacionesMujNac AS INT) END
        SET @LicenciasVigentesAnteriorMujNac = CASE WHEN @LicenciasVigentesAnteriorMujNac < 0 THEN 0 ELSE @LicenciasVigentesAnteriorMujNac END



        SET @LicenciasVigentesAnteriorHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                                                        AND id_Trimestre = @PeriodoAnterior
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR)),0 )
                                                + CASE WHEN @AjustesHomExt = '' THEN 0 ELSE CAST(@AjustesHomExt AS INT) END
                                                + CASE WHEN @NoLicenciasOtorgadasHomExt = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasHomExt AS INT) END
                                                - CASE WHEN @LiberacionesHomExt = '' THEN 0 ELSE CAST(@LiberacionesHomExt AS INT) END
                                                - CASE WHEN @CancelacionesHomExt = '' THEN 0 ELSE CAST(@CancelacionesHomExt AS INT) END
        SET @LicenciasVigentesAnteriorHomExt = CASE WHEN @LicenciasVigentesAnteriorHomExt < 0 THEN 0 ELSE @LicenciasVigentesAnteriorHomExt END

        SET @LicenciasVigentesAnteriorMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador = @ContadorUnidadesAcademicas)
                                                                        AND id_Trimestre = @PeriodoAnterior
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO 
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR))),0)
                                                + CASE WHEN @AjustesMujExt = '' THEN 0 ELSE CAST(@AjustesMujExt AS INT) END
                                                + CASE WHEN @NoLicenciasOtorgadasMujExt = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasMujExt AS INT) END
                                                - CASE WHEN @LiberacionesMujExt = '' THEN 0 ELSE CAST(@LiberacionesMujExt AS INT) END
                                                - CASE WHEN @CancelacionesMujExt = '' THEN 0 ELSE CAST(@CancelacionesMujExt AS INT) END
        SET @LicenciasVigentesAnteriorMujExt = CASE WHEN @LicenciasVigentesAnteriorMujExt < 0 THEN 0 ELSE @LicenciasVigentesAnteriorMujExt END

        SET @LicenciasVigentesAnteriorTot = @LicenciasVigentesAnteriorHomNac + @LicenciasVigentesAnteriorHomExt + @LicenciasVigentesAnteriorMujNac + @LicenciasVigentesAnteriorMujExt
            
        SET @NoLicenciasVigentesActHomNac = CASE WHEN @LicenciasVigentesAnteriorHomNac= '' THEN 0 ELSE CAST(@LicenciasVigentesAnteriorHomNac AS INT) END
                                            + CASE WHEN @AjustesHomNac = '' THEN 0 ELSE CAST(@AjustesHomNac AS INT) END 
                                            + CASE WHEN @NoLicenciasOtorgadasHomNac = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasHomNac AS INT) END
                                            - CASE WHEN @LiberacionesHomNac = '' THEN 0 ELSE CAST(@LiberacionesHomNac AS INT) END 
                                            - CASE WHEN @CancelacionesHomNac = '' THEN 0 ELSE CAST(@CancelacionesHomNac AS INT) END
        SET @NoLicenciasVigentesActHomNac = CASE WHEN @NoLicenciasVigentesActHomNac < 0 THEN 0 ELSE @NoLicenciasVigentesActHomNac END

        SET @NoLicenciasVigentesActMujNac = CASE WHEN @LicenciasVigentesAnteriorMujNac = '' THEN 0 ELSE CAST(@LicenciasVigentesAnteriorMujNac AS INT) END
                                            + CASE WHEN @AjustesMujNac = '' THEN 0 ELSE CAST(@AjustesMujNac AS INT) END
                                            + CASE WHEN @NoLicenciasOtorgadasMujNac = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasMujNac AS INT) END
                                            - CASE WHEN @LiberacionesMujNac = '' THEN 0 ELSE CAST(@LiberacionesMujNac AS INT) END
                                            - CASE WHEN @CancelacionesMujNac = '' THEN 0 ELSE CAST(@CancelacionesMujNac AS INT) END
        SET @NoLicenciasVigentesActMujNac = CASE WHEN @NoLicenciasVigentesActMujNac < 0 THEN 0 ELSE @NoLicenciasVigentesActMujNac END

        SET @NoLicenciasVigentesActHomExt = CASE WHEN @LicenciasVigentesAnteriorHomExt='' THEN 0 ELSE CAST(@LicenciasVigentesAnteriorHomExt AS INT) END
                                            + CASE WHEN @AjustesHomExt = '' THEN 0 ELSE CAST(@AjustesHomExt AS INT) END
                                            + CASE WHEN @NoLicenciasOtorgadasHomExt = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasHomExt AS INT) END
                                            - CASE WHEN @LiberacionesHomExt = '' THEN 0 ELSE CAST(@LiberacionesHomExt AS INT) END
                                            - CASE WHEN @CancelacionesHomExt = '' THEN 0 ELSE CAST(@CancelacionesHomExt AS INT) END
        SET @NoLicenciasVigentesActHomExt = CASE WHEN @NoLicenciasVigentesActHomExt < 0 THEN 0 ELSE @NoLicenciasVigentesActHomExt END

        SET @NoLicenciasVigentesActMujExt = CASE WHEN @LicenciasVigentesAnteriorMujExt = '' THEN 0 ELSE CAST(@LicenciasVigentesAnteriorMujExt AS INT) END
                                            + CASE WHEN @AjustesMujExt = '' THEN 0 ELSE CAST(@AjustesMujExt AS INT) END
                                            + CASE WHEN @NoLicenciasOtorgadasMujExt = '' THEN 0 ELSE CAST(@NoLicenciasOtorgadasMujExt AS INT) END
                                            - CASE WHEN @LiberacionesMujExt = '' THEN 0 ELSE CAST(@LiberacionesMujExt AS INT) END
                                            - CASE WHEN @CancelacionesMujExt = '' THEN 0 ELSE CAST(@CancelacionesMujExt AS INT) END
        SET @NoLicenciasVigentesActMujExt = CASE WHEN @NoLicenciasVigentesActMujExt < 0 THEN 0 ELSE @NoLicenciasVigentesActMujExt END

        SET @NoLicenciasVigentesActTot = @NoLicenciasVigentesActHomNac + @NoLicenciasVigentesActHomExt + @NoLicenciasVigentesActMujNac + @NoLicenciasVigentesActMujExt  

        SET @NoLicenciasVigentesActEstudioEspec = ISNULL((SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS 
                                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                                    AND id_Trimestre = @id_Trimestre
                                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC FROM SAC_TipoEstudioLCGS WHERE Desc_TipoEstudioLCGSSAC = @ESPECIALIDAD)),'');

        SET @NoLicenciasVigentesActEstudioMaest = ISNULL((SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS 
                                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                                    AND id_Trimestre = @id_Trimestre
                                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC FROM SAC_TipoEstudioLCGS WHERE Desc_TipoEstudioLCGSSAC = @MAESTRIA)),'');

        SET @NoLicenciasVigentesActEstudioDoct = ISNULL((SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS 
                                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                                    AND id_Trimestre = @id_Trimestre
                                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC FROM SAC_TipoEstudioLCGS WHERE Desc_TipoEstudioLCGSSAC = @DOCTORADO)), '');

        SET @NoLicenciasVigentesActEstudioEstan = ISNULL( (SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS 
                                                    WHERE id_UnidadAcademicaSAC = (SELECT id_Unidad FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
                                                    AND id_Trimestre = @id_Trimestre
                                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                                    AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC FROM SAC_TipoEstudioLCGS WHERE Desc_TipoEstudioLCGSSAC = @ESTANCIA)), '');

        SET @NoLicenciasVigentesActEstudioTot = CASE WHEN @NoLicenciasVigentesActEstudioEspec = '' THEN 0 ELSE CAST(@NoLicenciasVigentesActEstudioEspec AS INT) END + 
                                                CASE WHEN @NoLicenciasVigentesActEstudioMaest = '' THEN 0 ELSE CAST(@NoLicenciasVigentesActEstudioMaest AS INT) END +
                                                CASE WHEN @NoLicenciasVigentesActEstudioDoct = '' THEN 0 ELSE CAST (@NoLicenciasVigentesActEstudioDoct AS INT) END +
                                                CASE WHEN @NoLicenciasVigentesActEstudioEstan = '' THEN 0 ELSE CAST (@NoLicenciasVigentesActEstudioEstan AS INT) END


        UPDATE @TablaLicenciasGoceSueldo
        SET LicenciasVigentesAnteriorHomNac = @LicenciasVigentesAnteriorHomNac,
            LicenciasVigentesAnteriorMujNac = @LicenciasVigentesAnteriorMujNac,
            LicenciasVigentesAnteriorHomExt = @LicenciasVigentesAnteriorHomExt,
            LicenciasVigentesAnteriorMujExt = @LicenciasVigentesAnteriorMujExt,
            LicenciasVigentesAnteriorTot = @LicenciasVigentesAnteriorTot,
            AjustesHomNac = CASE WHEN @AjustesHomNac = '0' THEN '' ELSE @AjustesHomNac END,
            AjustesMujNac = CASE WHEN @AjustesMujNac = '0' THEN '' ELSE @AjustesMujNac END,
            AjustesHomExt = CASE WHEN @AjustesHomExt = '0' THEN '' ELSE @AjustesHomExt END,
            AjustesMujExt = CASE WHEN @AjustesMujExt = '0' THEN '' ELSE @AjustesMujExt END,
            NoLicenciasOtorgadasHomNac = CASE WHEN @NoLicenciasOtorgadasHomNac = '0' THEN '' ELSE @NoLicenciasOtorgadasHomNac END,
            NoLicenciasOtorgadasMujNac = CASE WHEN @NoLicenciasOtorgadasMujNac = '0' THEN '' ELSE @NoLicenciasOtorgadasMujNac END,
            NoLicenciasOtorgadasHomExt = CASE WHEN @NoLicenciasOtorgadasHomExt = '0' THEN '' ELSE @NoLicenciasOtorgadasHomExt END,
            NoLicenciasOtorgadasMujExt = CASE WHEN @NoLicenciasOtorgadasMujExt = '0' THEN '' ELSE @NoLicenciasOtorgadasMujExt END,
            NoProrrogasAutorizadasHomNac = CASE WHEN @NoProrrogasAutorizadasHomNac = '0' THEN '' ELSE @NoProrrogasAutorizadasHomNac END,
            NoProrrogasAutorizadasMujNac = CASE WHEN @NoProrrogasAutorizadasMujNac = '0' THEN '' ELSE @NoProrrogasAutorizadasMujNac END,
            NoProrrogasAutorizadasHomExt = CASE WHEN @NoProrrogasAutorizadasHomExt = '0' THEN '' ELSE @NoProrrogasAutorizadasHomExt END,
            NoProrrogasAutorizadasMujExt = CASE WHEN @NoProrrogasAutorizadasMujExt = '0' THEN '' ELSE @NoProrrogasAutorizadasMujExt END,
            LiberacionesHomNac = CASE WHEN @LiberacionesHomNac = '0' THEN '' ELSE @LiberacionesHomNac END,
            LiberacionesMujNac = CASE WHEN @LiberacionesMujNac = '0' THEN '' ELSE @LiberacionesMujNac END,
            LiberacionesHomExt = CASE WHEN @LiberacionesHomExt = '0' THEN '' ELSE @LiberacionesHomExt END,
            LiberacionesMujExt = CASE WHEN @LiberacionesMujExt = '0' THEN '' ELSE @LiberacionesMujExt END,
            CancelacionesHomNac = CASE WHEN @CancelacionesHomNac = '0' THEN '' ELSE @CancelacionesHomNac END,
            CancelacionesMujNac = CASE WHEN @CancelacionesMujNac = '0' THEN '' ELSE @CancelacionesMujNac END,
            CancelacionesHomExt = CASE WHEN @CancelacionesHomExt = '0' THEN '' ELSE @CancelacionesHomExt END,
            CancelacionesMujExt = CASE WHEN @CancelacionesMujExt = '0' THEN '' ELSE @CancelacionesMujExt END,
            NoLicenciasVigentesActHomNac = @NoLicenciasVigentesActHomNac,
            NoLicenciasVigentesActMujNac = @NoLicenciasVigentesActMujNac,
            NoLicenciasVigentesActHomExt = @NoLicenciasVigentesActHomExt,
            NoLicenciasVigentesActMujExt = @NoLicenciasVigentesActMujExt,
            NoLicenciasVigentesActTot = @NoLicenciasVigentesActTot,
            NoLicenciasVigentesActEstudioEspec = CASE WHEN @NoLicenciasVigentesActEstudioEspec = '0' THEN '' ELSE @NoLicenciasVigentesActEstudioEspec END,
            NoLicenciasVigentesActEstudioMaest = CASE WHEN @NoLicenciasVigentesActEstudioMaest = '0' THEN '' ELSE @NoLicenciasVigentesActEstudioMaest END,
            NoLicenciasVigentesActEstudioDoct = CASE WHEN @NoLicenciasVigentesActEstudioDoct = '0' THEN '' ELSE @NoLicenciasVigentesActEstudioDoct END,
            NoLicenciasVigentesActEstudioEstan = CASE WHEN @NoLicenciasVigentesActEstudioEstan = '0' THEN '' ELSE @NoLicenciasVigentesActEstudioEstan END,
            NoLicenciasVigentesActEstudioTot = @NoLicenciasVigentesActEstudioTot
        WHERE UnidadAcademica = (SELECT SiglasUnidadAcademica FROM @TablaUnidadesRama WHERE identificador= @ContadorUnidadesAcademicas)
        SET @ContadorUnidadesAcademicas = @ContadorUnidadesAcademicas + 1
    
    END

    DECLARE @ContadorRamas INT = 1
    WHILE @ContadorRamas <= (SELECT COUNT(*) FROM RamaConocimiento)
    BEGIN
        SELECT @SumLicenciasVigentesAnteriorHomNac = SUM(CAST(LicenciasVigentesAnteriorHomNac AS INT)),
            @SumLicenciasVigentesAnteriorMujNac = SUM(CAST(LicenciasVigentesAnteriorMujNac AS INT)),
            @SumLicenciasVigentesAnteriorHomExt = SUM(CAST(LicenciasVigentesAnteriorHomExt AS INT)),
            @SumLicenciasVigentesAnteriorMujExt = SUM(CAST(LicenciasVigentesAnteriorMujExt AS INT)),
            @SumLicenciasVigentesAnteriorTot = SUM(CAST(LicenciasVigentesAnteriorTot AS INT)),
                @SumAjustesHomNac = SUM(CAST(AjustesHomNac AS INT)),
                @SumAjustesMujNac = SUM(CAST(AjustesMujNac AS INT)),
                @SumAjustesHomExt = SUM(CAST(AjustesHomExt AS INT)),
                @SumAjustesMujExt = SUM(CAST(AjustesMujExt AS INT)),
                @SumNoLicenciasOtorgadasHomNac = SUM(CAST(NoLicenciasOtorgadasHomNac AS INT)),
                @SumNoLicenciasOtorgadasMujNac = SUM(CAST(NoLicenciasOtorgadasMujNac AS INT)),
                @SumNoLicenciasOtorgadasHomExt = SUM(CAST(NoLicenciasOtorgadasHomExt AS INT)),
                @SumNoLicenciasOtorgadasMujExt = SUM(CAST(NoLicenciasOtorgadasMujExt AS INT)),
                @SumNoProrrogasAutorizadasHomNac = SUM(CAST(NoProrrogasAutorizadasHomNac AS INT)),
                @SumNoProrrogasAutorizadasMujNac = SUM(CAST(NoProrrogasAutorizadasMujNac AS INT)),
                @SumNoProrrogasAutorizadasHomExt = SUM(CAST(NoProrrogasAutorizadasHomExt AS INT)),
                @SumNoProrrogasAutorizadasMujExt = SUM(CAST(NoProrrogasAutorizadasMujExt AS INT)),
                @SumLiberacionesHomNac = SUM(CAST(LiberacionesHomNac AS INT)),
                @SumLiberacionesMujNac = SUM(CAST(LiberacionesMujNac AS INT)),
                @SumLiberacionesHomExt = SUM(CAST(LiberacionesHomExt AS INT)),
                @SumLiberacionesMujExt = SUM(CAST(LiberacionesMujExt AS INT)),
                @SumCancelacionesHomNac = SUM(CAST(CancelacionesHomNac AS INT)),
                @SumCancelacionesMujNac = SUM(CAST(CancelacionesMujNac AS INT)),
                @SumCancelacionesHomExt = SUM(CAST(CancelacionesHomExt AS INT)),
                @SumCancelacionesMujExt = SUM(CAST(CancelacionesMujExt AS INT)),
                @SumNoLicenciasVigentesActHomNac = SUM(CAST(NoLicenciasVigentesActHomNac AS INT)),
                @SumNoLicenciasVigentesActMujNac = SUM(CAST(NoLicenciasVigentesActMujNac AS INT)),
                @SumNoLicenciasVigentesActHomExt = SUM(CAST(NoLicenciasVigentesActHomExt AS INT)),
                @SumNoLicenciasVigentesActMujExt = SUM(CAST(NoLicenciasVigentesActMujExt AS INT)),
                @SumNoLicenciasVigentesActTot = SUM(CAST(NoLicenciasVigentesActTot AS INT)),
                @SumNoLicenciasVigentesActEstudioEspec = SUM(CAST(NoLicenciasVigentesActEstudioEspec AS INT)),
                @SumNoLicenciasVigentesActEstudioMaest = SUM(CAST(NoLicenciasVigentesActEstudioMaest AS INT)),
                @SumNoLicenciasVigentesActEstudioDoct = SUM(CAST(NoLicenciasVigentesActEstudioDoct AS INT)),
                @SumNoLicenciasVigentesActEstudioEstan = SUM(CAST(NoLicenciasVigentesActEstudioEstan AS INT)),
                @SumNoLicenciasVigentesActEstudioTot = SUM(CAST(NoLicenciasVigentesActEstudioTot AS INT))
        FROM @TablaLicenciasGoceSueldo
        WHERE Rama = (SELECT Desc_SiglasRama FROM RamaConocimiento WHERE ID_RamaConocimiento = @ContadorRamas);
        
        UPDATE @TablaLicenciasGoceSueldo
        SET LicenciasVigentesAnteriorHomNac =  @SumLicenciasVigentesAnteriorHomNac,
            LicenciasVigentesAnteriorMujNac = @SumLicenciasVigentesAnteriorMujNac,
            LicenciasVigentesAnteriorHomExt = @SumLicenciasVigentesAnteriorHomExt,
            LicenciasVigentesAnteriorMujExt = @SumLicenciasVigentesAnteriorMujExt,
            LicenciasVigentesAnteriorTot = @SumLicenciasVigentesAnteriorTot,
            AjustesHomNac = @SumAjustesHomNac,
            AjustesMujNac = @SumAjustesMujNac,
            AjustesHomExt = @SumAjustesHomExt,
            AjustesMujExt = @SumAjustesMujExt,
            NoLicenciasOtorgadasHomNac = @SumNoLicenciasOtorgadasHomNac,
            NoLicenciasOtorgadasMujNac = @SumNoLicenciasOtorgadasMujNac,
            NoLicenciasOtorgadasHomExt = @SumNoLicenciasOtorgadasHomExt,
            NoLicenciasOtorgadasMujExt = @SumNoLicenciasOtorgadasMujExt,
            NoProrrogasAutorizadasHomNac = @SumNoProrrogasAutorizadasHomNac,
            NoProrrogasAutorizadasMujNac = @SumNoProrrogasAutorizadasMujNac,
            NoProrrogasAutorizadasHomExt = @SumNoProrrogasAutorizadasHomExt,
            NoProrrogasAutorizadasMujExt = @SumNoProrrogasAutorizadasMujExt,
            LiberacionesHomNac = @SumLiberacionesHomNac,
            LiberacionesMujNac = @SumLiberacionesMujNac,
            LiberacionesHomExt = @SumLiberacionesHomExt,
            LiberacionesMujExt = @SumLiberacionesMujExt,
            CancelacionesHomNac = @SumCancelacionesHomNac,
            CancelacionesMujNac = @SumCancelacionesMujNac,
            CancelacionesHomExt = @SumCancelacionesHomExt,
            CancelacionesMujExt = @SumCancelacionesMujExt,
            NoLicenciasVigentesActHomNac = @SumNoLicenciasVigentesActHomNac,
            NoLicenciasVigentesActMujNac = @SumNoLicenciasVigentesActMujNac,
            NoLicenciasVigentesActHomExt = @SumNoLicenciasVigentesActHomExt,
            NoLicenciasVigentesActMujExt = @SumNoLicenciasVigentesActMujExt,
            NoLicenciasVigentesActTot = @SumNoLicenciasVigentesActTot,
            NoLicenciasVigentesActEstudioEspec = @SumNoLicenciasVigentesActEstudioEspec,
            NoLicenciasVigentesActEstudioMaest = @SumNoLicenciasVigentesActEstudioMaest,
            NoLicenciasVigentesActEstudioDoct = @SumNoLicenciasVigentesActEstudioDoct,
            NoLicenciasVigentesActEstudioEstan = @SumNoLicenciasVigentesActEstudioEstan,
            NoLicenciasVigentesActEstudioTot = @SumNoLicenciasVigentesActEstudioTot

        WHERE Rama = (SELECT Desc_SiglasRama 
                    FROM RamaConocimiento 
                    WHERE ID_RamaConocimiento = @ContadorRamas) 
                    AND UnidadAcademica = 'Total Rama ' + ((SELECT Desc_SiglasRama
                                                            FROM RamaConocimiento 
                                                            WHERE ID_RamaConocimiento = @ContadorRamas));
        
        SET @ContadorRamas = @ContadorRamas + 1
    END

    SELECT
        UnidadAcademica,
        LicenciasVigentesAnteriorHomNac,
        LicenciasVigentesAnteriorMujNac,
        LicenciasVigentesAnteriorHomExt,
        LicenciasVigentesAnteriorMujExt,
        LicenciasVigentesAnteriorTot,
        AjustesHomNac,
        AjustesMujNac,
        AjustesHomExt,
        AjustesMujExt,
        NoLicenciasOtorgadasHomNac,
        NoLicenciasOtorgadasMujNac,
        NoLicenciasOtorgadasHomExt,
        NoLicenciasOtorgadasMujExt,
        NoProrrogasAutorizadasHomNac,
        NoProrrogasAutorizadasMujNac,
        NoProrrogasAutorizadasHomExt,
        NoProrrogasAutorizadasMujExt,
        LiberacionesHomNac,
        LiberacionesMujNac,
        LiberacionesHomExt,
        LiberacionesMujExt,
        CancelacionesHomNac,
        CancelacionesMujNac,
        CancelacionesHomExt,
        CancelacionesMujExt,
        NoLicenciasVigentesActHomNac,
        NoLicenciasVigentesActMujNac,
        NoLicenciasVigentesActHomExt,
        NoLicenciasVigentesActMujExt,
        NoLicenciasVigentesActTot,
        NoLicenciasVigentesActEstudioEspec,
        NoLicenciasVigentesActEstudioMaest,
        NoLicenciasVigentesActEstudioDoct,
        NoLicenciasVigentesActEstudioEstan,
        NoLicenciasVigentesActEstudioTot
    FROM @TablaLicenciasGoceSueldo
    ORDER BY Rama, Orden, UnidadAcademica 

END
