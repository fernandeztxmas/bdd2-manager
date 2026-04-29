CREATE OR REPLACE FUNCTION agregar_masivos() RETURNS void AS $$
DECLARE

    MAX_AVIONES CONSTANT integer := 10000;
    MAX_MODELOS CONSTANT integer := 100;

    ultimo_modelo_id  INTEGER;
    nuevo_modelo_id   INTEGER;
    ultimo_avion_id   INTEGER;
    dni_trab          INTEGER;
    falla_id          INTEGER;
    capacidad         INTEGER := 0;
    
BEGIN
    SELECT COALESCE(MAX("tipoModelo"), 0) INTO ultimo_modelo_id FROM "modeloAvion";
    SELECT COALESCE(MAX("nroAvion"),   0) INTO ultimo_avion_id  FROM avion;

    SELECT dni INTO dni_trab FROM trabajador ORDER BY RANDOM() LIMIT 1;
    SELECT "tipoFalla" INTO falla_id FROM falla ORDER BY RANDOM() LIMIT 1;

    -- Bucle para insertar la cantidad de modelos deseados
    FOR i IN 1..MAX_MODELOS LOOP

        nuevo_modelo_id := ultimo_modelo_id + i;
        capacidad       := capacidad + 1;

        INSERT INTO "modeloAvion" ("tipoModelo", descripcion, capacidad)
        VALUES (nuevo_modelo_id, 'Boeing ' || nuevo_modelo_id, capacidad);

        -- Bucle para insertar los aviones de cada modelo
        FOR j IN 1..MAX_AVIONES LOOP

            ultimo_avion_id := ultimo_avion_id + 1;

            INSERT INTO avion ("nroAvion", "tipoModelo", "año", "horasVuelo")
            VALUES (ultimo_avion_id, nuevo_modelo_id, 2025, j);

            INSERT INTO "trabajadorReparacion" (
                "dniTrabajador", "nroAvion",
                "fechaInicioReparacion", "fechaFinReparacion",
                "tipoFallaReparada"
            )
            VALUES (
                dni_trab,
                ultimo_avion_id,
                CURRENT_DATE,
                CURRENT_DATE + INTERVAL '10 days',
                falla_id
            );

        END LOOP;
        RAISE NOTICE 'Finalizada la carga de % aviones para el modelo % con capacidad %', MAX_AVIONES, nuevo_modelo_id, capacidad;
        
    END LOOP;
    RAISE NOTICE 'Finalizada la carga de % modelos', MAX_MODELOS;

END;
$$ LANGUAGE plpgsql;

SELECT agregar_masivos();