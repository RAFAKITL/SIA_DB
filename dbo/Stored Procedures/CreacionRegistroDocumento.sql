CREATE PROCEDURE CreacionRegistroDocumento
    @TituloDocumento varchar(255),
    @FechaCreacion varchar(255),
    @Estado varchar(255),
    @SiglasDependencia varchar(255),
    @Trimestre INT,
    @Anio varchar(4),
    @CorreoUsuario varchar(255),
    @ComentarioSeguimiento NVARCHAR(MAX)
AS
    BEGIN
        INSERT INTO Documento (
            Desc_TituloDocumento,
            Desc_FechaCreacion,
            id_EstadoActual, 
            id_DependenciaEvaluada,
            id_Trimestre,
            id_Anio
        )
        VALUES
        (
            @TituloDocumento,
            @FechaCreacion,
            (SELECT ID_EstadosSemaforo FROM EstadosSemaforo WHERE Desc_EstadoSemaforo = @Estado),
            (SELECT ID_DependenciasEvaluadas FROM Dependencias_Evaluadas WHERE Desc_SiglasDependencia = @SiglasDependencia),
            @Trimestre,
            (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
        );

        INSERT INTO SeguimientoDocumentos(
            id_Documento,
            Desc_FechaCambio,
            id_Estado,
            id_Usuario,
            Desc_Comentario,
            id_Trimestre,
            id_Anio
        )
        VALUES
        (
            (SELECT ID_Documento FROM Documento WHERE Desc_TituloDocumento = @TituloDocumento),
            @FechaCreacion,
            (SELECT ID_EstadosSemaforo FROM EstadosSemaforo WHERE Desc_EstadoSemaforo = @Estado),
            (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
            )),
            @ComentarioSeguimiento,
            @Trimestre,
            (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
        );
    END
