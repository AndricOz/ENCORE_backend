export interface Notificacion {
    id_notificacion: number;
    id_usuario: number;
    titulo: string;
    mensaje: string;
    tipo: string;
    enlace: string | null;
    leida: boolean;
    fecha_creacion: Date;
    fecha_lectura: Date | null;
}