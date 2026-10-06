export interface Resena {
    id_resena: number;
    id_contrato: number;
    id_cliente: number;
    id_perfil: number;
    calificacion: number;
    comentario: string | null;
    fecha_resena: Date;
    estado: 'publicada' | 'oculta';
}