DO $$
DECLARE

    MAX_AVIONES CONSTANT integer := 10000;
    MAX_MODELOS CONSTANT integer := 5;

    -- Variables para datos aleatorios
    dni_random integer;
    falla_random integer;
    id_nuevo_modelo integer;
    nro_nuevo_avion integer;
    
    cont_model integer; -- Contador para los modelos
    cont_avion integer; -- Contador para los aviones

BEGIN
    SELECT MAX("tipoModelo") + 1 INTO id_nuevo_modelo FROM avion;
    SELECT MAX("nroAvion") + 1 INTO nro_nuevo_avion FROM avion;
    
    -- Insertamos 5 modelos
    FOR cont_model IN 1..MAX_MODELOS LOOP
        
        -- 1. Insertar el Modelo de Avión
        INSERT INTO "modeloAvion" ("tipoModelo", descripcion, capacidad)
        VALUES (id_nuevo_modelo, 'Modelo Estandar ' || cont_model, 250);

        -- 2. Bucle para insertar 10.000 aviones por cada modelo
        FOR cont_avion IN 1..MAX_AVIONES LOOP        
            -- Obtener un trabajador y una falla al azar para la reparación
            SELECT dni INTO dni_random FROM trabajador ORDER BY random() LIMIT 1;
            SELECT "tipoFalla" INTO falla_random FROM falla ORDER BY random() LIMIT 1;

            -- 3. Insertar el Avión
            INSERT INTO avion ("nroAvion", "tipoModelo", "año", "horasVuelo")
            VALUES (nro_nuevo_avion, id_nuevo_modelo, floor(random() * (2025 - 1980 + 1) + 1980)::int, floor(random() * (10000 - 10 + 1) + 10)::int);

            -- 4. Insertar la Reparación (trabajadorReparacion)
            -- Usamos la fecha actual como inicio
            INSERT INTO "trabajadorReparacion" ("dniTrabajador", "nroAvion", "fechaInicioReparacion", "fechaFinReparacion", "tipoFallaReparada")
            VALUES (dni_random, nro_nuevo_avion, CURRENT_DATE, CURRENT_DATE + 1, falla_random);

            -- Incrementar el contador de número de avión para que sea único
            nro_nuevo_avion := nro_nuevo_avion + 1;
        END LOOP;
        RAISE NOTICE 'Finalizada la carga de % aviones para el modelo %', MAX_AVIONES, id_nuevo_modelo;
        id_nuevo_modelo := id_nuevo_modelo + 1;
    END LOOP;
    RAISE NOTICE 'Finalizada la carga de % modelos', MAX_MODELOS;

    -- Verificación de la "EstadísticaV" (Suma de capacidades)
    RAISE NOTICE 'Capacidad total actual en modeloAvion: %', (SELECT SUM(capacidad) FROM "modeloAvion");
END $$;