--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bootcamp; Type: SCHEMA; Schema: -; Owner: bootcamp
--

CREATE SCHEMA bootcamp;


ALTER SCHEMA bootcamp OWNER TO bootcamp;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: countries; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.countries (
    country_id character varying(2) NOT NULL,
    country_name character varying(40),
    region_id integer NOT NULL
);


ALTER TABLE bootcamp.countries OWNER TO bootcamp;

--
-- Name: departments; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.departments (
    department_id integer NOT NULL,
    department_name character varying(30),
    manager_id integer,
    location_id integer
);


ALTER TABLE bootcamp.departments OWNER TO bootcamp;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: bootcamp
--

CREATE SEQUENCE bootcamp.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.departments_department_id_seq OWNER TO bootcamp;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: bootcamp
--

ALTER SEQUENCE bootcamp.departments_department_id_seq OWNED BY bootcamp.departments.department_id;


--
-- Name: employees; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.employees (
    employee_id integer NOT NULL,
    first_name character varying(20),
    last_name character varying(25) NOT NULL,
    email character varying(25) NOT NULL,
    phone_number character varying(20),
    job_id character varying(10),
    salary numeric(8,2),
    commission_pct numeric(2,2),
    manager_id integer,
    department_id integer
);


ALTER TABLE bootcamp.employees OWNER TO bootcamp;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: bootcamp
--

CREATE SEQUENCE bootcamp.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.employees_employee_id_seq OWNER TO bootcamp;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: bootcamp
--

ALTER SEQUENCE bootcamp.employees_employee_id_seq OWNED BY bootcamp.employees.employee_id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE bootcamp.flyway_schema_history OWNER TO bootcamp;

--
-- Name: job_history; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.job_history (
    employee_id integer,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    job_id character varying(10),
    department_id integer
);


ALTER TABLE bootcamp.job_history OWNER TO bootcamp;

--
-- Name: jobs; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.jobs (
    job_id character varying(10) NOT NULL,
    job_title character varying(35),
    min_salary numeric(6,0),
    max_salary numeric(6,0)
);


ALTER TABLE bootcamp.jobs OWNER TO bootcamp;

--
-- Name: locations; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.locations (
    location_id integer NOT NULL,
    street_address character varying(40),
    postal_code character varying(12),
    city character varying(30),
    state_province character varying(25),
    country_id character varying(2)
);


ALTER TABLE bootcamp.locations OWNER TO bootcamp;

--
-- Name: locations_location_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: bootcamp
--

CREATE SEQUENCE bootcamp.locations_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.locations_location_id_seq OWNER TO bootcamp;

--
-- Name: locations_location_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: bootcamp
--

ALTER SEQUENCE bootcamp.locations_location_id_seq OWNED BY bootcamp.locations.location_id;


--
-- Name: regions; Type: TABLE; Schema: bootcamp; Owner: bootcamp
--

CREATE TABLE bootcamp.regions (
    region_id integer NOT NULL,
    region_name character varying(25)
);


ALTER TABLE bootcamp.regions OWNER TO bootcamp;

--
-- Name: regions_region_id_seq; Type: SEQUENCE; Schema: bootcamp; Owner: bootcamp
--

CREATE SEQUENCE bootcamp.regions_region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bootcamp.regions_region_id_seq OWNER TO bootcamp;

--
-- Name: regions_region_id_seq; Type: SEQUENCE OWNED BY; Schema: bootcamp; Owner: bootcamp
--

ALTER SEQUENCE bootcamp.regions_region_id_seq OWNED BY bootcamp.regions.region_id;


