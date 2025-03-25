CREATE PROCEDURE ActualizacionEstatusDocumento
    @TituloDocumento varchar(255),
    @NuevoEstado varchar(255),
    @FechaActualizacion varchar(255),
    @CorreoUsuario varchar(255),
    @ComentarioActualizacion varchar(255),
    @Trimestre INT,
    @Anio varchar(4)
AS
    BEGIN        
        UPDATE Documento
        SET id_EstadoActual = (SELECT ID_EstadosSemaforo FROM EstadosSemaforo
                                WHERE Desc_EstadoSemaforo = @NuevoEstado)
        WHERE Desc_TituloDocumento = @TituloDocumento;

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
            @FechaActualizacion,
            (SELECT ID_EstadosSemaforo FROM EstadosSemaforo WHERE Desc_EstadoSemaforo = @NuevoEstado),
            (SELECT ID_Usuario FROM Usuario_General WHERE id_CorreoElectronico = (
                SELECT ID_CorreoElectronico FROM Correo_Electronico WHERE Desc_Correo_Electronico = @CorreoUsuario
            )),
            @ComentarioActualizacion,
            @Trimestre,
            (SELECT ID_Anio FROM Anio WHERE Desc_Anio = @Anio)
        );
    END