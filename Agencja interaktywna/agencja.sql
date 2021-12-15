--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.0
-- Started on 2016-02-03 18:42:31

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 191 (class 3079 OID 12478)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2742 (class 0 OID 0)
-- Dependencies: 191
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 192 (class 1255 OID 16824)
-- Name: podlicz_uslugi(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION podlicz_uslugi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE	suma NUMERIC;
BEGIN
	suma := (SELECT cena FROM usluga WHERE usluga_id = NEW.usluga_id );
	suma := suma * NEW.ilosc;

	INSERT INTO
		zaplata
		(zlecenie_usluga_id,termin,wartosc)
	VALUES
		(NEW.zlecenie_usluga_id,(NEW.koniec + interval '1 week'),suma);
RETURN NEW;
END$$;


ALTER FUNCTION public.podlicz_uslugi() OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 16867)
-- Name: usun_usluge(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION usun_usluge() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF OLD.kontrahent_id IS NOT NULL THEN
		RAISE EXCEPTION 'Cant delete becouse contractor order was already made';
	END IF;

	IF TRUE IN (SELECT status FROM zaplata WHERE zlecenie_usluga_id = OLD.zlecenie_usluga_id  ) THEN
		RAISE EXCEPTION 'Cant delete becouse already paid';
	END IF;
	RETURN OLD;
END$$;


ALTER FUNCTION public.usun_usluge() OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 16865)
-- Name: zmiany_ilosci(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION zmiany_ilosci() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF OLD.ilosc <> NEW.ilosc THEN
		RAISE EXCEPTION 'Cant change amount now. Delete, and create new.';
	END IF;

	IF OLD.usluga_id <> NEW.usluga_id THEN
		RAISE EXCEPTION 'Cant change service now. Delete, and create new.';
	END IF;
	
	RETURN NEW;	
END;$$;


ALTER FUNCTION public.zmiany_ilosci() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 175 (class 1259 OID 16695)
-- Name: adres; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE adres (
    adres_id integer NOT NULL,
    ulica character varying,
    budynek character varying,
    kod_pocztowy character varying,
    miejscowosc character varying
);


ALTER TABLE adres OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 16693)
-- Name: adres_adres_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE adres_adres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE adres_adres_id_seq OWNER TO postgres;

--
-- TOC entry 2743 (class 0 OID 0)
-- Dependencies: 174
-- Name: adres_adres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE adres_adres_id_seq OWNED BY adres.adres_id;


--
-- TOC entry 177 (class 1259 OID 16706)
-- Name: firma; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE firma (
    firma_id integer NOT NULL,
    adres_id integer NOT NULL,
    nazwa character varying,
    nip character varying,
    regon character varying,
    telefon character varying,
    email character varying
);


ALTER TABLE firma OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 16704)
-- Name: firma_firma_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE firma_firma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE firma_firma_id_seq OWNER TO postgres;

--
-- TOC entry 2744 (class 0 OID 0)
-- Dependencies: 176
-- Name: firma_firma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE firma_firma_id_seq OWNED BY firma.firma_id;


--
-- TOC entry 173 (class 1259 OID 16684)
-- Name: klient; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE klient (
    klient_id integer NOT NULL,
    adres_id integer,
    firma_id integer,
    imie character varying,
    nazwisko character varying,
    telefon character varying,
    email character varying
);


ALTER TABLE klient OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 16682)
-- Name: klient_klient_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE klient_klient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE klient_klient_id_seq OWNER TO postgres;

--
-- TOC entry 2745 (class 0 OID 0)
-- Dependencies: 172
-- Name: klient_klient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE klient_klient_id_seq OWNED BY klient.klient_id;


--
-- TOC entry 189 (class 1259 OID 16798)
-- Name: kontrahent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE kontrahent (
    kontrahent_id integer NOT NULL,
    firma_id integer NOT NULL,
    ilosc real NOT NULL,
    cena numeric NOT NULL
);


