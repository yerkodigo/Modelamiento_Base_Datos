-- EFT SEMANA 9 - MODELAMIENTO DE BASES DE DATOS
-- CASO: ASOCIACION NACIONAL DE FUTBOL PROFESIONAL (ANFP)
-- Conexion: PRY2204_S9

-- ELIMINACION DE SECUENCIAS Y TABLAS ANTES DE CREARLAS
drop sequence seq_club_futbol;

drop table dominio_idioma cascade constraints;
drop table historial_club cascade constraints;
drop table personal_planta cascade constraints;
drop table jugador cascade constraints;
drop table trabajador cascade constraints;
drop table comuna cascade constraints;
drop table idioma cascade constraints;
drop table escuela_futbol cascade constraints;
drop table club_futbol cascade constraints;
drop table asociacion cascade constraints;
drop table nacionalidad cascade constraints;
drop table region cascade constraints;


-- CREACION DE TABLAS
-- Primero las tablas que no tienen claves foraneas.

create table REGION (
    id_region number(2) not null,
    nombre varchar2(40) not null
);
alter table REGION add constraint REGION_PK primary key (id_region);

-- La clave primaria de la tabla NACIONALIDAD debe ser IDENTITY
-- comenzar en 210 e incrementarse de 2 en 2.
create table NACIONALIDAD (
    id_nacion number(3) generated always as identity (start with 210 increment by 2) not null,
    descripcion varchar2(30) not null
);
alter table NACIONALIDAD add constraint NACIONALIDAD_PK primary key (id_nacion);

create table ASOCIACION (
    id_asociacion number(3) not null,
    nombre_asociacion varchar2(50) not null,
    fecha_creacion date not null,
    tipo_asociacion char(1) not null
);
alter table ASOCIACION add constraint ASOCIACION_PK primary key (id_asociacion);

-- tipo_club dejo por defecto 'Profesional'
create table CLUB_FUTBOL (
    id_club number(4) not null,
    nombre_club varchar2(40) not null,
    patrimonio number(12) not null,
    ubicacion_calle varchar2(60) not null,
    tipo_club varchar2(15) default 'Profesional' not null
);
alter table CLUB_FUTBOL add constraint CLUB_FUTBOL_PK primary key (id_club);
-- El codigo de la tabla CLUB_FUTBOL debe generarse con secuencia que empiece 703 y se incremente de 4 en 4.
create sequence seq_club_futbol start with 703 increment by 4 maxvalue 9999 nocache nocycle;
alter table CLUB_FUTBOL modify (id_club default seq_club_futbol.nextval);

create table ESCUELA_FUTBOL (
    id_escuela number(4) not null,
    nombre_escuela varchar2(40) not null,
    capacidad number(4) not null,
    fecha_fundacion date not null
);
alter table ESCUELA_FUTBOL add constraint ESCUELA_FUTBOL_PK primary key (id_escuela);

create table IDIOMA (
    id_idioma number(3) not null,
    nombre_idioma varchar2(30) not null
);
alter table IDIOMA add constraint IDIOMA_PK primary key (id_idioma);

-- tablas con foraneas

create table COMUNA (
    id_comuna number(3) not null,
    REGION_id_region number(2) not null,
    nombre varchar2(30) not null
);
alter table COMUNA add constraint COMUNA_PK primary key (id_comuna);
alter table COMUNA add constraint COMUNA_REGION_FK foreign key (REGION_id_region) references region (id_region);

