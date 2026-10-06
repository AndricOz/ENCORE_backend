export interface Pago {
    id_pago: number;
    id_contrato: number;
    monto: number;
    tipo: 'anticipo' | 'abono' | 'pago_final' | 'reembolso';
    metodo_pago: 'efectivo' | 'transferencia' | 'tarjeta' | 'otro';
    referencia: string | null;
    comprobante_url: string | null;
    fecha_pago: Date;
    estado: 'pendiente' | 'confirmado' | 'rechazado' | 'reembolsado';
    observaciones: string | null;
}