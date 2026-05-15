
CREATE TABLE BANCOS (
    codigo_banco CHAR(5)      PRIMARY KEY,
    nombre       VARCHAR(100)
);
CREATE DOMAIN TipoDeTitular AS CHAR(10)
    CHECK (VALUE IN ('titular', 'firmante'));
CREATE TYPE TipoTitular AS (
    dni    CHAR(11),
    nombre VARCHAR(100),
    tipo   TipoDeTitular
);
CREATE TABLE CUENTAS (
    banco CHAR(5),
    cbu CHAR(22),
    tipo CHAR(2),
    titulares TipoTitular[],
    saldo REAL,
    PRIMARY KEY (cbu),
    CONSTRAINT fk_banco
        FOREIGN KEY (banco)
        REFERENCES bancos(codigo_banco),
    CONSTRAINT chk_tipo_cuenta
        CHECK (tipo IN ('CA', 'CC')),
    CONSTRAINT chk_saldo
        CHECK (saldo > 0)
);


-- Primero insertamos un par de bancos
INSERT INTO BANCOS (codigo_banco, nombre) VALUES 
('GALIC', 'Banco Galicia'),
('NCMAC', 'Banco Macro'),
('SANTD', 'Banco Santander');

-- Luego insertamos cuentas con diferentes cantidades de titulares
INSERT INTO CUENTAS (banco, cbu, tipo, titulares, saldo) VALUES 

-- Cuenta 1: Solo tiene un titular (1 elemento en el array)
('GALIC', '1111000011110000111101', 'CA', 
 ARRAY[
    ROW('11111111', 'Juan Perez', 'titular')::TipoTitular
 ], 
 50000),

-- Cuenta 2: Tiene un titular y un firmante (2 elementos en el array)
('GALIC', '1111000011110000111102', 'CC', 
 ARRAY[
    ROW('22222222', 'Maria Lopez', 'titular')::TipoTitular,
    ROW('33333333', 'Carlos Gomez', 'firmante')::TipoTitular
 ], 
 150000),

-- Cuenta 3: Tiene un titular y DOS firmantes (3 elementos en el array)
('NCMAC', '2222000022220000222201', 'CC', 
 ARRAY[
    ROW('44444444', 'Ana Martinez', 'titular')::TipoTitular,
    ROW('55555555', 'Luis Suarez', 'firmante')::TipoTitular,
    ROW('66666666', 'Elena Diaz', 'firmante')::TipoTitular
 ], 
 500000),

-- Cuenta 4: Otra Caja de Ahorro con un solo titular (1 elemento)
('SANTD', '3333000033330000333301', 'CA', 
 ARRAY[
    ROW('77777777', 'Pablo Fernandez', 'titular')::TipoTitular
 ], 
 15000);
-- Luego insertamos cuentas con diferentes cantidades de titulares
INSERT INTO CUENTAS (banco, cbu, tipo, titulares, saldo) VALUES 

 -- Cuenta 3: Tiene un titular y DOS firmantes (3 elementos en el array)
('NCMAC', '2222000022220000222251', 'CA', 
 ARRAY[
    ROW('44443444', 'JUANA Martinez', 'firmante')::TipoTitular,
    ROW('55554555', 'NEI Suarez', 'firmante')::TipoTitular,
    ROW('66663666', 'MESSI Diaz', 'firmante')::TipoTitular
 ], 
 500000),;

-- Luego insertamos cuentas con diferentes cantidades de titulares
INSERT INTO CUENTAS (banco, cbu, tipo, titulares, saldo) VALUES 

 ('NCMAC', '2222000022220000222355', 'CA', 
 ARRAY[
    ROW('44343444', 'juana2 Martinez', 'firmante')::TipoTitular,
    ROW('55354555', 'nei2 Suarez', 'firmante')::TipoTitular
 ], 
 500000),;

UPDATE CUENTAS
SET titulares = (
    SELECT ARRAY_AGG(
        CASE 
            -- Si encontramos al que queremos cambiar (ej: por su DNI), le armamos la fila nueva
            WHEN t.dni = '55554555' THEN ROW(t.dni, t.nombre, 'titular')::TipoTitular
            -- A todos los demás, los devolvemos intactos
            ELSE t 
        END
    )
    FROM UNNEST(titulares) t  -- Desempaquetamos el arreglo de ESTA cuenta
)
WHERE cbu = '2222000022220000222251';



a. Hallar los CBU de las cuentas tipo CA donde todos sus titulares sean firmantes.

SELECT c.cbu, c.tipo
FROM CUENTAS c
WHERE c.tipo = 'CA'
  AND NOT EXISTS (
      -- Buscamos si hay algún intruso que sea 'titular'
      SELECT 1
      FROM UNNEST(c.titulares) t
      WHERE t.tipo = 'titular'  -- (o t.tipo != 'firmante')
  );
b. Desanidar la tabla CUENTAS para mostrarla en 1FN

SELECT 
    c.banco, 
    c.cbu, 
    c.tipo AS tipo_cuenta, 
    c.saldo, 
    t.dni, 
    t.nombre, 
    t.tipo AS rol_titular
FROM CUENTAS c, UNNEST(c.titulares) t;

c. Mostrar los nombres de los ‘firmantes’ de las cuentas tipo CC

SELECT t.nombre, c.tipo
FROM cuentas c, UNNEST(c.titulares) t
WHERE c.tipo = 'CC'
  AND t.tipo = 'firmante';