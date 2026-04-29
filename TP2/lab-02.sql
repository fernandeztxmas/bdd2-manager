-- ============================================================
-- TABLA AUDIT - TP2 - Base de Datos: tp1-Aviones
-- ============================================================

CREATE OR REPLACE FUNCTION tabla_existe(nombre_tabla text)
RETURNS boolean AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
          AND table_type   = 'BASE TABLE'
          AND table_name   = nombre_tabla
    );
END;
$$ LANGUAGE plpgsql;

-- PASO 2: Crear la tabla audit
CREATE TABLE audit (tabla text NOT NULL CONSTRAINT chk_tabla_existe CHECK (tabla_existe(tabla)),

    tipo_operacion  char(6) NOT NULL CONSTRAINT chk_tipo_operacion CHECK (tipo_operacion IN ('SELECT', 'INSERT', 'DELETE', 'UPDATE')),
    usuario text NOT NULL,
    fecha_hora timestamp NOT NULL DEFAULT current_timestamp
);


-- ============================================================
-- PRUEBAS
-- ============================================================

INSERT INTO audit (tabla, tipo_operacion, usuario) VALUES ('avion', 'INSERT', current_user);

INSERT INTO audit (tabla, tipo_operacion, usuario) VALUES ('avion', 'MERGE', current_user);

INSERT INTO audit (tabla, tipo_operacion, usuario) VALUES ('tabla_inventada', 'DELETE', current_user);

SELECT * FROM audit;
