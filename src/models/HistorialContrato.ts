export interface HistorialContrato {
    id_historial: number;
    id_contrato: number;
    id_usuario: number | null;
    estado_anterior: string | null;
    estado_nuevo: string;
    observacion: string | null;
    fecha_cambio: Date;
}