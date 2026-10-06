export interface Disponibilidad {
    id_disponibilidad: number;
    id_perfil: number;
    fecha_inicio: Date;
    fecha_fin: Date;
    estado: 'disponible' | 'bloqueado';
    motivo: string | null;
}