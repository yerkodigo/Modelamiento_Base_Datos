-- ELIMINACION DE SECUENCIAS Y TABLAS ANTES DE CREARLAS
drop sequence seq_ciudad;
drop sequence seq_servicio;

drop table detalle_servicio cascade constraints;
drop table mantencion cascade constraints;
drop table automovil cascade constraints;
drop table estandar cascade constraints;
drop table premium cascade constraints;
drop table cliente cascade constraints;
drop table modelo cascade constraints;
drop table marca cascade constraints;
drop table tipo_automovil cascade constraints;
drop table mecanico cascade constraints;
drop table sucursal cascade constraints;
drop table servicio cascade constraints;
drop table ciudad cascade constraints;
drop table pais cascade constraints;

-- CREACION DE TABLAS

create table PAIS (
    id_pais number(3) generated always as identity (start with 9 increment by 3) not null,
    nom_pais varchar2(30) not null
);
alter table PAIS add constraint PAIS_PK primary key (id_pais);

create table CIUDAD (
    id_ciudad number(3) not null,
    nom_ciudad varchar2(30) not null,
    cod_pais number(3) not null
);
alter table CIUDAD add constraint CIUDAD_PK primary key (id_ciudad);
alter table CIUDAD add constraint CIUDAD_FK_PAIS foreign key (cod_pais) references pais (id_pais);
-- Se conocen que hay del orden de 100 ciudades donde se realizan las mantenciones.
-- Por lo tanto, para poblar la tabla CIUDAD debes usar una identificación numérica que
-- comience en 165 y que se incremente en 5 (usa objeto secuencia).
create sequence seq_ciudad start with 165 increment by 5 maxvalue 999 nocache nocycle;
alter table CIUDAD modify (id_ciudad default seq_ciudad.nextval);

create table SERVICIO (
    id_servicio number(3) not null,
    descripcion varchar2(100) not null,
    costo number(7) not null
);
alter table SERVICIO add constraint SERVICIO_PK primary key (id_servicio);
-- Por un tema de seguridad, al poblar la tabla SERVICIO, el id_servicio debe iniciar en
-- 400, y se debe incrementar en 2 (usa objeto secuencia)
create sequence seq_servicio start with 400 increment by 2 maxvalue 999 nocache nocycle;
alter table SERVICIO modify (id_servicio default seq_servicio.nextval);

create table SUCURSAL (
    id_sucursal char(3) not null,
    nom_sucursal varchar2(20) not null,
    calle varchar2(20) not null,
    num_calle number(4) not null,
    cod_ciudad number(3) not null
);
alter table SUCURSAL add constraint SUCURSAL_PK primary key (id_sucursal);
alter table SUCURSAL add constraint SUCURSAL_FK_CIUDAD foreign key (cod_ciudad) references ciudad (id_ciudad);

create table MECANICO (
    cod_mecanico number(5) generated always as identity (start with 460 increment by 7) not null,
    pnombre varchar2(20) not null,
    snombre varchar2(20) not null,
    apaterno varchar2(20) not null,
    amaterno varchar2(20) not null,
    bono_jefatura number(10),
    sueldo number(10) not null,
    monto_impuestos number(10) not null,
    cod_supervisor number(5)
);
alter table MECANICO add constraint MECANICO_PK primary key (cod_mecanico);
alter table MECANICO add constraint MECANICO_FK_MECANICO foreign key (cod_supervisor) references mecanico (cod_mecanico);

create table MARCA (
    id_marca number(2) not null,
    descripcion varchar2(20) not null
);
alter table MARCA add constraint MARCA_PK primary key (id_marca);

create table MODELO (
    id_modelo number(5) not null,
    marca_id number(2) not null,
    descripcion varchar2(20) not null
);
alter table MODELO add constraint MODELO_PK primary key (id_modelo, marca_id);
alter table MODELO add constraint MODELO_FK_MARCA foreign key (marca_id) references marca (id_marca);

