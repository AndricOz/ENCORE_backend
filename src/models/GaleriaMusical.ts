export interface GaleriaMusical {
    id_elemento: number;
    id_perfil: number;
    tipo: 'imagen' | 'video' | 'audio' | 'enlace';
    url: string;
    descripcion: string | null;
    fecha_creacion: Date;
}