ALTER TABLE kontrahent OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 16796)
-- Name: kontrahent_kontrahent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE kontrahent_kontrahent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE kontrahent_kontrahent_id_seq OWNER TO postgres;

--
-- TOC entry 2746 (class 0 OID 0)
-- Dependencies: 188
-- Name: kontrahent_kontrahent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE kontrahent_kontrahent_id_seq OWNED BY kontrahent.kontrahent_id;


--
-- TOC entry 179 (class 1259 OID 16732)
-- Name: pracownik; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pracownik (
    pracownik_id integer NOT NULL,
    imie character varying,
    nazwisko character varying,
    stanowisko character varying
);


ALTER TABLE pracownik OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 16730)
-- Name: pracownik_pracownik_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pracownik_pracownik_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pracownik_pracownik_id_seq OWNER TO postgres;

--
-- TOC entry 2747 (class 0 OID 0)
-- Dependencies: 178
-- Name: pracownik_pracownik_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE pracownik_pracownik_id_seq OWNED BY pracownik.pracownik_id;


--
-- TOC entry 187 (class 1259 OID 16786)
-- Name: usluga; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE usluga (
    usluga_id integer NOT NULL,
    nazwa text,
    opis text,
    cena numeric NOT NULL
);


ALTER TABLE usluga OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16784)
-- Name: usluga_usluga_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE usluga_usluga_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usluga_usluga_id_seq OWNER TO postgres;

--
-- TOC entry 2748 (class 0 OID 0)
-- Dependencies: 186
-- Name: usluga_usluga_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE usluga_usluga_id_seq OWNED BY usluga.usluga_id;


--
-- TOC entry 185 (class 1259 OID 16769)
-- Name: zaplata; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE zaplata (
    zaplata_id integer NOT NULL,
    zlecenie_usluga_id integer NOT NULL,
    termin date,
    wartosc numeric,
    status boolean DEFAULT false
);


ALTER TABLE zaplata OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 16767)
-- Name: zaplata_zaplata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE zaplata_zaplata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zaplata_zaplata_id_seq OWNER TO postgres;

--
-- TOC entry 2749 (class 0 OID 0)
-- Dependencies: 184
-- Name: zaplata_zaplata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE zaplata_zaplata_id_seq OWNED BY zaplata.zaplata_id;


--
-- TOC entry 181 (class 1259 OID 16743)
-- Name: zlecenie; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE zlecenie (
    zlecenie_id integer NOT NULL,
    klient_id integer NOT NULL,
    pracownik_id integer NOT NULL
);


ALTER TABLE zlecenie OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 16761)
-- Name: zlecenie_usluga; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE zlecenie_usluga (
    zlecenie_usluga_id integer NOT NULL,
    zlecenie_id integer NOT NULL,
    usluga_id integer NOT NULL,
    kontrahent_id integer,
    start date DEFAULT now() NOT NULL,
    koniec date DEFAULT (now() + '7 days'::interval) NOT NULL,
    ilosc real NOT NULL
);


ALTER TABLE zlecenie_usluga OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 16759)
-- Name: zlecenie_usluga_zlecenie_usluga_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE zlecenie_usluga_zlecenie_usluga_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zlecenie_usluga_zlecenie_usluga_id_seq OWNER TO postgres;

--
-- TOC entry 2750 (class 0 OID 0)
-- Dependencies: 182
-- Name: zlecenie_usluga_zlecenie_usluga_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE zlecenie_usluga_zlecenie_usluga_id_seq OWNED BY zlecenie_usluga.zlecenie_usluga_id;


--
-- TOC entry 180 (class 1259 OID 16741)
-- Name: zlecenie_zlecenie_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE zlecenie_zlecenie_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zlecenie_zlecenie_id_seq OWNER TO postgres;

--
-- TOC entry 2751 (class 0 OID 0)
-- Dependencies: 180
-- Name: zlecenie_zlecenie_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE zlecenie_zlecenie_id_seq OWNED BY zlecenie.zlecenie_id;


