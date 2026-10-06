
-- =====================================================
-- ENCORE
-- Agenda y contratacion para musicos de eventos
-- Base de datos: MySQL 8.0.16+
-- =====================================================

create database if not exists encore_db
    character set utf8mb4
    collate utf8mb4_unicode_ci;

use encore_db;

-- =====================================================
-- 1. USUARIOS
-- =====================================================

create table usuarios (
    id_usuario int auto_increment primary key,
    nombre varchar(100) not null,
    apellido varchar(100) not null,
    correo varchar(150) not null unique,
    telefono varchar(25),
    password_hash varchar(255) not null,
    rol enum('cliente', 'musico', 'admin')
        not null default 'cliente',
    estado enum('activo', 'inactivo', 'suspendido')
        not null default 'activo',
    fecha_registro datetime not null default current_timestamp,
    fecha_actualizacion datetime not null
        default current_timestamp on update current_timestamp
);

-- =====================================================
-- 2. PERFILES MUSICALES
-- =====================================================

create table perfiles_musicales (
    id_perfil int auto_increment primary key,
    id_usuario int not null unique,
    nombre_artistico varchar(150) not null,
    descripcion text,
    tipo enum(
        'solista', 'banda', 'grupo', 'dj',
        'mariachi', 'marimba', 'otro'
    ) not null,
    ubicacion varchar(150),
    direccion varchar(255),
    precio_base decimal(10,2),
    experiencia_anios smallint unsigned,
    foto_perfil varchar(500),
    estado enum('borrador', 'publicado', 'oculto')
        not null default 'borrador',
    fecha_creacion datetime not null default current_timestamp,

    constraint fk_perfil_usuario
        foreign key (id_usuario)
        references usuarios(id_usuario)
        on delete restrict on update cascade,

    constraint chk_perfil_precio
        check (precio_base is null or precio_base >= 0),

    index idx_perfil_tipo_estado (tipo, estado),
    index idx_perfil_ubicacion (ubicacion)
);

-- =====================================================
-- 3. GENEROS MUSICALES
-- =====================================================

create table generos_musicales (
    id_genero int auto_increment primary key,
    nombre varchar(80) not null unique,
    descripcion varchar(255)
);

-- =====================================================
-- 4. RELACION PERFILES - GENEROS
-- =====================================================

create table perfil_genero (
    id_perfil int not null,
    id_genero int not null,

    primary key (id_perfil, id_genero),

    constraint fk_pg_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete cascade on update cascade,

    constraint fk_pg_genero
        foreign key (id_genero)
        references generos_musicales(id_genero)
        on delete restrict on update cascade
);

-- =====================================================
-- 5. INTEGRANTES
-- Para registrar integrantes de una banda o grupo
-- =====================================================

create table integrantes (
    id_integrante int auto_increment primary key,
    id_perfil int not null,
    nombre varchar(150) not null,
    instrumento varchar(100),
    descripcion varchar(255),
    orden smallint unsigned default 1,

    constraint fk_integrante_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete cascade on update cascade,

    index idx_integrantes_perfil (id_perfil)
);

-- =====================================================
-- 6. GALERIA MUSICAL
-- Fotos, videos o enlaces de presentaciones
-- =====================================================

create table galeria_musical (
    id_elemento int auto_increment primary key,
    id_perfil int not null,
    tipo enum('imagen', 'video', 'audio', 'enlace')
        not null,
    url varchar(500) not null,
    descripcion varchar(255),
    fecha_creacion datetime not null default current_timestamp,

    constraint fk_galeria_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete cascade on update cascade
);

-- =====================================================
-- 7. SERVICIOS MUSICALES
-- Diferentes paquetes ofrecidos por cada perfil
-- =====================================================

create table servicios_musicales (
    id_servicio int auto_increment primary key,
    id_perfil int not null,
    nombre varchar(150) not null,
    descripcion text,
    duracion_horas decimal(5,2) not null,
    precio decimal(10,2) not null,
    estado enum('activo', 'inactivo')
        not null default 'activo',

    constraint fk_servicio_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete cascade on update cascade,

    constraint chk_servicio_duracion
        check (duracion_horas > 0),

    constraint chk_servicio_precio
        check (precio >= 0),

    index idx_servicio_perfil_estado (id_perfil, estado)
);