-- TRABAJADOR es el supertipo. tipo_trabajador indica a cual subtipo pertenece
-- J jugador y P personal de planta.
create table TRABAJADOR (
    num_inscripcion number(9) not null,
    rut number(8) not null,
    dv char(1) not null,
    pnombre varchar2(20) not null,
    snombre varchar2(20),
    apaterno varchar2(20) not null,
    amaterno varchar2(20) not null,
    sueldo_base number(10) not null,
    fecha_nacimiento date not null,
    genero char(1) not null,
    estado_civil varchar2(15) not null,
    email varchar2(60),
    fono_movil varchar2(15) not null,
    direccion varchar2(60) not null,
    tipo_trabajador char(1) not null,
    COMUNA_id_comuna number(3) not null,
    NACIONALIDAD_id_nacion number(3) not null
);
alter table TRABAJADOR add constraint TRABAJADOR_PK primary key (num_inscripcion);
alter table TRABAJADOR add constraint TRABAJADOR_COMUNA_FK foreign key (COMUNA_id_comuna) references comuna (id_comuna);
alter table TRABAJADOR add constraint TRABAJADOR_NACIONALIDAD_FK foreign key (NACIONALIDAD_id_nacion) references nacionalidad (id_nacion);

-- JUGADOR como subtipo de Trabajador
create table JUGADOR (
    num_inscripcion number(9) not null,
    puesto varchar2(20) not null,
    total_premios number(12) default 0 not null,
    anio_egreso_amateur number(4),
    ASOCIACION_id_asociacion number(3) not null,
    ESCUELA_FUTBOL_id_escuela number(4)
);
alter table JUGADOR add constraint JUGADOR_PK primary key (num_inscripcion);
alter table JUGADOR add constraint JUGADOR_TRABAJADOR_FK foreign key (num_inscripcion) references trabajador (num_inscripcion);
alter table JUGADOR add constraint JUGADOR_ASOCIACION_FK foreign key (ASOCIACION_id_asociacion) references asociacion (id_asociacion);
alter table JUGADOR add constraint JUGADOR_ESCUELA_FUTBOL_FK foreign key (ESCUELA_FUTBOL_id_escuela) references escuela_futbol (id_escuela);

-- PERSONAL_PLANTA como subtipo de trabajador
create table PERSONAL_PLANTA (
    num_inscripcion number(9) not null,
    horas_trabajadas number(3),
    valor_hora_extra number(8),
    CLUB_FUTBOL_id_club number(4) not null
);
alter table PERSONAL_PLANTA add constraint PERSONAL_PLANTA_PK primary key (num_inscripcion);
alter table PERSONAL_PLANTA add constraint PERSONAL_PLANTA_TRABAJADOR_FK foreign key (num_inscripcion) references trabajador (num_inscripcion);
alter table PERSONAL_PLANTA add constraint PERSONAL_PLANTA_CLUB_FUTBOL_FK foreign key (CLUB_FUTBOL_id_club) references club_futbol (id_club);

create table HISTORIAL_CLUB (
    fecha_incorporacion date not null,
    fecha_fin_contrato date,
    CLUB_FUTBOL_id_club number(4) not null,
    JUGADOR_num_inscripcion number(9) not null
);
alter table HISTORIAL_CLUB add constraint HISTORIAL_CLUB_PK primary key (CLUB_FUTBOL_id_club, JUGADOR_num_inscripcion, fecha_incorporacion);
alter table HISTORIAL_CLUB add constraint HISTORIAL_CLUB_CLUB_FUTBOL_FK foreign key (CLUB_FUTBOL_id_club) references club_futbol (id_club);
alter table HISTORIAL_CLUB add constraint HISTORIAL_CLUB_JUGADOR_FK foreign key (JUGADOR_num_inscripcion) references jugador (num_inscripcion);


create table DOMINIO_IDIOMA (
    nivel varchar2(15) not null,
    IDIOMA_id_idioma number(3) not null,
    JUGADOR_num_inscripcion number(9) not null
);
alter table DOMINIO_IDIOMA add constraint DOMINIO_IDIOMA_PK primary key (IDIOMA_id_idioma, JUGADOR_num_inscripcion);
alter table DOMINIO_IDIOMA add constraint DOMINIO_IDIOMA_IDIOMA_FK foreign key (IDIOMA_id_idioma) references idioma (id_idioma);
alter table DOMINIO_IDIOMA add constraint DOMINIO_IDIOMA_JUGADOR_FK foreign key (JUGADOR_num_inscripcion) references jugador (num_inscripcion);


-- MODIFICACIONES DEL MODELO

