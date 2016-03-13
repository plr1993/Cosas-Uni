-- Ejercicio 1
DELETE FROM recurso;
COMMIT;
-- Ejercicio 2
ALTER TABLE recurso MODIFY codigo NUMERIC;

-- Ejercicio 3
CREATE TABLE compatible_con
  (
    nom_formato1 VARCHAR2(10),
    nom_formato2 VARCHAR2(10),
    CONSTRAINT PK_COMPATIBLE_CON PRIMARY KEY (nom_formato1,nom_formato2),
    CONSTRAINT FK_COMPATIBLE_CON_FORMATO1 FOREIGN KEY (nom_formato1) REFERENCES formato,
    CONSTRAINT FK_COMPATIBLE_CON_FORMATO2 FOREIGN KEY (nom_formato2) REFERENCES formato
  );
CREATE TABLE recurso_gratuito
  (
    codigo NUMERIC CONSTRAINT PK_RECURSO_GRATUITO PRIMARY KEY
                   CONSTRAINT FK_RGRATUITO_RECURSO REFERENCES Recurso,
    max_descargas NUMERIC
  );
CREATE TABLE recurso_pago
  (
    codigo NUMERIC CONSTRAINT PK_RECURSO_PAGO PRIMARY KEY,
    precio DECIMAL(10,2)
  );
CREATE TABLE meses
  (mes VARCHAR2(9) CONSTRAINT PK_MESES PRIMARY KEY
  );
CREATE TABLE usuarios
  (
    identificador VARCHAR2(100) CONSTRAINT PK_USUARIOS PRIMARY KEY,
    nombre        VARCHAR2(100)
  );
CREATE TABLE control_acceso
  (
    cod_recurso NUMERIC,
    id_usuario  VARCHAR2(100),
    mes         VARCHAR2(9),
    CONSTRAINT PK_CONTROL_ACCESO PRIMARY KEY (id_usuario,mes),
    CONSTRAINT FK_CONTROL_ACCESO_RECURSO_PAGO FOREIGN KEY (cod_recurso) REFERENCES recurso_pago,
    CONSTRAINT FK_CONTROL_ACCESO_USUARIOS FOREIGN KEY (id_usuario) REFERENCES usuarios,
    CONSTRAINT FK_CONTROL_ACCESO_MESES FOREIGN KEY (mes) REFERENCES meses
  );
CREATE TABLE Contador_descargas
   (
    cod_recurso NUMERIC,
    id_usuario VARCHAR2(100),
    contador NUMERIC NOT NULL,
    CONSTRAINT PK_CONTADOR_DESCARGAS PRIMARY KEY (id_usuario,cod_recurso),
    CONSTRAINT FK_CDESCARGAS_RECURSO_GRATUITO FOREIGN KEY (cod_recurso) REFERENCES recurso_gratuito,
    CONSTRAINT FK_CDESCARGAS_USUARIOS FOREIGN KEY (id_usuario) REFERENCES usuarios
   );
-- Ejercicio 4
ALTER TABLE control_acceso ADD CONSTRAINT UQ_CONTROL_ACCESO UNIQUE
(
  id_usuario,cod_recurso
)
;
-- La sentencia siguiente no haría falta, ya que id_usuario no admite nulos al formar parte de la clave principal.
-- ALTER TABLE control_acceso MODIFY id_usuario NOT NULL;
-- Esta sí es imprescindible, para que la combinación de las dos columnas sea clave alternativa. No pueden contener nulos ninguna de las dos
ALTER TABLE control_acceso MODIFY cod_recurso NOT NULL;

-- Ejercicio 5
ALTER TABLE recurso_pago ADD CONSTRAINT FK_RECURSO_PAGO_RECURSOS FOREIGN KEY
(
  codigo
)
REFERENCES recurso;

-- Ejercicio 6
INSERT INTO recurso
  (codigo,descripcion,falta,nombre_formato,tamanyo,tiempo_des
  )