-- =====================================================
-- 8. DISPONIBILIDAD
-- Horarios disponibles o bloqueados por el musico
-- =====================================================

create table disponibilidad (
    id_disponibilidad int auto_increment primary key,
    id_perfil int not null,
    fecha_inicio datetime not null,
    fecha_fin datetime not null,
    estado enum('disponible', 'bloqueado')
        not null default 'disponible',
    motivo varchar(255),

    constraint fk_disponibilidad_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete cascade on update cascade,

    constraint chk_disponibilidad_fechas
        check (fecha_fin > fecha_inicio),

    index idx_disponibilidad_agenda
        (id_perfil, fecha_inicio, fecha_fin)
);

-- =====================================================
-- 9. SOLICITUDES DE EVENTOS
-- =====================================================

create table solicitudes_eventos (
    id_solicitud int auto_increment primary key,
    id_cliente int not null,
    id_perfil int not null,
    id_servicio int null,
    nombre_evento varchar(150) not null,
    tipo_evento varchar(100) not null,
    fecha_inicio datetime not null,
    fecha_fin datetime not null,
    ubicacion varchar(255) not null,
    descripcion text,
    presupuesto decimal(10,2),
    estado enum(
        'pendiente', 'en_negociacion', 'aceptada',
        'rechazada', 'cancelada', 'finalizada'
    ) not null default 'pendiente',
    fecha_solicitud datetime not null default current_timestamp,

    constraint fk_solicitud_cliente
        foreign key (id_cliente)
        references usuarios(id_usuario)
        on delete restrict on update cascade,

    constraint fk_solicitud_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete restrict on update cascade,

    constraint fk_solicitud_servicio
        foreign key (id_servicio)
        references servicios_musicales(id_servicio)
        on delete set null on update cascade,

    constraint chk_solicitud_fechas
        check (fecha_fin > fecha_inicio),

    constraint chk_solicitud_presupuesto
        check (presupuesto is null or presupuesto >= 0),

    index idx_solicitud_cliente (id_cliente),
    index idx_solicitud_perfil_estado (id_perfil, estado),
    index idx_solicitud_fecha (fecha_inicio)
);

-- =====================================================
-- 10. COTIZACIONES
-- Un mismo evento puede tener varias propuestas
-- =====================================================

create table cotizaciones (
    id_cotizacion int auto_increment primary key,
    id_solicitud int not null,
    numero_version int unsigned not null default 1,
    precio_total decimal(10,2) not null,
    anticipo_requerido decimal(10,2) not null default 0,
    condiciones text,
    fecha_cotizacion datetime not null default current_timestamp,
    fecha_vencimiento datetime,
    estado enum(
        'pendiente', 'aceptada', 'rechazada',
        'vencida', 'cancelada', 'reemplazada'
    ) not null default 'pendiente',

    constraint fk_cotizacion_solicitud
        foreign key (id_solicitud)
        references solicitudes_eventos(id_solicitud)
        on delete restrict on update cascade,

    constraint uq_cotizacion_version
        unique (id_solicitud, numero_version),

    constraint chk_cotizacion_precio
        check (precio_total >= 0),

    constraint chk_cotizacion_anticipo
        check (
            anticipo_requerido >= 0
            and anticipo_requerido <= precio_total
        ),

    index idx_cotizacion_estado (estado)
);

-- =====================================================
-- 11. CONTRATOS
-- Guarda las condiciones aceptadas
-- =====================================================