-- El nombre del club registrado en la tabla CLUB_FUTBOL debe ser unico.
alter table CLUB_FUTBOL add constraint CLUB_FUTBOL_NOMBRE_UN unique (nombre_club);

-- El tipo de club solo puede ser Profesional o Amateur.
alter table CLUB_FUTBOL add constraint CLUB_FUTBOL_TIPO_CK check (tipo_club in ('Profesional','Amateur'));

-- La fecha de creacion registrada en la tabla ASOCIACION debe ser igual o posterior
-- al 31 de diciembre de 1980.
alter table ASOCIACION add constraint ASOCIACION_FECHA_CK check (fecha_creacion >= to_date('31-12-1980', 'DD-MM-YYYY'));

-- El tipo de asociacion solo puede ser profesional (P) o amateur (A).
alter table ASOCIACION add constraint ASOCIACION_TIPO_CK check (tipo_asociacion in ('P','A'));

-- El RUT identifica a una persona, por lo que no se puede repetir entre trabajadores.
alter table TRABAJADOR add constraint TRABAJADOR_RUT_UN unique (rut);

-- El email es opcional, pero en caso de registrarse no se puede repetir.
alter table TRABAJADOR add constraint TRABAJADOR_EMAIL_UN unique (email);

-- El digito verificador debe estar en el siguiente listado: 0,1,2,3,4,5,6,7,8,9,'K'.
alter table TRABAJADOR add constraint TRABAJADOR_DV_CK check (dv in ('0','1','2','3','4','5','6','7','8','9','K'));

-- El genero se registra como M o F, igual que en el formulario de inscripcion.
alter table TRABAJADOR add constraint TRABAJADOR_GENERO_CK check (genero in ('M','F'));

-- Estados civiles permitidos.
alter table TRABAJADOR add constraint TRABAJADOR_ESTADO_CIVIL_CK check (estado_civil in ('Soltero','Casado','Viudo','Divorciado'));

-- El tipo de trabajador indica el subtipo: J (jugador) o P (personal de planta).
alter table TRABAJADOR add constraint TRABAJADOR_TIPO_CK check (tipo_trabajador in ('J','P'));

-- El fin de contrato no puede ser anterior a la incorporacion al club.
alter table HISTORIAL_CLUB add constraint HISTORIAL_CLUB_FECHAS_CK check (fecha_fin_contrato >= fecha_incorporacion);

-- Niveles de dominio de idioma permitidos.
alter table DOMINIO_IDIOMA add constraint DOMINIO_IDIOMA_NIVEL_CK check (nivel in ('Basico','Intermedio','Avanzado'));


-- POBLAMIENTO DEL MODELO

-- REGION
-- Agregue regiones 8 y 16 que no aparecian pero las comunas las referenciaban
insert into region (id_region, nombre) values (1, 'ARICA Y PARINACOTA Y TARAPACA');
insert into region (id_region, nombre) values (2, 'ANTOFAGASTA');
insert into region (id_region, nombre) values (3, 'ATACAMA Y COQUIMBO');
insert into region (id_region, nombre) values (5, 'VALPARAISO');
insert into region (id_region, nombre) values (8, 'BIOBIO');
insert into region (id_region, nombre) values (13, 'METROPOLITANA');
insert into region (id_region, nombre) values (16, 'ÑUBLE');

-- COMUNA
insert into comuna (id_comuna, REGION_id_region, nombre) values (101, 13, 'Santiago');
insert into comuna (id_comuna, REGION_id_region, nombre) values (102, 5, 'Valparaíso');
insert into comuna (id_comuna, REGION_id_region, nombre) values (103, 8, 'Concepción');
insert into comuna (id_comuna, REGION_id_region, nombre) values (104, 2, 'Antofagasta');
insert into comuna (id_comuna, REGION_id_region, nombre) values (105, 16, 'Chillán');

