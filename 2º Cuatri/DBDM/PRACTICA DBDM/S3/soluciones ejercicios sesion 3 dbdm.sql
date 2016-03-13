-- Si quieres limpiar la base de datos antes de probar los ejercicios
-- ejecuta las cinco sentencias que siguen


DROP TABLE SE_VISUALIZA_CON;
DROP TABLE VISOR;
DROP TABLE RECURSO;   
DROP TABLE FORMATO;
DROP TABLE CLAVES;

-- Ejercicio 1


CREATE TABLE CLAVES (clave VARCHAR2(256) CONSTRAINT PK_clave PRIMARY KEY);
CREATE TABLE VISOR (nombre VARCHAR2(100) CONSTRAINT PK_VISOR PRIMARY KEY, 
                    empresa VARCHAR2(100), 
                    clave varchar2(256) NOT NULL,
                    CONSTRAINT UK_CLAVE UNIQUE  (CLAVE),
                    CONSTRAINT FK_VISOR_CLAVE FOREIGN KEY (CLAVE) REFERENCES CLAVES(CLAVE)
 );
CREATE TABLE FORMATO (nombre VARCHAR2(10) CONSTRAINT PK_FORMATO PRIMARY KEY, descrip VARCHAR2(100), anyo INTEGER);
CREATE TABLE SE_VISUALIZA_CON (nombre_visor VARCHAR2(100),  codec VARCHAR2(100) NOT NULL , CONSTRAINT PK_SE_VISUALIZA_CON PRIMARY KEY (nombre_visor),CONSTRAINT FK_SVCON_VISOR FOREIGN KEY (nombre_visor) REFERENCES VISOR(nombre));
CREATE TABLE RECURSO (codigo VARCHAR2(50), descripcion VARCHAR2(100), falta date, tamanyo number(8,2), tiempo_des number(8,2),   CONSTRAINT PK_RECURSO PRIMARY KEY (codigo));

-- Ejercicio 2

ALTER TABLE FORMATO MODIFY descrip NOT NULL;

 
ALTER TABLE SE_VISUALIZA_CON ADD NOMBRE_FORMATO VARCHAR2(10) CONSTRAINT FK__SE_VISUALIZA_CON_FORMATO  REFERENCES formato;

ALTER TABLE SE_VISUALIZA_CON drop constraint PK_SE_VISUALIZA_CON;
ALTER TABLE SE_VISUALIZA_CON ADD (CONSTRAINT PK_SE_VISUALIZA_CON primary  key(nombre_visor, nombre_formato ));

ALTER TABLE RECURSO ADD nombre_formato VARCHAR2(10) CONSTRAINT FK_RECURSO_FORMATO REFERENCES FORMATO;

-- Ejercicio 3

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

-- Ejercicio 4

CREATE TABLE VISUALIZANDO(cod_visor VARCHAR2(3) CONSTRAINT PK_VISUALIZANDO PRIMARY KEY, visor VARCHAR2(15), aplicacion VARCHAR2(100), visionados INTEGER);

-- Ejercicio 5

-- a)

DROP TABLE VISOR;

-- No nos permite borrarla, porque la integridad referencial nos lo impide. La tabla SE_VISUALIZA_CON tiene una clave ajena hacia VISOR .

-- b)

DROP TABLE VISUALIZANDO;

-- Sí permite borrarla, ya que es una tabla independiente.

-- Ejercicio 6

DELETE RECURSO WHERE codigo like '%Video%';

-- Ejericio 7

UPDATE VISOR SET empresa='ADOBE' WHERE nombre='Corel Photoshop';

-- Ejercicio 8

-- La sentencia ALTER TABLE sirve para modificar la estructura de las tablas, y la sentencia UPDATE para modificar la información de ellas, es decir,
-- datos de filas ya existentes. Aunque ambas sirven para modificar cosas, el significado de su ejecución es totalmente distinto.

-- Ejercicio 9

CREATE TABLE EJERCICIO9 (col1 VARCHAR2(4) DEFAULT 'COL1' NULL,col2 VARCHAR2(4) NULL, col3 VARCHAR2(4) DEFAULT 'COL3' NOT NULL, col4 VARCHAR2(4) NOT NULL); 

-- En todos los casos supondremos que la sentencia de inserción es correcta para el resto de columnas.

-- INSERCIÓN DE NULL

-- Si insertamos un NULO en la col1, el SGBD incluirá el valor NULL, ya que estamos forzando que se inserte ese valor. No tomará el valor por defecto.
-- Si insertamos un NULO en la col2, el SGBD incluirá un NULO en esa fila por la misma razón que para col1, aunque éste no tiene valor por defecto.
-- En ningún caso podremos insertar nulos en las filas definidas como NOT NULL. Esto es en la col3 y col 4. La razón es obvia: están definidas para que no los admitan.

-- INSERCIÓN DE DEFAULT

INSERT INTO EJERCICIO9(COL1,COL2,COL3,COL4) VALUES(DEFAULT, DEFAULT,DEFAULT,'DEFA');

-- El resultado es:    COL1,NULL,COL3,DEFA
-- En la col1 pondrá el valor COL1 porque tiene definida esa cadena por defecto.
-- En la col2 pondrá un nulo, porque no tiene valor por defecto.
-- En la col3 pondrá COL3, porque no tiene valor definido por defecto (caso similar al de col1).
-- En la col4 pondrá la cadena 'DEFA', ya que es el que le hemos puesto al no admitir nulos y no tener valor por defecto asignado. Lo hacemos así para que no dé fallo la senencia insert.

-- NO PONIENDO VALOR A LA COLUMNA

-- Si no ponemos valor para la col1, el SGBD incluirá automáticamente el valor 'COL1', tal como está definido en la restricción DEFAULT.
-- Si no ponemos valor para la col2, el SGBD incluirá un NULO en esa fila, ya que no hay definida restricción DEFAULT y además la columna admite nulos.
-- Si no ponemos valor para la col3, el SGBD incluirá automáticamente el valor 'COL3', tal como está definido en la restricción DEFAULT.
-- Si no ponemos valor para la col4, el SGBD nos dará un error, y no nos dejará insertar. El motivo es que al no haber valor, intenta insertar un NULL, y como esa columna no los admite
-- falla la sentencia

-- EJERCICIO 10

DROP TABLE EJERCICIO9;


-- EJERCICIO 11

insert into visor (nombre, empresa) values ('XX','Visor XX');

select * from visor;

-> Sí que aparece

rollback;

select * from visor;
-> Ya no aparece pues la transacción ha sido annulada 


-- EJERCICIO 12

grant select on visor to dbdm_micompañero

insert into visor (nombre, empresa) values ('YY','Visor XX');

select * from visor;

-- > A ti sí debe salirte

-- Tu compañero ejecuta 

select * from dbdm_miusuario.visor

--> Y no le sale (lógico, al no haberse producido el commit)

--> Tú ejecutas el commit
commit;

--> A tu compañero ya le sale



