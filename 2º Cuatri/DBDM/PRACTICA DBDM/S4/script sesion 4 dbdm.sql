-- Ejecuta estos comandos antes de empezar la sesion 4

-- Si quieres borrar las tablas que vas a crear
-- en la sesión 4, quita el comentario de
-- las 6 sentencias que siguen

/* 
DROP TABLE CONTROL_ACCESO   CASCADE   CONSTRAINTS;
DROP TABLE USUARIOS   CASCADE   CONSTRAINTS;
DROP TABLE RECURSO_PAGO   CASCADE   CONSTRAINTS;
DROP TABLE RECURSO_GRATUITO   CASCADE   CONSTRAINTS;
DROP TABLE MESES   CASCADE   CONSTRAINTS;
DROP TABLE COMPATIBLE_CON   CASCADE   CONSTRAINTS; 
*/
DROP TABLE RECURSO   CASCADE   CONSTRAINTS;
DROP TABLE SE_VISUALIZA_CON   CASCADE   CONSTRAINTS;
DROP TABLE VISOR   CASCADE   CONSTRAINTS;
DROP TABLE CLAVES CASCADE CONSTRAINTS;
DROP TABLE FORMATO   CASCADE   CONSTRAINTS;
DROP TABLE RECSESION4 CASCADE CONSTRAINTS;

-- Sesion 3

CREATE TABLE CLAVES (clave VARCHAR2(256) CONSTRAINT PK_clave PRIMARY KEY);
CREATE TABLE VISOR (nombre VARCHAR2(100) CONSTRAINT PK_VISOR PRIMARY KEY, 
                    empresa VARCHAR2(100), 
                    clave varchar2(256) NOT NULL,
                    CONSTRAINT UK_CLAVE UNIQUE  (CLAVE),
                    CONSTRAINT FK_VISOR_CLAVE FOREIGN KEY (CLAVE) REFERENCES CLAVES(CLAVE)
 );
CREATE TABLE FORMATO (nombre VARCHAR2(10) CONSTRAINT PK_FORMATO PRIMARY KEY, descrip VARCHAR2(100), anyo INTEGER);

CREATE TABLE SE_VISUALIZA_CON (nombre_visor VARCHAR2(100),  
                               nombre_formato VARCHAR2(10),
                               codec VARCHAR2(100) NOT NULL , 
                               CONSTRAINT PK_SE_VISUALIZA_CON PRIMARY KEY (nombre_visor),
                               CONSTRAINT FK_SVCON_VISOR FOREIGN KEY (nombre_visor) REFERENCES VISOR(nombre),
                               CONSTRAINT FK_SVCON_FORMATO FOREIGN KEY (nombre_formato) REFERENCES FORMATO(nombre));
                               
CREATE TABLE RECURSO (codigo VARCHAR2(50), 
                      descripcion VARCHAR2(100), 
                      falta date, 
                      tamanyo number(8,2), 
                      tiempo_des number(8,2),   
                      nombre_formato VARCHAR2(10) CONSTRAINT FK_RECURSO_FORMATO REFERENCES FORMATO(nombre),
                      CONSTRAINT PK_RECURSO PRIMARY KEY (codigo));

-- Tabla Claves

INSERT INTO CLAVES(Clave) VALUES ('ABCD');
INSERT INTO CLAVES(Clave) VALUES ('EFGH');
INSERT INTO CLAVES(Clave) VALUES ('IJKL');
INSERT INTO CLAVES(Clave) VALUES ('MNOP');
INSERT INTO CLAVES(Clave) VALUES ('QRST');

-- Tabla VISOR

INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Internet Explorer','Microsoft', 'ABCD');
INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Chrome','Google','EFGH');
INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Corel Photoshop','Corel','IJKL');
INSERT INTO VISOR(nombre, empresa, clave) VALUES ('Windows Media Player','Microsoft','MNOP');

-- Tabla Formato

INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('JPG','Fotografías',1992);
INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('MP3','Audio digital',1995);
INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('MPEG4','Video digital',1998);
INSERT INTO FORMATO (nombre, descrip, anyo) VALUES ('MP4','Audio o video digital',1998);

-- Tabla SE_VISUALIZA_CON

INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Internet Explorer','JPG','IE_JPG.DLL');
INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Chrome','MP3','CH_MP3 .DLL');
INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Corel Photoshop','MPEG4','ADOBE_COD.DLL');
INSERT INTO SE_VISUALIZA_CON (nombre_visor, nombre_formato, codec) VALUES ('Windows Media Player','MP4','WIN_CODECS.DLL');

-- Tabla RECURSO

INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('Video1', 'Corporativo', 'MPEG4',to_date('01/01/2013','dd/mm/yyyy'),2000,10);
INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('Video2', 'Sede', 'MPEG4',to_date('01/04/2016','dd/mm/yyyy'),20000,100);
INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('Musica1', 'Centralita', 'MP3',to_date('01/01/2016','dd/mm/yyyy'),200,5);
INSERT INTO RECURSO (codigo,descripcion,nombre_formato,falta,tamanyo,tiempo_des) VALUES ('FOTO1', 'Paisaje bonito','JPG', to_date('01/10/2015','dd/mm/yyyy'),150,3);

-- Inicio Sesion 4

DROP TABLE recsesion4;
CREATE TABLE recsesion4
  (
    codigo         NUMERIC CONSTRAINT PK_RECSESION4 PRIMARY KEY,
    tipo           VARCHAR2(6),
    descripcion    VARCHAR2(100),
    falta          DATE,
    nombre_formato VARCHAR2(10),
    tamanyo        NUMBER(8,2),
    tiempo_des     NUMBER(8,2)
  );
INSERT
INTO recsesion4
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    1,
    'PAGO',
    'Zapatillas',
    '01/01/2013',
    'MP3',
    500.01,
    15.25
  );
INSERT
INTO recsesion4
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    2,
    'PAGO',
    'Vídeo musical canción zapatillas',
    '01/02/2013',
    'MP4',
    7700.01,
    55.25
  );
INSERT
INTO recsesion4
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    3,
    'PAGO',
    'Titanic',
    '01/01/2013',
    'MPEG4',
    4400.01,
    345.25
  );
INSERT
INTO recsesion4
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    4,
    'PAGO',
    'Foto moda con derechos autor',
    '01/02/2013',
    'JPG',
    400.01,
    9.25
  );
INSERT
INTO recsesion4
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    5,
    'GRATIS',
    'Melodía telediario',
    '01/02/2013',
    'MP3',
    300.01,
    8.25
  );
INSERT
INTO recsesion4
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    6,
    'GRATIS',
    'Anuncio Universidad Alicante',
    '01/01/2013',
    'MPEG4',
    201.02,
    6.25
  );
INSERT
INTO recsesion4
  (
    codigo,
    tipo,
    descripcion,
    falta,
    nombre_formato,
    tamanyo,
    tiempo_des
  )
  VALUES
  (
    7,
    'GRATIS',
    'Foto profesores UA',
    '15/02/2013',
    'JPG',
    200.01,
    5.25
  );
  
  
COMMIT;