export interface Reporte {
    id_reporte: number;
    id_usuario_reporta: number;
    id_usuario_reportado: number | null;
    id_perfil_reportado: number | null;
    motivo: string;
    descripcion: string | null;
    estado: 'pendiente' | 'en_revision' | 'resuelto' | 'descartado';
    fecha_reporte: Date;
    fecha_resolucion: Date | null;
    id_administrador: number | null;
    resolucion: string | null;
}