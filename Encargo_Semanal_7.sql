-- ELIMINACION DE TABLAS ANTES DE CREARLAS
drop table titulacion cascade constraints;
drop table titulo cascade constraints;
drop table dominio cascade constraints;
drop table idioma cascade constraints;
drop table personal cascade constraints;
drop table genero cascade constraints;
drop table estado_civil cascade constraints;
drop table compania cascade constraints;
drop table comuna cascade constraints;
drop table region cascade constraints;

-- CREACON DE TABLAS
create table REGION (
    id_region number(2) generated always as identity (start with 7 increment by 2) not null,
    nombre_region varchar2(25) not null
);
alter table REGION add constraint REGION_PK primary key (id_region);

create table COMUNA (
    id_comuna number(5) not null,
    comuna_nombre varchar2(25) not null,
    cod_region number(2) not null
);
alter table COMUNA add constraint COMUNA_PK primary key (id_comuna, cod_region);
alter table COMUNA add constraint COMUNA_FK_region foreign key (cod_region) references region (id_region);
-- Se conocen que hay del orden de 350 comunas. Por lo tanto, para poblar la tabla correspondiente debes usar una identificación numérica que comience en 1101 y que se incremente en 6 (usa objeto secuencia).
drop sequence seq_comuna;
create sequence seq_comuna start with 1101 increment by 6 maxvalue 99999 nocache nocycle;
alter table COMUNA modify (id_comuna default seq_comuna.nextval);

create table COMPANIA (
    id_empresa number(2) not null,
    nombre_empresa varchar2(25) not null,
    calle varchar2(50) not null,
    numeracion number(5) not null,
    renta_promedio number(10) not null,
    pct_aumento number(4,3),
    cod_comuna number(5) not null,
    cod_region number(2) not null
);
alter table COMPANIA add constraint COMPANIA_PK primary key (id_empresa);
alter table COMPANIA add constraint COMPANIA_UN_NOMBRE unique (nombre_empresa);
alter table COMPANIA add constraint COMPANIA_FK_COMUNA foreign key (cod_comuna, cod_region) references comuna (id_comuna, cod_region);
-- Se sabe que el sistema debe administrar 7 compañías distintas, por un tema de seguridad el id_empresa debe iniciar en 10, y se debe incrementar en 5 unidades (usa objeto secuencia)
drop sequence seq_compania;
create sequence seq_compania start with 10 increment by 5 maxvalue 99 nocache nocycle;
alter table COMPANIA modify (id_empresa default seq_compania.nextval);

create table ESTADO_CIVIL (
    id_estado_civil varchar2(2) not null,
    descripcion_est_civil varchar2(25) not null
);
alter table ESTADO_CIVIL add constraint ESTADO_CIVIL_PK primary key (id_estado_civil);

create table GENERO (
    id_genero varchar2(3) not null,
    descripcion_genero varchar2(25) not null
);
alter table GENERO add constraint GENERO_PK primary key (id_genero);

create table PERSONAL (
    rut_persona number(8) not null,
    dv_persona char(1) not null,
    primer_nombre varchar2(25) not null,
    segundo_nombre varchar2(25),
    primer_apellido varchar2(25) not null,
    segundo_apellido varchar2(25) not null,
    fecha_contratacion date not null,
    fecha_nacimiento date not null,
    email  varchar2(100),
    calle  varchar2(50) not null,
    numeracion number(5) not null,
    sueldo number(5) not null,
    cod_comuna number(5) not null,
    cod_region number(2) not null,
    cod_genero varchar2(3),
    cod_estado_civil varchar2(2),
    cod_empresa number(2) not null,
    encargado_rut number(8)
);
alter table PERSONAL add constraint PERSONAL_PK primary key (rut_persona);
alter table PERSONAL add constraint PERSONAL_FK_COMPANIA foreign key (cod_empresa) references compania (id_empresa);
alter table PERSONAL add constraint PERSONAL_FK_COMUNA foreign key (cod_comuna, cod_region) references comuna (id_comuna, cod_region);
alter table PERSONAL add constraint PERSONAL_FK_ESTADO_CIVIL foreign key (cod_estado_civil) references estado_civil (id_estado_civil);
alter table PERSONAL add constraint PERSONAL_FK_GENERO foreign key (cod_genero) references genero (id_genero);
alter table PERSONAL add constraint PERSONAL_PERSONAL_FK foreign key (encargado_rut) references personal (rut_persona);
--• Aunque el email de una persona es opcional, no se debe repetir.
alter table PERSONAL add constraint PERSONAL_EMAIL_UN unique (email);
--• El dígito verificador del RUN del PERSONAL debe estar en el siguiente listado: 0,1,2,3,4,5,6,7,8,9,’K’.
alter table PERSONAL add constraint PERSONAL_RUT_CK check (dv_persona in ('0','1','2','3','4','5','6','7','8','9','K'));
--• Debes considerar que el sueldo mínimo del personal es de 450.000 pesos.
alter table PERSONAL add constraint PERSONAL_SUELDO_CK check (sueldo >= 450000);

