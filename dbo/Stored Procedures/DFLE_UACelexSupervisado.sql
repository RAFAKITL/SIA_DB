--Formato 1: Unidades Académicas que cuentan con CELEX supervisadas ACUMULADO
CREATE PROCEDURE DFLE_UACelexSupervisado
    @SiglasTipoUnidad VARCHAR(255),
    @anio INT,
    @id_Trimestre INT

AS 
BEGIN 
    SET NOCOUNT ON;
    DECLARE @TablaUnidadesAcademicas TABLE (
        UnidadAcademica VARCHAR(255),
        ID_UnidadAcademica INT IDENTITY (1,1)
    );
    INSERT INTO @TablaUnidadesAcademicas 
        SELECT 
            Siglas
        FROM
            UnidadesAcademicas
        WHERE
            id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica 
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidad); 
                                    
    DECLARE @Supervision TABLE (
        SiglasUA VARCHAR(255), 
        UATrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        UATrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        UATrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        UATrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        TrimeUno VARCHAR(1) NOT NULL DEFAULT ' ',
        TrimeDos VARCHAR(1)  NOT NULL DEFAULT ' ',
        TrimeTres VARCHAR(1) NOT NULL DEFAULT ' ',
        TrimeCuatro VARCHAR(1) NOT NULL DEFAULT ' ',
        TotalSupervision INT NOT NULL DEFAULT 0 
    );


    DECLARE @contadorUA INT = 1;
    DECLARE @SiglasUA VARCHAR(255);
    WHILE @contadorUA <= (SELECT COUNT(*) FROM @TablaUnidadesAcademicas)
    BEGIN
        SET @SiglasUA = (SELECT UnidadAcademica FROM @TablaUnidadesAcademicas WHERE ID_UnidadAcademica = @contadorUA);

        DECLARE @UATrimUno VARCHAR(1) = CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUA) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = 1) THEN '1' ELSE ' ' END ;
                                                    
        DECLARE @UATrimDos VARCHAR(1)  = CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUA) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = 2) THEN '1' ELSE ' ' END ;
        DECLARE @UATrimTres VARCHAR(1)  = CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUA) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = 3) THEN '1' ELSE ' ' END ;
        DECLARE @UATrimCuatro VARCHAR(1) = CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUA) 
                                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                AND id_Trimestre = 4) THEN '1' ELSE ' ' END ;

        DECLARE @TrimeUno INT = ISNULL((SELECT TRIM_UNO_Supervicion
                    FROM DFLE_SupervicionCelex
                    WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                    AND id_Trimestre = 1
                    AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                            FROM UnidadesAcademicas 
                                            WHERE Siglas =  @SiglasUA)),0);
        DECLARE @TrimeDos INT = ISNULL((SELECT TRIM_UNO_Supervicion
                    FROM DFLE_SupervicionCelex
                    WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                    AND id_Trimestre = 2
                    AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                            FROM UnidadesAcademicas 
                                            WHERE Siglas =  @SiglasUA)),0);
        DECLARE @TrimeTres INT = ISNULL((SELECT TRIM_UNO_Supervicion
                    FROM DFLE_SupervicionCelex
                    WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                    AND id_Trimestre = 3
                    AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                            FROM UnidadesAcademicas 
                                            WHERE Siglas =  @SiglasUA)),0);
        DECLARE @TrimeCuatro INT = ISNULL((SELECT TRIM_UNO_Supervicion
                    FROM DFLE_SupervicionCelex
                    WHERE id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio) 
                    AND id_Trimestre = 4
                    AND id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                            FROM UnidadesAcademicas 
                                            WHERE Siglas =  @SiglasUA)),0);
        
       
        INSERT INTO @Supervision(
            SiglasUA,
            UATrimUno,
            UATrimDos,
            UATrimTres,
            UATrimCuatro,
            TrimeUno,
            TrimeDos,
            TrimeTres,
            TrimeCuatro,
            TotalSupervision
        )VALUES(
            @SiglasUA,
            CASE WHEN @UATrimUno = 0
            THEN ' '
            ELSE CAST(@UATrimUno AS VARCHAR(1))
            END,
            CASE WHEN @UATrimDos = 0
            THEN ' '
            ELSE CAST(@UATrimDos AS VARCHAR(1))
            END,
            CASE WHEN @UATrimTres = 0
            THEN ' '
            ELSE CAST(@UATrimTres AS VARCHAR(1))
            END,
            CASE WHEN @UATrimCuatro = 0
            THEN ' '
            ELSE CAST(@UATrimCuatro AS VARCHAR(1))
            END,
            CASE WHEN @TrimeUno = 0
            THEN ' '
            ELSE CAST(@TrimeUno AS VARCHAR(1))
            END,
            CASE WHEN @TrimeDos = 0
            THEN ' '
            ELSE CAST(@TrimeDos AS VARCHAR(1))
            END,
            CASE WHEN @TrimeTres = 0
            THEN ' '
            ELSE CAST(@TrimeTres AS VARCHAR(1))
            END,
            CASE WHEN @TrimeCuatro = 0
            THEN ' '
            ELSE CAST(@TrimeCuatro AS VARCHAR(1))
            END,
            @TrimeUno + @TrimeDos + @TrimeTres + @TrimeCuatro
            );                        

        SET @contadorUA = @contadorUA + 1;
    END
    SELECT  * FROM @Supervision S ;
END