create table TIPO_AUTOMOVIL (
    id_tipo char(3) not null,
    descripcion varchar2(20) not null
);
alter table TIPO_AUTOMOVIL add constraint TIPO_AUTOMOVIL_PK primary key (id_tipo);

create table CLIENTE (
    rut number(8) not null,
    dv char(1) not null,
    pnombre varchar2(20) not null,
    snombre varchar2(20),
    apaterno varchar2(20) not null,
    amaterno varchar2(20) not null,
    telefono varchar2(12),
    email varchar2(40),
    tipo_cli char(1) not null
);
alter table CLIENTE add constraint CLIENTE_PK primary key (rut);

create table ESTANDAR (
    cl_rut number(8) not null,
    puntaje_fidelidad number(10) not null
);
alter table ESTANDAR add constraint ESTANDAR_PK primary key (cl_rut);
alter table ESTANDAR add constraint ESTANDAR_FK_CLIENTE foreign key (cl_rut) references cliente (rut);

create table PREMIUM (
    cl_rut number(8) not null,
    pesos_clientes number(10) not null,
    monto_credito number(10)
);
alter table PREMIUM add constraint PREMIUM_PK primary key (cl_rut);
alter table PREMIUM add constraint PREMIUM_FK_CLIENTE foreign key (cl_rut) references cliente (rut);

create table AUTOMOVIL (
    patente char(8) not null,
    annio number(4) not null,
    cant_puertas number(1) not null,
    km number(6) not null,
    color varchar2(30) not null,
    cod_tipo_auto char(3) not null,
    cod_modelo number(5) not null,
    cod_marca number(2) not null,
    cl_rut number(8) not null
);
alter table AUTOMOVIL add constraint AUTOMOVIL_PK primary key (patente);
alter table AUTOMOVIL add constraint AUTOMOVIL_FK_CLIENTE foreign key (cl_rut) references cliente (rut);
alter table AUTOMOVIL add constraint AUTOMOVIL_FK_MODELO foreign key (cod_modelo, cod_marca) references modelo (id_modelo, marca_id);
alter table AUTOMOVIL add constraint AUTOMOVIL_FK_TIPO foreign key (cod_tipo_auto) references tipo_automovil (id_tipo);

create table MANTENCION (
    num_mantencion number(4) not null,
    cod_sucursal char(3) not null,
    fecha_ingreso date not null,
    fecha_salida date,
    patente_auto char(8),
    cod_mecanico number(5) not null,
    costo_total number(7) not null,
    estado varchar2(15)
);
alter table MANTENCION add constraint MANTENCION_PK primary key (num_mantencion);
alter table MANTENCION add constraint MANTENCION_FK_AUTOMOVIL foreign key (patente_auto) references automovil (patente);
alter table MANTENCION add constraint MANTENCION_FK_MECANICO foreign key (cod_mecanico) references mecanico (cod_mecanico);
alter table MANTENCION add constraint MANTENCION_FK_SUCURSAL foreign key (cod_sucursal) references sucursal (id_sucursal);

create table DETALLE_SERVICIO (
    mantencion_num number(4) not null,
    cod_servicio number(3) not null,
    descuento_serv number(4,3) not null,
    cantidad number(3) not null
);
alter table DETALLE_SERVICIO add constraint DETALLE_SERVICIO_PK primary key (mantencion_num, cod_servicio);
alter table DETALLE_SERVICIO add constraint DETALLE_SERVICIO_FK_MANTENCION foreign key (mantencion_num) references mantencion (num_mantencion);
alter table DETALLE_SERVICIO add constraint DETALLE_SERVICIO_FK_SERVICIO foreign key (cod_servicio) references servicio (id_servicio);


-- MODIFICACION DEL MODELO (ALTER TABLE)