SELECT codigo,descripcion,falta,nombre_formato,tamanyo,tiempo_des FROM recsesion4;
COMMIT;

-- Ejercicio 7
-- Le pondremos también 10 como valor máximo de descargas a cada recurso gratuito
INSERT INTO recurso_gratuito
  (codigo,max_descargas
  )
SELECT codigo,10 FROM recsesion4 WHERE tipo='GRATIS';
COMMIT;

INSERT INTO recurso_pago
  (codigo,precio
  )
SELECT codigo,10 FROM recsesion4 WHERE tipo='PAGO';
COMMIT;

-- Ejercicio 8
ALTER TABLE recurso_pago MODIFY precio NOT NULL;

 
-- Ejercicio 9


CREATE OR REPLACE VIEW recursos_de_pago as select r.*,p.precio from recurso r, recurso_pago p where r.codigo=p.codigo and p.precio > 5;


-- Ejercicio 10

CREATE OR REPLACE VIEW recursos_de_musica  as select r.* from recurso r where r.nombre_formato = 'MP3';

INSERT INTO recursos_de_musica  (codigo,descripcion,nombre_formato, falta, tamanyo,tiempo_des) VALUES (8,'Fotografía chula','JPG',to_Date('01/01/2013','DD/MM/YYYY'),400.05,4.05);
INSERT INTO recursos_de_musica  (codigo,descripcion,nombre_formato, falta, tamanyo,tiempo_des) VALUES (9,'Fotos inédito ','JPG',to_date('01/02/2013','DD/MM/YYYY'),500.25,5.05);
INSERT INTO recursos_de_musica  (codigo,descripcion,nombre_formato, falta, tamanyo,tiempo_des) VALUES (10,'Día en el Zoo','MPEG4',to_Date('01/03/2012','DD/MM/YYYY'),5000.99,65.55);

COMMIT;

select * from recursos_de_musica;

-- No salen ya que ninguno es de formato MP3

SELECT * FROM recurso;

-> Si salen, por tanto a traves de la vista  recursos_de_musica he conseguido meter rursos que no son MP3. 
-> La solucion sería creandola con with check option

CREATE OR REPLACE VIEW recursos_de_musica  as select r.* from recurso r where r.nombre_formato = 'MP3' with check option;

--si intento hacer un insert ahora que no sea MP3 sale 

-- ORA-01402: violación de la cláusula WHERE en la vista WITH CHECK OPTION




-- Ejercicio 11

-- Desde la sesión INVITADO

SELECT * FROM dbdm_xxxx.recurso;

-- Falla, ya que no tenemos permisos para realizar SELECT sobre esa tabla del usuario propietario.

-- Ejercicio 12

GRANT SELECT ON RECURSO TO invitado_dbdm_xxxx;

-- Desde la sesión del INVITADO, ejecutamos

SELECT * FROM dbdm_xxxx.recurso;

-- Ahora sí podemos ver todas las columnas y filas de la tabla RECURSO del propietario

-- Ejercicio 13

REVOKE SELECT ON RECURSO FROM invitado_dbdm_xxxx;

-- Ejercicio 14

EXPLAIN PLAN SET statement_id='SIN_INDICE' FOR SELECT * FROM RECURSO WHERE FALTA < '01/01/2016';
SELECT STATEMENT_ID,OPERATION,OPTIONS,OBJECT_NAME,POSITION FROM PLAN_TABLE;

-- Ejercicio 15

CREATE INDEX IND_RECURSO_FALTA ON RECURSO(FALTA);

-- Ejercicio 16

EXPLAIN PLAN SET statement_id='CON_INDICE' FOR SELECT * FROM RECURSO WHERE FALTA < '01/01/2016';
SELECT STATEMENT_ID,OPERATION,OPTIONS,OBJECT_NAME,POSITION FROM PLAN_TABLE;

-- Ejercicio 17

-- En el primer caso haría una búsqueda secuencial por todas las filas, y en la segunda
-- utilizaría el índice que hemos creado.


