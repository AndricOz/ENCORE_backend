export interface ContactoUsuario {
    id_contacto: number;
    id_usuario: number;
    nombre_contacto: string;
    telefono: string;
    relacion: string | null;
    es_principal: boolean;
}