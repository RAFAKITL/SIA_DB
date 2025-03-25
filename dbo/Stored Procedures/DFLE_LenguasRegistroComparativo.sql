--Numero de Formato: 5 Lenguas con registro COMPARATIVO
CREATE PROCEDURE DFLE_LenguasRegistroComparativo
    @anio INT,
    @id_trimestre INT
AS 
BEGIN
    SET NOCOUNT ON;
    DECLARE @LenguasRegistro TABLE(
        Lengua VARCHAR(50) NOT NULL DEFAULT ' ',
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
    INSERT INTO @LenguasRegistro(Lengua)
    SELECT Desc_Idioma FROM DFLE_Idiomas;

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

    DECLARE @ContadorIdiomas INT = 1;
    DECLARE @ContadorTrimestre INT;

    WHILE @ContadorIdiomas <= (SELECT COUNT(*) FROM DFLE_Idiomas)
    BEGIN 
        SET @ContadorTrimestre = 1;
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
                                    AND id_Idioma = @ContadorIdiomas), 0);
            SET @AntNS = @AntNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'NS'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @AntCINV = @AntCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))   
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'C INV'))
                                    AND id_Anio = (SELECT id_Anio from Anio WHERE Desc_Anio = @AnioAnterior)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @AntCVDR = @AntCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'UAVDR'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @AntCIITA = @AntCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'CIITA'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @AntCENLEX = @AntCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'UAAE'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);
                                    
            SET @ActNMS = @ActNMS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'NMS'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @ActNS = @ActNS + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'NS'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @ActCINV = @ActCINV + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))    
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'C INV'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @ActCVDR = @ActCVDR + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica))  
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'UAVDR'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @ActCIITA = @ActCIITA + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'CIITA'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @ActCENLEX = @ActCENLEX + ISNULL((SELECT COUNT(DISTINCT(id_UnidadAcademica)) 
                                    FROM DFLE_AlumnosLenguasPGI
                                    WHERE id_UnidadAcademica in (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica
                                                                                                FROM TipoUnidadAcademica
                                                                                                WHERE Desc_SiglasTipo = 'UAAE'))
                                    AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                                    AND id_Trimestre = @ContadorTrimestre
                                    AND id_Idioma = @ContadorIdiomas),0);

            SET @ContadorTrimestre = @ContadorTrimestre + 1;
        END
        SET @AntTotal = @AntNMS + @AntNS + @AntCINV + @AntCVDR + @AntCIITA + @AntCENLEX;
        SET @ActTotal = @ActNMS + @ActNS + @ActCINV + @ActCVDR + @ActCIITA + @ActCENLEX;

        SET @Variacion = CASE WHEN @AntTotal = 0 
                        THEN 0 
                        ELSE ((@ActTotal/ @AntTotal)-1) END;

        SET @Justicacion = (SELECT Desc_Justificacion
                            FROM DFLE_JustificacionesFormato5_9
                            WHERE id_Idioma = @ContadorIdiomas
                            AND id_Anio = (SELECT id_Anio FROM Anio WHERE Desc_Anio = @anio)
                            AND id_Trimestre = @id_trimestre
                            AND id_FormatoAutoevaluacion = (SELECT ID_Formato 
                                                        FROM Formatos
                                                        WHERE Desc_NumeroFormato = 5
                                                        AND id_DependenciaEvaluada = (SELECT ID_DependenciasEvaluadas
                                                                                    FROM Dependencias_Evaluadas
                                                                                    WHERE Desc_SiglasDependencia = 'DFLE')));

        UPDATE @LenguasRegistro
        SET AntNMS = @AntNMS,
            AntNS = @AntNS,
            AntCINV = @AntCINV,
            AntCVDR = @AntCVDR,
            AntCIITA = @AntCIITA,
            AntCENLEX = @AntCENLEX,
            AntTotal = @AntTotal,
            ActNMS = @ActNMS,
            ActNS = @ActNS,
            ActCINV = @ActCINV,
            ActCVDR = @ActCVDR,
            ActCIITA = @ActCIITA,
            ActCENLEX = @ActCENLEX,
            ActTotal = @ActTotal,
            Variacion = CASE WHEN @AntTotal = 0 AND @Variacion = 0 
                        THEN ' '
                        ELSE CONCAT(@Variacion, '%') END,
            Justicacion = ISNULL(@Justicacion, ' ')
        WHERE Lengua = (SELECT Desc_Idioma FROM DFLE_Idiomas WHERE ID_Idioma = @ContadorIdiomas);

        SET @AntNMS = 0;
        SET @AntNS = 0;
        SET @AntCINV = 0;
        SET @AntCVDR = 0;
        SET @AntCIITA = 0;
        SET @AntCENLEX = 0;

        SET @ActNMS = 0;
        SET @ActNS = 0;
        SET @ActCINV = 0;
        SET @ActCVDR = 0;
        SET @ActCIITA = 0;
        SET @ActCENLEX = 0;

        SET @ContadorIdiomas = @ContadorIdiomas + 1;
    END
    SELECT * FROM @LenguasRegistro;
END

