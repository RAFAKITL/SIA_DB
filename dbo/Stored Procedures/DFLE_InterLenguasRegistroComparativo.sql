--Procedimiento para el rellenado de la interfaz que representa el fomato 5

CREATE PROCEDURE DFLE_InterLenguasRegistroComparativo
    @Idioma varchar(255),
    @anio INT,
    @id_trimestre INT,
    @Final varchar(15)
AS
BEGIN
    -- SET NOCOUNT ON;
    DECLARE @LenguasRegistro TABLE(
        AntNMS INT NOT NULL DEFAULT 0,
        AntNS INT NOT NULL DEFAULT 0,
        AntCINV INT NOT NULL DEFAULT 0,
        AntCVDR INT NOT NULL DEFAULT 0,
        AntCIITA INT NOT NULL DEFAULT 0,
        AntCENLEX INT NOT NULL DEFAULT 0,
        AntTotal INT NOT NULL DEFAULT 0,

        ActNMS INT NOT NULL DEFAULT 0,
        ActNS INT NOT NULL DEFAULT 0,  
        ActCINV INT NOT NULL DEFAULT 0,
        ActCVDR INT NOT NULL DEFAULT 0,
        ActCIITA INT NOT NULL DEFAULT 0,
        ActCENLEX INT NOT NULL DEFAULT 0,
        ActTotal INT NOT NULL DEFAULT 0,

        Variacion VARCHAR(255) NOT NULL DEFAULT ' ',
        Justicacion VARCHAR(255) NOT NULL DEFAULT ' '
    );

    DECLARE @Identificadores TABLE(
        IdentificadorJustificacion INT
    );

    DECLARE @AntNMS INT = 0;
    DECLARE @AntNS INT = 0;
    DECLARE @AntCINV INT = 0;
    DECLARE @AntCVDR INT = 0;
    DECLARE @AntCIITA INT = 0;
    DECLARE @AntCENLEX INT = 0;
    DECLARE @AntTotal INT = 0;

    DECLARE @ActNMS INT = 0;
    DECLARE @ActNS INT = 0;
    DECLARE @ActCINV INT = 0;
    DECLARE @ActCVDR INT = 0;
    DECLARE @ActCIITA INT = 0;
    DECLARE @ActCENLEX INT = 0;
    DECLARE @ActTotal INT = 0;

    DECLARE @Variacion DECIMAL(10,2) = 0;
    DECLARE @Justicacion VARCHAR(255) = ' ';

    DECLARE @AnioAnterior INT = @anio - 1;

    DECLARE @ContadorTrimestre INT = 1;

    

    IF @Final = 'FINAL'
        BEGIN
            WHILE @ContadorTrimestre <= @id_trimestre
                BEGIN
                    IF @Idioma = 'TOTAL'
                    BEGIN
                        SET @AntNMS = @AntNMS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))
                                            FROM DFLE_AlumnosLenguasPGI
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'NMS'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                            AND id_Trimestre = @ContadorTrimestre), 0);

                        SET @AntNS = @AntNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'NS'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @AntCINV = @AntCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))   
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'C INV'))
                                                AND id_Anio = (SELECT id_Anio from Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @AntCVDR = @AntCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAVDR'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @AntCIITA = @AntCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'CIITA'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @AntCENLEX = @AntCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAAE'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre),0);
                                                
                        SET @ActNMS = @ActNMS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'NMS'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @ActNS = @ActNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'NS'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @ActCINV = @ActCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'C INV'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @ActCVDR = @ActCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAVDR'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @ActCIITA = @ActCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'CIITA'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre),0);

                        SET @ActCENLEX = @ActCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAAE'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre),0);
                    END
                    ELSE
                    BEGIN
                        SET @AntNMS = @AntNMS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'NMS'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)), 0);
                        SET @AntNS = @AntNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'NS'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @AntCINV = @AntCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))   
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'C INV'))
                                                AND id_Anio = (SELECT id_Anio from Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @AntCVDR = @AntCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAVDR'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @AntCIITA = @AntCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'CIITA'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @AntCENLEX = @AntCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAAE'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);
                                                
                        SET @ActNMS = @ActNMS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'NMS'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @ActNS = @ActNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'NS'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @ActCINV = @ActCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'C INV'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @ActCVDR = @ActCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAVDR'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @ActCIITA = @ActCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'CIITA'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);

                        SET @ActCENLEX = @ActCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                            FROM TipoUnidadAcademica
                                                                                                            WHERE Desc_SiglasTipo = 'UAAE'))
                                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                AND id_Trimestre = @ContadorTrimestre
                                                AND id_Idioma = (SELECT ID_Idioma 
                                                                FROM DFLE_Idiomas
                                                                WHERE Desc_Idioma = @Idioma)),0);
                    END
                    SET @ContadorTrimestre = @ContadorTrimestre + 1;
                END
            SET @AntTotal = @AntNMS + @AntNS + @AntCINV + @AntCVDR + @AntCIITA + @AntCENLEX;
            SET @ActTotal = @ActNMS + @ActNS + @ActCINV + @ActCVDR + @ActCIITA + @ActCENLEX;

            SET @Variacion = CASE WHEN @AntTotal = 0 
                            THEN 0 
                            ELSE ((@ActTotal/ @AntTotal)-1) END;

            SET @Justicacion = ISNULL((SELECT Desc_Justificacion
                                FROM DFLE_JustificacionesFormato5_9
                                WHERE id_Idioma = (SELECT ID_Idioma 
                                                    FROM DFLE_Idiomas
                                                    WHERE Desc_Idioma = @Idioma)
                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                AND id_Trimestre = @id_trimestre
                                AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                                            FROM Formatos
                                                            WHERE Desc_NumeroFormato = 5
                                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                        FROM Dependencias_Evaluadas
                                                                                        WHERE Desc_SiglasDependencia = 'DFLE'))), ' ');

            INSERT INTO @LenguasRegistro
            VALUES(@AntNMS,
                    @AntNS,
                    @AntCINV,
                    @AntCVDR,
                    @AntCIITA,
                    @AntCENLEX,
                    @AntTotal,
                    @ActNMS,
                    @ActNS,
                    @ActCINV,
                    @ActCVDR,
                    @ActCIITA,
                    @ActCENLEX,
                    @ActTotal,
                    CASE WHEN @AntTotal = 0 AND @Variacion = 0 
                            THEN ' '
                            ELSE CONCAT(@Variacion, '%') END,
                    ISNULL(@Justicacion, ' '));

            INSERT INTO @Identificadores(
                IdentificadorJustificacion
            )SELECT ID_JustificacionesFormato5_9
            FROM DFLE_JustificacionesFormato5_9
            WHERE id_Idioma = (SELECT ID_Idioma 
                                FROM DFLE_Idiomas
                                WHERE Desc_Idioma = @Idioma)
            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
            AND id_Trimestre = @id_trimestre
            AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                                            FROM Formatos
                                                            WHERE Desc_NumeroFormato = 5
                                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                        FROM Dependencias_Evaluadas
                                                                                        WHERE Desc_SiglasDependencia = 'DFLE'));
        END
        ELSE
        BEGIN
            WHILE @ContadorTrimestre <= @id_trimestre
                BEGIN
                    SET @AntNMS = @AntNMS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))
                                            FROM DFLE_AlumnosLenguasPGI
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'NMS'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)), 0);
                    SET @AntNS = @AntNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                            FROM DFLE_AlumnosLenguasPGI
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'NS'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @AntCINV = @AntCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))   
                                            FROM DFLE_AlumnosLenguasPGI
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'C INV'))
                                            AND id_Anio = (SELECT id_Anio from Anio WHERE Desc_Anio = @AnioAnterior)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @AntCVDR = @AntCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                            FROM DFLE_AlumnosLenguasPGI
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'UAVDR'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @AntCIITA = @AntCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                            FROM DFLE_AlumnosLenguasPGI
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'CIITA'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @AntCENLEX = @AntCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                            FROM DFLE_AlumnosLenguasPGI
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'UAAE'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);
                                            
                    SET @ActNMS = @ActNMS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                            FROM DFLE_AlumnosLenguasPGI_Temporal
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'NMS'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @ActNS = @ActNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                            FROM DFLE_AlumnosLenguasPGI_Temporal
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'NS'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @ActCINV = @ActCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                            FROM DFLE_AlumnosLenguasPGI_Temporal
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'C INV'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @ActCVDR = @ActCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                            FROM DFLE_AlumnosLenguasPGI_Temporal
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'UAVDR'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @ActCIITA = @ActCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                            FROM DFLE_AlumnosLenguasPGI_Temporal
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'CIITA'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @ActCENLEX = @ActCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                            FROM DFLE_AlumnosLenguasPGI_Temporal
                                            WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                        FROM UnidadesAcademicas 
                                                                        WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                        FROM TipoUnidadAcademica
                                                                                                        WHERE Desc_SiglasTipo = 'UAAE'))
                                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                            AND id_Trimestre = @ContadorTrimestre
                                            AND id_Idioma = (SELECT ID_Idioma 
                                                            FROM DFLE_Idiomas
                                                            WHERE Desc_Idioma = @Idioma)),0);

                    SET @ContadorTrimestre = @ContadorTrimestre + 1;
                END
            SET @AntTotal = @AntNMS + @AntNS + @AntCINV + @AntCVDR + @AntCIITA + @AntCENLEX;
            SET @ActTotal = @ActNMS + @ActNS + @ActCINV + @ActCVDR + @ActCIITA + @ActCENLEX;

            SET @Variacion = CASE WHEN @AntTotal = 0 
                            THEN 0 
                            ELSE ((@ActTotal/ @AntTotal)-1) END;

            SET @Justicacion = ISNULL((SELECT Desc_Justificacion
                                FROM DFLE_JustificacionesFormato5_9_Temporal
                                WHERE id_Idioma = (SELECT ID_Idioma 
                                                    FROM DFLE_Idiomas
                                                    WHERE Desc_Idioma = @Idioma)
                                AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                AND id_Trimestre = @id_trimestre
                                AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                                            FROM Formatos
                                                            WHERE Desc_NumeroFormato = 5
                                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                        FROM Dependencias_Evaluadas
                                                                                        WHERE Desc_SiglasDependencia = 'DFLE'))), 0);

            INSERT INTO @LenguasRegistro
            VALUES(@AntNMS,
                    @AntNS,
                    @AntCINV,
                    @AntCVDR,
                    @AntCIITA,
                    @AntCENLEX,
                    @AntTotal,
                    @ActNMS,
                    @ActNS,
                    @ActCINV,
                    @ActCVDR,
                    @ActCIITA,
                    @ActCENLEX,
                    @ActTotal,
                    CASE WHEN @AntTotal = 0 AND @Variacion = 0 
                            THEN ' '
                            ELSE CONCAT(@Variacion, '%') END,
                    ISNULL(@Justicacion, ' '));

            INSERT INTO @Identificadores(
                IdentificadorJustificacion
            )SELECT ID_JustificacionesFormato5_9
            FROM DFLE_JustificacionesFormato5_9_Temporal
            WHERE id_Idioma = (SELECT ID_Idioma 
                                FROM DFLE_Idiomas
                                WHERE Desc_Idioma = @Idioma)
            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
            AND id_Trimestre = @id_trimestre
            AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                                            FROM Formatos
                                                            WHERE Desc_NumeroFormato = 5
                                                            AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                        FROM Dependencias_Evaluadas
                                                                                        WHERE Desc_SiglasDependencia = 'DFLE'))
        END

    SELECT * FROM @LenguasRegistro;
    SELECT * FROM @Identificadores;
END
