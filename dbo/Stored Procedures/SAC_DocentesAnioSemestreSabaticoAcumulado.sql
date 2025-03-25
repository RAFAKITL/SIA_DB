-- Formato 11 Docentes en anio y semestre sabatico acumulado al periodo
-- Autor: Eduardo Castillo
CREATE PROCEDURE SAC_DocentesAnioSemestreSabaticoAcumulado
    @anio INT,
    @id_trimestre INT
AS
BEGIN 
    SET NOCOUNT ON;
    DECLARE @DocentesSabaticoAcumulado TABLE(
        Nivel VARCHAR(255) NOT NULL DEFAULT ' ',

        T1_AnioHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T1_AnioMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T1_SemestreHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T1_SemestreMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T1_TotalHombres INT NOT NULL DEFAULT 0,
        T1_TotalMujeres INT NOT NULL DEFAULT 0,
        T1_Total INT NOT NULL DEFAULT 0,

        T2_AnioHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T2_AnioMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T2_SemestreHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T2_SemestreMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T2_TotalHombres INT NOT NULL DEFAULT 0,
        T2_TotalMujeres INT NOT NULL DEFAULT 0,
        T2_Total INT NOT NULL DEFAULT 0,

        T3_AnioHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T3_AnioMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T3_SemestreHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T3_SemestreMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T3_TotalHombres INT NOT NULL DEFAULT 0,
        T3_TotalMujeres INT NOT NULL DEFAULT 0,
        T3_Total INT NOT NULL DEFAULT 0,

        T4_AnioHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T4_AnioMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T4_SemestreHombres VARCHAR(255) NOT NULL DEFAULT ' ',
        T4_SemestreMujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        T4_TotalHombres INT NOT NULL DEFAULT 0,
        T4_TotalMujeres INT NOT NULL DEFAULT 0,
        T4_Total INT NOT NULL DEFAULT 0,

        Cifras_AnioHombres INT NOT NULL DEFAULT 0,
        Cifras_AnioMujeres INT NOT NULL DEFAULT 0,
        Cifras_SemestreHombres INT NOT NULL DEFAULT 0,
        Cifras_SemestreMujeres INT NOT NULL DEFAULT 0,
        Cifras_TotalHombres INT NOT NULL DEFAULT 0,
        Cifras_TotalMujeres INT NOT NULL DEFAULT 0,
        Cifras_Total INT NOT NULL DEFAULT 0
    );

    -- Cómo quiero mostrar el texto de cada Nivel
    DECLARE @NMS VARCHAR(255) = 'MEDIO SUPERIOR';
    DECLARE @NS_PS VARCHAR(255) = 'SUPERIOR Y POSGRADO';
    DECLARE @CINV_CIITA VARCHAR(255) = 'CENTROS DE INVESTIGACIÓN';
    DECLARE @UACA_UAVDR VARCHAR(255) = 'AREA CENTRAL';
    -- Tabla de Niveles para poder iterar sobre su ID y además respetar el orden
    DECLARE @Niveles TABLE (
        ID_Nivel INT IDENTITY(1,1),
        Desc_Nivel VARCHAR(255) NOT NULL DEFAULT ' ',
        Origen_Justificaciones INT DEFAULT 0 -- Aquí tendrá la id de TipoUnidadAcademica de donde se sacará la justificación
    );

    INSERT INTO @Niveles (Desc_Nivel)
    VALUES (@NMS),
            (@NS_PS),
            (@CINV_CIITA),
            (@UACA_UAVDR);
    -- Tabla de las áreas incluídas en cada Nivel porque algunos niveles contienen más de una
    DECLARE @TipoUA TABLE (
        ID_Areas INT IDENTITY(1,1),
        Desc_TipoUA VARCHAR(255) NOT NULL DEFAULT ' ',
        Desc_Nivel VARCHAR(255) NOT NULL DEFAULT ' '
    );

    INSERT INTO @TipoUA (Desc_TipoUA, Desc_Nivel)
    VALUES ('NMS', @NMS),
            ('NS', @NS_PS),
            ('C INV', @CINV_CIITA),
            ('CIITA', @CINV_CIITA),
            ('UACA', @UACA_UAVDR),
            ('UAVDR', @UACA_UAVDR);
    -- Declaro todas las variables a usar
    DECLARE @NivelActual VARCHAR(255) = '';
    DECLARE @CifrasParaT4_AnioHombres INT = 0;
    DECLARE @CifrasParaT4_AnioMujeres INT = 0;
    DECLARE @CifrasParaT4_SemestreHombres INT = 0;
    DECLARE @CifrasParaT4_SemestreMujeres INT = 0;

    DECLARE @AnioHombres INT = 0;
    DECLARE @AnioMujeres INT = 0;
    DECLARE @SemestreHombres INT = 0;
    DECLARE @SemestreMujeres INT = 0;

    DECLARE @ContNiveles INT = 1;
    DECLARE @ContTrimestres INT = 1;
    -- Itero por los 4 Niveles
    WHILE @ContNiveles <= (SELECT COUNT(*) FROM @Niveles)
    BEGIN

        SET @NivelActual = (SELECT Desc_Nivel 
                            FROM @Niveles 
                            WHERE ID_Nivel = @ContNiveles);

        INSERT INTO @DocentesSabaticoAcumulado (Nivel)
        VALUES (@NivelActual);

        -- Itero por el no. de Trimestres recibidos por parámetro
        SET @ContTrimestres = 1;
        WHILE @ContTrimestres <= @id_trimestre
        BEGIN
            SET @AnioHombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                FROM SAC_RegistroSabaticos
                                WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                                FROM UnidadesAcademicas UA 
                                                                JOIN TipoUnidadAcademica TUA 
                                                                ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                                WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                                FROM @TipoUA
                                                                                                WHERE Desc_Nivel  IN (SELECT Desc_Nivel 
                                                                                                                        FROM @Niveles
                                                                                                                        WHERE ID_Nivel = @ContNiveles)))
                                AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                        FROM SAC_AnioSemestre
                                                        WHERE Desc_AnioSemestreSAC = 'AÑO')
                                AND id_Trimestre = @ContTrimestres
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);
            SET @AnioMujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                FROM SAC_RegistroSabaticos
                                WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                                FROM UnidadesAcademicas UA 
                                                                JOIN TipoUnidadAcademica TUA 
                                                                ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                                WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                                FROM @TipoUA
                                                                                                WHERE Desc_Nivel  IN (SELECT Desc_Nivel 
                                                                                                                        FROM @Niveles
                                                                                                                        WHERE ID_Nivel = @ContNiveles)))
                                AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                        FROM SAC_AnioSemestre
                                                        WHERE Desc_AnioSemestreSAC = 'AÑO')
                                AND id_Trimestre = @ContTrimestres
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);
                                                
            SET @SemestreHombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                FROM SAC_RegistroSabaticos
                                WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                                FROM UnidadesAcademicas UA 
                                                                JOIN TipoUnidadAcademica TUA 
                                                                ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                                WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                                FROM @TipoUA
                                                                                                WHERE Desc_Nivel  IN (SELECT Desc_Nivel 
                                                                                                                        FROM @Niveles
                                                                                                                        WHERE ID_Nivel = @ContNiveles)))
                                AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                        FROM SAC_AnioSemestre
                                                        WHERE Desc_AnioSemestreSAC = 'SEMESTRE')
                                AND id_Trimestre = @ContTrimestres
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);
            SET @SemestreMujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                FROM SAC_RegistroSabaticos
                                WHERE id_UnidadAcademicaSAC IN (SELECT ID_UnidadAcademica
                                                                FROM UnidadesAcademicas UA 
                                                                JOIN TipoUnidadAcademica TUA 
                                                                ON UA.id_TipoUnidadAcademica = TUA.ID_TipoUnidadAcademica
                                                                WHERE TUA.Desc_SiglasTipo IN (SELECT Desc_TipoUA 
                                                                                                FROM @TipoUA
                                                                                                WHERE Desc_Nivel  IN (SELECT Desc_Nivel 
                                                                                                                        FROM @Niveles
                                                                                                                        WHERE ID_Nivel = @ContNiveles)))
                                AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                        FROM SAC_AnioSemestre
                                                        WHERE Desc_AnioSemestreSAC = 'SEMESTRE')
                                AND id_Trimestre = @ContTrimestres
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);

            IF @ContTrimestres = 1
            BEGIN  
                UPDATE @DocentesSabaticoAcumulado
                SET T1_AnioHombres = CAST(@AnioHombres AS VARCHAR(255)),
                    T1_AnioMujeres = CAST(@AnioMujeres AS VARCHAR(255)),
                    T1_SemestreHombres = CAST(@SemestreHombres AS VARCHAR(255)),
                    T1_SemestreMujeres = CAST(@SemestreMujeres AS VARCHAR(255)),
                    T1_TotalHombres = @AnioHombres + @SemestreHombres,
                    T1_TotalMujeres = @AnioMujeres + @SemestreMujeres,
                    T1_Total = @AnioHombres + @SemestreHombres + @AnioMujeres + @SemestreMujeres,
                    Cifras_AnioHombres = @AnioHombres,
                    Cifras_AnioMujeres = @AnioMujeres,
                    Cifras_SemestreHombres = @SemestreHombres,
                    Cifras_SemestreMujeres = @SemestreMujeres,
                    Cifras_TotalHombres = @AnioHombres + @SemestreHombres,
                    Cifras_TotalMujeres = @AnioMujeres + @SemestreMujeres,
                    Cifras_Total = @AnioHombres + @SemestreHombres + @AnioMujeres + @SemestreMujeres
                WHERE Nivel = @NivelActual;
            END
            ELSE IF @ContTrimestres = 2
            BEGIN
                UPDATE @DocentesSabaticoAcumulado
                SET T2_AnioHombres = CAST(@AnioHombres AS VARCHAR(255)),
                    T2_AnioMujeres = CAST(@AnioMujeres AS VARCHAR(255)),
                    T2_SemestreHombres = CAST(@SemestreHombres AS VARCHAR(255)),
                    T2_SemestreMujeres = CAST(@SemestreMujeres AS VARCHAR(255)),
                    T2_TotalHombres = @AnioHombres + @SemestreHombres,
                    T2_TotalMujeres = @AnioMujeres + @SemestreMujeres,
                    T2_Total = @AnioHombres + @SemestreHombres + @AnioMujeres + @SemestreMujeres,
                    Cifras_AnioHombres = @AnioHombres,
                    Cifras_AnioMujeres = @AnioMujeres,
                    Cifras_SemestreHombres = @SemestreHombres,
                    Cifras_SemestreMujeres = @SemestreMujeres,
                    Cifras_TotalHombres = @AnioHombres + @SemestreHombres,
                    Cifras_TotalMujeres = @AnioMujeres + @SemestreMujeres,
                    Cifras_Total = @AnioHombres + @SemestreHombres + @AnioMujeres + @SemestreMujeres
                WHERE Nivel = @NivelActual;
            END
            ELSE IF @ContTrimestres = 3
            BEGIN -- Se guardarán los resultados del trimestre 3
                -- Para copiarlos en caso de trimestre = 4
                SET @CifrasParaT4_AnioHombres = @AnioHombres;
                SET @CifrasParaT4_AnioMujeres = @AnioMujeres;
                SET @CifrasParaT4_SemestreHombres = @SemestreHombres;
                SET @CifrasParaT4_SemestreMujeres = @SemestreMujeres;
                UPDATE @DocentesSabaticoAcumulado
                SET T3_AnioHombres = CAST(@AnioHombres AS VARCHAR(255)),
                    T3_AnioMujeres = CAST(@AnioMujeres AS VARCHAR(255)),
                    T3_SemestreHombres = CAST(@SemestreHombres AS VARCHAR(255)),
                    T3_SemestreMujeres = CAST(@SemestreMujeres AS VARCHAR(255)),    
                    T3_TotalHombres = @AnioHombres + @SemestreHombres,
                    T3_TotalMujeres = @AnioMujeres + @SemestreMujeres,
                    T3_Total = @AnioHombres + @SemestreHombres + @AnioMujeres + @SemestreMujeres,
                    Cifras_AnioHombres = @AnioHombres,
                    Cifras_AnioMujeres = @AnioMujeres,
                    Cifras_SemestreHombres = @SemestreHombres,
                    Cifras_SemestreMujeres = @SemestreMujeres,
                    Cifras_TotalHombres = @AnioHombres + @SemestreHombres,
                    Cifras_TotalMujeres = @AnioMujeres + @SemestreMujeres,
                    Cifras_Total = @AnioHombres + @SemestreHombres + @AnioMujeres + @SemestreMujeres
                WHERE Nivel = @NivelActual;
            END
            ELSE IF @ContTrimestres = 4
            BEGIN
                UPDATE @DocentesSabaticoAcumulado
                SET T4_AnioHombres = CAST(@AnioHombres AS VARCHAR(255)),
                    T4_AnioMujeres = CAST(@AnioMujeres AS VARCHAR(255)),
                    T4_SemestreHombres = CAST(@SemestreHombres AS VARCHAR(255)),
                    T4_SemestreMujeres = CAST(@SemestreMujeres AS VARCHAR(255)),
                    T4_TotalHombres = @AnioHombres + @SemestreHombres,
                    T4_TotalMujeres = @AnioMujeres + @SemestreMujeres,
                    T4_Total = @AnioHombres + @SemestreHombres + @AnioMujeres + @SemestreMujeres,
                    Cifras_AnioHombres = @CifrasParaT4_AnioHombres,
                    Cifras_AnioMujeres = @CifrasParaT4_AnioMujeres,
                    Cifras_SemestreHombres = @CifrasParaT4_SemestreHombres,
                    Cifras_SemestreMujeres = @CifrasParaT4_SemestreMujeres,
                    Cifras_TotalHombres = @CifrasParaT4_AnioHombres + @CifrasParaT4_SemestreHombres,
                    Cifras_TotalMujeres = @CifrasParaT4_AnioMujeres + @CifrasParaT4_SemestreMujeres,
                    Cifras_Total = @CifrasParaT4_AnioHombres + @CifrasParaT4_SemestreHombres + @CifrasParaT4_AnioMujeres + @CifrasParaT4_SemestreMujeres
                WHERE Nivel = @NivelActual;
            END

            SET @ContTrimestres = @ContTrimestres + 1;
        END

        SET @ContNiveles = @ContNiveles + 1;
    END

    INSERT INTO @DocentesSabaticoAcumulado
    SELECT 'TOTAL',
            CAST(SUM(CAST(T1_AnioHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T1_AnioMujeres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T1_SemestreHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T1_SemestreMujeres AS INT)) AS VARCHAR(255)),
            SUM(T1_TotalHombres),
            SUM(T1_TotalMujeres),
            SUM(T1_Total),
            CAST(SUM(CAST(T2_AnioHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T2_AnioMujeres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T2_SemestreHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T2_SemestreMujeres AS INT)) AS VARCHAR(255)),
            SUM(T2_TotalHombres),
            SUM(T2_TotalMujeres),
            SUM(T2_Total),
            CAST(SUM(CAST(T3_AnioHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T3_AnioMujeres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T3_SemestreHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T3_SemestreMujeres AS INT)) AS VARCHAR(255)),
            SUM(T3_TotalHombres),
            SUM(T3_TotalMujeres),
            SUM(T3_Total),
            CAST(SUM(CAST(T4_AnioHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T4_AnioMujeres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T4_SemestreHombres AS INT)) AS VARCHAR(255)),
            CAST(SUM(CAST(T4_SemestreMujeres AS INT)) AS VARCHAR(255)),
            SUM(T4_TotalHombres),
            SUM(T4_TotalMujeres),
            SUM(T4_Total),
            SUM(Cifras_AnioHombres),
            SUM(Cifras_AnioMujeres),
            SUM(Cifras_SemestreHombres),
            SUM(Cifras_SemestreMujeres),
            SUM(Cifras_TotalHombres),
            SUM(Cifras_TotalMujeres),
            SUM(Cifras_Total)
    FROM @DocentesSabaticoAcumulado;

    SELECT * FROM @DocentesSabaticoAcumulado;

END