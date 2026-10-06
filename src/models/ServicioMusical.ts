export interface ServicioMusical {
    id_servicio: number;
    id_perfil: number;
    nombre: string;
    descripcion: string | null;
    duracion_horas: number;
    precio: number;
    estado: 'activo' | 'inactivo';
}