create table contratos (
    id_contrato int auto_increment primary key,
    id_cotizacion int not null unique,
    fecha_contrato datetime not null default current_timestamp,
    monto_total decimal(10,2) not null,
    anticipo_acordado decimal(10,2) not null default 0,
    condiciones_acordadas text,
    estado enum(
        'pendiente', 'confirmado', 'en_proceso',
        'completado', 'cancelado'
    ) not null default 'pendiente',
    fecha_cancelacion datetime,
    motivo_cancelacion varchar(500),

    constraint fk_contrato_cotizacion
        foreign key (id_cotizacion)
        references cotizaciones(id_cotizacion)
        on delete restrict on update cascade,

    constraint chk_contrato_monto
        check (monto_total >= 0),

    constraint chk_contrato_anticipo
        check (
            anticipo_acordado >= 0
            and anticipo_acordado <= monto_total
        ),

    index idx_contrato_estado (estado)
);

-- =====================================================
-- 12. RESERVAS DE AGENDA
-- Relaciona los contratos con sus horarios reservados
-- =====================================================

create table reservas_agenda (
    id_reserva int auto_increment primary key,
    id_contrato int not null unique,
    fecha_inicio datetime not null,
    fecha_fin datetime not null,
    estado enum('reservada', 'cancelada', 'completada')
        not null default 'reservada',
    fecha_creacion datetime not null default current_timestamp,

    constraint fk_reserva_contrato
        foreign key (id_contrato)
        references contratos(id_contrato)
        on delete restrict on update cascade,

    constraint chk_reserva_fechas
        check (fecha_fin > fecha_inicio),

    index idx_reserva_fechas (fecha_inicio, fecha_fin),
    index idx_reserva_estado (estado)
);

-- =====================================================
-- 13. PAGOS
-- Anticipos, abonos y liquidaciones
-- =====================================================

create table pagos (
    id_pago int auto_increment primary key,
    id_contrato int not null,
    monto decimal(10,2) not null,
    tipo enum('anticipo', 'abono', 'pago_final', 'reembolso')
        not null,
    metodo_pago enum(
        'efectivo', 'transferencia', 'tarjeta', 'otro'
    ) not null default 'otro',
    referencia varchar(150),
    comprobante_url varchar(500),
    fecha_pago datetime not null default current_timestamp,
    estado enum(
        'pendiente', 'confirmado', 'rechazado', 'reembolsado'
    ) not null default 'pendiente',
    observaciones varchar(500),

    constraint fk_pago_contrato
        foreign key (id_contrato)
        references contratos(id_contrato)
        on delete restrict on update cascade,

    constraint chk_pago_monto
        check (monto > 0),

    index idx_pago_contrato_estado (id_contrato, estado),
    index idx_pago_fecha (fecha_pago)
);

-- =====================================================
-- 14. FAVORITOS
-- Los clientes guardan perfiles musicales
-- =====================================================

create table favoritos (
    id_cliente int not null,
    id_perfil int not null,
    fecha_agregado datetime not null default current_timestamp,

    primary key (id_cliente, id_perfil),

    constraint fk_favorito_cliente
        foreign key (id_cliente)
        references usuarios(id_usuario)
        on delete cascade on update cascade,

    constraint fk_favorito_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete cascade on update cascade
);

-- =====================================================
-- 15. RESENAS
-- Solo deben permitirse reseñas de contratos validos
-- =====================================================

create table resenas (
    id_resena int auto_increment primary key,
    id_contrato int not null unique,
    id_cliente int not null,
    id_perfil int not null,
    calificacion tinyint unsigned not null,
    comentario text,
    fecha_resena datetime not null default current_timestamp,
    estado enum('publicada', 'oculta')
        not null default 'publicada',

    constraint fk_resena_contrato
        foreign key (id_contrato)
        references contratos(id_contrato)
        on delete restrict on update cascade,

    constraint fk_resena_cliente
        foreign key (id_cliente)
        references usuarios(id_usuario)
        on delete restrict on update cascade,

    constraint fk_resena_perfil
        foreign key (id_perfil)
        references perfiles_musicales(id_perfil)
        on delete restrict on update cascade,

    constraint chk_resena_calificacion
        check (calificacion between 1 and 5),

    index idx_resena_perfil (id_perfil, estado)
);

-- =====================================================
-- 16. NOTIFICACIONES
-- =====================================================

