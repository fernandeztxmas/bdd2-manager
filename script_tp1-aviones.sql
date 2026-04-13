--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: avion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE avion (
    "nroAvion" integer NOT NULL,
    "tipoModelo" integer,
    "año" integer,
    "horasVuelo" integer
);


ALTER TABLE avion OWNER TO postgres;

--
-- Name: falla; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE falla (
    "tipoFalla" integer NOT NULL,
    descripcion character(50)
);


ALTER TABLE falla OWNER TO postgres;

--
-- Name: localidad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE localidad (
    "idLocalidad" integer NOT NULL,
    "nombreLocalidad" character(50)
);


ALTER TABLE localidad OWNER TO postgres;

--
-- Name: modeloAvion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "modeloAvion" (
    "tipoModelo" integer NOT NULL,
    descripcion character(50),
    capacidad integer
);


ALTER TABLE "modeloAvion" OWNER TO postgres;

--
-- Name: piloto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE piloto (
    "dniPiloto" integer NOT NULL,
    "nroLicencia" integer,
    "horasVuelo" real,
    "fechaInicio" date
);


ALTER TABLE piloto OWNER TO postgres;

--
-- Name: pilotoAvion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "pilotoAvion" (
    "dniPiloto" integer NOT NULL,
    "nroAvion" integer NOT NULL
);


ALTER TABLE "pilotoAvion" OWNER TO postgres;

--
-- Name: trabajador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE trabajador (
    dni integer NOT NULL,
    nombre character(50),
    direccion character(50),
    "idLocalidad" integer,
    telefono character(30),
    "valorHora" real
);


ALTER TABLE trabajador OWNER TO postgres;

--
-- Name: trabajadorReparacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE "trabajadorReparacion" (
    "dniTrabajador" integer NOT NULL,
    "nroAvion" integer NOT NULL,
    "fechaInicioReparacion" date NOT NULL,
    "fechaFinReparacion" date,
    "tipoFallaReparada" integer
);


ALTER TABLE "trabajadorReparacion" OWNER TO postgres;

--
-- Data for Name: avion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY avion ("nroAvion", "tipoModelo", "año", "horasVuelo") FROM stdin;
1000	10	1989	5600
1001	10	1996	780
1002	11	2000	500
1003	12	2001	640
1004	12	2003	700
1005	11	2009	50
\.


--
-- Data for Name: falla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY falla ("tipoFalla", descripcion) FROM stdin;
1	Falla en turbina                                  
2	Flap oscilante                                    
3	Tren de aterrizaje perezoso                       
4	Bomba de combustible fallada                      
\.


--
-- Data for Name: localidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY localidad ("idLocalidad", "nombreLocalidad") FROM stdin;
9100	Trelew                                            
9105	Gaiman                                            
9103	Rawson                                            
9200	Esquel                                            
9000	Comodoro Rivadavia                                
\.


--
-- Data for Name: modeloAvion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "modeloAvion" ("tipoModelo", descripcion, capacidad) FROM stdin;
10	Boeing 737                                        	250
11	Boeing 747                                        	120
12	Embraer 750                                       	150
\.


--
-- Data for Name: piloto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY piloto ("dniPiloto", "nroLicencia", "horasVuelo", "fechaInicio") FROM stdin;
3	992	4000	2000-01-03
2	102	5000	1978-03-04
1	100	8900	1974-07-05
\.


--
-- Data for Name: pilotoAvion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "pilotoAvion" ("dniPiloto", "nroAvion") FROM stdin;
1	1000
3	1000
3	1001
3	1002
2	1001
2	1002
1	1004
\.


--
-- Data for Name: trabajador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY trabajador (dni, nombre, direccion, "idLocalidad", telefono, "valorHora") FROM stdin;
1	Trabajador 1                                      	Dir. 1                                            	9100	1                             	100
2	Trabajador 2                                      	Dir. 2                                            	9100	2                             	102
3	Trabajador 3                                      	Dir. 3                                            	9000	3                             	103
4	Trabajador 4                                      	Dir. 4                                            	9000	4                             	104
5	Trabajador 5                                      	Dir. 5                                            	9200	5                             	105
\.