-- ASOCIACION
insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (25, 'Asociación de Fútbol de Santiago', to_date('15-05-2001', 'DD-MM-YYYY'), 'P');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (26, 'Asociación Nacional de Fútbol Amateur', to_date('10-03-1998', 'DD-MM-YYYY'), 'A');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (27, 'Asociación de Fútbol de Valparaíso', to_date('21-07-1987', 'DD-MM-YYYY'), 'P');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (28, 'Asociación de Fútbol de Concepción', to_date('30-11-1995', 'DD-MM-YYYY'), 'A');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (29, 'Asociación de Fútbol de Antofagasta', to_date('25-06-2003', 'DD-MM-YYYY'), 'P');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (30, 'Asociación de Fútbol de Temuco', to_date('12-01-2010', 'DD-MM-YYYY'), 'A');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (31, 'Asociación de Fútbol de Rancagua', to_date('08-09-1999', 'DD-MM-YYYY'), 'P');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (32, 'Asociación de Fútbol de Puerto Montt', to_date('20-04-2005', 'DD-MM-YYYY'), 'A');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (33, 'Asociación de Fútbol de La Serena', to_date('14-08-2012', 'DD-MM-YYYY'), 'P');

insert into asociacion (id_asociacion, nombre_asociacion, fecha_creacion, tipo_asociacion)
values (34, 'Asociación de Fútbol de Chillán', to_date('01-12-2018', 'DD-MM-YYYY'), 'A');

-- NACIONALIDAD
-- se omiten ids
insert into nacionalidad (descripcion) values ('Chilena');
insert into nacionalidad (descripcion) values ('Argentina');
insert into nacionalidad (descripcion) values ('Peruana');
insert into nacionalidad (descripcion) values ('Boliviana');
insert into nacionalidad (descripcion) values ('Brasileña');

-- CLUB_FUTBOL
-- se omiten ids
insert into club_futbol (nombre_club, patrimonio, ubicacion_calle)
values ('Colo-Colo', 500000000, 'Av. Marathon 5300');

insert into club_futbol (nombre_club, patrimonio, ubicacion_calle)
values ('Universidad de Chile', 450000000, 'Av. El Parrón 0931');

insert into club_futbol (nombre_club, patrimonio, ubicacion_calle)
values ('Deportes Antofagasta', 180000000, 'Avenida Angamos 01606');

insert into club_futbol (nombre_club, patrimonio, ubicacion_calle)
values ('Huachipato', 220000000, 'Avenida Desiderio García 909');

insert into club_futbol (nombre_club, patrimonio, ubicacion_calle)
values ('Ñublense', 170000000, 'Avenida Pedro Aguirre Cerda 1003');

commit;


-- RECUPERACION DE DATOS

-- INFORME 1: Asociaciones de futbol profesional
-- Asociaciones de tipo profesional (P), creadas despues del año 2000,
-- ordenadas de manera descendente segun su fecha de creacion.
select
    'ID:' || id_asociacion || ' * ' || nombre_asociacion as "ASOCIACION",
    to_char(fecha_creacion, 'DD-MM-YYYY') as "CREADA",
    tipo_asociacion as "TIPO"
from asociacion
where tipo_asociacion = 'P'
    and fecha_creacion > to_date('31-12-2000', 'DD-MM-YYYY') -- despues del año 2000 = desde el 01-01-2001
order by
    fecha_creacion desc; -- se ordena por la columna fecha y no por el alias "CREADA", porque el alias es texto


-- INFORME 2: Patrimonio de clubes de futbol
-- Patrimonio en pesos y su conversion a dolares (tipo de cambio $955 por dolar).
-- Clubes cuyo nombre contenga la letra a, con patrimonio superior a $200.000.000
-- y de tipo profesional, ordenados de manera descendente segun el codigo del club.
select
    id_club as "CLUB",
    nombre_club as "NOMBRE CLUB",
    patrimonio as "PATRIMONIO EN PESOS",
    patrimonio / 955 as "PATRIMONIO EN DOLARES"
from club_futbol
where nombre_club like '%a%' -- % reemplaza cualquier cantidad de caracteres antes y despues de la a
    and patrimonio > 200000000
    and tipo_club = 'Profesional'
order by
    id_club desc;