-- eliminar un atributo derivado de la tabla
-- MANTENCION, ya que puede calcularse con los costos de los servicios en tiempo
-- real. Se solicita eliminar la columna costo_total de la tabla MANTENCION.
alter table MANTENCION drop column costo_total;

-- Debido a que cada mantención es identificada por la sucursal, se debe identificar
-- cada mantención por el número de mantención más el identificador de sucursal. Se
-- requiere realizar cambios en la clave primaria de la tabla MANTENCION y ajustar la
-- clave foránea en la tabla DETALLE_SERVICIO.
alter table DETALLE_SERVICIO drop constraint DETALLE_SERVICIO_FK_MANTENCION;
alter table MANTENCION drop constraint MANTENCION_PK;
alter table MANTENCION add constraint MANTENCION_PK primary key (num_mantencion, cod_sucursal);

alter table DETALLE_SERVICIO add cod_sucursal char(3) not null;
alter table DETALLE_SERVICIO drop constraint DETALLE_SERVICIO_PK;
alter table DETALLE_SERVICIO add constraint DETALLE_SERVICIO_PK primary key (mantencion_num, cod_sucursal, cod_servicio);
alter table DETALLE_SERVICIO add constraint DETALLE_SERVICIO_FK_MANTENCION foreign key (mantencion_num, cod_sucursal) references mantencion (num_mantencion, cod_sucursal);

-- El campo email en la tabla CLIENTE es opcional; sin embargo, en caso de
-- registrarse, debe ser único en la base de datos y no podrá repetirse entre distintos clientes.
alter table CLIENTE add constraint CLIENTE_EMAIL_UN unique (email);

--El dígito verificador (dv) del RUT de cada CLIENTE debe estar en el siguiente listado: 0,1,2,3,4,5,6,7,8,9,’K’
alter table CLIENTE add constraint CLIENTE_DV_CK check (dv in ('0','1','2','3','4','5','6','7','8','9','K'));

-- El sistema debe garantizar que el sueldo de un mecánico no sea inferior a $510.000
-- pesos al momento de registrar o actualizar su información, así aseguramos
-- condiciones laborales justas. Controla con un CHECK sobre el campo sueldo para
-- impedir el almacenamiento de valores menores a $510.000 pesos.
alter table MECANICO add constraint MECANICO_SUELDO_CK check (sueldo >= 510000);

-- Los clientes pueden agendar una mantención registrando en el sistema la fecha de
-- llegada. Para controlar el estado de una mantención, se requiere implementar una
-- restricción CHECK que valide los posibles estados de una mantención: Reserva, Ingresado, Entregado, Anulado.
alter table MANTENCION add constraint MANTENCION_ESTADO_CK check (estado in ('Reserva','Ingresado','Entregado','Anulado'));


-- POBLAMIENTO DEL MODELO
-- PAIS
insert into pais (nom_pais) values ('Chile');
insert into pais (nom_pais) values ('Peru');
insert into pais (nom_pais) values ('Colombia');

-- CIUDAD
insert into ciudad (nom_ciudad, cod_pais) values ('Santiago', 9);
insert into ciudad (nom_ciudad, cod_pais) values ('Lima', 12);
insert into ciudad (nom_ciudad, cod_pais) values ('Bogotá', 15);

-- SUCURSAL
insert into sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
values ('S01', 'Providencia', 'Av. A. Varas', 234, 165);

insert into sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
values ('S02', 'Las 4 esquinas', 'Av. Latina', 669, 170);

insert into sucursal (id_sucursal, nom_sucursal, calle, num_calle, cod_ciudad)
values ('S03', 'El Cafetero', 'Av. El Faro', 900, 175);

-- SERVICIO
insert into servicio (descripcion, costo) values ('Cambio Luces', 45000);
insert into servicio (descripcion, costo) values ('Desabolladura', 67000);
insert into servicio (descripcion, costo) values ('Revisión Frenos', 30000);
insert into servicio (descripcion, costo) values ('Cambio Puerta Trasera', 50000);