--
-- TOC entry 2566 (class 2604 OID 16698)
-- Name: adres_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY adres ALTER COLUMN adres_id SET DEFAULT nextval('adres_adres_id_seq'::regclass);


--
-- TOC entry 2567 (class 2604 OID 16709)
-- Name: firma_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY firma ALTER COLUMN firma_id SET DEFAULT nextval('firma_firma_id_seq'::regclass);


--
-- TOC entry 2565 (class 2604 OID 16687)
-- Name: klient_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY klient ALTER COLUMN klient_id SET DEFAULT nextval('klient_klient_id_seq'::regclass);


--
-- TOC entry 2576 (class 2604 OID 16801)
-- Name: kontrahent_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY kontrahent ALTER COLUMN kontrahent_id SET DEFAULT nextval('kontrahent_kontrahent_id_seq'::regclass);


--
-- TOC entry 2568 (class 2604 OID 16735)
-- Name: pracownik_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pracownik ALTER COLUMN pracownik_id SET DEFAULT nextval('pracownik_pracownik_id_seq'::regclass);


--
-- TOC entry 2575 (class 2604 OID 16789)
-- Name: usluga_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usluga ALTER COLUMN usluga_id SET DEFAULT nextval('usluga_usluga_id_seq'::regclass);


--
-- TOC entry 2573 (class 2604 OID 16772)
-- Name: zaplata_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zaplata ALTER COLUMN zaplata_id SET DEFAULT nextval('zaplata_zaplata_id_seq'::regclass);


--
-- TOC entry 2569 (class 2604 OID 16746)
-- Name: zlecenie_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zlecenie ALTER COLUMN zlecenie_id SET DEFAULT nextval('zlecenie_zlecenie_id_seq'::regclass);


--
-- TOC entry 2570 (class 2604 OID 16764)
-- Name: zlecenie_usluga_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zlecenie_usluga ALTER COLUMN zlecenie_usluga_id SET DEFAULT nextval('zlecenie_usluga_zlecenie_usluga_id_seq'::regclass);


--
-- TOC entry 2720 (class 0 OID 16695)
-- Dependencies: 175
-- Data for Name: adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO adres VALUES (1, 'Bałtycka', '28', '70-881', 'Szczecin');
INSERT INTO adres VALUES (2, 'Zacisze', '6, 1 piętro', '60-831', 'Poznań');
INSERT INTO adres VALUES (3, 'Ogińskiego Michała Kleofasa', '11/332a', '03-345', 'Warszawa');
INSERT INTO adres VALUES (4, 'Herberta', '140 lok. 327', '15-779', 'Białystok');
INSERT INTO adres VALUES (5, '6 Sierpnia', '68A', '90-645', 'Łódź');
INSERT INTO adres VALUES (6, 'Aleje Zielone', '57', '00-530', 'Wszyscycowice');


--
-- TOC entry 2752 (class 0 OID 0)
-- Dependencies: 174
-- Name: adres_adres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('adres_adres_id_seq', 6, true);


--
-- TOC entry 2722 (class 0 OID 16706)
-- Dependencies: 177
-- Data for Name: firma; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO firma VALUES (1, 3, 'Drukarnia Rafael', '4238095141', '69085391742800', '72 162 59 03', 'biuro@rafael.pl');
INSERT INTO firma VALUES (2, 4, 'Drukarnia Leyko', '2260804015', '551115222', '12 656 44 87', 'drukarnia@leyko.pl');
INSERT INTO firma VALUES (4, 5, 'Mewa Radio', '6529558596', '55580361271360', '79 256 68 68', 'radio@mewa.so.pl');
INSERT INTO firma VALUES (5, 1, 'Magazyn TNT', '6529488596', '55580369261360', '76 886 68 48', 'tnt@magazyn.pl');


