-- Formato [1, 2, 3, 4, 6, 7, 8, 9] Docentes en año/semestre Todas las áreas
-- Autor: Eduardo Castillo
CREATE PROCEDURE SAC_DocentesAnioSemestreSabatico
    @SiglasTipoUnidadAcademica VARCHAR(255),
    @AnioSemestre VARCHAR(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @DocentesAnioSabatico TABLE (
        ID_DocentesAnioSabatico INT IDENTITY(1,1),
        ID_Rama INT NOT NULL DEFAULT 0,
        UnidadAcademica VARCHAR(255) NOT NULL DEFAULT ' ',
        A1_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        A1_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        A2_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        A2_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        Actividades_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        Actividades_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        EstParciales_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        EstParciales_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        Individuales_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        Individuales_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        Total_NoPrioritario INT NOT NULL DEFAULT 0,

        Investigacion_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        Investigacion_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        EstPosgrado_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        EstPosgrado_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        Diplomados_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        Diplomados_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        Estancias_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        Estancias_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        Elaboracion_Hombres VARCHAR(255) NOT NULL DEFAULT ' ',
        Elaboracion_Mujeres VARCHAR(255) NOT NULL DEFAULT ' ',
        Total_Prioritario INT NOT NULL DEFAULT 0,

        Total_Hombres INT NOT NULL DEFAULT 0,
        Total_Mujeres INT NOT NULL DEFAULT 0,
        Total_General INT NOT NULL DEFAULT 0
    );
    
    -- Tabla provisional estática para Unidades Academicas

    DECLARE @UnidadesAcademicas TABLE(
        ID_UnidadAcademica INT IDENTITY(1,1),
        Siglas VARCHAR(255) NOT NULL DEFAULT ' ',
        ID_Rama INT NOT NULL DEFAULT 0
    );

    -- Aquí me aseguro de obtener las siglas de los Centros de la Base de Datos (por precaución)
    DECLARE @Centros_Investigacion VARCHAR(255) = (SELECT Desc_SiglasTipo
                                                    FROM TipoUnidadAcademica
                                                    WHERE Desc_TipoUnidadAcademica = 'UNIDADES ACADÉMICAS DE INVESTIGACIÓN CIENTÍFICA Y TECNOLÓGICA');
    DECLARE @Centros_Innovacion VARCHAR(255) = (SELECT Desc_SiglasTipo
                                                FROM TipoUnidadAcademica
                                                WHERE Desc_TipoUnidadAcademica = 'UNIDADES ACADÉMICAS DE INNOVACION E INTEGRACION DE TECNOLOGÍAS AVANZADAS');
    DECLARE @Unidades_Centrales VARCHAR(255) = (SELECT Desc_SiglasTipo
                                                FROM TipoUnidadAcademica
                                                WHERE Desc_TipoUnidadAcademica = 'UNIDADES DE ÁREA CENTRAL o ADMNISTRATIVAS');
    DECLARE @UnidadesVinculacion VARCHAR(255) = (SELECT Desc_SiglasTipo
                                                FROM TipoUnidadAcademica
                                                WHERE Desc_TipoUnidadAcademica = 'UNIDADES ACADÉMICAS DE VINCULACION Y DESARROLLO REGIONAL');
    -- Si se reciben Centros de Investigación (C INV), se agregan también los de Innovación
    IF @SiglasTipoUnidadAcademica = @Centros_Investigacion
    BEGIN
        INSERT INTO @UnidadesAcademicas(Siglas, ID_Rama)
        (SELECT UA.Siglas, RC.ID_RamaConocimiento
                        FROM UnidadesAcademicas UA 
                        JOIN RamaConocimiento RC ON UA.id_RamaConocimiento = RC.ID_RamaConocimiento
                        WHERE UA.id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                        FROM TipoUnidadAcademica
                                                        WHERE Desc_SiglasTipo = @Centros_Investigacion)
                        OR UA.id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                        FROM TipoUnidadAcademica
                                                        WHERE Desc_SiglasTipo = @Centros_Innovacion)
                        GROUP BY RC.ID_RamaConocimiento, UA.Siglas);
    END
    ELSE IF @SiglasTipoUnidadAcademica = @Unidades_Centrales
    -- Si se reciben Unidades de Área Central (UACA), se agregan también las de Vinculación
    BEGIN
        INSERT INTO @UnidadesAcademicas(Siglas, ID_Rama)
        (SELECT UA.Siglas, RC.ID_RamaConocimiento
                        FROM UnidadesAcademicas UA 
                        JOIN RamaConocimiento RC ON UA.id_RamaConocimiento = RC.ID_RamaConocimiento
                        WHERE UA.id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                        FROM TipoUnidadAcademica
                                                        WHERE Desc_SiglasTipo = @Unidades_Centrales)
                        OR UA.id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                        FROM TipoUnidadAcademica
                                                        WHERE Desc_SiglasTipo = @UnidadesVinculacion)
                        GROUP BY RC.ID_RamaConocimiento, UA.Siglas);
    END
    ELSE
    -- Si no se insertan solo las recibidas (NS, NMS)
    BEGIN
        INSERT INTO @UnidadesAcademicas(Siglas, ID_Rama)
        (SELECT UA.Siglas, RC.ID_RamaConocimiento
                        FROM UnidadesAcademicas UA 
                        JOIN RamaConocimiento RC ON UA.id_RamaConocimiento = RC.ID_RamaConocimiento
                        WHERE UA.id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                        FROM TipoUnidadAcademica
                                                        WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica)
                        GROUP BY RC.ID_RamaConocimiento, UA.Siglas);
    END

    -- Tabla provisional para programas No Prioritarios

    DECLARE @TablaNoPrioritarios TABLE(
        ID_TablaNoPrioritarios INT IDENTITY(1,1),
        Desc_ProgramaSabatico VARCHAR(255) NOT NULL DEFAULT ' '
    );

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

    DECLARE @ContSiglasUA INT = 1;
    DECLARE @TituloRama VARCHAR(255) = ' ';

    -- Iteraremos sobre las Ramas de Conocimiento para agregar su TOTAL al final de cada una
    DECLARE @ContRama INT = 1;
    WHILE @ContRama <= (SELECT COUNT(*)
                        FROM RamaConocimiento)
    BEGIN
        -- Ingresamos a la tabla principal las Unidades Académicas de la Rama Actual
        INSERT INTO @DocentesAnioSabatico (ID_Rama, UnidadAcademica)
        SELECT ID_Rama, Siglas FROM @UnidadesAcademicas
        WHERE ID_Rama = @ContRama;
        
        -- Iteraremos sobre cada Unidad Académica de la Rama Actual
        DECLARE @ContSiglasxRama INT = 1;
        WHILE @ContSiglasxRama <= (SELECT COUNT(*) 
                                FROM @UnidadesAcademicas
                                WHERE ID_Rama = @ContRama)        
        BEGIN
            -- Guardamos la Sigla Actual
            DECLARE @SiglasActual VARCHAR(255) = (SELECT Siglas 
                                                FROM @UnidadesAcademicas 
                                                WHERE ID_UnidadAcademica = @ContSiglasUA
                                                AND ID_Rama = @ContRama);
            DECLARE @Total_Hombres INT = 0;
            DECLARE @Total_Mujeres INT = 0;

        -- Dividimos 2 WHILE en Programas No prioritarios y Programas prioritarios
        -- Esto para sacar el Total al final de cada Programa

            DECLARE @Total_NoPrioritario INT = 0;
            -- WHILE que itera sobre cada Programa No Prioritario
            DECLARE @ContNoPrioritario INT = 1;
            WHILE @ContNoPrioritario <= (SELECT COUNT(*) 
                                            FROM SAC_ProgramasSabatico
                                            WHERE Desc_Prioridad = 'NO PRIORITARIOS')
            BEGIN
                DECLARE @Hombres INT = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM SAC_RegistroSabaticos
                                        WHERE id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @SiglasActual)
                                        AND id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                                        FROM SAC_ProgramasSabatico
                                                                        WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                                            FROM @TablaNoPrioritarios
                                                                                                            WHERE ID_TablaNoPrioritarios = @ContNoPrioritario))
                                        AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                                FROM SAC_AnioSemestre
                                                                WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                                        AND id_Trimestre = @id_Trimestre
                                        AND id_Anio = (SELECT ID_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)), 0);
                SET @Total_Hombres = @Total_Hombres + @Hombres;

                DECLARE @Mujeres INT = ISNULL((SELECT SUM(Desc_Mujeres) 
                                        FROM SAC_RegistroSabaticos
                                        WHERE id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @SiglasActual)
                                        AND id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                                        FROM SAC_ProgramasSabatico
                                                                        WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                                            FROM @TablaNoPrioritarios
                                                                                                            WHERE ID_TablaNoPrioritarios = @ContNoPrioritario))
                                        AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                                FROM SAC_AnioSemestre
                                                                WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                                        AND id_Trimestre = @id_Trimestre
                                        AND id_Anio = (SELECT ID_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)), 0);
                SET @Total_Mujeres = @Total_Mujeres + @Mujeres;
                
                -- Condiciones que actualizarán en tabla principal los valores de Hombres y Mujeres
                IF @ContNoPrioritario = 1
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET A1_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                        ELSE CAST(@Hombres AS VARCHAR(255)) 
                                    END,
                        A1_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                        ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                    END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContNoPrioritario = 2
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET A2_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                        ELSE CAST(@Hombres AS VARCHAR(255)) 
                                    END,
                        A2_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                        ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                    END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContNoPrioritario = 3
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET Actividades_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                    ELSE CAST(@Hombres AS VARCHAR(255)) 
                                                END,
                        Actividades_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                    ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                                END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContNoPrioritario = 4
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET EstParciales_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                    ELSE CAST(@Hombres AS VARCHAR(255)) 
                                                END,
                        EstParciales_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                    ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                                END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContNoPrioritario = 5
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET Individuales_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                    ELSE CAST(@Hombres AS VARCHAR(255)) 
                                                END,
                        Individuales_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                    ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                                END
                    WHERE UnidadAcademica = @SiglasActual;
                END

                SET @Total_NoPrioritario = @Total_NoPrioritario + @Hombres + @Mujeres;

                SET @ContNoPrioritario = @ContNoPrioritario + 1;
            END
            -- Actualizamos el Total de No Prioritarios
            UPDATE @DocentesAnioSabatico
            SET Total_NoPrioritario = @Total_NoPrioritario
            WHERE UnidadAcademica = @SiglasActual;

            DECLARE @Total_Prioritario INT = 0;
            -- WHILE que itera sobre cada Programa Prioritario

            DECLARE @ContPrioritario INT = 1;
            WHILE @ContPrioritario <= (SELECT COUNT(*) 
                                            FROM SAC_ProgramasSabatico
                                            WHERE Desc_Prioridad = 'PRIORITARIOS')
            BEGIN
                SET @Hombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                        FROM SAC_RegistroSabaticos
                                        WHERE id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @SiglasActual)
                                        AND id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                                        FROM SAC_ProgramasSabatico
                                                                        WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                                            FROM @TablaPrioritarios
                                                                                                            WHERE ID_TablaPrioritarios = @ContPrioritario))
                                        AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                                FROM SAC_AnioSemestre
                                                                WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                                        AND id_Trimestre = 4
                                        AND id_Anio = (SELECT ID_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)), 0);

                SET @Total_Hombres = @Total_Hombres + @Hombres;

                SET @Mujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                        FROM SAC_RegistroSabaticos
                                        WHERE id_UnidadAcademicaSAC = (SELECT ID_UnidadAcademica
                                                                        FROM UnidadesAcademicas
                                                                        WHERE Siglas = @SiglasActual)
                                        AND id_ProgramasSabaticoSAC = (SELECT id_ProgramasSabaticoSAC
                                                                        FROM SAC_ProgramasSabatico
                                                                        WHERE Desc_ProgramasSabaticoSAC = (SELECT Desc_ProgramaSabatico
                                                                                                            FROM @TablaPrioritarios
                                                                                                            WHERE ID_TablaPrioritarios = @ContPrioritario))
                                        AND id_AnioSemestre = (SELECT ID_AnioSemestreSAC
                                                                FROM SAC_AnioSemestre
                                                                WHERE Desc_AnioSemestreSAC = @AnioSemestre)
                                        AND id_Trimestre = 4
                                        AND id_Anio = (SELECT ID_Anio
                                                        FROM Anio
                                                        WHERE Desc_Anio = @anio)), 0);
                
                SET @Total_Mujeres = @Total_Mujeres + @Mujeres;
                
                -- Condiciones
                IF @ContPrioritario = 1
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET Investigacion_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                    ELSE CAST(@Hombres AS VARCHAR(255)) 
                                                END,
                        Investigacion_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                    ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                                END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContPrioritario = 2
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET EstPosgrado_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                    ELSE CAST(@Hombres AS VARCHAR(255)) 
                                                END,
                        EstPosgrado_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                    ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                                END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContPrioritario = 3
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET Diplomados_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                ELSE CAST(@Hombres AS VARCHAR(255)) 
                                            END,
                        Diplomados_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                            END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContPrioritario = 4
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET Estancias_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                ELSE CAST(@Hombres AS VARCHAR(255)) 
                                            END,
                        Estancias_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                            END
                    WHERE UnidadAcademica = @SiglasActual;
                END
                ELSE IF @ContPrioritario = 5
                BEGIN
                    UPDATE @DocentesAnioSabatico
                    SET Elaboracion_Hombres = CASE WHEN @Hombres = 0 THEN ' ' 
                                                ELSE CAST(@Hombres AS VARCHAR(255)) 
                                            END,
                        Elaboracion_Mujeres = CASE WHEN @Mujeres = 0 THEN ' ' 
                                                ELSE CAST(@Mujeres AS VARCHAR(255)) 
                                            END
                    WHERE UnidadAcademica = @SiglasActual;
                END                

                SET @Total_Prioritario = @Total_Prioritario + @Hombres + @Mujeres;

                SET @ContPrioritario = @ContPrioritario + 1;
            END
            -- Actualizamos el Total de Prioritarios
            UPDATE @DocentesAnioSabatico
            SET Total_Prioritario = @Total_Prioritario,
                Total_Hombres = @Total_Hombres,
                Total_Mujeres = @Total_Mujeres,
                Total_General = @Total_NoPrioritario + @Total_Prioritario
            WHERE UnidadAcademica = @SiglasActual;

            SET @ContSiglasUA = @ContSiglasUA + 1;
            SET @ContSiglasxRama = @ContSiglasxRama + 1;
        END        

        -- Agregamos una fila de TOTAL al final de cada Rama

        IF @ContRama = 1
        BEGIN
            SET @TituloRama = 'TOTAL RAMA ICFM';
        END
        ELSE IF @ContRama = 2
        BEGIN
            SET @TituloRama = 'TOTAL RAMA CMB';
        END
        ELSE IF @ContRama = 3
        BEGIN
            SET @TituloRama = 'TOTAL RAMA CSA';
        END
        ELSE IF @ContRama = 4
        BEGIN
            SET @TituloRama = 'TOTAL RAMA INTERDISCIPLINARIA';
        END
        ELSE IF @ContRama = 5
        BEGIN
            SET @TituloRama = 'TOTAL RAMA NO APLICA';
        END
        INSERT INTO @DocentesAnioSabatico (UnidadAcademica, 
                                            A1_Hombres, 
                                            A1_Mujeres, 
                                            A2_Hombres, 
                                            A2_Mujeres, 
                                            Actividades_Hombres, 
                                            Actividades_Mujeres, 
                                            EstParciales_Hombres, 
                                            EstParciales_Mujeres, 
                                            Individuales_Hombres, 
                                            Individuales_Mujeres, 
                                            Total_NoPrioritario, 
                                            Investigacion_Hombres, 
                                            Investigacion_Mujeres, 
                                            EstPosgrado_Hombres,
                                            EstPosgrado_Mujeres, 
                                            Diplomados_Hombres, 
                                            Diplomados_Mujeres, 
                                            Estancias_Hombres, 
                                            Estancias_Mujeres, 
                                            Elaboracion_Hombres, 
                                            Elaboracion_Mujeres, 
                                            Total_Prioritario, 
                                            Total_Hombres, 
                                            Total_Mujeres, 
                                            Total_General)
        VALUES (@TituloRama,
                (SELECT ISNULL(SUM(CASE WHEN A1_Hombres = ' ' THEN 0 ELSE CAST(A1_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN A1_Mujeres = ' ' THEN 0 ELSE CAST(A1_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN A2_Hombres = ' ' THEN 0 ELSE CAST(A2_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN A2_Mujeres = ' ' THEN 0 ELSE CAST(A2_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Actividades_Hombres = ' ' THEN 0 ELSE CAST(Actividades_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Actividades_Mujeres = ' ' THEN 0 ELSE CAST(Actividades_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN EstParciales_Hombres = ' ' THEN 0 ELSE CAST(EstParciales_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN EstParciales_Mujeres = ' ' THEN 0 ELSE CAST(EstParciales_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Individuales_Hombres = ' ' THEN 0 ELSE CAST(Individuales_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Individuales_Mujeres = ' ' THEN 0 ELSE CAST(Individuales_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(Total_NoPrioritario), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Investigacion_Hombres = ' ' THEN 0 ELSE CAST(Investigacion_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Investigacion_Mujeres = ' ' THEN 0 ELSE CAST(Investigacion_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN EstPosgrado_Hombres = ' ' THEN 0 ELSE CAST(EstPosgrado_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN EstPosgrado_Mujeres = ' ' THEN 0 ELSE CAST(EstPosgrado_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Diplomados_Hombres = ' ' THEN 0 ELSE CAST(Diplomados_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Diplomados_Mujeres = ' ' THEN 0 ELSE CAST(Diplomados_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Estancias_Hombres = ' ' THEN 0 ELSE CAST(Estancias_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Estancias_Mujeres = ' ' THEN 0 ELSE CAST(Estancias_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Elaboracion_Hombres = ' ' THEN 0 ELSE CAST(Elaboracion_Hombres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(CASE WHEN Elaboracion_Mujeres = ' ' THEN 0 ELSE CAST(Elaboracion_Mujeres AS VARCHAR(255)) END), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(Total_Prioritario), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(Total_Hombres), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(Total_Mujeres), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama),
                (SELECT ISNULL(SUM(Total_General), 0) FROM @DocentesAnioSabatico WHERE ID_Rama = @ContRama));

        SET @ContRama = @ContRama + 1;
    END

    INSERT INTO @DocentesAnioSabatico (UnidadAcademica,
                                        A1_Hombres,
                                        A1_Mujeres,
                                        A2_Hombres,
                                        A2_Mujeres,
                                        Actividades_Hombres,
                                        Actividades_Mujeres,
                                        EstParciales_Hombres,
                                        EstParciales_Mujeres,
                                        Individuales_Hombres,
                                        Individuales_Mujeres,
                                        Total_NoPrioritario,
                                        Investigacion_Hombres,
                                        Investigacion_Mujeres,
                                        EstPosgrado_Hombres,
                                        EstPosgrado_Mujeres,
                                        Diplomados_Hombres,
                                        Diplomados_Mujeres,
                                        Estancias_Hombres,
                                        Estancias_Mujeres,
                                        Elaboracion_Hombres,
                                        Elaboracion_Mujeres,
                                        Total_Prioritario,
                                        Total_Hombres,
                                        Total_Mujeres,
                                        Total_General)
    VALUES ('TOTAL',
            (SELECT ISNULL(SUM(CASE WHEN A1_Hombres = ' ' THEN 0 ELSE CAST(A1_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN A1_Mujeres = ' ' THEN 0 ELSE CAST(A1_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN A2_Hombres = ' ' THEN 0 ELSE CAST(A2_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN A2_Mujeres = ' ' THEN 0 ELSE CAST(A2_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Actividades_Hombres = ' ' THEN 0 ELSE CAST(Actividades_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Actividades_Mujeres = ' ' THEN 0 ELSE CAST(Actividades_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN EstParciales_Hombres = ' ' THEN 0 ELSE CAST(EstParciales_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN EstParciales_Mujeres = ' ' THEN 0 ELSE CAST(EstParciales_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Individuales_Hombres = ' ' THEN 0 ELSE CAST(Individuales_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Individuales_Mujeres = ' ' THEN 0 ELSE CAST(Individuales_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(Total_NoPrioritario)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Investigacion_Hombres = ' ' THEN 0 ELSE CAST(Investigacion_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Investigacion_Mujeres = ' ' THEN 0 ELSE CAST(Investigacion_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN EstPosgrado_Hombres = ' ' THEN 0 ELSE CAST(EstPosgrado_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN EstPosgrado_Mujeres = ' ' THEN 0 ELSE CAST(EstPosgrado_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Diplomados_Hombres = ' ' THEN 0 ELSE CAST(Diplomados_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Diplomados_Mujeres = ' ' THEN 0 ELSE CAST(Diplomados_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Estancias_Hombres = ' ' THEN 0 ELSE CAST(Estancias_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Estancias_Mujeres = ' ' THEN 0 ELSE CAST(Estancias_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Elaboracion_Hombres = ' ' THEN 0 ELSE CAST(Elaboracion_Hombres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(CASE WHEN Elaboracion_Mujeres = ' ' THEN 0 ELSE CAST(Elaboracion_Mujeres AS VARCHAR(255)) END)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(Total_Prioritario)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(Total_Hombres)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(Total_Mujeres)/2, 0) FROM @DocentesAnioSabatico),
            (SELECT ISNULL(SUM(Total_General)/2, 0) FROM @DocentesAnioSabatico));

    SELECT UnidadAcademica,
        A1_Hombres,
        A1_Mujeres,
        A2_Hombres,
        A2_Mujeres,
        Actividades_Hombres,
        Actividades_Mujeres,
        EstParciales_Hombres,
        EstParciales_Mujeres,
        Individuales_Hombres,
        Individuales_Mujeres,
        Total_NoPrioritario,
        Investigacion_Hombres,
        Investigacion_Mujeres,
        EstPosgrado_Hombres,
        EstPosgrado_Mujeres,
        Diplomados_Hombres,
        Diplomados_Mujeres,
        Estancias_Hombres,
        Estancias_Mujeres,
        Elaboracion_Hombres,
        Elaboracion_Mujeres,
        Total_Prioritario,
        Total_Hombres,
        Total_Mujeres,
        Total_General
    FROM @DocentesAnioSabatico;
END