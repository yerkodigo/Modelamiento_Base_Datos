-- ELIMINACION DE TABLAS ANTES DE CREARLAS
drop table REGION cascade constraints;
drop table ESPECIALIDAD cascade constraints;
drop table BANCO cascade constraints;
drop table DIAGNOSTICO cascade constraints;
drop table TIPO_RECETA cascade constraints;
drop table TIPO_MEDICAMENTO cascade constraints;
drop table VIA_ADMINISTRACION cascade constraints;
drop table DIGITADOR cascade constraints;
drop table CIUDAD cascade constraints;
drop table COMUNA cascade constraints;
drop table MEDICO cascade constraints;
drop table PACIENTE cascade constraints;
drop table MEDICAMENTO cascade constraints;
drop table RECETA cascade constraints;
drop table DOSIS cascade constraints;
drop table PAGO cascade constraints;


-- CREACION DE TABLAS
create table REGION (
    id_region number(4) not null,
    nombre varchar2(30) not null
);
alter table region add constraint region_pk primary key (id_region);

create table ESPECIALIDAD (
    id_especialidad number(4) generated always as identity not null,
    nombre varchar2(25) not null
);
alter table ESPECIALIDAD add constraint especialidad_pk primary key (id_especialidad);

create table BANCO (
 cod_banco number(2) not null,
 nombre varchar2(25) not null
);
alter table banco add constraint banco_pk primary key (cod_banco);

create table DIAGNOSTICO (
    cod_diagnostico number(3) not null,
    nombre varchar2(25) not null
);
alter table diagnostico add constraint diagnostico_pk primary key (cod_diagnostico);

create table TIPO_RECETA (
    id_tipo_receta number(3) not null,
    nombre varchar2(25) not NULL
);
alter table tipo_receta add constraint tipo_receta_pk primary key (id_tipo_receta);

create table TIPO_MEDICAMENTO ( -- no esta textual pero lo normalice ya que salia como number en la foto
    id_tipo_medicamento number(3) not null,
    nombre varchar2(25) not null
);
alter table tipo_medicamento add constraint tipo_medicamento_pk primary key (id_tipo_medicamento);

create table VIA_ADMINISTRACION ( -- no esta textual pero lo normalice ya que salia como number en la foto
    id_via_administracion number(3) not null,
    nombre varchar2(25) not null
);
alter table via_administracion add constraint via_administracion_pk primary key (id_via_administracion);

create table DIGITADOR (
    id_digitador number(20) not null,
    dv_digitador char(1) not null,
    pnombre varchar2(25) not null,
    papellido varchar2(25) not null
);
alter table digitador add constraint digitador_pk primary key (id_digitador);
alter table digitador add constraint digitador_dv_ck check (dv_digitador in ('0','1','2','3','4','5','6','7','8','9','K'));

create table CIUDAD (
    id_ciudad number(5) not null,
    nombre varchar2(25) not null,
    id_region number(4) not null
);
alter table ciudad add constraint ciudad_pk primary key (id_ciudad);
alter table ciudad add constraint ciudad_region_fk foreign key (id_region) references region (id_region);

create table COMUNA (
    id_comuna number(5) generated always as identity (start with 1101 increment by 1) not null,
    nombre varchar2(25) not null,
    id_ciudad number(5) not null
);
alter table comuna add constraint comuna_pk primary key (id_comuna);
alter table comuna add constraint comuna_ciudad_fk foreign key (id_ciudad) references ciudad (id_ciudad);

create table MEDICO (
    rut_med number(8) not null,
    dv_med char(1) not null,
    pnombre varchar2(25) not null,
    snombre varchar2(25),
    papellido varchar2(25) not null,
    sapellido varchar2(25),
    id_especialidad number(4) not null,
    telefono number(11) not null
);
alter table medico add constraint medico_pk primary key (rut_med);
alter table medico add constraint medico_dv_ck check (dv_med in ('0','1','2','3','4','5','6','7','8','9','K'));
alter table medico add constraint medico_telefono_uk unique (telefono);
alter table medico add constraint medico_especialidad_fk foreign key (id_especialidad) references especialidad (id_especialidad);

