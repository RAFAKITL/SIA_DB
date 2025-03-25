--Numero de Formato: 7 Enseñanza de lenguas por Nivel Educativo
CREATE PROCEDURE DFLE_EnsenanzaLenguasNivelEducativo
    @SiglasTipoUnidadAcademica varchar(255),
    @SiglasRamaConocimiento varchar(255),
    @anio INT,
    @id_Trimestre INT
AS
BEGIN
    SET NOCOUNT ON;
    --**********************************************************************************
    --Declaraciones importantes a tomar en cuenta
    --**********************************************************************************

    --!Declaracion de la tabla provisional para organizar los datos que se mostraran con 
    --!procedimiento

    DECLARE @EnsenanzaAlumnosNivelEducativo TABLE(
        SiglasUnidadesAcademicas varchar(255),
        
        NMS_Hombres varchar(255) NOT NULL DEFAULT ' ',
        NMS_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        NMS_Total varchar(255) NOT NULL DEFAULT ' ',

        NS_Hombres varchar(255) NOT NULL DEFAULT ' ',
        NS_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        NS_Total varchar(255) NOT NULL DEFAULT ' ',

        Pos_Hombres varchar(255) NOT NULL DEFAULT ' ',
        Pos_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        Pos_Total varchar(255) NOT NULL DEFAULT ' ',

        Egresados_Hombres varchar(255) NOT NULL DEFAULT ' ',
        Egresados_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        Egresados_Total varchar(255) NOT NULL DEFAULT ' ',

        Empleados_Hombres varchar(255) NOT NULL DEFAULT ' ',
        Empleados_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        Empleados_Total varchar(255) NOT NULL DEFAULT ' ',

        Subtotal_Hombres varchar(255) NOT NULL DEFAULT ' ',
        Subtotal_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        Subtotal_Total varchar(255) NOT NULL DEFAULT ' ',

        PublicoGeneral_Hombres varchar(255) NOT NULL DEFAULT ' ',
        PublicoGeneral_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        PublicoGeneral_Total varchar(255) NOT NULL DEFAULT ' ',

        PoblacionAtendida_Hombres varchar(255) NOT NULL DEFAULT ' ',
        PoblacionAtendida_Mujeres varchar(255) NOT NULL DEFAULT ' ',
        PoblacionAtendida_Total varchar(255) NOT NULL DEFAULT ' '
    )

    --!Declaramos la tabla que contendra las unidades academicas para poder iterar
    --!sobre ellas
    DECLARE @UnidadesAcademicas TABLE(
        ID_Unidad INT IDENTITY(1,1),
        SiglasUnidadAcademica varchar(255)
    );

    --!Declaramos el contador para recorrer las unidades academicas y los
    --!niveles educativos así como la variable que guarda el valor de 
    --!la unidad academica actual, el nivel educativo sera buscado por su ID
    DECLARE @ContadorUA INT = 1;
    DECLARE @ContadorNivelEducativo INT = 1;

    DECLARE @SiglasUnidadActual varchar(255);


    --!Declaramos las variables para guardar las cantidades de hombres, mujeres y total,
    --!además las varibles que llevaran el conteo del subtotal y el total de la poblacion atendida
    DECLARE @Hombres INT;
    DECLARE @Mujeres INT;
    DECLARE @TotalHM INT;

    SET @Hombres = 0;
    SET @Mujeres = 0;
    SET @TotalHM = 0;

    DECLARE @SubtotalHombres INT;
    DECLARE @SubtotalMujeres INT;
    DECLARE @SubtotalTotal INT;

    DECLARE @PoblacionAtendidaHombres INT;
    DECLARE @PoblacionAtendidaMujeres INT;
    DECLARE @PoblacionAtendidaTotal INT;


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
                                    WHERE Desc_SiglasTipo = @SiglasTipoUnidadAcademica)
    AND id_RamaConocimiento = (SELECT ID_RamaConocimiento 
                                FROM RamaConocimiento
                                WHERE Desc_SiglasRama = @SiglasRamaConocimiento);

    --!While para el recorrido de las unidades academicas
    WHILE @ContadorUA <= (SELECT COUNT(*) FROM @UnidadesAcademicas)
    BEGIN

        --!Asignacion de la unidad actual
        SET @SiglasUnidadActual = (SELECT SiglasUnidadAcademica FROM @UnidadesAcademicas WHERE ID_Unidad = @ContadorUA);
        SET @ContadorNivelEducativo = 1;
        
        SET @SubtotalHombres = 0;
        SET @SubtotalMujeres = 0;
        SET @SubtotalTotal = 0;

        SET @PoblacionAtendidaHombres = 0;
        SET @PoblacionAtendidaMujeres = 0;
        SET @PoblacionAtendidaTotal = 0;

        --!Insertamos la unidad a la tabla provisional
        INSERT INTO @EnsenanzaAlumnosNivelEducativo(
            SiglasUnidadesAcademicas
        )VALUES(
            @SiglasUnidadActual
        );

        --!While para recorrer los niveles educativos de los alumnos de la DFLE
        WHILE @ContadorNivelEducativo <= (SELECT COUNT(*) FROM DFLE_NivelEducativo)
        BEGIN
            SET @Hombres = ISNULL((SELECT SUM(Desc_Hombres) 
                                    FROM DFLE_AlumnosEnsenanzaLenguas
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE Siglas = @SiglasUnidadActual) 
                                    AND id_NivelEducativo = @ContadorNivelEducativo ), 0);

            SET @Mujeres = ISNULL((SELECT SUM(Desc_Mujeres) 
                                    FROM DFLE_AlumnosEnsenanzaLenguas
                                    WHERE id_UnidadAcademica = (SELECT ID_UnidadAcademica 
                                                                FROM UnidadesAcademicas 
                                                                WHERE Siglas = @SiglasUnidadActual) 
                                    AND id_NivelEducativo = @ContadorNivelEducativo ), 0);

            SET @TotalHM = @Hombres + @Mujeres;

            IF @ContadorNivelEducativo = 1
            BEGIN
                UPDATE @EnsenanzaAlumnosNivelEducativo
                SET NMS_Hombres = @Hombres,
                    NMS_Mujeres = @Mujeres,
                    NMS_Total = @TotalHM
                WHERE SiglasUnidadesAcademicas = @SiglasUnidadActual;

                SET @SubtotalHombres = @SubtotalHombres + @Hombres;
                SET @SubtotalMujeres = @SubtotalMujeres + @Mujeres;
                SET @SubtotalTotal = @SubtotalTotal + @TotalHM;
            END
            ELSE IF @ContadorNivelEducativo = 2
            BEGIN
                UPDATE @EnsenanzaAlumnosNivelEducativo
                SET NS_Hombres = @Hombres,
                    NS_Mujeres = @Mujeres,
                    NS_Total = @TotalHM
                WHERE SiglasUnidadesAcademicas = @SiglasUnidadActual;

                SET @SubtotalHombres = @SubtotalHombres + @Hombres;
                SET @SubtotalMujeres = @SubtotalMujeres + @Mujeres;
                SET @SubtotalTotal = @SubtotalTotal + @TotalHM;

            END
            ELSE IF @ContadorNivelEducativo = 3
            BEGIN
                UPDATE @EnsenanzaAlumnosNivelEducativo
                SET Pos_Hombres = @Hombres,
                    Pos_Mujeres = @Mujeres,
                    Pos_Total = @TotalHM
                WHERE SiglasUnidadesAcademicas = @SiglasUnidadActual;

                SET @SubtotalHombres = @SubtotalHombres + @Hombres;
                SET @SubtotalMujeres = @SubtotalMujeres + @Mujeres;
                SET @SubtotalTotal = @SubtotalTotal + @TotalHM;

            END
            ELSE IF @ContadorNivelEducativo = 4
            BEGIN
                UPDATE @EnsenanzaAlumnosNivelEducativo
                SET Egresados_Hombres = @Hombres,
                    Egresados_Mujeres = @Mujeres,
                    Egresados_Total = @TotalHM
                WHERE SiglasUnidadesAcademicas = @SiglasUnidadActual;
                
                SET @SubtotalHombres = @SubtotalHombres + @Hombres;
                SET @SubtotalMujeres = @SubtotalMujeres + @Mujeres;
                SET @SubtotalTotal = @SubtotalTotal + @TotalHM;

            END
            ELSE IF @ContadorNivelEducativo = 5
            BEGIN
                UPDATE @EnsenanzaAlumnosNivelEducativo
                SET Empleados_Hombres = @Hombres,
                    Empleados_Mujeres = @Mujeres,
                    Empleados_Total = @TotalHM
                WHERE SiglasUnidadesAcademicas = @SiglasUnidadActual;

                SET @SubtotalHombres = @SubtotalHombres + @Hombres;
                SET @SubtotalMujeres = @SubtotalMujeres + @Mujeres;
                SET @SubtotalTotal = @SubtotalTotal + @TotalHM;

            END
            ELSE IF @ContadorNivelEducativo = 6
            BEGIN
                UPDATE @EnsenanzaAlumnosNivelEducativo
                SET PublicoGeneral_Hombres = @Hombres,
                    PublicoGeneral_Mujeres = @Mujeres,
                    PublicoGeneral_Total = @TotalHM
                WHERE SiglasUnidadesAcademicas = @SiglasUnidadActual;

                DECLARE @PublicoGeneral_Hombres INT = @Hombres;
                DECLARE @PublicoGeneral_Mujeres INT = @Mujeres;
                DECLARE @PublicoGeneral_Total INT = @TotalHM;
            END

            SET @ContadorNivelEducativo = @ContadorNivelEducativo + 1;
        END

        SET @PoblacionAtendidaHombres = @SubtotalHombres + @PublicoGeneral_Hombres;
        SET @PoblacionAtendidaMujeres = @SubtotalMujeres + @PublicoGeneral_Mujeres;
        SET @PoblacionAtendidaTotal = @SubtotalTotal + @PublicoGeneral_Total;

        UPDATE @EnsenanzaAlumnosNivelEducativo
        SET Subtotal_Hombres = @SubtotalHombres,
            Subtotal_Mujeres = @SubtotalMujeres,
            Subtotal_Total = @SubtotalTotal,
            PoblacionAtendida_Hombres = @PoblacionAtendidaHombres,
            PoblacionAtendida_Mujeres = @PoblacionAtendidaMujeres,
            PoblacionAtendida_Total = @PoblacionAtendidaTotal
        WHERE SiglasUnidadesAcademicas = @SiglasUnidadActual;

        SET @ContadorUA = @ContadorUA + 1;
    END
    SELECT * FROM @EnsenanzaAlumnosNivelEducativo;
END