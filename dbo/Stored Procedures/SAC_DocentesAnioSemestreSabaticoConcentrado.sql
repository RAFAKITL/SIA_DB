-- Formato 5 y 10 Docentes en año/semestre sabatico concentrado
-- Autor: Eduardo Castillo
CREATE PROCEDURE SAC_DocentesAnioSemestreSabaticoConcentrado
    @AnioSemestre VARCHAR(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DocentesConcentrado TABLE (
        Desc_Seccion VARCHAR(255) NOT NULL DEFAULT ' ',

        A1_Hombres INT NOT NULL DEFAULT 0,
        A1_Mujeres INT NOT NULL DEFAULT 0,
        A2_Hombres INT NOT NULL DEFAULT 0,
        A2_Mujeres INT NOT NULL DEFAULT 0,
        Actividades_Hombres INT NOT NULL DEFAULT 0,
        Actividades_Mujeres INT NOT NULL DEFAULT 0,
        EstParciales_Hombres INT NOT NULL DEFAULT 0,
        EstParciales_Mujeres INT NOT NULL DEFAULT 0,
        Individuales_Hombres INT NOT NULL DEFAULT 0,
        Individuales_Mujeres INT NOT NULL DEFAULT 0,
        Total_NoPrioritario INT NOT NULL DEFAULT 0,

        Investigacion_Hombres INT NOT NULL DEFAULT 0,
        Investigacion_Mujeres INT NOT NULL DEFAULT 0,
        EstPosgrado_Hombres INT NOT NULL DEFAULT 0,
        EstPosgrado_Mujeres INT NOT NULL DEFAULT 0,
        Diplomados_Hombres INT NOT NULL DEFAULT 0,
        Diplomados_Mujeres INT NOT NULL DEFAULT 0,
        Estancias_Hombres INT NOT NULL DEFAULT 0,
        Estancias_Mujeres INT NOT NULL DEFAULT 0,
        Elaboracion_Hombres INT NOT NULL DEFAULT 0,
        Elaboracion_Mujeres INT NOT NULL DEFAULT 0,
        Total_Prioritario INT NOT NULL DEFAULT 0,

        Total_Hombres INT NOT NULL DEFAULT 0,
        Total_Mujeres INT NOT NULL DEFAULT 0,
        Total_General INT NOT NULL DEFAULT 0
    );

    DECLARE @TablaNoPrioritarios TABLE(
        ID_TablaNoPrioritarios INT IDENTITY(1,1),
        Desc_ProgramaSabatico VARCHAR(255) NOT NULL DEFAULT ' '
    );

    -- Tabla provisional para programas No Prioritarios
    INSERT INTO @TablaNoPrioritarios
    SELECT Desc_ProgramasSabaticoSAC 
    FROM SAC_ProgramasSabatico
    WHERE Desc_Prioridad = 'NO PRIORITARIOS';

    -- Programas Prioritarios
    DECLARE @TablaPrioritarios TABLE(
        ID_TablaPrioritarios INT IDENTITY(1,1),
        Desc_ProgramaSabatico VARCHAR(255)
    );

    INSERT INTO @TablaPrioritarios
    SELECT Desc_ProgramasSabaticoSAC 
    FROM SAC_ProgramasSabatico
    WHERE Desc_Prioridad = 'PRIORITARIOS';

    DECLARE @NMS VARCHAR(255) = 'NIVEL MEDIO SUPERIOR';
    DECLARE @NS_PS VARCHAR(255) = 'NIVEL SUPERIOR';
    DECLARE @CINV_CIITA VARCHAR(255) = 'CENTROS DE INVESTIGACIÓN';
    DECLARE @UACA_UAVDR VARCHAR(255) = 'AREA CENTRAL';

    DECLARE @Secciones TABLE (
        ID_Seccion INT IDENTITY(1,1),
        Desc_Seccion VARCHAR(255) NOT NULL DEFAULT ' '
    );

    INSERT INTO @Secciones (Desc_Seccion)
    VALUES (@NMS),
            (@NS_PS),
            (@CINV_CIITA),
            (@UACA_UAVDR);

    DECLARE @TipoUA TABLE (
        ID_Areas INT IDENTITY(1,1),
        Desc_TipoUA VARCHAR(255) NOT NULL DEFAULT ' ',
        Desc_Seccion VARCHAR(255) NOT NULL DEFAULT ' '
    );

    INSERT INTO @TipoUA (Desc_TipoUA, Desc_Seccion)
    VALUES ('NMS', @NMS),
            ('NS', @NS_PS),
            ('C INV', @CINV_CIITA),
            ('CIITA', @CINV_CIITA),
            ('UACA', @UACA_UAVDR),
            ('UAVDR', @UACA_UAVDR);

    DECLARE @Hombres INT = 0;
    DECLARE @Mujeres INT = 0;
    DECLARE @Total_Hombres INT = 0;
    DECLARE @Total_Mujeres INT = 0;
    DECLARE @Total_NoPrioritario INT = 0;
    DECLARE @Total_Prioritario INT = 0;

    DECLARE @SeccionActual VARCHAR(255) = ' ';

    DECLARE @ContNoPrioritarios INT = 1;
    DECLARE @ContPrioritarios INT = 1;
    DECLARE @ContAreas INT = 1;
    
    WHILE @ContAreas <= (SELECT COUNT(*) 
                                    FROM @Secciones)
    BEGIN
        -- Obtenemos la seccion actual y la insertamos
        SET @SeccionActual = (SELECT Desc_Seccion 
                            FROM @Secciones
                            WHERE ID_Seccion = @ContAreas);
        INSERT INTO @DocentesConcentrado (Desc_Seccion)
        VALUES (@SeccionActual);

        -- WHILE itera sobre programas No Prioritarios
        WHILE @ContNoPrioritarios <= (SELECT COUNT(*) 
                                        FROM SAC_ProgramasSabatico
                                        WHERE Desc_Prioridad = 'NO PRIORITARIOS')
        BEGIN
            SET @Hombres = ISNULL((SELECT SUM(Desc_Hombres)
                            FROM SAC_RegistroSabaticos
                            WHERE id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                            FROM SAC_ProgramasSabatico
                                                            WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                            FROM @TablaNoPrioritarios
                                                                                            WHERE ID_TablaNoPrioritarios = @ContNoPrioritarios))
                            AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                    FROM SAC_AnioSemestre
                                                    WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                            FROM UnidadesAcademicas UA 
                                                            JOIN TipoUnidadAcademica TUA 
                                                            ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                            WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                            FROM @TipoUA
                                                                                            WHERE Desc_Seccion  IN (SELECT Desc_Seccion 
                                                                                                                    FROM @Secciones
                                                                                                                    WHERE ID_Seccion = @ContAreas)))
                            AND id_Trimestre = @id_Trimestre
                            AND id_Anio = (SELECT ID_Anio 
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)), 0);
            SET @Mujeres = ISNULL((SELECT SUM(Desc_Mujeres)
                            FROM SAC_RegistroSabaticos
                            WHERE id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                            FROM SAC_ProgramasSabatico
                                                            WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                            FROM @TablaNoPrioritarios
                                                                                            WHERE ID_TablaNoPrioritarios = @ContNoPrioritarios))
                            AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                    FROM SAC_AnioSemestre
                                                    WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                            FROM UnidadesAcademicas UA 
                                                            JOIN TipoUnidadAcademica TUA 
                                                            ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                            WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                            FROM @TipoUA
                                                                                            WHERE Desc_Seccion  IN (SELECT Desc_Seccion 
                                                                                                                    FROM @Secciones
                                                                                                                    WHERE ID_Seccion = @ContAreas)))
                            AND id_Trimestre = @id_Trimestre
                            AND id_Anio = (SELECT ID_Anio 
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)), 0);
            
            IF @ContNoPrioritarios = 1
            BEGIN
                UPDATE @DocentesConcentrado
                SET A1_Hombres = @Hombres,
                    A1_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContNoPrioritarios = 2
            BEGIN
                UPDATE @DocentesConcentrado
                SET A2_Hombres = @Hombres,
                    A2_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContNoPrioritarios = 3
            BEGIN
                UPDATE @DocentesConcentrado
                SET Actividades_Hombres = @Hombres,
                    Actividades_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContNoPrioritarios = 4
            BEGIN
                UPDATE @DocentesConcentrado
                SET EstParciales_Hombres = @Hombres,
                    EstParciales_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContNoPrioritarios = 5
            BEGIN
                UPDATE @DocentesConcentrado
                SET Individuales_Hombres = @Hombres,
                    Individuales_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END

            SET @Total_NoPrioritario = @Total_NoPrioritario + @Hombres + @Mujeres;
            SET @Total_Hombres = @Total_Hombres + @Hombres;
            SET @Total_Mujeres = @Total_Mujeres + @Mujeres;

            SET @ContNoPrioritarios = @ContNoPrioritarios + 1;
        END

        UPDATE @DocentesConcentrado
        SET Total_NoPrioritario = @Total_NoPrioritario
        WHERE Desc_Seccion = @SeccionActual;
        -- Reseteo @Total_NoPrioritario
        SET @Total_NoPrioritario = 0;
        -- Reseteo @ContNoPrioritarios
        SET @ContNoPrioritarios = 1;

        -- WHILE itera sobre programas Prioritarios
        WHILE @ContPrioritarios <= (SELECT COUNT(*) 
                                    FROM SAC_ProgramasSabatico
                                    WHERE Desc_Prioridad = 'PRIORITARIOS')
        BEGIN
            SET @Hombres = ISNULL((SELECT SUM(Desc_Hombres)
                            FROM SAC_RegistroSabaticos
                            WHERE id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                            FROM SAC_ProgramasSabatico
                                                            WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                            FROM @TablaPrioritarios
                                                                                            WHERE ID_TablaPrioritarios = @ContPrioritarios))
                            AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                    FROM SAC_AnioSemestre
                                                    WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                            FROM UnidadesAcademicas UA 
                                                            JOIN TipoUnidadAcademica TUA 
                                                            ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                            WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                            FROM @TipoUA
                                                                                            WHERE Desc_Seccion  IN (SELECT Desc_Seccion 
                                                                                                                    FROM @Secciones
                                                                                                                    WHERE ID_Seccion = @ContAreas)))
                            AND id_Trimestre = @id_Trimestre
                            AND id_Anio = (SELECT ID_Anio 
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)), 0);
            SET @Mujeres = ISNULL((SELECT SUM(Desc_Mujeres)
                            FROM SAC_RegistroSabaticos
                            WHERE id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                            FROM SAC_ProgramasSabatico
                                                            WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                            FROM @TablaPrioritarios
                                                                                            WHERE ID_TablaPrioritarios = @ContPrioritarios))
                            AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                    FROM SAC_AnioSemestre
                                                    WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                            AND id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                            FROM UnidadesAcademicas UA 
                                                            JOIN TipoUnidadAcademica TUA 
                                                            ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                            WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                            FROM @TipoUA
                                                                                            WHERE Desc_Seccion  IN (SELECT Desc_Seccion 
                                                                                                                    FROM @Secciones
                                                                                                                    WHERE ID_Seccion = @ContAreas)))
                            AND id_Trimestre = @id_Trimestre
                            AND id_Anio = (SELECT ID_Anio 
                                            FROM Anio
                                            WHERE Desc_Anio = @anio)), 0);

            IF @ContPrioritarios = 1
            BEGIN
                UPDATE @DocentesConcentrado
                SET Investigacion_Hombres = @Hombres,
                    Investigacion_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContPrioritarios = 2
            BEGIN
                UPDATE @DocentesConcentrado
                SET EstPosgrado_Hombres = @Hombres,
                    EstPosgrado_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContPrioritarios = 3
            BEGIN
                UPDATE @DocentesConcentrado
                SET Diplomados_Hombres = @Hombres,
                    Diplomados_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContPrioritarios = 4
            BEGIN
                UPDATE @DocentesConcentrado
                SET Estancias_Hombres = @Hombres,
                    Estancias_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            ELSE IF @ContPrioritarios = 5
            BEGIN
                UPDATE @DocentesConcentrado
                SET Elaboracion_Hombres = @Hombres,
                    Elaboracion_Mujeres = @Mujeres
                WHERE Desc_Seccion = @SeccionActual;
            END
            
            SET @Total_Prioritario = @Total_Prioritario + @Hombres + @Mujeres;
            SET @Total_Hombres = @Total_Hombres + @Hombres;
            SET @Total_Mujeres = @Total_Mujeres + @Mujeres;

            SET @ContPrioritarios = @ContPrioritarios + 1;
        END

        UPDATE @DocentesConcentrado
        SET Total_Prioritario = @Total_Prioritario,
            Total_Hombres = @Total_Hombres,
            Total_Mujeres = @Total_Mujeres,
            Total_General = @Total_Hombres + @Total_Mujeres
        WHERE Desc_Seccion = @SeccionActual;
        -- Reseteo @Total_Prioritario
        SET @Total_Prioritario = 0;
        -- Reseteo @Total_Hombres
        SET @Total_Hombres = 0;
        -- Reseteo @Total_Mujeres
        SET @Total_Mujeres = 0;
        -- Reseteo @ContPrioritarios
        SET @ContPrioritarios = 1;

        SET @ContAreas = @ContAreas + 1;
    END
    
    SELECT * FROM @DocentesConcentrado
    UNION ALL
    SELECT
        'TOTAL',
        SUM(A1_Hombres),
        SUM(A1_Mujeres),
        SUM(A2_Hombres),
        SUM(A2_Mujeres),
        SUM(Actividades_Hombres),
        SUM(Actividades_Mujeres),
        SUM(EstParciales_Hombres),
        SUM(EstParciales_Mujeres),
        SUM(Individuales_Hombres),
        SUM(Individuales_Mujeres),
        SUM(Total_NoPrioritario),
        SUM(Investigacion_Hombres),
        SUM(Investigacion_Mujeres),
        SUM(EstPosgrado_Hombres),
        SUM(EstPosgrado_Mujeres),
        SUM(Diplomados_Hombres),
        SUM(Diplomados_Mujeres),
        SUM(Estancias_Hombres),
        SUM(Estancias_Mujeres),
        SUM(Elaboracion_Hombres),
        SUM(Elaboracion_Mujeres),
        SUM(Total_Prioritario),
        SUM(Total_Hombres),
        SUM(Total_Mujeres),
        SUM(Total_General)
    FROM @DocentesConcentrado;
END