create table PACIENTE (
    rut_pac varchar2(25) not null,
    dv_pac char(1) not null,
    pnombre varchar2(25) not null,
    snombre varchar2(25),
    edad date not null,
    telefono number(11) not null,
    calle varchar2(25) not null,
    numeracion number(5) not null,
    id_comuna number(5) not null
);
alter table paciente add constraint paciente_pk primary key (rut_pac);
alter table paciente add constraint paciente_dv_ck check (dv_pac in ('0','1','2','3','4','5','6','7','8','9','K'));
alter table paciente add constraint paciente_comuna_fk foreign key (id_comuna) references comuna (id_comuna);

create table MEDICAMENTO (
    cod_medicamento number(7) not null,
    nombre varchar2(25) not null,
    tipo_medicamento number(3) not null,
    via_administra number(3) not null,
    dosis_recomendada varchar2(25) not null,
    stock number(6) not null
);
alter table medicamento add constraint medicamento_pk primary key (cod_medicamento);
alter table medicamento add constraint medicamento_tipo_medicamento_fk foreign key (tipo_medicamento) references tipo_medicamento (id_tipo_medicamento);
alter table medicamento add constraint medicamento_via_administracion_fk foreign key (via_administra) references via_administracion (id_via_administracion);

create table RECETA (
    cod_receta number (7) not null,
    observaciones varchar2(500),
    fecha_emision date not null,
    fecha_vencimiento date,
    id_digitador number(20) not null,
    pac_rut varchar2(25) not null,
    id_diagnostico number(3) not null,
    med_rut number(8) not null,
    id_tipo_receta number(3) not null
);
alter table receta add constraint receta_pk primary key (cod_receta);
alter table receta add constraint receta_diagnostico_fk foreign key (id_diagnostico) references diagnostico (cod_diagnostico);
alter table receta add constraint receta_medico_fk foreign key (med_rut) references medico (rut_med);
alter table receta add constraint receta_paciente_fk foreign key (pac_rut) references paciente (rut_pac);
alter table receta add constraint receta_digitador_fk foreign key (id_digitador) references digitador (id_digitador);
alter table receta add constraint receta_tipo_receta_fk foreign key (id_tipo_receta) references tipo_receta (id_tipo_receta);

create table DOSIS (
    id_medicamento number(7) not null,
    id_receta number(7) not null,
    descripcion_dosis varchar2(25) not null
);
alter table dosis add constraint dosis_pk primary key (id_medicamento, id_receta);
alter table dosis add constraint dosis_medicamento_fk foreign key (id_medicamento) references medicamento (cod_medicamento);
alter table dosis add constraint dosis_receta_fk foreign key (id_receta) references receta (cod_receta);

create table PAGO (
    cod_boleta number(6) not null,
    id_receta number(7) not null,
    fecha_pago date not null,
    monto_total number(8) not null,
    metodo_pago varchar2(15) not null,
    id_banco number(2)
);
alter table pago add constraint boleta_pk primary key (cod_boleta);
alter table pago add constraint pago_banco_fk foreign key (id_banco) references banco (cod_banco);
alter table pago add constraint pago_receta_fk foreign key (id_receta) references receta (cod_receta);



--• Agregar el precio unitario de cada medicamento.
alter table medicamento add precio_unitario number(7) not null;

--• Se conoce que el precio de un medicamento oscila entre los $1.000 y los $2.000.000 de pesos. 
alter table medicamento add constraint medicamento_precio_ck check (precio_unitario between 1000 and 2000000);

--• Se definió que los métodos de pagos pueden ser: EFECTIVO, TARJETA, TRANSFERENCIA. Por lo tanto, debes agregar esta restricción.
alter table pago add constraint pago_metodo_ck check (metodo_pago in ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA'));

--• Por último, para efectos de optimizar el acceso a los datos del paciente, se debe eliminar la columna edad, y en su reemplazo agregar la fecha de nacimiento del paciente.
alter table paciente drop column edad;
alter table paciente add fecha_nacimiento date not null;

