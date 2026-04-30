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


-- ============================================================
-- TRIGGERS sobre la tabla avion
-- ============================================================

-- Función reutilizable para ambos triggers.
-- TG_TABLE_NAME → nombre de la tabla que disparó el trigger (automático)
-- TG_OP         → operación que lo disparó: 'INSERT', 'DELETE', etc. (automático)
CREATE OR REPLACE FUNCTION fn_audit_avion()
RETURNS trigger AS $$
BEGIN
    INSERT INTO audit (tabla, tipo_operacion, usuario, fecha_hora)
    VALUES (TG_TABLE_NAME, TG_OP, current_user, current_timestamp);

    -- En INSERT devolvemos NEW, en DELETE devolvemos OLD
    -- AFTER trigger → el valor de retorno no afecta la operación original,
    -- pero igual hay que retornar algo no-NULL para que no cancele.
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger para INSERCION sobre avion
CREATE TRIGGER tg_audit_avion_insert
    AFTER INSERT ON avion
    FOR EACH ROW
    EXECUTE PROCEDURE fn_audit_avion();

-- Trigger para ELIMINACION sobre avion
CREATE TRIGGER tg_audit_avion_delete
    AFTER DELETE ON avion
    FOR EACH ROW
    EXECUTE PROCEDURE fn_audit_avion();


-- ============================================================
-- PRUEBAS DE LOS TRIGGERS
-- ============================================================

-- INSERT: debería disparar tg_audit_avion_insert y registrar en audit
INSERT INTO avion ("nroAvion", "tipoModelo", "año", "horasVuelo") VALUES (999, 737, 2020, 1500);

-- DELETE: debería disparar tg_audit_avion_delete y registrar en audit
DELETE FROM avion WHERE nroAvion = 999;

-- Verificar que quedaron los dos registros de auditoría (uno INSERT, uno DELETE)
SELECT * FROM audit;
