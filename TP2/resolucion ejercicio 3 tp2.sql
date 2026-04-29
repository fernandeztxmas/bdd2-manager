--EJERCICIO 3
CREATE TABLE "trabajador-fijo"
(idtrabajador integer, 
 nombre char(30),
 despacho char(30),
 telefono char(30),
 sueldo real,        
   CONSTRAINT "pkTrabajadorFijo" PRIMARY KEY (idtrabajador));
   
CREATE TABLE "trabajador-tiempo-parcial"
(idtrabajador integer, 
 nombre char(30),
 sueldo_por_hora real,
   CONSTRAINT "pkTrabajadorTiempoParcial" PRIMARY KEY (idtrabajador));

CREATE TABLE direccion 
(idtrabajador integer,
 calle char (50),
 ciudad char(50),
 CONSTRAINT "pkDireccion" PRIMARY KEY  (idtrabajador,calle,ciudad));


-- ESTO OBLIGARIA A QUE UN IDTRABAJADOR EN DIRECCION PERTENEZCA
-- TANTO A trabajador-tiempo-parcial COMO A trabajador-fijo
ALTER TABLE direccion
  ADD CONSTRAINT fkTrabajadorTP FOREIGN KEY (idtrabajador) REFERENCES "trabajador-tiempo-parcial" 
ALTER TABLE direccion
  ADD CONSTRAINT fkTrabajadorF FOREIGN KEY (idTrabajador) REFERENCES "trabajador-fijo"

-- DESCARTAMOS PORQUE TIENE QUE SER UN "or" UNA TABLA O LA OTRA
ALTER TABLE direccion   DROP CONSTRAINT fkTrabajador
ALTER TABLE direccion   DROP CONSTRAINT fkTrabajadorTP


---- LO IDEAL SERÍA CREAR UN ASERTO !
---- EN ESTE EJEMPLO, EN EL PREDICADO DEL ASERTO SE CONTROLA QUE EN TODO MOMENTO EN LA BD
---- NO EXISTAN TUPLAS EN DIRECCION QUE NO ESTÉN NI EN trabajador-fijo NI EN trabajador-tiempo-parcial
---- ESTE PREDICADO SE CHEQUEA ANTE CUALQUIER CAMBIO EN CUALQUIER TABLA DE LA BD , POR ESO ES COSTOSO Y 
---- POR EJEMPLO POSTGRES NO LO IMPLEMENTA  
CREATE ASSERTION assCheck CHECK(NOT EXISTS 
				(SELECT * FROM direccion WHERE nombre NOT IN 
				    (SELECT idtrabajador FROM "trabajador-tiempo-parcial")  AND
                     idtrabajador NOT IN (SELECT nombre FROM "trabajador-fijo")))
							  

INSERT INTO "trabajador-fijo" VALUES (1, 'Prueba Trab. Fijo 1', 'Despacho 1', '', 90001);
INSERT INTO "trabajador-fijo" VALUES (2, 'Prueba Trab. Fijo 2', 'Despacho 2', '', 90002);
INSERT INTO "trabajador-fijo" VALUES (11, 'Prueba Trab. Fijo 3', 'Despacho 3', '', 90003);
  
INSERT INTO "trabajador-tiempo-parcial" VALUES (3, 'Prueba Trab. Tpo. Parcial 1', 9001);
INSERT INTO "trabajador-tiempo-parcial" VALUES (4, 'Prueba Trab. Tpo. Parcial 2', 9002);
INSERT INTO "trabajador-tiempo-parcial" VALUES (5, 'Prueba Trab. Tpo. Parcial 3', 9003); 
							  
INSERT INTO direccion VALUES (5, 'san martin', 'trelew');
INSERT INTO direccion VALUES (11, '25 de mayo 440', 'trelew');
INSERT INTO direccion VALUES (100, '25 de mayo 440', 'trelew');	
			
UPDATE "trabajador-fijo" SET idtrabajador = 100 WHERE idtrabajador=5
UPDATE "trabajador-fijo" SET idtrabajador = 1 WHERE idtrabajador=5
UPDATE "trabajador-fijo" SET NOMBRE = 'Prueba Trab. Fijo 3' WHERE nombre='Pepe'

			
--- PARA SIMULAR EL ASERTO LO HAREMOS CON 
--- 1) UN CHECK CONSTRAINT EN LA TABLA DIRECCION (VA A CONTROLAR QUE SIEMPRE EL NOMBRE DE LA TUPLA AFECTADA EXISTE EN UNA O EN LA OTRA TABLA)
--- 2) UN TRIGGER QUE SE DISPARE POR CADA ELIMINACION O ACTUALIZACIÓN DE trabajador-fijo O DE trabajador-tiempo-parcial QUE CONTROLE QUE EL NOMBRE 
--- QUE SE QUIERE BORRAR O MODIFICAR , NO ESTÉ SIENDO REFERENCIADO POR ALGUNA DIRECCION- 
--- SE DEBE HACER CON TRIGGER PARA CONTROLAR QUE LO QUE SE QUIERE CAMBIAR ES EL NOMBRE Y EN ESE CASO CONTROLAR QUE NO ESTÉ REFERENCIADO Y,
--- SI LO QUE SE QUIERE CAMBIAR SON OTROS CAMPOS, PERMITIR EL CAMBIO