create table IDIOMA (
    id_idioma number(3) generated always as identity (start with 25 increment by 3) not null,
    nombre_idioma varchar2(30) not null
);
alter table idioma add constraint IDIOMA_PK primary key (id_idioma);

create table DOMINIO (
    id_idioma number(3) not null,
    persona_rut number(8) not null,
    nivel varchar2(25) not null
);
alter table DOMINIO add constraint DOMINIO_PK primary key (id_idioma, persona_rut);
alter table DOMINIO add constraint DOMINIO_FK_IDIOMA foreign key (id_idioma) references idioma (id_idioma);
alter table DOMINIO add constraint DOMINIO_FK_PERSONAL foreign key (persona_rut) references personal (rut_persona);

create table TITULO (
    id_titulo varchar2(3) not null,
    descripcion_titulo varchar2(60) not null
);
alter table TITULO add constraint TITULO_PK primary key (id_titulo);

create table TITULACION (
    cod_titulo varchar2(3) not null,
    persona_rut number(8) not null,
    fecha_titulacion date not null
);
alter table TITULACION add constraint TITULACION_PK primary key (cod_titulo, persona_rut);
alter table TITULACION add constraint TITULACION_FK_PERSONAL foreign key (persona_rut) references personal (rut_persona);
alter table TITULACION add constraint TITULACION_FK_TITULO foreign key (cod_titulo) references titulo (id_titulo);


-- INSERTS DE TABLAS
--• REGION (en la creación de la tabla utiliza identity)
insert into region (nombre_region) values ('ARICA Y PARINACOTA');
insert into region (nombre_region) values ('METROPOLITANA');
insert into region (nombre_region) values ('LA ARAUCANIA');

--• COMUNA (usa objeto sequence)
-- Aqui omito el id_comuna ya que la secuencia la agregue como default despues de la creacion de la tabla y lo hace solo.
insert into comuna (comuna_nombre, cod_region) values ('Arica', 7);
insert into comuna (comuna_nombre, cod_region) values ('Santiago', 9);
insert into comuna (comuna_nombre, cod_region) values ('Temuco', 11);

--• COMPANIA (usa objeto sequence)
-- Aqui omito el id_empresa ya que la secuencia la agregue como default despues de la creacion de la tabla y lo hace solo.
insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('CCyRojas', 'Amapolas', 506, 1857000, 0.5, 1101, 7);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('SenTTy', 'Los Alamos', 3490, 897000, 0.025, 1101, 7);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('Praxia LTDA', 'Las Camelias', 11098, 2157000, 0.035, 1107, 9);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('TIC spa', 'FLORES s.a', 4357, 857000, null, 1107, 9);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('SANTANA LTDA', 'Avda Vic. Mackena', 106, 757000, 0.015, 1101, 7);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589000, 0.015, 1107, 9);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('J.A HOFFMAN', 'LATINA D.32', 509, 1857000, 0.025, 1113, 11);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('CAGLIARI D.', 'ALAMEDA', 206, 1857000, null, 1107, 9);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('Rojas HNOS LTDA', 'SUCRE', 106, 957000, 0.005, 1113, 11);

insert into compania (nombre_empresa, calle, numeracion, renta_promedio, pct_aumento, cod_comuna, cod_region)
values ('FRIENDS P. S.A', 'SUICIA', 506, 857000, 0.015, 1113, 11);

--• IDIOMA (en la creación de la tabla utiliza identity)
insert into idioma (nombre_idioma) values ('Ingles');
insert into idioma (nombre_idioma) values ('Chino');
insert into idioma (nombre_idioma) values ('Aleman');
insert into idioma (nombre_idioma) values ('Espanol');
insert into idioma (nombre_idioma) values ('Frances');


-- RECUPERACION DE DATOS
select 
    nombre_empresa as "Nombre Empresa",
    calle || ' ' ||numeracion as "Dirección",
    renta_promedio as "Renta Promedio",
    renta_promedio * (pct_aumento + 1) as "Simulación de Renta"
from compania
order by
    "Renta Promedio" desc,
    "Nombre Empresa" asc;
    
    
-- Los valores obtenidos aqui no coincidian con la imagen de la figura 4 ys que parece tener otro porcentaje aplicado.
select
    id_empresa as CODIGO,
    nombre_empresa as EMPRESA,
    renta_promedio as "PROM RENTA ACTUAL",
    (pct_aumento*1.15) as "PCT AUMENTO EN 15%", -- El porcentaje aumentado en 15%
    renta_promedio * ((pct_aumento*1.15) + 1) as "RENTA AUMENTADA"
from compania
order by
"PROM RENTA ACTUAL" asc, -- ordenando la data por renta promedio actual ascendente
EMPRESA desc; -- y posteriormente por el nombre de la empresa de forma descendente. 