--
-- Data for Name: trabajadorReparacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY "trabajadorReparacion" ("dniTrabajador", "nroAvion", "fechaInicioReparacion", "fechaFinReparacion", "tipoFallaReparada") FROM stdin;
4	1000	2011-11-10	2011-12-20	1
4	1001	2011-12-10	2012-01-31	2
4	1001	2012-01-10	2012-01-31	3
4	1000	2011-12-30	2012-01-10	4
\.


--
-- Name: avion pkAvion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avion
    ADD CONSTRAINT "pkAvion" PRIMARY KEY ("nroAvion");


--
-- Name: falla pkFalla; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY falla
    ADD CONSTRAINT "pkFalla" PRIMARY KEY ("tipoFalla");


--
-- Name: localidad pkLocalidad; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY localidad
    ADD CONSTRAINT "pkLocalidad" PRIMARY KEY ("idLocalidad");


--
-- Name: modeloAvion pkModeloAvion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "modeloAvion"
    ADD CONSTRAINT "pkModeloAvion" PRIMARY KEY ("tipoModelo");


--
-- Name: piloto pkPiloto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY piloto
    ADD CONSTRAINT "pkPiloto" PRIMARY KEY ("dniPiloto");


--
-- Name: pilotoAvion pkPilotoAvion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "pilotoAvion"
    ADD CONSTRAINT "pkPilotoAvion" PRIMARY KEY ("dniPiloto", "nroAvion");


--
-- Name: trabajador pkTrabajador; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajador
    ADD CONSTRAINT "pkTrabajador" PRIMARY KEY (dni);


--
-- Name: trabajadorReparacion pkTrabajadorReparacion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "trabajadorReparacion"
    ADD CONSTRAINT "pkTrabajadorReparacion" PRIMARY KEY ("dniTrabajador", "nroAvion", "fechaInicioReparacion");


--
-- Name: pilotoAvion fkAvion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "pilotoAvion"
    ADD CONSTRAINT "fkAvion" FOREIGN KEY ("nroAvion") REFERENCES avion("nroAvion");


--
-- Name: trabajadorReparacion fkAvion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "trabajadorReparacion"
    ADD CONSTRAINT "fkAvion" FOREIGN KEY ("nroAvion") REFERENCES avion("nroAvion");


--
-- Name: trabajadorReparacion fkFalla; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "trabajadorReparacion"
    ADD CONSTRAINT "fkFalla" FOREIGN KEY ("tipoFallaReparada") REFERENCES falla("tipoFalla");


--
-- Name: trabajador fkLocalidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY trabajador
    ADD CONSTRAINT "fkLocalidad" FOREIGN KEY ("idLocalidad") REFERENCES localidad("idLocalidad");


--
-- Name: pilotoAvion fkPiloto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "pilotoAvion"
    ADD CONSTRAINT "fkPiloto" FOREIGN KEY ("dniPiloto") REFERENCES piloto("dniPiloto");


--
-- Name: avion fkTipoModelo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY avion
    ADD CONSTRAINT "fkTipoModelo" FOREIGN KEY ("tipoModelo") REFERENCES "modeloAvion"("tipoModelo");


--
-- Name: piloto fkTrabajador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY piloto
    ADD CONSTRAINT "fkTrabajador" FOREIGN KEY ("dniPiloto") REFERENCES trabajador(dni);


--
-- Name: trabajadorReparacion fkTrabajador; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY "trabajadorReparacion"
    ADD CONSTRAINT "fkTrabajador" FOREIGN KEY ("dniTrabajador") REFERENCES trabajador(dni);


--
-- PostgreSQL database dump complete
--

