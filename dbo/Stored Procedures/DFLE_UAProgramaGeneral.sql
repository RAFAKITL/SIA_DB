--Numero de formato: 3 UNIDADES ACADÉMICAS QUE IMPLEMENTAN EL PROGRAMA GENERAL DE LENGUAS Acumulado
CREATE PROCEDURE DFLE_UAProgramaGeneral
    @SiglasTipoUnidadAcademica VARCHAR(50),
    @Anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    --**********************************************************************************
    --Declaraciones importantes a tomar en cuenta
    --**********************************************************************************

    --!Declaracion de la tabla provisional para organizar los datos que se mostraran con 
    --!procedimiento
    DECLARE @UnidadesProgramaGeneral TABLE(
        SiglasUnidadAcademica varchar(255),
        CELEX varchar(1),

        InglesPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        InglesSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        InglesTercerAnio varchar(1) NOT NULL DEFAULT ' ',
        InglesCuartoAnio varchar(1) NOT NULL DEFAULT ' ',
        InglesAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        InglesTotal varchar(1) NOT NULL DEFAULT '0',

        AlemanPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        AlemanSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        AlemanAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        AlemanTotal varchar(1) NOT NULL DEFAULT '0',

        JaponesPrimerAnio varchar(1) NOT NULL DEFAULT ' ' ,
        JaponesSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        JaponesAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        JaponesTotal varchar(1) NOT NULL DEFAULT '0',

        CoreanoPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        CoreanoSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        CoreanoAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        CoreanoTotal varchar(1) NOT NULL DEFAULT '0',

        PortuguesPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        PortuguesSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        PortuguesAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        PortuguesTotal varchar(1) NOT NULL DEFAULT '0',

        LenguaSenasPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        LenguaSenasSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        LenguaSenasAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        LenguaSenasTotal varchar(1) NOT NULL DEFAULT '0',

        FrancesPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        FrancesSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        FrancesAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        FrancesTotal varchar(1) NOT NULL DEFAULT '0',

        EspanolPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        EspanolSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        EspanolAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        EspanolTotal varchar(1) NOT NULL DEFAULT '0',

        ChinoMandarinPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        ChinoMandarinSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        ChinoMandarinAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        ChinoMandarinTotal varchar(1) NOT NULL DEFAULT '0',

        HindiPrimerAnio varchar(1) NOT NULL DEFAULT ' ',
        HindiSegundoAnio varchar(1) NOT NULL DEFAULT ' ',
        HindiAnioTrimestreActual varchar(1) NOT NULL DEFAULT ' ',
        HindiTotal varchar(1) NOT NULL DEFAULT '0',

        InglesImplementacion varchar(1) NOT NULL DEFAULT ' ',
        AlemanImplementacion varchar(1) NOT NULL DEFAULT ' ',
        JaponesImplementacion varchar(1) NOT NULL DEFAULT ' ',
        ChinoMandarinImplementacion varchar(1) NOT NULL DEFAULT ' ',
        PortuguesImplementacion varchar(1) NOT NULL DEFAULT ' ',
        LenguaSenasImplementacion varchar(1) NOT NULL DEFAULT ' ',
        FrancesImplementacion varchar(1) NOT NULL DEFAULT ' ',
        EspanolImplementacion varchar(1) NOT NULL DEFAULT ' ',
        CoreanoImplementacion varchar(1) NOT NULL DEFAULT ' ',
        HindiImplementacion varchar(1) NOT NULL DEFAULT ' '
    );

    --!Declaramos la tabla que contendra las unidades academicas para poder iterar
    --!sobre ellas
    DECLARE @UnidadesAcademicas TABLE(
        ID_Unidad INT IDENTITY(1,1),
        SiglasUnidadAcademica varchar(255)
    );

    --!Declaramos la tabla que contendra los idiomas que cuenten con el programa general
    DECLARE @IdiomasPGI TABLE(
        ID_Idioma INT IDENTITY(1,1),
        Desc_Idioma varchar(255)
    )

    --!Declaramos el contador para recorrer las unidades academicas así como 
    --!la variable que guarda el valor de la unidad academica actual
    DECLARE @ContadorUA INT = 1;
    DECLARE @ContadorIdioma INT = 1;
    DECLARE @SiglasUnidadActual varchar(255);

    --!Declaramos variables para que guarden la información sobre la existencia del
    --!programa general institucional en la unidad academica actual

    --DECLARE @CELEX INT;
    DECLARE @CELEX VARCHAR(1);
    DECLARE @InglesPrimerAnio INT;
    DECLARE @InglesSegundoAnio INT;
    DECLARE @InglesTercerAnio INT;
    DECLARE @InglesCuartoAnio INT;
    DECLARE @InglesAnioTrimestreActual INT;
    DECLARE @InglesTotal INT;
    
    DECLARE @PrimerAnio INT;
    DECLARE @SegundoAnio INT;
    DECLARE @AnioTrimestreActual INT;
    DECLARE @Total INT;

    --!Declaracion variables para años anteriores
    DECLARE @AnioAnterior INT = @Anio - 1;
    DECLARE @AnioAnteAnterior INT = @Anio - 2;
    DECLARE @AnioAnteAnteAnterior INT = @Anio - 3;
    DECLARE @AnioAnteAnteAnteAnterior INT = @Anio - 4;

    --****************************************************************************
    --En esta parte se comienza el codigo para el relleno de la tabla provisional
    --****************************************************************************

    --!Se insertan las unidades academicas correspondientes al tipo solicitado
    INSERT INTO @UnidadesAcademicas(
        SiglasUnidadAcademica
    )
    SELECT Siglas 
    FROM UnidadesAcademicas
    WHERE id_TipoUnidadAcademica = (SELECT ID_TipoUnidadAcademica 
                                    FROM TipoUnidadAcademica
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica);

    INSERT INTO @UnidadesProgramaGeneral(
        SiglasUnidadAcademica
    )
    SELECT SiglasUnidadAcademica 
    FROM @UnidadesAcademicas
    

    --!Insertamos los idiomas que cuentan con PGII
    INSERT INTO @IdiomasPGI(
        Desc_Idioma
    )
    SELECT Desc_Idioma
    FROM DFLE_Idiomas
    WHERE Desc_PGI != ' ';

    --!While para el recorrido de las unidades academicas
    WHILE @ContadorUA <= (SELECT COUNT(*) FROM @UnidadesAcademicas)
    BEGIN

        --!Asignacion de la unidad actual
        SET @SiglasUnidadActual = (SELECT SiglasUnidadAcademica FROM @UnidadesAcademicas WHERE ID_Unidad = @ContadorUA);

        SET @CELEX = CASE WHEN EXISTS(SELECT * 
                                        FROM DFLE_AlumnosEnsenanzaLenguas
                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                    FROM UnidadesAcademicas 
                                                                    WHERE Siglas = @SiglasUnidadActual) 
                                        AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @anio)
                                        AND id_Trimestre = @id_Trimestre) THEN '1' ELSE ' ' END ;
        
        UPDATE @UnidadesProgramaGeneral
        SET CELEX = @CELEX
        WHERE SiglasUnidadAcademica = @SiglasUnidadActual;

        SET @ContadorIdioma = 1;

        WHILE @ContadorIdioma <= (SELECT COUNT(*) FROM @IdiomasPGI)
        BEGIN 
            IF @ContadorIdioma = 1
            BEGIN
                SET @InglesPrimerAnio = CASE WHEN EXISTS(SELECT * 
                                                        FROM DFLE_AlumnosLenguasPGI
                                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                    FROM UnidadesAcademicas 
                                                                                    WHERE Siglas = @SiglasUnidadActual)
                                                        AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                                FROM @IdiomasPGI 
                                                                                                                                WHERE ID_Idioma = @ContadorIdioma)) 
                                                        AND id_Anio = (SELECT ID_Anio 
                                                                        FROM Anio 
                                                                        WHERE Desc_Anio = @AnioAnteAnteAnteAnterior)
                                                        ) THEN 1 ELSE 0 END ;
                SET @InglesSegundoAnio = CASE WHEN EXISTS(SELECT * 
                                                        FROM DFLE_AlumnosLenguasPGI
                                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                    FROM UnidadesAcademicas 
                                                                                    WHERE Siglas = @SiglasUnidadActual)
                                                        AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                                FROM @IdiomasPGI 
                                                                                                                                WHERE ID_Idioma = @ContadorIdioma)) 
                                                        AND id_Anio = (SELECT ID_Anio 
                                                                        FROM Anio 
                                                                        WHERE Desc_Anio = @AnioAnteAnteAnterior)
                                                        ) THEN 1 ELSE 0 END ;
                SET @InglesTercerAnio = CASE WHEN EXISTS(SELECT * 
                                                        FROM DFLE_AlumnosLenguasPGI
                                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                    FROM UnidadesAcademicas 
                                                                                    WHERE Siglas = @SiglasUnidadActual)
                                                        AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                                FROM @IdiomasPGI 
                                                                                                                                WHERE ID_Idioma = @ContadorIdioma)) 
                                                        AND id_Anio = (SELECT ID_Anio 
                                                                        FROM Anio 
                                                                        WHERE Desc_Anio = @AnioAnteAnterior)
                                                        ) THEN 1 ELSE 0 END ;
                SET @InglesCuartoAnio = CASE WHEN EXISTS(SELECT * 
                                                        FROM DFLE_AlumnosLenguasPGI
                                                        WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                    FROM UnidadesAcademicas 
                                                                                    WHERE Siglas = @SiglasUnidadActual)
                                                        AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                                FROM @IdiomasPGI 
                                                                                                                                WHERE ID_Idioma = @ContadorIdioma)) 
                                                        AND id_Anio = (SELECT ID_Anio 
                                                                        FROM Anio 
                                                                        WHERE Desc_Anio = @AnioAnterior)
                                                        ) THEN 1 ELSE 0 END ;
                SET @InglesAnioTrimestreActual = CASE WHEN EXISTS(SELECT * 
                                                                FROM DFLE_AlumnosLenguasPGI
                                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                            FROM UnidadesAcademicas 
                                                                                            WHERE Siglas = @SiglasUnidadActual) 
                                                                AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                                FROM @IdiomasPGI 
                                                                                                                                WHERE ID_Idioma = @ContadorIdioma)) 
                                                                AND id_Anio = (SELECT ID_Anio 
                                                                                FROM Anio 
                                                                                WHERE Desc_Anio = @Anio)
                                                                AND id_Trimestre = @id_Trimestre
                                                                ) THEN 1 ELSE 0 END ;
                SET @InglesTotal = @InglesPrimerAnio + @InglesSegundoAnio + @InglesTercerAnio + @InglesCuartoAnio + @InglesAnioTrimestreActual;

                UPDATE @UnidadesProgramaGeneral
                SET InglesPrimerAnio = CASE WHEN @InglesPrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@InglesPrimerAnio AS VARCHAR(1)) END,
                    InglesSegundoAnio = CASE WHEN @InglesSegundoAnio = 0 
                                        THEN ' ' ELSE CAST(@InglesSegundoAnio AS VARCHAR(1)) END,
                    InglesTercerAnio = CASE WHEN @InglesTercerAnio = 0 
                                        THEN ' ' ELSE CAST(@InglesTercerAnio AS VARCHAR(1)) END,
                    InglesCuartoAnio = CASE WHEN @InglesCuartoAnio = 0 
                                        THEN ' ' ELSE CAST(@InglesCuartoAnio AS VARCHAR(1)) END,
                    InglesAnioTrimestreActual = CASE WHEN @InglesAnioTrimestreActual = 0 
                                                THEN ' ' ELSE CAST(@InglesAnioTrimestreActual AS VARCHAR(1)) END,
                    InglesTotal = CASE WHEN @InglesTotal = 0 
                                    THEN '0' ELSE CAST(@InglesTotal AS VARCHAR(1)) END,
                    InglesImplementacion = CASE WHEN @InglesTotal > 0  THEN '1' ELSE ' ' END

                WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
            END
            ELSE
            BEGIN
                SET @PrimerAnio = CASE WHEN EXISTS(SELECT * 
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE Siglas = @SiglasUnidadActual)
                                                AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                        FROM @IdiomasPGI 
                                                                                                                        WHERE ID_Idioma = @ContadorIdioma)) 
                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @AnioAnteAnterior)
                                                ) THEN 1 ELSE 0 END ;
                SET @SegundoAnio = CASE WHEN EXISTS(SELECT *
                                                FROM DFLE_AlumnosLenguasPGI
                                                WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                            FROM UnidadesAcademicas 
                                                                            WHERE Siglas = @SiglasUnidadActual)
                                                AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                        FROM @IdiomasPGI 
                                                                                                                        WHERE ID_Idioma = @ContadorIdioma)) 
                                                AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @AnioAnterior)
                                                ) THEN 1 ELSE 0 END ;
                SET @AnioTrimestreActual = CASE WHEN EXISTS(SELECT * 
                                                            FROM DFLE_AlumnosLenguasPGI
                                                            WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                                        FROM UnidadesAcademicas 
                                                                                        WHERE Siglas = @SiglasUnidadActual)
                                                            AND id_Idioma = (SELECT ID_Idioma FROM DFLE_Idiomas WHERE Desc_Idioma = (SELECT Desc_Idioma 
                                                                                                                                FROM @IdiomasPGI 
                                                                                                                                WHERE ID_Idioma = @ContadorIdioma)) 
                                                            AND id_Anio = (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
                                                            AND id_Trimestre = @id_Trimestre
                                                            ) THEN 1 ELSE 0 END ;
                SET @Total = @PrimerAnio + @SegundoAnio + @AnioTrimestreActual;

                IF @ContadorIdioma = 2
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET FrancesPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        FrancesSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        FrancesAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        FrancesTotal = @Total,
                        FrancesImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 3
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET AlemanPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        AlemanSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        AlemanAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        AlemanTotal = @Total,
                        AlemanImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 4
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET JaponesPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        JaponesSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        JaponesAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        JaponesTotal = @Total,
                        JaponesImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 5
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET ChinoMandarinPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        ChinoMandarinSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        ChinoMandarinAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        ChinoMandarinTotal = @Total,
                        ChinoMandarinImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 6
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET PortuguesPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        PortuguesSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        PortuguesAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        PortuguesTotal = @Total,
                        PortuguesImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 7
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET EspanolPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        EspanolSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        EspanolAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        EspanolTotal = @Total,
                        EspanolImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 8
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET LenguaSenasPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        LenguaSenasSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        LenguaSenasAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        LenguaSenasTotal = @Total,
                        LenguaSenasImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 9
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET CoreanoPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        CoreanoSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        CoreanoAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        CoreanoTotal = @Total,
                        CoreanoImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
                ELSE IF @ContadorIdioma = 10
                BEGIN
                    UPDATE @UnidadesProgramaGeneral
                    SET HindiPrimerAnio = CASE WHEN @PrimerAnio = 0 
                                        THEN ' ' ELSE CAST(@PrimerAnio AS VARCHAR(1)) END,
                        HindiSegundoAnio = CASE WHEN @SegundoAnio= 0 
                                        THEN ' ' ELSE CAST(@SegundoAnio AS VARCHAR(1)) END,
                        HindiAnioTrimestreActual = CASE WHEN @AnioTrimestreActual= 0 
                                        THEN ' ' ELSE CAST(@AnioTrimestreActual AS VARCHAR(1)) END,
                        HindiTotal = @Total,
                        HindiImplementacion = CASE WHEN @Total > 0 THEN '1' ELSE ' ' END
                    WHERE SiglasUnidadAcademica = @SiglasUnidadActual;
                END
            END
            SET @ContadorIdioma = @ContadorIdioma + 1;
        END
        SET @ContadorUA = @ContadorUA + 1;
    END
    --****************************************************************************

    --!Select para mostrar la tabla que rellena la parte correspondiente al formato de 
    --!este procedimiento
    SELECT * FROM @UnidadesProgramaGeneral
END
