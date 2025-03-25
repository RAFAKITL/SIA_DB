-- Jesus Perez 
-- Formato 25 Licencias con goce de sueldo acumulado
CREATE PROCEDURE SAC_LicenciasGoceSueldoAcumulado
    @Anio INT,
    @Trimestre INT
AS
BEGIN
    DECLARE @PeriodoAnterior INT = @Trimestre - 1
    Set @PeriodoAnterior = CASE WHEN @PeriodoAnterior = 0 THEN 4 ELSE @PeriodoAnterior END

    DECLARE @AnioAnterior INT = CASE WHEN @PeriodoAnterior = 4 THEN @anio - 1 ELSE @anio END

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

    DECLARE @LicenciasVigentesAnteriorHomNac INT = 0
    DECLARE @LicenciasVigentesAnteriorMujNac INT = 0
    DECLARE @LicenciasVigentesAnteriorHomExt INT = 0
    DECLARE @LicenciasVigentesAnteriorMujExt INT = 0
    DECLARE @LicenciasVigentesAnteriorTot INT = 0

    DECLARE @AjustesHomNac INT = 0
    DECLARE @AjustesMujNac INT = 0
    DECLARE @AjustesHomExt INT = 0
    DECLARE @AjustesMujExt INT = 0

    DECLARE @NoLicenciasOtorgadasHomNac INT = 0
    DECLARE @NoLicenciasOtorgadasMujNac INT = 0
    DECLARE @NoLicenciasOtorgadasHomExt INT = 0
    DECLARE @NoLicenciasOtorgadasMujExt INT = 0

    DECLARE @NoProrrogasAutorizadasHomNac INT = 0
    DECLARE @NoProrrogasAutorizadasMujNac INT = 0
    DECLARE @NoProrrogasAutorizadasHomExt INT = 0
    DECLARE @NoProrrogasAutorizadasMujExt INT = 0
    
    DECLARE @LiberacionesHomNac INT = 0
    DECLARE @LiberacionesMujNac INT = 0
    DECLARE @LiberacionesHomExt INT = 0
    DECLARE @LiberacionesMujExt INT = 0

    DECLARE @CancelacionesHomNac INT = 0
    DECLARE @CancelacionesMujNac INT = 0
    DECLARE @CancelacionesHomExt INT = 0
    DECLARE @CancelacionesMujExt INT = 0

    DECLARE @NoLicenciasVigentesActHomNac INT = 0
    DECLARE @NoLicenciasVigentesActMujNac INT = 0
    DECLARE @NoLicenciasVigentesActHomExt INT = 0
    DECLARE @NoLicenciasVigentesActMujExt INT = 0
    DECLARE @NoLicenciasVigentesActTot INT = 0
    
    DECLARE @NoLicenciasVigentesActEstudioEspec INT = 0
    DECLARE @NoLicenciasVigentesActEstudioMaest INT = 0
    DECLARE @NoLicenciasVigentesActEstudioDoct INT = 0
    DECLARE @NoLicenciasVigentesActEstudioEstan INT = 0
    DECLARE @NoLicenciasVigentesActEstudioTot INT = 0

    DECLARE @TablaLicenciasGoceSueldo TABLE
    (
        Periodo VARCHAR(255) NOT NULL DEFAULT '',

        LicenciasVigentesAnteriorHomNac INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorMujNac INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorHomExt INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorMujExt INT NOT NULL DEFAULT 0,
        LicenciasVigentesAnteriorTot INT NOT NULL DEFAULT 0,

        AjustesHomNac INT NOT NULL DEFAULT 0,
        AjustesMujNac INT NOT NULL DEFAULT 0,
        AjustesHomExt INT NOT NULL DEFAULT 0,
        AjustesMujExt INT NOT NULL DEFAULT 0,

        NoLicenciasOtorgadasHomNac INT NOT NULL DEFAULT 0,
        NoLicenciasOtorgadasMujNac INT NOT NULL DEFAULT 0,
        NoLicenciasOtorgadasHomExt INT NOT NULL DEFAULT 0,
        NoLicenciasOtorgadasMujExt INT NOT NULL DEFAULT 0,

        NoProrrogasAutorizadasHomNac INT NOT NULL DEFAULT 0,
        NoProrrogasAutorizadasMujNac INT NOT NULL DEFAULT 0,
        NoProrrogasAutorizadasHomExt INT NOT NULL DEFAULT 0,
        NoProrrogasAutorizadasMujExt INT NOT NULL DEFAULT 0,

        LiberacionesHomNac INT NOT NULL DEFAULT 0,
        LiberacionesMujNac INT NOT NULL DEFAULT 0,
        LiberacionesHomExt INT NOT NULL DEFAULT 0,
        LiberacionesMujExt INT NOT NULL DEFAULT 0,

        CancelacionesHomNac INT NOT NULL DEFAULT 0,
        CancelacionesMujNac INT NOT NULL DEFAULT 0,
        CancelacionesHomExt INT NOT NULL DEFAULT 0,
        CancelacionesMujExt INT NOT NULL DEFAULT 0,

        NoLicenciasVigentesActHomNac INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActMujNac INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActHomExt INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActMujExt INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActTot INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActEstudioEspec INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActEstudioMaest INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActEstudioDoct INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActEstudioEstan INT NOT NULL DEFAULT 0,
        NoLicenciasVigentesActEstudioTot INT NOT NULL DEFAULT 0
    )
    INSERT INTO @TablaLicenciasGoceSueldo (Periodo)
    SELECT Desc_PeriodoTrimestre FROM Trimestre WHERE ID_Trimestre <= @Trimestre;

    DECLARE @ContadorPeriodo INT = 1
    WHILE @ContadorPeriodo <= @Trimestre
    BEGIN

        SET @AjustesHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), 0);
        SET @AjustesMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), 0);
        SET @AjustesHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), 0);
        SET @AjustesMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo 
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @AJUSTES)), 0);

        SET @NoLicenciasOtorgadasHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), 0);
        SET @NoLicenciasOtorgadasMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), 0);
        SET @NoLicenciasOtorgadasHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), 0);
        SET @NoLicenciasOtorgadasMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_LICENCIAS_OTORGADAS)), 0);
        SET @NoProrrogasAutorizadasHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), 0);
        SET @NoProrrogasAutorizadasMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), 0);
        SET @NoProrrogasAutorizadasHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), 0);
        SET @NoProrrogasAutorizadasMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @NO_PRORROGAS_AUTORIZADAS)), 0);
        SET @LiberacionesHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), 0);
        SET @LiberacionesMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), 0);
        SET @LiberacionesHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), 0);
        SET @LiberacionesMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LIBERACIONES)), 0);
        SET @CancelacionesHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), 0);
        SET @CancelacionesMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), 0);
        SET @CancelacionesHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), 0);

        SET @CancelacionesMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                    WHERE id_Trimestre = @ContadorPeriodo
                                    AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                    AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @CANCELACIONES)), 0);
       
        SET @LicenciasVigentesAnteriorHomNac = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_Trimestre = @PeriodoAnterior
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR)),0)
                                            + @AjustesHomNac + @NoLicenciasOtorgadasHomNac - @LiberacionesHomNac - @CancelacionesHomNac;
        SET  @LicenciasVigentesAnteriorHomNac = CASE WHEN @LicenciasVigentesAnteriorHomNac < 0 THEN 0 ELSE @LicenciasVigentesAnteriorHomNac END;

        SET @LicenciasVigentesAnteriorMujNac = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_Trimestre = @PeriodoAnterior 
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @NACIONAL)
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR)),0)
                                            + @AjustesMujNac + @NoLicenciasOtorgadasMujNac - @LiberacionesMujNac - @CancelacionesMujNac;
        SET @LicenciasVigentesAnteriorMujNac = CASE WHEN @LicenciasVigentesAnteriorMujNac < 0 THEN 0 ELSE @LicenciasVigentesAnteriorMujNac END;

        SET @LicenciasVigentesAnteriorHomExt = ISNULL((SELECT SUM(Desc_Hombres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_Trimestre = @PeriodoAnterior
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR)),0)
                                            + @AjustesHomExt + @NoLicenciasOtorgadasHomExt - @LiberacionesHomExt - @CancelacionesHomExt;
        SET @LicenciasVigentesAnteriorHomExt = CASE WHEN @LicenciasVigentesAnteriorHomExt < 0 THEN 0 ELSE @LicenciasVigentesAnteriorHomExt END;

        SET @LicenciasVigentesAnteriorMujExt = ISNULL((SELECT SUM(Desc_Mujeres) FROM SAC_RegistroLicenciasConGoceDeSueldo
                                                                        WHERE id_Trimestre = @PeriodoAnterior 
                                                                        AND id_Anio = (SELECT ID_anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                                        AND id_Origen = (SELECT ID_OriginSAC FROM SAC_Origen WHERE Desc_OriginSAC = @EXTRANJERO)
                                                                        AND id_EstadoLCGSSAC = (SELECT ID_EstadoLCGSSAC FROM SAC_EstadoLCGS WHERE Desc_EstadoLCGSSAC = @LICENCIAS_VIGENTES_ANTERIOR)),0)
                                            + @AjustesMujExt + @NoLicenciasOtorgadasMujExt - @LiberacionesMujExt - @CancelacionesMujExt;
        SET @LicenciasVigentesAnteriorMujExt = CASE WHEN @LicenciasVigentesAnteriorMujExt < 0 THEN 0 ELSE @LicenciasVigentesAnteriorMujExt END;

        SET @LicenciasVigentesAnteriorTot = @LicenciasVigentesAnteriorHomNac + @LicenciasVigentesAnteriorMujNac + @LicenciasVigentesAnteriorHomExt + @LicenciasVigentesAnteriorMujExt;

       
        SET @NoLicenciasVigentesActHomNac = ISNULL(@LicenciasVigentesAnteriorHomNac, 0 ) + ISNULL(@AjustesHomNac, 0) + ISNULL(@NoLicenciasOtorgadasHomNac, 0) - ISNULL(@LiberacionesHomNac, 0) - ISNULL(@CancelacionesHomNac, 0);
        SET @NoLicenciasVigentesActHomNac = CASE WHEN @NoLicenciasVigentesActHomNac < 0 THEN 0 ELSE @NoLicenciasVigentesActHomNac END;
        SET @NoLicenciasVigentesActMujNac = ISNULL(@LicenciasVigentesAnteriorMujNac, 0 ) + ISNULL(@AjustesMujNac, 0) + ISNULL(@NoLicenciasOtorgadasMujNac, 0) - ISNULL(@LiberacionesMujNac, 0) - ISNULL(@CancelacionesMujNac, 0);
        SET @NoLicenciasVigentesActMujNac = CASE WHEN @NoLicenciasVigentesActMujNac < 0 THEN 0 ELSE @NoLicenciasVigentesActMujNac END;
        SET @NoLicenciasVigentesActHomExt = ISNULL(@LicenciasVigentesAnteriorHomExt, 0 ) + ISNULL(@AjustesHomExt, 0) + ISNULL(@NoLicenciasOtorgadasHomExt, 0) - ISNULL(@LiberacionesHomExt, 0) - ISNULL(@CancelacionesHomExt, 0);
        SET @NoLicenciasVigentesActHomExt = CASE WHEN @NoLicenciasVigentesActHomExt < 0 THEN 0 ELSE @NoLicenciasVigentesActHomExt END;
        SET @NoLicenciasVigentesActMujExt = ISNULL(@LicenciasVigentesAnteriorMujExt, 0 ) + ISNULL(@AjustesMujExt, 0) + ISNULL(@NoLicenciasOtorgadasMujExt, 0) - ISNULL(@LiberacionesMujExt, 0) - ISNULL(@CancelacionesMujExt, 0);
        SET @NoLicenciasVigentesActMujExt = CASE WHEN @NoLicenciasVigentesActMujExt < 0 THEN 0 ELSE @NoLicenciasVigentesActMujExt END;
        
        SET @NoLicenciasVigentesActTot = @NoLicenciasVigentesActHomNac + @NoLicenciasVigentesActHomExt + @NoLicenciasVigentesActMujNac + @NoLicenciasVigentesActMujExt;

        SET @NoLicenciasVigentesActEstudioEspec = ISNULL((SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS
                                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                                        AND id_Anio = (SELECT ID_anio 
                                                                                        FROM Anio 
                                                                                        WHERE Desc_Anio = @Anio)
                                                                        AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC 
                                                                                                    FROM SAC_TipoEstudioLCGS 
                                                                                                    WHERE Desc_TipoEstudioLCGSSAC = @ESPECIALIDAD)),0);
        SET @NoLicenciasVigentesActEstudioMaest = ISNULL((SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS
                                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                                        AND id_Anio = (SELECT ID_anio 
                                                                                        FROM Anio 
                                                                                        WHERE Desc_Anio = @Anio)
                                                                        AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC 
                                                                                                    FROM SAC_TipoEstudioLCGS 
                                                                                                    WHERE Desc_TipoEstudioLCGSSAC = @MAESTRIA)),0);
        SET @NoLicenciasVigentesActEstudioDoct = ISNULL((SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS
                                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                                        AND id_Anio = (SELECT ID_anio 
                                                                                        FROM Anio 
                                                                                        WHERE Desc_Anio = @Anio)
                                                                        AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC 
                                                                                                    FROM SAC_TipoEstudioLCGS 
                                                                                                    WHERE Desc_TipoEstudioLCGSSAC = @DOCTORADO)),0);    
        SET @NoLicenciasVigentesActEstudioEstan = ISNULL((SELECT COUNT(*) FROM SAC_RegistroCantidadesTipoLCGS
                                                                        WHERE id_Trimestre = @ContadorPeriodo
                                                                        AND id_Anio = (SELECT ID_anio 
                                                                                        FROM Anio 
                                                                                        WHERE Desc_Anio = @Anio)
                                                                        AND id_TipoEstudioLCGSSAC = (SELECT ID_TipoEstudioLCGSSAC 
                                                                                                    FROM SAC_TipoEstudioLCGS 
                                                                                                    WHERE Desc_TipoEstudioLCGSSAC = @ESTANCIA)),0);
        SET @NoLicenciasVigentesActEstudioTot = @NoLicenciasVigentesActEstudioEspec + @NoLicenciasVigentesActEstudioDoct + @NoLicenciasVigentesActEstudioMaest + @NoLicenciasVigentesActEstudioEstan;

        UPDATE @TablaLicenciasGoceSueldo
        SET LicenciasVigentesAnteriorHomNac = @LicenciasVigentesAnteriorHomNac,
            LicenciasVigentesAnteriorMujNac = @LicenciasVigentesAnteriorMujNac,
            LicenciasVigentesAnteriorHomExt = @LicenciasVigentesAnteriorHomExt,
            LicenciasVigentesAnteriorMujExt = @LicenciasVigentesAnteriorMujExt,
            LicenciasVigentesAnteriorTot = @LicenciasVigentesAnteriorTot,
            AjustesHomNac = @AjustesHomNac,
            AjustesMujNac = @AjustesMujNac,
            AjustesHomExt = @AjustesHomExt,
            AjustesMujExt = @AjustesMujExt,
            NoLicenciasOtorgadasHomNac = @NoLicenciasOtorgadasHomNac,
            NoLicenciasOtorgadasMujNac = @NoLicenciasOtorgadasMujNac,
            NoLicenciasOtorgadasHomExt = @NoLicenciasOtorgadasHomExt,
            NoLicenciasOtorgadasMujExt = @NoLicenciasOtorgadasMujExt,
            NoProrrogasAutorizadasHomNac = @NoProrrogasAutorizadasHomNac,
            NoProrrogasAutorizadasMujNac = @NoProrrogasAutorizadasMujNac,
            NoProrrogasAutorizadasHomExt = @NoProrrogasAutorizadasHomExt,
            NoProrrogasAutorizadasMujExt = @NoProrrogasAutorizadasMujExt,
            LiberacionesHomNac = @LiberacionesHomNac,
            LiberacionesMujNac = @LiberacionesMujNac,
            LiberacionesHomExt = @LiberacionesHomExt,
            LiberacionesMujExt = @LiberacionesMujExt,
            CancelacionesHomNac = @CancelacionesHomNac,
            CancelacionesMujNac = @CancelacionesMujNac,
            CancelacionesHomExt = @CancelacionesHomExt,
            CancelacionesMujExt = @CancelacionesMujExt,
            NoLicenciasVigentesActHomNac = @NoLicenciasVigentesActHomNac,
            NoLicenciasVigentesActMujNac = @NoLicenciasVigentesActMujNac,
            NoLicenciasVigentesActHomExt = @NoLicenciasVigentesActHomExt,
            NoLicenciasVigentesActMujExt = @NoLicenciasVigentesActMujExt,
            NoLicenciasVigentesActTot = @NoLicenciasVigentesActTot,
            NoLicenciasVigentesActEstudioEspec = @NoLicenciasVigentesActEstudioEspec,
            NoLicenciasVigentesActEstudioMaest = @NoLicenciasVigentesActEstudioMaest,
            NoLicenciasVigentesActEstudioDoct = @NoLicenciasVigentesActEstudioDoct,
            NoLicenciasVigentesActEstudioEstan = @NoLicenciasVigentesActEstudioEstan,
            NoLicenciasVigentesActEstudioTot = @NoLicenciasVigentesActEstudioTot
        WHERE Periodo = (SELECT Desc_PeriodoTrimestre FROM Trimestre WHERE ID_Trimestre = @ContadorPeriodo);
        
        SET @ContadorPeriodo = @ContadorPeriodo + 1  
        SET @PeriodoAnterior = CASE WHEN @PeriodoAnterior = 4 THEN 1 ELSE @PeriodoAnterior + 1 END
        SET @AnioAnterior = CASE WHEN @PeriodoAnterior = 1 THEN @AnioAnterior + 1 ELSE @AnioAnterior END  
    END
    
    SELECT * FROM @TablaLicenciasGoceSueldo
    UNION ALL
    SELECT 'CIFRAS AL PERIODO',
        SUM(LicenciasVigentesAnteriorHomNac),
        SUM(LicenciasVigentesAnteriorMujNac),
        SUM(LicenciasVigentesAnteriorHomExt),
        SUM(LicenciasVigentesAnteriorMujExt),
        SUM(LicenciasVigentesAnteriorTot),
        SUM(AjustesHomNac),
        SUM(AjustesMujNac),
        SUM(AjustesHomExt),
        SUM(AjustesMujExt),
        SUM(NoLicenciasOtorgadasHomNac),
        SUM(NoLicenciasOtorgadasMujNac),
        SUM(NoLicenciasOtorgadasHomExt),
        SUM(NoLicenciasOtorgadasMujExt),
        SUM(NoProrrogasAutorizadasHomNac),
        SUM(NoProrrogasAutorizadasMujNac),
        SUM(NoProrrogasAutorizadasHomExt),
        SUM(NoProrrogasAutorizadasMujExt),
        SUM(LiberacionesHomNac),
        SUM(LiberacionesMujNac),
        SUM(LiberacionesHomExt),
        SUM(LiberacionesMujExt),
        SUM(CancelacionesHomNac),
        SUM(CancelacionesMujNac),
        SUM(CancelacionesHomExt),
        SUM(CancelacionesMujExt),
        SUM(NoLicenciasVigentesActHomNac),
        SUM(NoLicenciasVigentesActMujNac),
        SUM(NoLicenciasVigentesActHomExt),
        SUM(NoLicenciasVigentesActMujExt),
        SUM(NoLicenciasVigentesActTot),
        SUM(NoLicenciasVigentesActEstudioEspec),
        SUM(NoLicenciasVigentesActEstudioMaest),
        SUM(NoLicenciasVigentesActEstudioDoct),
        SUM(NoLicenciasVigentesActEstudioEstan),
        SUM(NoLicenciasVigentesActEstudioTot)
    FROM @TablaLicenciasGoceSueldo;

END