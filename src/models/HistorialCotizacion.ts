export interface HistorialCotizacion {
    id_historial: number;
    id_cotizacion: number;
    id_usuario: number | null;
    accion: string;
    detalle: string | null;
    fecha_cambio: Date;
}