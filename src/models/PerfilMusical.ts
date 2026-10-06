export interface PerfilMusical {
    id_perfil: number;
    id_usuario: number;
    nombre_artistico: string;
    descripcion: string | null;
    tipo: 'solista' | 'banda' | 'grupo' | 'dj' | 'mariachi' | 'marimba' | 'otro';
    ubicacion: string | null;
    direccion: string | null;
    precio_base: number | null;
    experiencia_anios: number | null;
    foto_perfil: string | null;
    estado: 'borrador' | 'publicado' | 'oculto';
    fecha_creacion: Date;
}