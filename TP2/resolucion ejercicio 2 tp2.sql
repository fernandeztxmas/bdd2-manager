--EJERCICIO 2
CREATE TABLE empleado (idempleado integer,
                       nombreempleado char(50),
					   calle char(50),
					   ciudad char(50),
					   CONSTRAINT pk_Empleado PRIMARY KEY (idempleado));

CREATE TABLE empresa (idempresa integer,
                      nombreempresa char(50),
					  ciudad char(50),
					  CONSTRAINT pk_Empresa PRIMARY KEY (idempresa));


CREATE TABLE trabaja (idempleado integer,
                      idempresa integer,
                      sueldo real,
                      CONSTRAINT pk_trabaja PRIMARY KEY(idempleado, idempresa),
                      CONSTRAINT fk_trabajaempleado FOREIGN KEY (idempleado) REFERENCES empleado 
					                                ON DELETE CASCADE ON UPDATE CASCADE,
					  CONSTRAINT fk_trabajaempresa FOREIGN KEY (idempresa) REFERENCES empresa 
                                                    ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TABLE jefe (idempleadosubordinado integer,
				   idempleadojefe integer,
				  CONSTRAINT pk_jefe PRIMARY KEY (idempleadosubordinado, idempleadojefe),
				  CONSTRAINT fk_jefeempsub FOREIGN KEY (idempleadosubordinado) REFERENCES empleado
				   									ON DELETE CASCADE ON UPDATE CASCADE,
				  CONSTRAINT fk_jefejefe FOREIGN KEY (idempleadojefe) REFERENCES empleado
				                                    ON DELETE CASCADE ON UPDATE CASCADE,
				  CONSTRAINT chk_noeselmismo CHECK (idempleadojefe <> idempleadosubordinado))



INSERT INTO empleado VALUES (1, 'JUANA', '9 DE JULIO', 'TRELEW');
INSERT INTO empleado VALUES (2, 'TOMAS', '25 DE MAYO', 'RAWSON');
INSERT INTO empleado VALUES (3, 'ALEJO', 'BELGRANO', 'TRELEW');


INSERT INTO empresa VALUES (1, 'UNPSJB', 'Trelew');
INSERT INTO empresa VALUES (2, 'banco nacion', 'Trelew')


INSERT INTO trabaja VALUES (1, 1) --JUANA UNPSJB
INSERT INTO trabaja VALUES (2, 2) --TOMAS banco nacion
INSERT INTO trabaja VALUES (3, 1) --ALEJO UNPSJB
INSERT INTO trabaja VALUES (3, 2) --ALEJO banco nacion
INSERT INTO trabaja VALUES (3, 3) --ALEJO STJ



SELECT * FROM empleado;
SELECT * FROM empresa;
SELECT * FROM trabaja;
SELECT * FROM jefeemp;

INSERT INTO jefe VALUES (3, 3);     -- NO SE PERMITE POR LA REGLA CHECK
INSERT INTO jefe VALUES (50, 1);    -- NO SE PERMITE PORQUE NO EXISTE EL EMPLEADO
INSERT INTO jefe VALUES (1, 2);
INSERT INTO jefe VALUES (2, 3);
INSERT INTO jefe VALUES (2, 3);     -- SE PERMITE LA PRIMERA, NO POR SEGUNDA VEZ
INSERT INTO jefe VALUES (1, 3);
INSERT INTO jefe VALUES (1, 50);    -- NO SE PERMITE PORQUE NO EXISTE EL JEFE