--
-- Name: departments department_id; Type: DEFAULT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.departments ALTER COLUMN department_id SET DEFAULT nextval('bootcamp.departments_department_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.employees ALTER COLUMN employee_id SET DEFAULT nextval('bootcamp.employees_employee_id_seq'::regclass);


--
-- Name: locations location_id; Type: DEFAULT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.locations ALTER COLUMN location_id SET DEFAULT nextval('bootcamp.locations_location_id_seq'::regclass);


--
-- Name: regions region_id; Type: DEFAULT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.regions ALTER COLUMN region_id SET DEFAULT nextval('bootcamp.regions_region_id_seq'::regclass);


--
-- Data for Name: countries; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.countries VALUES ('AR', 'Argentina', 2);
INSERT INTO bootcamp.countries VALUES ('AU', 'Australia', 3);
INSERT INTO bootcamp.countries VALUES ('BE', 'Belgium', 1);
INSERT INTO bootcamp.countries VALUES ('BR', 'Brazil', 2);
INSERT INTO bootcamp.countries VALUES ('CA', 'Canada', 2);
INSERT INTO bootcamp.countries VALUES ('CH', 'Switzerland', 1);
INSERT INTO bootcamp.countries VALUES ('CN', 'China', 3);
INSERT INTO bootcamp.countries VALUES ('DE', 'Germany', 1);
INSERT INTO bootcamp.countries VALUES ('DK', 'Denmark', 1);
INSERT INTO bootcamp.countries VALUES ('EG', 'Egypt', 4);
INSERT INTO bootcamp.countries VALUES ('FR', 'France', 1);
INSERT INTO bootcamp.countries VALUES ('HK', 'HongKong', 3);
INSERT INTO bootcamp.countries VALUES ('IL', 'Israel', 4);
INSERT INTO bootcamp.countries VALUES ('IN', 'India', 3);
INSERT INTO bootcamp.countries VALUES ('IT', 'Italy', 1);
INSERT INTO bootcamp.countries VALUES ('JP', 'Japan', 3);
INSERT INTO bootcamp.countries VALUES ('KW', 'Kuwait', 4);
INSERT INTO bootcamp.countries VALUES ('MX', 'Mexico', 2);
INSERT INTO bootcamp.countries VALUES ('NG', 'Nigeria', 4);
INSERT INTO bootcamp.countries VALUES ('NL', 'Netherlands', 1);
INSERT INTO bootcamp.countries VALUES ('SG', 'Singapore', 3);
INSERT INTO bootcamp.countries VALUES ('UK', 'United Kingdom', 1);
INSERT INTO bootcamp.countries VALUES ('US', 'United States of America', 2);
INSERT INTO bootcamp.countries VALUES ('ZM', 'Zambia', 4);
INSERT INTO bootcamp.countries VALUES ('ZW', 'Zimbabwe', 4);


--
-- Data for Name: departments; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.departments VALUES (300, 'System Analis', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (10, 'Administration', 200, 1700);
INSERT INTO bootcamp.departments VALUES (20, 'Marketing', 201, 1800);
INSERT INTO bootcamp.departments VALUES (30, 'Purchasing', 114, 1700);
INSERT INTO bootcamp.departments VALUES (40, 'Human Resources', 203, 2400);
INSERT INTO bootcamp.departments VALUES (50, 'Shipping', 121, 1500);
INSERT INTO bootcamp.departments VALUES (60, 'IT', 103, 1400);
INSERT INTO bootcamp.departments VALUES (70, 'Public Relations', 204, 2700);
INSERT INTO bootcamp.departments VALUES (80, 'Sales', 145, 2500);
INSERT INTO bootcamp.departments VALUES (90, 'Executive', 100, 1700);
INSERT INTO bootcamp.departments VALUES (100, 'Finance', 108, 1700);
INSERT INTO bootcamp.departments VALUES (110, 'Accounting', 205, 1700);
INSERT INTO bootcamp.departments VALUES (120, 'Treasury', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (130, 'Corporate Tax', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (140, 'Control And Credit', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (150, 'Shareholder Services', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (160, 'Benefits', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (170, 'Manufacturing', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (180, 'Construction', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (190, 'Contracting', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (200, 'Operations', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (210, 'IT Support', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (220, 'NOC', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (230, 'IT Helpdesk', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (240, 'Government Sales', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (250, 'Retail Sales', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (260, 'Recruiting', NULL, 1700);
INSERT INTO bootcamp.departments VALUES (270, 'Payroll', NULL, 1700);


--
-- Data for Name: employees; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.employees VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', 'AD_PRES', 24000.00, NULL, NULL, 90);
INSERT INTO bootcamp.employees VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', 'AD_VP', 17000.00, NULL, 100, 90);
INSERT INTO bootcamp.employees VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', 'AD_VP', 17000.00, NULL, 100, 90);
INSERT INTO bootcamp.employees VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', 'IT_PROG', 9000.00, NULL, 102, 60);
INSERT INTO bootcamp.employees VALUES (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', 'IT_PROG', 6000.00, NULL, 103, 60);
INSERT INTO bootcamp.employees VALUES (105, 'David', 'Austin', 'DAUSTIN', '590.423.4569', 'IT_PROG', 4800.00, NULL, 103, 60);
INSERT INTO bootcamp.employees VALUES (106, 'Valli', 'Pataballa', 'VPATABAL', '590.423.4560', 'IT_PROG', 4800.00, NULL, 103, 60);
INSERT INTO bootcamp.employees VALUES (107, 'Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', 'IT_PROG', 4200.00, NULL, 103, 60);
INSERT INTO bootcamp.employees VALUES (108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', 'FI_MGR', 12000.00, NULL, 101, 100);
INSERT INTO bootcamp.employees VALUES (109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', 'FI_ACCOUNT', 9000.00, NULL, 108, 100);
INSERT INTO bootcamp.employees VALUES (110, 'John', 'Chen', 'JCHEN', '515.124.4269', 'FI_ACCOUNT', 8200.00, NULL, 108, 100);
INSERT INTO bootcamp.employees VALUES (111, 'Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', 'FI_ACCOUNT', 7700.00, NULL, 108, 100);
INSERT INTO bootcamp.employees VALUES (112, 'Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', 'FI_ACCOUNT', 7800.00, NULL, 108, 100);
INSERT INTO bootcamp.employees VALUES (113, 'Luis', 'Popp', 'LPOPP', '515.124.4567', 'FI_ACCOUNT', 6900.00, NULL, 108, 100);
INSERT INTO bootcamp.employees VALUES (114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', 'PU_MAN', 11000.00, NULL, 100, 30);
INSERT INTO bootcamp.employees VALUES (115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', 'PU_CLERK', 3100.00, NULL, 114, 30);
INSERT INTO bootcamp.employees VALUES (116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', 'PU_CLERK', 2900.00, NULL, 114, 30);
INSERT INTO bootcamp.employees VALUES (117, 'Sigal', 'Tobias', 'STOBIAS', '515.127.4564', 'PU_CLERK', 2800.00, NULL, 114, 30);
INSERT INTO bootcamp.employees VALUES (118, 'Guy', 'Himuro', 'GHIMURO', '515.127.4565', 'PU_CLERK', 2600.00, NULL, 114, 30);
INSERT INTO bootcamp.employees VALUES (119, 'Karen', 'Colmenares', 'KCOLMENA', '515.127.4566', 'PU_CLERK', 2500.00, NULL, 114, 30);
INSERT INTO bootcamp.employees VALUES (120, 'Matthew', 'Weiss', 'MWEISS', '650.123.1234', 'ST_MAN', 8000.00, NULL, 100, 50);
INSERT INTO bootcamp.employees VALUES (121, 'Adam', 'Fripp', 'AFRIPP', '650.123.2234', 'ST_MAN', 8200.00, NULL, 100, 50);
INSERT INTO bootcamp.employees VALUES (122, 'Payam', 'Kaufling', 'PKAUFLIN', '650.123.3234', 'ST_MAN', 7900.00, NULL, 100, 50);
INSERT INTO bootcamp.employees VALUES (123, 'Shanta', 'Vollman', 'SVOLLMAN', '650.123.4234', 'ST_MAN', 6500.00, NULL, 100, 50);
INSERT INTO bootcamp.employees VALUES (124, 'Kevin', 'Mourgos', 'KMOURGOS', '650.123.5234', 'ST_MAN', 5800.00, NULL, 100, 50);
INSERT INTO bootcamp.employees VALUES (125, 'Julia', 'Nayer', 'JNAYER', '650.124.1214', 'ST_CLERK', 3200.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (126, 'Irene', 'Mikkilineni', 'IMIKKILI', '650.124.1224', 'ST_CLERK', 2700.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (127, 'James', 'Landry', 'JLANDRY', '650.124.1334', 'ST_CLERK', 2400.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (128, 'Steven', 'Markle', 'SMARKLE', '650.124.1434', 'ST_CLERK', 2200.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (129, 'Laura', 'Bissot', 'LBISSOT', '650.124.5234', 'ST_CLERK', 3300.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (130, 'Mozhe', 'Atkinson', 'MATKINSO', '650.124.6234', 'ST_CLERK', 2800.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (131, 'James', 'Marlow', 'JAMRLOW', '650.124.7234', 'ST_CLERK', 2500.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (132, 'TJ', 'Olson', 'TJOLSON', '650.124.8234', 'ST_CLERK', 2100.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (133, 'Jason', 'Mallin', 'JMALLIN', '650.127.1934', 'ST_CLERK', 3300.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (134, 'Michael', 'Rogers', 'MROGERS', '650.127.1834', 'ST_CLERK', 2900.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (135, 'Ki', 'Gee', 'KGEE', '650.127.1734', 'ST_CLERK', 2400.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (136, 'Hazel', 'Philtanker', 'HPHILTAN', '650.127.1634', 'ST_CLERK', 2200.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (137, 'Renske', 'Ladwig', 'RLADWIG', '650.121.1234', 'ST_CLERK', 3600.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (138, 'Stephen', 'Stiles', 'SSTILES', '650.121.2034', 'ST_CLERK', 3200.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (139, 'John', 'Seo', 'JSEO', '650.121.2019', 'ST_CLERK', 2700.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (140, 'Joshua', 'Patel', 'JPATEL', '650.121.1834', 'ST_CLERK', 2500.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (141, 'Trenna', 'Rajs', 'TRAJS', '650.121.8009', 'ST_CLERK', 3500.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (142, 'Curtis', 'Davies', 'CDAVIES', '650.121.2994', 'ST_CLERK', 3100.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (143, 'Randall', 'Matos', 'RMATOS', '650.121.2874', 'ST_CLERK', 2600.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (144, 'Peter', 'Vargas', 'PVARGAS', '650.121.2004', 'ST_CLERK', 2500.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', 'SA_MAN', 14000.00, 0.40, 100, 80);
INSERT INTO bootcamp.employees VALUES (146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', 'SA_MAN', 13500.00, 0.30, 100, 80);
INSERT INTO bootcamp.employees VALUES (147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', 'SA_MAN', 12000.00, 0.30, 100, 80);
INSERT INTO bootcamp.employees VALUES (148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', 'SA_MAN', 11000.00, 0.30, 100, 80);
INSERT INTO bootcamp.employees VALUES (149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', 'SA_MAN', 10500.00, 0.20, 100, 80);
INSERT INTO bootcamp.employees VALUES (150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', 'SA_REP', 10000.00, 0.30, 145, 80);
INSERT INTO bootcamp.employees VALUES (151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', 'SA_REP', 9500.00, 0.25, 145, 80);
INSERT INTO bootcamp.employees VALUES (152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', 'SA_REP', 9000.00, 0.25, 145, 80);
INSERT INTO bootcamp.employees VALUES (153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', 'SA_REP', 8000.00, 0.20, 145, 80);
INSERT INTO bootcamp.employees VALUES (154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', 'SA_REP', 7500.00, 0.20, 145, 80);
INSERT INTO bootcamp.employees VALUES (155, 'Oliver', 'Tuvault', 'OTUVAULT', '011.44.1344.486508', 'SA_REP', 7000.00, 0.15, 145, 80);
INSERT INTO bootcamp.employees VALUES (156, 'Janette', 'King', 'JKING', '011.44.1345.429268', 'SA_REP', 10000.00, 0.35, 146, 80);
INSERT INTO bootcamp.employees VALUES (157, 'Patrick', 'Sully', 'PSULLY', '011.44.1345.929268', 'SA_REP', 9500.00, 0.35, 146, 80);
INSERT INTO bootcamp.employees VALUES (158, 'Allan', 'McEwen', 'AMCEWEN', '011.44.1345.829268', 'SA_REP', 9000.00, 0.35, 146, 80);
INSERT INTO bootcamp.employees VALUES (159, 'Lindsey', 'Smith', 'LSMITH', '011.44.1345.729268', 'SA_REP', 8000.00, 0.30, 146, 80);
INSERT INTO bootcamp.employees VALUES (160, 'Louise', 'Doran', 'LDORAN', '011.44.1345.629268', 'SA_REP', 7500.00, 0.30, 146, 80);
INSERT INTO bootcamp.employees VALUES (161, 'Sarath', 'Sewall', 'SSEWALL', '011.44.1345.529268', 'SA_REP', 7000.00, 0.25, 146, 80);
INSERT INTO bootcamp.employees VALUES (162, 'Clara', 'Vishney', 'CVISHNEY', '011.44.1346.129268', 'SA_REP', 10500.00, 0.25, 147, 80);
INSERT INTO bootcamp.employees VALUES (163, 'Danielle', 'Greene', 'DGREENE', '011.44.1346.229268', 'SA_REP', 9500.00, 0.15, 147, 80);
INSERT INTO bootcamp.employees VALUES (164, 'Mattea', 'Marvins', 'MMARVINS', '011.44.1346.329268', 'SA_REP', 7200.00, 0.10, 147, 80);
INSERT INTO bootcamp.employees VALUES (165, 'David', 'Lee', 'DLEE', '011.44.1346.529268', 'SA_REP', 6800.00, 0.10, 147, 80);
INSERT INTO bootcamp.employees VALUES (166, 'Sundar', 'Ande', 'SANDE', '011.44.1346.629268', 'SA_REP', 6400.00, 0.10, 147, 80);
INSERT INTO bootcamp.employees VALUES (167, 'Amit', 'Banda', 'ABANDA', '011.44.1346.729268', 'SA_REP', 6200.00, 0.10, 147, 80);
INSERT INTO bootcamp.employees VALUES (168, 'Lisa', 'Ozer', 'LOZER', '011.44.1343.929268', 'SA_REP', 11500.00, 0.25, 148, 80);
INSERT INTO bootcamp.employees VALUES (169, 'Harrison', 'Bloom', 'HBLOOM', '011.44.1343.829268', 'SA_REP', 10000.00, 0.20, 148, 80);
INSERT INTO bootcamp.employees VALUES (170, 'Tayler', 'Fox', 'TFOX', '011.44.1343.729268', 'SA_REP', 9600.00, 0.20, 148, 80);
INSERT INTO bootcamp.employees VALUES (171, 'William', 'Smith', 'WSMITH', '011.44.1343.629268', 'SA_REP', 7400.00, 0.15, 148, 80);
INSERT INTO bootcamp.employees VALUES (172, 'Elizabeth', 'Bates', 'EBATES', '011.44.1343.529268', 'SA_REP', 7300.00, 0.15, 148, 80);
INSERT INTO bootcamp.employees VALUES (173, 'Sundita', 'Kumar', 'SKUMAR', '011.44.1343.329268', 'SA_REP', 6100.00, 0.10, 148, 80);
INSERT INTO bootcamp.employees VALUES (174, 'Ellen', 'Abel', 'EABEL', '011.44.1644.429267', 'SA_REP', 11000.00, 0.30, 149, 80);
INSERT INTO bootcamp.employees VALUES (175, 'Alyssa', 'Hutton', 'AHUTTON', '011.44.1644.429266', 'SA_REP', 8800.00, 0.25, 149, 80);
INSERT INTO bootcamp.employees VALUES (176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', 'SA_REP', 8600.00, 0.20, 149, 80);
INSERT INTO bootcamp.employees VALUES (177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', 'SA_REP', 8400.00, 0.20, 149, 80);
INSERT INTO bootcamp.employees VALUES (178, 'Kimberely', 'Grant', 'KGRANT', '011.44.1644.429263', 'SA_REP', 7000.00, 0.15, 149, NULL);
INSERT INTO bootcamp.employees VALUES (179, 'Charles', 'Johnson', 'CJOHNSON', '011.44.1644.429262', 'SA_REP', 6200.00, 0.10, 149, 80);
INSERT INTO bootcamp.employees VALUES (180, 'Winston', 'Taylor', 'WTAYLOR', '650.507.9876', 'SH_CLERK', 3200.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (181, 'Jean', 'Fleaur', 'JFLEAUR', '650.507.9877', 'SH_CLERK', 3100.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (182, 'Martha', 'Sullivan', 'MSULLIVA', '650.507.9878', 'SH_CLERK', 2500.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (183, 'Girard', 'Geoni', 'GGEONI', '650.507.9879', 'SH_CLERK', 2800.00, NULL, 120, 50);
INSERT INTO bootcamp.employees VALUES (184, 'Nandita', 'Sarchand', 'NSARCHAN', '650.509.1876', 'SH_CLERK', 4200.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (185, 'Alexis', 'Bull', 'ABULL', '650.509.2876', 'SH_CLERK', 4100.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (186, 'Julia', 'Dellinger', 'JDELLING', '650.509.3876', 'SH_CLERK', 3400.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (187, 'Anthony', 'Cabrio', 'ACABRIO', '650.509.4876', 'SH_CLERK', 3000.00, NULL, 121, 50);
INSERT INTO bootcamp.employees VALUES (188, 'Kelly', 'Chung', 'KCHUNG', '650.505.1876', 'SH_CLERK', 3800.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (189, 'Jennifer', 'Dilly', 'JDILLY', '650.505.2876', 'SH_CLERK', 3600.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (190, 'Timothy', 'Gates', 'TGATES', '650.505.3876', 'SH_CLERK', 2900.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (191, 'Randall', 'Perkins', 'RPERKINS', '650.505.4876', 'SH_CLERK', 2500.00, NULL, 122, 50);
INSERT INTO bootcamp.employees VALUES (192, 'Sarah', 'Bell', 'SBELL', '650.501.1876', 'SH_CLERK', 4000.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (193, 'Britney', 'Everett', 'BEVERETT', '650.501.2876', 'SH_CLERK', 3900.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (194, 'Samuel', 'McCain', 'SMCCAIN', '650.501.3876', 'SH_CLERK', 3200.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (195, 'Vance', 'Jones', 'VJONES', '650.501.4876', 'SH_CLERK', 2800.00, NULL, 123, 50);
INSERT INTO bootcamp.employees VALUES (196, 'Alana', 'Walsh', 'AWALSH', '650.507.9811', 'SH_CLERK', 3100.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (197, 'Kevin', 'Feeney', 'KFEENEY', '650.507.9822', 'SH_CLERK', 3000.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (198, 'Donald', 'OConnell', 'DOCONNEL', '650.507.9833', 'SH_CLERK', 2600.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (199, 'Douglas', 'Grant', 'DGRANT', '650.507.9844', 'SH_CLERK', 2600.00, NULL, 124, 50);
INSERT INTO bootcamp.employees VALUES (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', 'AD_ASST', 4400.00, NULL, 101, 10);
INSERT INTO bootcamp.employees VALUES (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', 'MK_MAN', 13000.00, NULL, 100, 20);
INSERT INTO bootcamp.employees VALUES (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', 'MK_REP', 6000.00, NULL, 201, 20);
INSERT INTO bootcamp.employees VALUES (203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', 'HR_REP', 6500.00, NULL, 101, 40);
INSERT INTO bootcamp.employees VALUES (204, 'Hermann', 'Baer', 'HBAER', '515.123.8888', 'PR_REP', 10000.00, NULL, 101, 70);
INSERT INTO bootcamp.employees VALUES (205, 'Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', 'AC_MGR', 12000.00, NULL, 101, 110);
INSERT INTO bootcamp.employees VALUES (206, 'William', 'Gietz', 'WGIETZ', '515.123.8181', 'AC_ACCOUNT', 8300.00, NULL, 205, 110);


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.flyway_schema_history VALUES (0, NULL, '<< Flyway Schema Creation >>', 'SCHEMA', '"bootcamp"', NULL, 'bootcamp', '2022-02-06 03:21:01.472064', 0, true);
INSERT INTO bootcamp.flyway_schema_history VALUES (1, '1', 'schema-hr', 'SQL', 'V1__schema-hr.sql', -517226740, 'bootcamp', '2022-02-06 03:21:01.543639', 98, true);


--
-- Data for Name: job_history; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.job_history VALUES (102, '1993-01-13 00:00:00', '1998-07-24 00:00:00', 'IT_PROG', 60);
INSERT INTO bootcamp.job_history VALUES (101, '1989-09-21 00:00:00', '1993-10-27 00:00:00', 'AC_ACCOUNT', 110);
INSERT INTO bootcamp.job_history VALUES (101, '1993-10-28 00:00:00', '1997-03-15 00:00:00', 'AC_MGR', 110);
INSERT INTO bootcamp.job_history VALUES (201, '1996-02-17 00:00:00', '1999-12-19 00:00:00', 'MK_REP', 20);
INSERT INTO bootcamp.job_history VALUES (114, '1998-03-24 00:00:00', '1999-12-31 00:00:00', 'ST_CLERK', 50);
INSERT INTO bootcamp.job_history VALUES (122, '1999-01-01 00:00:00', '1999-12-31 00:00:00', 'ST_CLERK', 50);
INSERT INTO bootcamp.job_history VALUES (200, '1987-09-17 00:00:00', '1993-06-17 00:00:00', 'AD_ASST', 90);
INSERT INTO bootcamp.job_history VALUES (176, '1998-03-24 00:00:00', '1998-12-31 00:00:00', 'SA_REP', 80);
INSERT INTO bootcamp.job_history VALUES (176, '1999-01-01 00:00:00', '1999-12-31 00:00:00', 'SA_MAN', 80);
INSERT INTO bootcamp.job_history VALUES (200, '1994-07-01 00:00:00', '1998-12-31 00:00:00', 'AC_ACCOUNT', 90);


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.jobs VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO bootcamp.jobs VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO bootcamp.jobs VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO bootcamp.jobs VALUES ('FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO bootcamp.jobs VALUES ('FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO bootcamp.jobs VALUES ('AC_MGR', 'Accounting Manager', 8200, 16000);
INSERT INTO bootcamp.jobs VALUES ('AC_ACCOUNT', 'Public Accountant', 4200, 9000);
INSERT INTO bootcamp.jobs VALUES ('SA_MAN', 'Sales Manager', 10000, 20000);
INSERT INTO bootcamp.jobs VALUES ('SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO bootcamp.jobs VALUES ('PU_MAN', 'Purchasing Manager', 8000, 15000);
INSERT INTO bootcamp.jobs VALUES ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);
INSERT INTO bootcamp.jobs VALUES ('ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO bootcamp.jobs VALUES ('ST_CLERK', 'Stock Clerk', 2000, 5000);
INSERT INTO bootcamp.jobs VALUES ('SH_CLERK', 'Shipping Clerk', 2500, 5500);
INSERT INTO bootcamp.jobs VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO bootcamp.jobs VALUES ('MK_MAN', 'Marketing Manager', 9000, 15000);
INSERT INTO bootcamp.jobs VALUES ('MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO bootcamp.jobs VALUES ('HR_REP', 'Human Resources Representative', 4000, 9000);
INSERT INTO bootcamp.jobs VALUES ('PR_REP', 'Public Relations Representative', 4500, 10500);


--
-- Data for Name: locations; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.locations VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', '', 'IT');
INSERT INTO bootcamp.locations VALUES (1100, '93091 Calle della Testa', '10934', 'Venice', '', 'IT');
INSERT INTO bootcamp.locations VALUES (1200, '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP');
INSERT INTO bootcamp.locations VALUES (1300, '9450 Kamiya-cho', '6823', 'Hiroshima', '', 'JP');
INSERT INTO bootcamp.locations VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO bootcamp.locations VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO bootcamp.locations VALUES (1600, '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US');
INSERT INTO bootcamp.locations VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO bootcamp.locations VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO bootcamp.locations VALUES (1900, '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA');
INSERT INTO bootcamp.locations VALUES (2000, '40-5-12 Laogianggen', '190518', 'Beijing', '', 'CN');
INSERT INTO bootcamp.locations VALUES (2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN');
INSERT INTO bootcamp.locations VALUES (2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU');
INSERT INTO bootcamp.locations VALUES (2300, '198 Clementi North', '540198', 'Singapore', '', 'SG');
INSERT INTO bootcamp.locations VALUES (2400, '8204 Arthur St', '', 'London', '', 'UK');
INSERT INTO bootcamp.locations VALUES (2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');
INSERT INTO bootcamp.locations VALUES (2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK');
INSERT INTO bootcamp.locations VALUES (2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');
INSERT INTO bootcamp.locations VALUES (2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR');
INSERT INTO bootcamp.locations VALUES (2900, '20 Rue des Corps-Saints', '1730', 'Geneva', 'Geneve', 'CH');
INSERT INTO bootcamp.locations VALUES (3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH');
INSERT INTO bootcamp.locations VALUES (3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL');
INSERT INTO bootcamp.locations VALUES (3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal,', 'MX');


--
-- Data for Name: regions; Type: TABLE DATA; Schema: bootcamp; Owner: bootcamp
--

INSERT INTO bootcamp.regions VALUES (1, 'Europe');
INSERT INTO bootcamp.regions VALUES (2, 'Americas');
INSERT INTO bootcamp.regions VALUES (3, 'Asia');
INSERT INTO bootcamp.regions VALUES (4, 'Middle East and Africa');


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: bootcamp
--

SELECT pg_catalog.setval('bootcamp.departments_department_id_seq', 1, false);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: bootcamp
--

SELECT pg_catalog.setval('bootcamp.employees_employee_id_seq', 1, false);


--
-- Name: locations_location_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: bootcamp
--

SELECT pg_catalog.setval('bootcamp.locations_location_id_seq', 1, false);


--
-- Name: regions_region_id_seq; Type: SEQUENCE SET; Schema: bootcamp; Owner: bootcamp
--

SELECT pg_catalog.setval('bootcamp.regions_region_id_seq', 1, false);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (job_id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (location_id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (region_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: bootcamp; Owner: bootcamp
--

CREATE INDEX flyway_schema_history_s_idx ON bootcamp.flyway_schema_history USING btree (success);


--
-- Name: countries fk_contries_region_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.countries
    ADD CONSTRAINT fk_contries_region_id FOREIGN KEY (region_id) REFERENCES bootcamp.regions(region_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: departments fk_departments_location_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.departments
    ADD CONSTRAINT fk_departments_location_id FOREIGN KEY (location_id) REFERENCES bootcamp.locations(location_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: departments fk_departments_manager_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.departments
    ADD CONSTRAINT fk_departments_manager_id FOREIGN KEY (manager_id) REFERENCES bootcamp.employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees fk_employees_department_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.employees
    ADD CONSTRAINT fk_employees_department_id FOREIGN KEY (department_id) REFERENCES bootcamp.departments(department_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees fk_employees_job_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.employees
    ADD CONSTRAINT fk_employees_job_id FOREIGN KEY (job_id) REFERENCES bootcamp.jobs(job_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employees fk_employees_manager_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.employees
    ADD CONSTRAINT fk_employees_manager_id FOREIGN KEY (manager_id) REFERENCES bootcamp.employees(employee_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: job_history fk_job_history_department_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.job_history
    ADD CONSTRAINT fk_job_history_department_id FOREIGN KEY (department_id) REFERENCES bootcamp.departments(department_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: job_history fk_job_history_job_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.job_history
    ADD CONSTRAINT fk_job_history_job_id FOREIGN KEY (job_id) REFERENCES bootcamp.jobs(job_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: locations fk_locations_contry_id; Type: FK CONSTRAINT; Schema: bootcamp; Owner: bootcamp
--

ALTER TABLE ONLY bootcamp.locations
    ADD CONSTRAINT fk_locations_contry_id FOREIGN KEY (country_id) REFERENCES bootcamp.countries(country_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