--
-- TOC entry 2753 (class 0 OID 0)
-- Dependencies: 176
-- Name: firma_firma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('firma_firma_id_seq', 5, true);


--
-- TOC entry 2718 (class 0 OID 16684)
-- Dependencies: 173
-- Data for Name: klient; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO klient VALUES (2, 2, NULL, 'Bronisław', 'Walczak', '79 952 19 27', 'bronislaw.walczak@gmail.com');
INSERT INTO klient VALUES (3, 3, 5, 'Jan', 'Nowak', '72 418 68 68', 'nowakos@interia.pl');
INSERT INTO klient VALUES (1, 1, NULL, 'Jolanta', 'Górska', '67 613 75 69', 'jola@teleworm.pl');
INSERT INTO klient VALUES (4, 6, 2, 'Marcin', 'Wschód', '00 568 48 50', 'wschid@marcin.pl');


--
-- TOC entry 2754 (class 0 OID 0)
-- Dependencies: 172
-- Name: klient_klient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('klient_klient_id_seq', 4, true);


--
-- TOC entry 2734 (class 0 OID 16798)
-- Dependencies: 189
-- Data for Name: kontrahent; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO kontrahent VALUES (5, 4, 30, 7.02);
INSERT INTO kontrahent VALUES (6, 4, 30, 4.2);
INSERT INTO kontrahent VALUES (3, 2, 50, 7.5);
INSERT INTO kontrahent VALUES (1, 1, 1000, 2.09);
INSERT INTO kontrahent VALUES (2, 1, 10, 9.81);
INSERT INTO kontrahent VALUES (7, 5, 30, 3.2);
INSERT INTO kontrahent VALUES (8, 5, 30, 1.2);


--
-- TOC entry 2755 (class 0 OID 0)
-- Dependencies: 188
-- Name: kontrahent_kontrahent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('kontrahent_kontrahent_id_seq', 8, true);


--
-- TOC entry 2724 (class 0 OID 16732)
-- Dependencies: 179
-- Data for Name: pracownik; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO pracownik VALUES (1, 'Karina ', 'Kalinowska', 'Project Manager ');
INSERT INTO pracownik VALUES (2, 'Marcin', 'Kucharski', 'Opiekun klienta');
INSERT INTO pracownik VALUES (3, 'Mateusz', 'Sobczak', 'Programista');


--
-- TOC entry 2756 (class 0 OID 0)
-- Dependencies: 178
-- Name: pracownik_pracownik_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('pracownik_pracownik_id_seq', 3, true);


--
-- TOC entry 2732 (class 0 OID 16786)
-- Dependencies: 187
-- Data for Name: usluga; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO usluga VALUES (4, 'Ulotki A5', 'Druk ulotek reklamowych w formacie A5.', 7.45);
INSERT INTO usluga VALUES (2, 'Ulotki A3', 'Druk ulotek reklamowych w formacie A3.', 15.99);
INSERT INTO usluga VALUES (8, 'Strona internetowa', 'Wykonanie strony internetowej', 985.1);
INSERT INTO usluga VALUES (5, 'Radio', 'Reklama w radiu.', 25.99);
INSERT INTO usluga VALUES (7, 'Radio lokalne', 'Reklama w radiu lokalnym.', 9.99);


--
-- TOC entry 2757 (class 0 OID 0)
-- Dependencies: 186
-- Name: usluga_usluga_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('usluga_usluga_id_seq', 8, true);


--
-- TOC entry 2730 (class 0 OID 16769)
-- Dependencies: 185
-- Data for Name: zaplata; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO zaplata VALUES (12, 18, '2016-02-10', 350, false);
INSERT INTO zaplata VALUES (10, 18, '2016-02-17', 449.5, false);
INSERT INTO zaplata VALUES (13, 20, '2016-02-17', 779.7, false);
INSERT INTO zaplata VALUES (14, 21, '2016-01-27', 1559.4, false);
INSERT INTO zaplata VALUES (15, 22, '2016-01-17', 74.5, false);
INSERT INTO zaplata VALUES (11, 19, '2016-02-17', 7450, true);
INSERT INTO zaplata VALUES (16, 23, '2016-02-17', 985.1, false);
INSERT INTO zaplata VALUES (19, 26, '2016-02-17', 9.99, false);
INSERT INTO zaplata VALUES (20, 27, '2016-02-17', 985.1, false);