--• MECANICO
insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Jorge', 'Pablo', 'Soto', 'Sierpe', 5400000, 2759000, 223580, null);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Pedro', 'Jose', 'Manriquez', 'Corral', null, 759000, 23980, null);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Sandra', 'Josefa', 'Letelier', 'S.', 0, 659000, 22358, 460);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Felipe', 'M.', 'Vidal', 'A.', null, 759000, 23580, 460);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Jose', 'Miguel', 'Troncoso', 'B.', null, 659000, 44580, 474);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Juan', 'Pablo', 'Sánchez', 'R.', null, 859000, 23380, 474);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Carlos', 'Felipe', 'Soto', 'J.', 0, 597000, 23580, 474);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Alberto', 'P.', 'Cerda', 'Ramírez', null, 559000, 22380, 460);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Alejandra', 'Gabriela', 'Infanti', 'R.', null, 659000, 22380, 460);

insert into mecanico (pnombre, snombre, apaterno, amaterno, bono_jefatura, sueldo, monto_impuestos, cod_supervisor)
values ('Roberto', 'Patricio', 'Gutierrez', 'Sosa', null, 859000, 22380, 460);

--• MANTENCION
insert into mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
values (101, 'S01', to_date('12-04-2023', 'DD-MM-YYYY'), null, null, 481, 'Reserva');

insert into mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
values (102, 'S02', to_date('21-02-2023', 'DD-MM-YYYY'), to_date('21-02-2023', 'DD-MM-YYYY'), null, 502, 'Entregado');

insert into mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
values (103, 'S02', to_date('09-10-2023', 'DD-MM-YYYY'), null, null, 502, 'Anulado');

insert into mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
values (104, 'S03', to_date('11-08-2023', 'DD-MM-YYYY'), to_date('18-08-2023', 'DD-MM-YYYY'), null, 509, 'Entregado');

insert into mantencion (num_mantencion, cod_sucursal, fecha_ingreso, fecha_salida, patente_auto, cod_mecanico, estado)
values (105, 'S03', to_date('03-12-2023', 'DD-MM-YYYY'), null, null, 509, 'Ingresado');

-- RECUPERACION DE DATOS

-- obtener un listado de los mecánicos cuyo bono de jefatura es nulo y cuyo monto de
-- impuestos es inferior a 40.000 pesos.
select
    cod_mecanico as "ID MECANICO",
    pnombre || ' ' || apaterno as "NOMBRE MECANICO",
    sueldo as "SALARIO",
    monto_impuestos as "IMPUESTO ACTUAL",
    monto_impuestos * 0.8 as "IMPUESTO REBAJADO", -- 80% del monto de impuestos (descuento del 20%)
    sueldo - (monto_impuestos * 0.8) as "SUELDO CON REBAJA IMPUESTOS"
from mecanico
where bono_jefatura is null -- con nulos no se usa "= null", se usa IS NULL
    and monto_impuestos < 40000
order by
    "IMPUESTO ACTUAL" desc,
    apaterno asc;


-- Se requiere realizar un ajuste salarial del 5% a los mecánicos que tienen un sueldo entre
-- 600 mil y 900 mil pesos, o aquellos que no tienen un supervisor asignado. El ajuste salarial
-- debe mostrarse junto con el sueldo actual y el sueldo reajustado.
select
    cod_mecanico as "IDENTIFICADOR",
    pnombre || ' ' || snombre || ' ' || apaterno as "MECANICO",
    sueldo as "SALARIO ACTUAL",
    sueldo * 0.05 as "AJUSTE",
    sueldo + (sueldo * 0.05) as "SUELDO_REAJUSTADO"
from mecanico
where (sueldo between 600000 and 900000) -- BETWEEN es inclusivo en ambos limites
    or cod_supervisor is null
order by
    "SALARIO ACTUAL" asc,
    "MECANICO" desc;