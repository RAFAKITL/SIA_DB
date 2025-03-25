--Numero de Formato: 4 Lenguas registradas por las Unidades Académicas CONCENTRADO
CREATE PROCEDURE DFLE_LenguasRegistradasUA
@SiglasTipoUnidad VARCHAR(255),
@anio INT

AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @contadorIdioma INT = 1;

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
    DECLARE @contadorUA INT = 1;


    DECLARE @TablaLenguasRegistradasUA TABLE(
        UnidadAcademica VARCHAR(255),
        Cuenta VARCHAR(1) NOT NULL DEFAULT ' ',
        
        InglesTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        InglesTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        InglesTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        InglesTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        FrancesTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        FrancesTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        FrancesTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        FrancesTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        AlemanTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        AlemanTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        AlemanTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        AlemanTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        ItalianoTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        ItalianoTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        ItalianoTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        ItalianoTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        JaponesTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        JaponesTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        JaponesTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        JaponesTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        ChinoTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        ChinoTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        ChinoTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        ChinoTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        PortuguesTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        PortuguesTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        PortuguesTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        PortuguesTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        RusoTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        RusoTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        RusoTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        RusoTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        NahualtTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        NahualtTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        NahualtTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        NahualtTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        EspanolTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        EspanolTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        EspanolTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        EspanolTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        SenasTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        SenasTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        SenasTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        SenasTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        CoreanoTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        CoreanoTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        CoreanoTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        CoreanoTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        HindiTrimUno VARCHAR(1) NOT NULL DEFAULT ' ',
        HindiTrimDos VARCHAR(1) NOT NULL DEFAULT ' ',
        HindiTrimTres VARCHAR(1) NOT NULL DEFAULT ' ',
        HindiTrimCuatro VARCHAR(1) NOT NULL DEFAULT ' ',

        TotalTrimUno INT NOT NULL DEFAULT 0,
        TotalTrimDos INT NOT NULL DEFAULT 0,
        TotalTrimTres INT NOT NULL DEFAULT 0,
        TotalTrimCuatro INT NOT NULL DEFAULT 0
    );
    DECLARE @SiglasUA VARCHAR(255);
    

    WHILE @contadorUA <= (SELECT COUNT(*) FROM @TablaUnidadesAcademicas)
    BEGIN
        SET @SiglasUA = (SELECT UnidadAcademica FROM @TablaUnidadesAcademicas WHERE ID_UnidadAcademica = @contadorUA);

        
        DECLARE @TotTrim1 INT = 0;
        DECLARE @TotTrim2 INT = 0;
        DECLARE @TotTrim3 INT = 0;
        DECLARE @TotTrim4 INT = 0;

        INSERT INTO @TablaLenguasRegistradasUA (
            UnidadAcademica
        )
        VALUES(
            @SiglasUA
        )
        SET  @contadorIdioma = 1;
        WHILE @contadorIdioma <= (SELECT COUNT(*) FROM DFLE_Idiomas)
        BEGIN

            DECLARE @UATrimUno VARCHAR(1) = CASE WHEN EXISTS(SELECT * 
                                                                    FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                                FROM UnidadesAcademicas 
                                                                                                WHERE Siglas = @SiglasUA)
                                                                    AND id_Idioma = @contadorIdioma
                                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                    AND id_Trimestre = 1) THEN '1' ELSE ' ' END ;
                                                        
            DECLARE @UATrimDos VARCHAR(1)  = CASE WHEN EXISTS(SELECT * 
                                                                    FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                                FROM UnidadesAcademicas 
                                                                                                WHERE Siglas = @SiglasUA) 
                                                                    AND id_Idioma = @contadorIdioma
                                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                    AND id_Trimestre = 2) THEN '1' ELSE ' ' END ;
            DECLARE @UATrimTres VARCHAR(1)  = CASE WHEN EXISTS(SELECT * 
                                                                    FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                                FROM UnidadesAcademicas 
                                                                                                WHERE Siglas = @SiglasUA) 
                                                                    AND id_Idioma = @contadorIdioma
                                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                    AND id_Trimestre = 3) THEN '1' ELSE ' ' END ;
            DECLARE @UATrimCuatro VARCHAR(1) = CASE WHEN EXISTS(SELECT * 
                                                                    FROM DFLE_AlumnosEnsenanzaLenguas 
                                                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                                FROM UnidadesAcademicas 
                                                                                                WHERE Siglas = @SiglasUA) 
                                                                    AND id_Idioma = @contadorIdioma
                                                                    AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                                                    AND id_Trimestre = 4) THEN '1' ELSE ' ' END ;

            SET @TotTrim1 = @TotTrim1 + (CASE WHEN @UATrimUno = '1' THEN 1 ELSE 0 END);
            SET @TotTrim2 = @TotTrim2 + (CASE WHEN @UATrimDos = '1' THEN 1 ELSE 0 END);
            SET @TotTrim3 = @TotTrim3 + (CASE WHEN @UATrimTres = '1' THEN 1 ELSE 0 END);
            SET @TotTrim4 = @TotTrim4 + (CASE WHEN @UATrimCuatro = '1' THEN 1 ELSE 0 END);
           
            IF @contadorIdioma = 1
            BEGIN 
                UPDATE @TablaLenguasRegistradasUA 
                SET InglesTrimUno = @UATrimUno,
                InglesTrimDos = @UATrimDos,               
                InglesTrimTres = @UATrimTres, 
                InglesTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 2
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET FrancesTrimUno = @UATrimUno,
                FrancesTrimDos = @UATrimDos,               
                FrancesTrimTres = @UATrimTres, 
                FrancesTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 3
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET AlemanTrimUno = @UATrimUno,
                AlemanTrimDos = @UATrimDos,               
                AlemanTrimTres = @UATrimTres, 
                AlemanTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 4
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET ItalianoTrimUno = @UATrimUno,
                ItalianoTrimDos = @UATrimDos,               
                ItalianoTrimTres = @UATrimTres, 
                ItalianoTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 5
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET JaponesTrimUno = @UATrimUno,
                JaponesTrimDos = @UATrimDos,               
                JaponesTrimTres = @UATrimTres, 
                JaponesTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 6
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET ChinoTrimUno = @UATrimUno,
                ChinoTrimDos = @UATrimDos,               
                ChinoTrimTres = @UATrimTres, 
                ChinoTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 7
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET PortuguesTrimUno = @UATrimUno,
                PortuguesTrimDos = @UATrimDos,               
                PortuguesTrimTres = @UATrimTres, 
                PortuguesTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 8
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET RusoTrimUno = @UATrimUno,
                RusoTrimDos = @UATrimDos,               
                RusoTrimTres = @UATrimTres, 
                RusoTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 9
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET NahualtTrimUno = @UATrimUno,
                NahualtTrimDos = @UATrimDos,               
                NahualtTrimTres = @UATrimTres, 
                NahualtTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 10
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET EspanolTrimUno = @UATrimUno,
                EspanolTrimDos = @UATrimDos,               
                EspanolTrimTres = @UATrimTres, 
                EspanolTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 11
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET SenasTrimUno = @UATrimUno,
                SenasTrimDos = @UATrimDos,               
                SenasTrimTres = @UATrimTres, 
                SenasTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 12
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET CoreanoTrimUno = @UATrimUno,
                CoreanoTrimDos = @UATrimDos,               
                CoreanoTrimTres = @UATrimTres, 
                CoreanoTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END
            ELSE IF @contadorIdioma = 13
            BEGIN
                UPDATE @TablaLenguasRegistradasUA 
                SET HindiTrimUno = @UATrimUno,
                HindiTrimDos = @UATrimDos,               
                HindiTrimTres = @UATrimTres, 
                HindiTrimCuatro = @UATrimCuatro
                WHERE UnidadAcademica = @SiglasUA
            END

            SET @contadorIdioma = @contadorIdioma + 1;
        END 
        DECLARE @Cuenta VARCHAR(1) = CASE WHEN (@TotTrim4 >0 
                                    OR @TotTrim3 >0 
                                    OR @TotTrim2 >0 
                                    OR @TotTrim1 >0 )
                                    THEN '1' ELSE ' ' END ;

        UPDATE @TablaLenguasRegistradasUA
        SET TotalTrimUno = @TotTrim1,
            TotalTrimDos = @TotTrim2,
            TotalTrimTres = @TotTrim3,
            TotalTrimCuatro = @TotTrim4,
            Cuenta = @Cuenta
        WHERE UnidadAcademica = @SiglasUA; 

        SET @contadorUA = @contadorUA + 1;
        SET @Cuenta = ' ';
    END     
    SELECT * FROM @TablaLenguasRegistradasUA
END