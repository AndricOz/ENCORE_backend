export interface Cotizacion {
    id_cotizacion: number;
    id_solicitud: number;
    numero_version: number;
    precio_total: number;
    anticipo_requerido: number;
    condiciones: string | null;
    fecha_cotizacion: Date;
    fecha_vencimiento: Date | null;
    estado: 'pendiente' | 'aceptada' | 'rechazada' | 'vencida' | 'cancelada' | 'reemplazada';
}