-- creo la funcion, para luego usarla en el CHECK CONSTRAINT de la tabla direcciónque reemplazar al aserto
CREATE OR REPLACE FUNCTION existeNombre (nom char(30)) RETURNS boolean AS $$
BEGIN
	RETURN (nom IN (SELECT nombre FROM "trabajador-fijo" tf
                UNION SELECT nombre FROM "trabajador-tiempo-parcial"));	
END
$$ language plpgsql

-- creo la regla de integridad para la tabla direccion
ALTER TABLE direccion 
   ADD CONSTRAINT chkExisteNombre CHECK (existeidtrabajador(id));

delete from direccion

-- creo la 1er funcion, que se va a usar en el TRIGGER de las tablas que son referenciadas 
CREATE OR REPLACE FUNCTION existeIdReferenciado (idT char(30)) RETURNS boolean AS $$
BEGIN
	RETURN (idT IN (SELECT idtrabajador FROM "direccion"));	
END
$$ language plpgsql

-- creo la 2da funcion, que se va a usar en el TRIGGER de las tablas que son referenciadas 
CREATE OR REPLACE FUNCTION integridadIdReferenciado () RETURNS trigger AS $$
BEGIN
	IF TG_OP = 'DELETE' THEN
		IF existeIdReferenciado(OLD.idtrabajador) THEN
			--- se puede hacer la propagacion en cascada
			raise notice 'no permito el DELETE porque % tiene direcciones ' , old.idtrabajador;
			RETURN NEW;
		ELSE	
			RETURN OLD;
		END IF;
	END IF;

	IF TG_OP = 'UPDATE' AND (NEW.idtrabajador <> OLD.idtrabajador) THEN
		IF existeIdReferenciado(OLD.idtrabajador) THEN
		        --- se puede hacer la propagacion en cascada
			raise notice 'no permito el UPDATE porque % tiene direcciones ' , old.idtrabajador;
			RETURN OLD;
		ELSE	
			RETURN NEW;
		END IF;
	END IF;
END
$$ language plpgsql


--- creo los triggers
CREATE TRIGGER tgControlNombresReferenciados 
BEFORE UPDATE or DELETE ON "trabajador-fijo"
FOR EACH ROW EXECUTE procedure integridadNombreReferenciado();

CREATE TRIGGER tgControlNombresReferenciados 
BEFORE UPDATE or DELETE ON "trabajador-tiempo-parcial"
FOR EACH ROW EXECUTE procedure integridadNombreReferenciado();

--- PRUEBAS
INSERT INTO direccion VALUES (1, 'belgrano', 'trelew');     --- PERMITIDO
INSERT INTO direccion VALUES (3, 'belgrano', 'trelew');     --- PERMITIDO
INSERT INTO direccion VALUES (100, 'belgrano', 'trelew');   --- NO LO PERMITE PORQUE NO EXISTE EN LAS TABLAS REFERENCIADAS


UPDATE "direccion" set idtrabajador= 100 where idtrabajador = 1;   -- NO LO PERMITE PORQUE NO EXISTE EN NINGUNA EL VALOR NUEVO
UPDATE "direccion" set idtrabajador= 3 where idtrabajador =1;   -- PERMITIDO PORQUE EXISTE  EL VALOR NUEVO, EN LA OTRA TABLA

UPDATE "trabajador-fijo" set idtrabajador= 100 where idtrabajador= 1;  -- NO LO PERMITE PORQUE TIENE TUPLAS QUE LO REFERENCIAN
UPDATE "trabajador-fijo" set idtrabajador= 100 where idtrabajador= 2;  -- PERMITIDO

DELETE FROM "trabajador-tiempo-parcial" where idtrabajador= 1;    -- NO LO PERMITE PORQUE TIENE TUPLAS QUE LO REFERENCIAN
DELETE FROM "trabajador-tiempo-parcial" where idtrabajador= 11;   -- PERMITIDO


SELECT * from "trabajador-fijo";
SELECT * from "trabajador-tiempo-parcial"; 
SELECT * from direccion;

DROP TABLE "direccion";
DROP TABLE "trabajador-fijo";
DROP TABLE "trabajador-tiempo-parcial";


