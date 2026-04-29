-- función para asociar al trigger (el código tiene que estar en una función en postgres)
-- la función debe devolver trigger
CREATE OR REPLACE FUNCTION fcAvisaInsert() RETURNS TRIGGER AS $$
DECLARE 
BEGIN
	RAISE NOTICE 'Se hizo un %', TG_OP;
	RAISE NOTICE 'Se hizo antes o despues: %', TG_WHEN;
	RAISE NOTICE 'Se hizo por tupla o por instruccion: %', TG_LEVEL;
	RAISE NOTICE 'Valor antes: %    Valor posterior:  %', OLD.Dni, NEW.Dni;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;


-- Creación del trigger
CREATE TRIGGER tgAvisarInsert BEFORE INSERT OR UPDATE OR DELETE
ON jefe FOR EACH ROW
EXECUTE PROCEDURE fcAvisaInsert();

DROP TRIGGER tgAvisarInsert ON jefe

INSERT INTO jefe VALUES(1);
INSERT INTO jefe VALUES (2)

UPDATE jefe SET dni = 3 WHERE dni=1

SELECT * FROM jefe

DELETE FROM jefe