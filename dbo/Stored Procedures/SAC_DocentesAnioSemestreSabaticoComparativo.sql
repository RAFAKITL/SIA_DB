-- Formato 12 Docentes en anio y semestre sabatico comparativo
-- Autor: Eduardo Castillo
CREATE PROCEDURE SAC_DocentesAnioSemestreSabaticoComparativo
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @DocentesSabaticoComparativo TABLE(
        Nivel VARCHAR(255) NOT NULL DEFAULT ' ',

        AntAnio INT NOT NULL DEFAULT 0,
        AntSemestre INT NOT NULL DEFAULT 0,
        AntTotal INT NOT NULL DEFAULT 0,

        ActHombresAnio INT NOT NULL DEFAULT 0,
        ActMujeresAnio INT NOT NULL DEFAULT 0,
        ActTotalAnio INT NOT NULL DEFAULT 0,
        ActHombresSemestre INT NOT NULL DEFAULT 0,
        ActMujeresSemestre INT NOT NULL DEFAULT 0,
        ActTotalSemestre INT NOT NULL DEFAULT 0,

        Variacion DECIMAL(3, 2) NOT NULL DEFAULT 0,
        Justificacion VARCHAR(255) NOT NULL DEFAULT ' '
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
    -- La justificación de C INV y CIITA se encuentra en SAC_Justificaciones -> C INV
    -- Y la de UACA y UAVDR en SAC_Justificaciones -> UACA
    DECLARE @OrigenNMS INT = (SELECT ID_TipoUnidadAcademica
                            FROM TipoUnidadAcademica
                            WHERE Desc_SiglasTipo = 'NMS');
    DECLARE @OrigenNS INT = (SELECT ID_TipoUnidadAcademica
                            FROM TipoUnidadAcademica
                            WHERE Desc_SiglasTipo = 'NS');
    DECLARE @OrigenCINV INT = (SELECT ID_TipoUnidadAcademica
                            FROM TipoUnidadAcademica
                            WHERE Desc_SiglasTipo = 'C INV');
    DECLARE @OrigenUACA INT = (SELECT ID_TipoUnidadAcademica
                            FROM TipoUnidadAcademica
                            WHERE Desc_SiglasTipo = 'UACA');

    INSERT INTO @Niveles (Desc_Nivel, Origen_Justificaciones)
    VALUES (@NMS, @OrigenNMS),
            (@NS_PS, @OrigenNS),
            (@CINV_CIITA, @OrigenCINV),
            (@UACA_UAVDR, @OrigenUACA);
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
    DECLARE @ProgramaApoyo VARCHAR(255) = 'AÑO Y SEMESTRE SABÁTICO'; -- Para el filtro al recuperar de tabla SAC_Justificaciones
    DECLARE @anio_anterior INT = @anio - 1;
    DECLARE @NivelActual VARCHAR(255) = '';

    DECLARE @AntAnio INT = 0;
    DECLARE @AntSemestre INT = 0;
    DECLARE @ActHombresAnio INT = 0;
    DECLARE @ActMujeresAnio INT = 0;
    DECLARE @ActHombresSemestre INT = 0;
    DECLARE @ActMujeresSemestre INT = 0;
    DECLARE @Variacion DECIMAL(3, 2) = 0;
    DECLARE @Justificacion VARCHAR(255) = '';

    DECLARE @ContNiveles INT = 1;
    -- Itero por los 4 Niveles
    WHILE @ContNiveles <= (SELECT COUNT(*) FROM @Niveles)
    BEGIN

        SET @NivelActual = (SELECT Desc_Nivel 
                            FROM @Niveles 
                            WHERE ID_Nivel = @ContNiveles);
        
        SET @AntAnio = ISNULL((SELECT SUM(Desc_Hombres + Desc_Mujeres) 
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
                                AND id_Trimestre BETWEEN 1 AND @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio_anterior)), 0);

        SET @AntSemestre = ISNULL((SELECT SUM(Desc_Hombres + Desc_Mujeres) 
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
                                AND id_Trimestre BETWEEN 1 AND @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio_anterior)), 0);
                                                
        SET @ActHombresAnio = ISNULL((SELECT SUM(Desc_Hombres) 
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
                                AND id_Trimestre BETWEEN 1 AND @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);
        SET @ActMujeresAnio = ISNULL((SELECT SUM(Desc_Mujeres) 
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
                                AND id_Trimestre BETWEEN 1 AND @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);   

        SET @ActHombresSemestre = ISNULL((SELECT SUM(Desc_Hombres) 
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
                                AND id_Trimestre BETWEEN 1 AND @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);
        SET @ActMujeresSemestre = ISNULL((SELECT SUM(Desc_Mujeres) 
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
                                AND id_Trimestre BETWEEN 1 AND @id_Trimestre
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)), 0);
        SET @Variacion = CASE WHEN (@AntAnio + @AntSemestre) = 0 
                        THEN 0 
                        ELSE 
                        ((@ActHombresAnio + @ActMujeresAnio + @ActHombresSemestre + @ActMujeresSemestre) - (@AntAnio + @AntSemestre)) / (@AntAnio + @AntSemestre) * 100 END;
        SET @Justificacion = ISNULL((SELECT TOP(1) Desc_Justificacion
                                FROM SAC_Justificaciones
                                WHERE id_TipoUnidadAcademicaSAC = (SELECT Origen_Justificaciones
                                                                FROM @Niveles
                                                                WHERE ID_Nivel = @ContNiveles)
                                AND id_ProgramaApoyoSAC = (SELECT ID_ProgramaApoyoSAC 
                                                            FROM SAC_ProgramaApoyo
                                                            WHERE Desc_ProgramaApoyoSAC = @ProgramaApoyo)
                                AND id_Anio = (SELECT ID_Anio
                                                FROM Anio
                                                WHERE Desc_Anio = @anio)
                                AND id_Trimestre = @id_Trimestre), ' ');

        INSERT INTO @DocentesSabaticoComparativo (Nivel, 
                                                AntAnio, 
                                                AntSemestre,
                                                AntTotal,
                                                ActHombresAnio,
                                                ActMujeresAnio,
                                                ActTotalAnio,
                                                ActHombresSemestre,
                                                ActMujeresSemestre,
                                                ActTotalSemestre,
                                                Variacion,
                                                Justificacion)
        VALUES (@NivelActual,
                @AntAnio,
                @AntSemestre,
                @AntAnio + @AntSemestre,
                @ActHombresAnio,
                @ActMujeresAnio,
                @ActHombresAnio + @ActMujeresAnio,
                @ActHombresSemestre,
                @ActMujeresSemestre,
                @ActHombresSemestre + @ActMujeresSemestre,
                @Variacion,
                @Justificacion);

        SET @ContNiveles = @ContNiveles + 1;
    END

    SELECT * FROM @DocentesSabaticoComparativo
    UNION ALL
    SELECT 'TOTAL', 
            SUM(AntAnio), 
            SUM(AntSemestre),
            SUM(AntTotal),
            SUM(ActHombresAnio),
            SUM(ActMujeresAnio),
            SUM(ActTotalAnio),
            SUM(ActHombresSemestre),
            SUM(ActMujeresSemestre),
            SUM(ActTotalSemestre),
            CASE WHEN SUM(AntAnio + AntSemestre) = 0 
                THEN 0 
                ELSE 
                (SUM(ActHombresAnio + ActMujeresAnio + ActHombresSemestre + ActMujeresSemestre) - SUM(AntAnio + AntSemestre)) / (SUM(AntAnio + AntSemestre)) * 100 END,
            ' '
    FROM @DocentesSabaticoComparativo;

END