--
-- TOC entry 2758 (class 0 OID 0)
-- Dependencies: 184
-- Name: zaplata_zaplata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('zaplata_zaplata_id_seq', 21, true);


--
-- TOC entry 2726 (class 0 OID 16743)
-- Dependencies: 181
-- Data for Name: zlecenie; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO zlecenie VALUES (1, 1, 2);
INSERT INTO zlecenie VALUES (2, 1, 3);
INSERT INTO zlecenie VALUES (3, 3, 1);
INSERT INTO zlecenie VALUES (4, 2, 1);


--
-- TOC entry 2728 (class 0 OID 16761)
-- Dependencies: 183
-- Data for Name: zlecenie_usluga; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO zlecenie_usluga VALUES (18, 1, 2, 3, '2016-02-03', '2016-02-10', 50);
INSERT INTO zlecenie_usluga VALUES (20, 2, 5, 5, '2016-02-03', '2016-02-10', 30);
INSERT INTO zlecenie_usluga VALUES (21, 2, 5, 6, '2016-01-15', '2016-01-20', 60);
INSERT INTO zlecenie_usluga VALUES (19, 1, 4, 1, '2016-02-03', '2016-02-10', 1000);
INSERT INTO zlecenie_usluga VALUES (22, 3, 4, 2, '2016-01-10', '2016-01-10', 10);
INSERT INTO zlecenie_usluga VALUES (23, 4, 8, NULL, '2016-02-03', '2016-02-10', 1);
INSERT INTO zlecenie_usluga VALUES (26, 4, 7, NULL, '2016-02-03', '2016-02-10', 1);
INSERT INTO zlecenie_usluga VALUES (27, 4, 8, NULL, '2016-02-03', '2016-02-10', 1);


--
-- TOC entry 2759 (class 0 OID 0)
-- Dependencies: 182
-- Name: zlecenie_usluga_zlecenie_usluga_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('zlecenie_usluga_zlecenie_usluga_id_seq', 28, true);


--
-- TOC entry 2760 (class 0 OID 0)
-- Dependencies: 180
-- Name: zlecenie_zlecenie_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('zlecenie_zlecenie_id_seq', 4, true);


--
-- TOC entry 2580 (class 2606 OID 16703)
-- Name: adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (adres_id);


--
-- TOC entry 2582 (class 2606 OID 16714)
-- Name: firma_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY firma
    ADD CONSTRAINT firma_pkey PRIMARY KEY (firma_id);


--
-- TOC entry 2578 (class 2606 OID 16692)
-- Name: klient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY klient
    ADD CONSTRAINT klient_pkey PRIMARY KEY (klient_id);


--
-- TOC entry 2594 (class 2606 OID 16803)
-- Name: kontrahent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY kontrahent
    ADD CONSTRAINT kontrahent_pkey PRIMARY KEY (kontrahent_id);


--
-- TOC entry 2584 (class 2606 OID 16740)
-- Name: pracownik_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pracownik
    ADD CONSTRAINT pracownik_pkey PRIMARY KEY (pracownik_id);


--
-- TOC entry 2592 (class 2606 OID 16794)
-- Name: usluga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY usluga
    ADD CONSTRAINT usluga_pkey PRIMARY KEY (usluga_id);


--
-- TOC entry 2590 (class 2606 OID 16774)
-- Name: zaplata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY zaplata
    ADD CONSTRAINT zaplata_pkey PRIMARY KEY (zaplata_id);