create table notificaciones (
    id_notificacion int auto_increment primary key,
    id_usuario int not null,
    titulo varchar(150) not null,
    mensaje text not null,
    tipo varchar(50) not null,
    enlace varchar(500),
    leida boolean not null default false,
    fecha_creacion datetime not null default current_timestamp,
    fecha_lectura datetime,

    constraint fk_notificacion_usuario
        foreign key (id_usuario)
        references usuarios(id_usuario)
        on delete cascade on update cascade,

    index idx_notificacion_usuario
        (id_usuario, leida, fecha_creacion)
);

-- =====================================================
-- 17. REPORTES
-- Reportes de perfiles, usuarios o contenido
-- =====================================================

create table reportes (
    id_reporte int auto_increment primary key,
    id_usuario_reporta int not null,
    id_usuario_reportado int null,
    id_perfil_reportado int null,
    motivo varchar(150) not null,
    descripcion text,
    estado enum(
        'pendiente', 'en_revision', 'resuelto', 'descartado'
    ) not null default 'pendiente',
    fecha_reporte datetime not null default current_timestamp,
    fecha_resolucion datetime,
    id_administrador int null,
    resolucion text,

    constraint fk_reporte_reporta
        foreign key (id_usuario_reporta)
        references usuarios(id_usuario)
        on delete restrict on update cascade,

    constraint fk_reporte_reportado
        foreign key (id_usuario_reportado)
        references usuarios(id_usuario)
        on delete set null on update cascade,

    constraint fk_reporte_perfil
        foreign key (id_perfil_reportado)
        references perfiles_musicales(id_perfil)
        on delete set null on update cascade,

    constraint fk_reporte_admin
        foreign key (id_administrador)
        references usuarios(id_usuario)
        on delete set null on update cascade,

    index idx_reporte_estado (estado, fecha_reporte)
);

-- =====================================================
-- 18. HISTORIAL DE ESTADOS DE CONTRATOS
-- Registra los cambios importantes de estado
-- =====================================================

create table historial_contratos (
    id_historial int auto_increment primary key,
    id_contrato int not null,
    id_usuario int null,
    estado_anterior varchar(30),
    estado_nuevo varchar(30) not null,
    observacion varchar(500),
    fecha_cambio datetime not null default current_timestamp,

    constraint fk_historial_contrato
        foreign key (id_contrato)
        references contratos(id_contrato)
        on delete restrict on update cascade,

    constraint fk_historial_usuario
        foreign key (id_usuario)
        references usuarios(id_usuario)
        on delete set null on update cascade,

    index idx_historial_contrato (id_contrato, fecha_cambio)
);

-- =====================================================
-- 19. HISTORIAL DE COTIZACIONES
-- Registro de cambios en propuestas económicas
-- =====================================================

create table historial_cotizaciones (
    id_historial int auto_increment primary key,
    id_cotizacion int not null,
    id_usuario int null,
    accion varchar(100) not null,
    detalle text,
    fecha_cambio datetime not null default current_timestamp,

    constraint fk_historial_cotizacion
        foreign key (id_cotizacion)
        references cotizaciones(id_cotizacion)
        on delete restrict on update cascade,

    constraint fk_historial_cot_usuario
        foreign key (id_usuario)
        references usuarios(id_usuario)
        on delete set null on update cascade,

    index idx_historial_cotizacion
        (id_cotizacion, fecha_cambio)
);

-- =====================================================
-- 20. DATOS DE CONTACTO ADICIONALES
-- Direcciones o contactos alternativos del cliente
-- =====================================================

create table contactos_usuarios (
    id_contacto int auto_increment primary key,
    id_usuario int not null,
    nombre_contacto varchar(150) not null,
    telefono varchar(25) not null,
    relacion varchar(80),
    es_principal boolean not null default false,

    constraint fk_contacto_usuario
        foreign key (id_usuario)
        references usuarios(id_usuario)
        on delete cascade on update cascade,

    index idx_contactos_usuario (id_usuario)
);
