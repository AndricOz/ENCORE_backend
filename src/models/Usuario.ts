export interface Usuario {
    id_usuario: number;
    nombre: string;
    apellido: string;
    correo: string;
    telefono: string | null;
    password_hash: string;
    rol: 'cliente' | 'musico' | 'admin';
    estado: 'activo' | 'inactivo' | 'suspendido';
    fecha_registro: Date;
    fecha_actualizacion: Date;
}