--
-- TOC entry 2586 (class 2606 OID 16748)
-- Name: zlecenie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY zlecenie
    ADD CONSTRAINT zlecenie_pkey PRIMARY KEY (zlecenie_id);


--
-- TOC entry 2588 (class 2606 OID 16766)
-- Name: zlecenie_usluga_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY zlecenie_usluga
    ADD CONSTRAINT zlecenie_usluga_pkey PRIMARY KEY (zlecenie_usluga_id);


--
-- TOC entry 2607 (class 2620 OID 16868)
-- Name: anuluj_kontrakt; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER anuluj_kontrakt BEFORE DELETE ON zlecenie_usluga FOR EACH ROW EXECUTE PROCEDURE usun_usluge();


--
-- TOC entry 2606 (class 2620 OID 16866)
-- Name: monitoruj_zmiany; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER monitoruj_zmiany BEFORE UPDATE ON zlecenie_usluga FOR EACH ROW EXECUTE PROCEDURE zmiany_ilosci();


--
-- TOC entry 2605 (class 2620 OID 16827)
-- Name: podlicz_do_zaplaty; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER podlicz_do_zaplaty AFTER INSERT ON zlecenie_usluga FOR EACH ROW EXECUTE PROCEDURE podlicz_uslugi();


--
-- TOC entry 2597 (class 2606 OID 16715)
-- Name: firma_adres_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY firma
    ADD CONSTRAINT firma_adres_id_fkey FOREIGN KEY (adres_id) REFERENCES adres(adres_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2595 (class 2606 OID 16720)
-- Name: klient_adres_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY klient
    ADD CONSTRAINT klient_adres_id_fkey FOREIGN KEY (adres_id) REFERENCES adres(adres_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2596 (class 2606 OID 16725)
-- Name: klient_firma_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY klient
    ADD CONSTRAINT klient_firma_id_fkey FOREIGN KEY (firma_id) REFERENCES firma(firma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2604 (class 2606 OID 16840)
-- Name: kontrahent_firma_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY kontrahent
    ADD CONSTRAINT kontrahent_firma_id_fkey FOREIGN KEY (firma_id) REFERENCES firma(firma_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2603 (class 2606 OID 16855)
-- Name: zaplata_zlecenie_usluga_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zaplata
    ADD CONSTRAINT zaplata_zlecenie_usluga_id_fkey FOREIGN KEY (zlecenie_usluga_id) REFERENCES zlecenie_usluga(zlecenie_usluga_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 2598 (class 2606 OID 16749)
-- Name: zlecenie_klient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zlecenie
    ADD CONSTRAINT zlecenie_klient_id_fkey FOREIGN KEY (klient_id) REFERENCES klient(klient_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2599 (class 2606 OID 16754)
-- Name: zlecenie_pracownik_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zlecenie
    ADD CONSTRAINT zlecenie_pracownik_id_fkey FOREIGN KEY (pracownik_id) REFERENCES pracownik(pracownik_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2602 (class 2606 OID 16860)
-- Name: zlecenie_usluga_kontrahent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zlecenie_usluga
    ADD CONSTRAINT zlecenie_usluga_kontrahent_id_fkey FOREIGN KEY (kontrahent_id) REFERENCES kontrahent(kontrahent_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 2601 (class 2606 OID 16819)
-- Name: zlecenie_usluga_usluga_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zlecenie_usluga
    ADD CONSTRAINT zlecenie_usluga_usluga_id_fkey FOREIGN KEY (usluga_id) REFERENCES usluga(usluga_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2600 (class 2606 OID 16809)
-- Name: zlecenie_usluga_zlecenie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY zlecenie_usluga
    ADD CONSTRAINT zlecenie_usluga_zlecenie_id_fkey FOREIGN KEY (zlecenie_id) REFERENCES zlecenie(zlecenie_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 2741 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2016-02-03 18:42:33

--
-- PostgreSQL database dump complete
--

