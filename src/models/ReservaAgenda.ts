export interface ReservaAgenda {
    id_reserva: number;
    id_contrato: number;
    fecha_inicio: Date;
    fecha_fin: Date;
    estado: 'reservada' | 'cancelada' | 'completada';
    fecha_creacion: Date;
}