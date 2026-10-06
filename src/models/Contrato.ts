export interface Contrato {
    id_contrato: number;
    id_cotizacion: number;
    fecha_contrato: Date;
    monto_total: number;
    anticipo_acordado: number;
    condiciones_acordadas: string | null;
    estado: 'pendiente' | 'confirmado' | 'en_proceso' | 'completado' | 'cancelado';
    fecha_cancelacion: Date | null;
    motivo_cancelacion: string | null;
}