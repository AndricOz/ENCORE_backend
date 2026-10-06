export interface Integrante {
    id_integrante: number;
    id_perfil: number;
    nombre: string;
    instrumento: string | null;
    descripcion: string | null;
    orden: number | null;
}