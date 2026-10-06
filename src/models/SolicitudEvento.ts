export interface SolicitudEvento {
    id_solicitud: number;
    id_cliente: number;
    id_perfil: number;
    id_servicio: number | null;
    nombre_evento: string;
    tipo_evento: string;
    fecha_inicio: Date;
    fecha_fin: Date;
    ubicacion: string;
    descripcion: string | null;
    presupuesto: number | null;
    estado: 'pendiente' | 'en_negociacion' | 'aceptada' | 'rechazada' | 'cancelada' | 'finalizada';
    fecha_solicitud: Date;
}