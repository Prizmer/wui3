--
-- PostgreSQL database dump
--

-- Dumped from database version 15.14
-- Dumped by pg_dump version 16.0

-- Started on 2026-09-30 00:47:35

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 155953)
-- Name: abonents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abonents (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    account_1 character varying(16) NOT NULL,
    account_2 character varying(16) NOT NULL,
    flat_number character varying(50) NOT NULL,
    guid_objects uuid NOT NULL,
    guid_types_abonents uuid NOT NULL
);


ALTER TABLE public.abonents OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 155956)
-- Name: link_abonents_taken_params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_abonents_taken_params (
    guid uuid NOT NULL,
    name character varying(200) NOT NULL,
    coefficient double precision NOT NULL,
    coefficient_2 double precision NOT NULL,
    coefficient_3 double precision NOT NULL,
    guid_abonents uuid NOT NULL,
    guid_taken_params uuid NOT NULL
);


ALTER TABLE public.link_abonents_taken_params OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 155959)
-- Name: meters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meters (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    address integer NOT NULL,
    password character varying(100) NOT NULL,
    attr1 character varying(20) NOT NULL,
    attr2 character varying(20) NOT NULL,
    attr3 character varying(20) NOT NULL,
    attr4 character varying(20) NOT NULL,
    password_type_hex boolean NOT NULL,
    factory_number_manual character varying(16) NOT NULL,
    factory_number_readed character varying(16),
    is_factory_numbers_equal boolean,
    dt_install timestamp with time zone,
    dt_last_read timestamp with time zone,
    time_delay_current integer NOT NULL,
    guid_meters uuid,
    guid_types_meters uuid NOT NULL
);


ALTER TABLE public.meters OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 155962)
-- Name: names_params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.names_params (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    guid_measurement uuid NOT NULL,
    guid_resources uuid NOT NULL
);


ALTER TABLE public.names_params OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 155965)
-- Name: objects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.objects (
    guid uuid NOT NULL,
    name character varying(100) NOT NULL,
    level smallint NOT NULL,
    guid_parent uuid
);


ALTER TABLE public.objects OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 155968)
-- Name: params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.params (
    guid uuid NOT NULL,
    name character varying(200) NOT NULL,
    param_address integer NOT NULL,
    channel integer NOT NULL,
    guid_names_params uuid NOT NULL,
    guid_types_meters uuid NOT NULL,
    guid_types_params uuid NOT NULL
);


ALTER TABLE public.params OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 155971)
-- Name: resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resources (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    type numeric(3,0) NOT NULL
);


ALTER TABLE public.resources OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 155974)
-- Name: taken_params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taken_params (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    guid uuid NOT NULL,
    guid_meters uuid NOT NULL,
    guid_params uuid NOT NULL
);


ALTER TABLE public.taken_params OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 155977)
-- Name: all_res_abons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.all_res_abons AS
 SELECT z1.ab_guid,
    z1.ab_name,
    z1.obj_name,
    z1.factory_number_manual,
    z1.res_name,
    z1.ktt,
    z1.ktn,
    z1.a,
    z1.name_parent,
    z1.lic_num,
    z1.name_param,
    z1.dt_install
   FROM ( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            abonents.account_1 AS lic_num,
            objects.name AS obj_name,
            meters.factory_number_manual,
            resources.name AS res_name,
            link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a,
            objects1.name AS name_parent,
            names_params.name AS name_param,
            meters.dt_install
           FROM public.objects objects1,
            public.abonents,
            public.objects,
            public.link_abonents_taken_params,
            public.taken_params,
            public.params,
            public.meters,
            public.names_params,
            public.resources
          WHERE (((objects.guid_parent)::text = (objects1.guid)::text) AND ((abonents.guid_objects)::text = (objects.guid)::text) AND ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND ((taken_params.guid_params)::text = (params.guid)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((params.guid_names_params)::text = (names_params.guid)::text) AND ((names_params.guid_resources)::text = (resources.guid)::text) AND ((names_params.name)::text !~~ '%Профиль%'::text))
          GROUP BY meters.dt_install, names_params.name, abonents.account_1, objects1.name, abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, link_abonents_taken_params.coefficient, link_abonents_taken_params.coefficient_2, link_abonents_taken_params.coefficient_3
          ORDER BY abonents.name) z1;


ALTER VIEW public.all_res_abons OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 155982)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 155985)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_id_seq OWNER TO postgres;

--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 224
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 225 (class 1259 OID 155986)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 155989)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 226
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 227 (class 1259 OID 155990)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 155993)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_permission_id_seq OWNER TO postgres;

--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 228
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 229 (class 1259 OID 155994)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 155999)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 156002)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 231
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 232 (class 1259 OID 156003)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_id_seq OWNER TO postgres;

--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 232
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 233 (class 1259 OID 156004)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 156007)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 234
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- TOC entry 235 (class 1259 OID 156008)
-- Name: balance_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.balance_groups (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.balance_groups OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 156011)
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    comment text NOT NULL,
    date timestamp with time zone NOT NULL,
    guid_abonents uuid NOT NULL,
    guid_resources uuid
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 156016)
-- Name: comport_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comport_settings (
    guid uuid NOT NULL,
    name character varying(3) NOT NULL,
    baudrate integer NOT NULL,
    data_bits numeric(3,0) NOT NULL,
    parity numeric(3,0) NOT NULL,
    stop_bits numeric(3,0) NOT NULL,
    write_timeout smallint NOT NULL,
    read_timeout smallint NOT NULL,
    attempts numeric(3,0) NOT NULL,
    delay_between_sending integer NOT NULL,
    gsm_on boolean NOT NULL,
    gsm_phone_number character varying(15) NOT NULL,
    gsm_init_string character varying(50) NOT NULL
);


ALTER TABLE public.comport_settings OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 156019)
-- Name: current_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.current_values (
    id integer NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    value double precision NOT NULL,
    status boolean NOT NULL,
    id_taken_params integer NOT NULL
);


ALTER TABLE public.current_values OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 156022)
-- Name: current_values_archive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.current_values_archive (
    id integer NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    value double precision NOT NULL,
    status boolean NOT NULL,
    id_taken_params integer NOT NULL
);


ALTER TABLE public.current_values_archive OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 156025)
-- Name: current_values_archive_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.current_values_archive_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.current_values_archive_id_seq OWNER TO postgres;

--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 240
-- Name: current_values_archive_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.current_values_archive_id_seq OWNED BY public.current_values_archive.id;


--
-- TOC entry 241 (class 1259 OID 156026)
-- Name: current_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.current_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.current_values_id_seq OWNER TO postgres;

--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 241
-- Name: current_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.current_values_id_seq OWNED BY public.current_values.id;


--
-- TOC entry 242 (class 1259 OID 156027)
-- Name: daily_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.daily_values (
    id integer NOT NULL,
    date date NOT NULL,
    value double precision NOT NULL,
    status boolean NOT NULL,
    id_taken_params integer NOT NULL
);


ALTER TABLE public.daily_values OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 156030)
-- Name: daily_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.daily_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.daily_values_id_seq OWNER TO postgres;

--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 243
-- Name: daily_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.daily_values_id_seq OWNED BY public.daily_values.id;


--
-- TOC entry 244 (class 1259 OID 156031)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 156037)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_admin_log_id_seq OWNER TO postgres;

--
-- TOC entry 3849 (class 0 OID 0)
-- Dependencies: 245
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 246 (class 1259 OID 156038)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 156041)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_content_type_id_seq OWNER TO postgres;

--
-- TOC entry 3850 (class 0 OID 0)
-- Dependencies: 247
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 248 (class 1259 OID 156042)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 156047)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 3851 (class 0 OID 0)
-- Dependencies: 249
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- TOC entry 250 (class 1259 OID 156048)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 156053)
-- Name: link_meters_tcpip_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_meters_tcpip_settings (
    guid uuid NOT NULL,
    guid_meters uuid NOT NULL,
    guid_tcpip_settings uuid NOT NULL
);


ALTER TABLE public.link_meters_tcpip_settings OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 156056)
-- Name: tcpip_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tcpip_settings (
    guid uuid NOT NULL,
    ip_address character varying(15) NOT NULL,
    ip_port integer NOT NULL,
    write_timeout smallint NOT NULL,
    read_timeout smallint NOT NULL,
    attempts numeric(3,0) NOT NULL,
    delay_between_sending integer NOT NULL
);


ALTER TABLE public.tcpip_settings OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 156059)
-- Name: types_meters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types_meters (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    driver_name character varying(50) NOT NULL
);


ALTER TABLE public.types_meters OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 156062)
-- Name: electric_abons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.electric_abons AS
 SELECT abonents.guid AS ab_guid,
    abonents.name AS ab_name,
    objects.name AS obj_name,
    meters.factory_number_manual,
    resources.name,
    meters.address,
    tcpip_settings.ip_address,
    tcpip_settings.ip_port,
    types_meters.name AS type_meter
   FROM public.abonents,
    public.objects,
    public.link_abonents_taken_params,
    public.taken_params,
    public.params,
    public.meters,
    public.names_params,
    public.resources,
    public.link_meters_tcpip_settings,
    public.tcpip_settings,
    public.types_meters
  WHERE ((meters.guid_types_meters = types_meters.guid) AND ((link_meters_tcpip_settings.guid_meters = meters.guid) AND (link_meters_tcpip_settings.guid_tcpip_settings = tcpip_settings.guid) AND ((abonents.guid_objects)::text = (objects.guid)::text) AND ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND ((taken_params.guid_params)::text = (params.guid)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((params.guid_names_params)::text = (names_params.guid)::text) AND ((names_params.guid_resources)::text = (resources.guid)::text) AND ((resources.name)::text = 'Электричество'::text)))
  GROUP BY meters.address, tcpip_settings.ip_address, types_meters.name, tcpip_settings.ip_port, abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name
  ORDER BY abonents.name;


ALTER VIEW public.electric_abons OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 199349)
-- Name: electric_abons_2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.electric_abons_2 AS
SELECT
    NULL::uuid AS ab_guid,
    NULL::character varying(50) AS ab_name,
    NULL::character varying(100) AS obj_name,
    NULL::character varying(16) AS factory_number_manual,
    NULL::character varying(50) AS res_name,
    NULL::timestamp with time zone AS date,
    NULL::character varying(50) AS name,
    NULL::text AS comment,
    NULL::uuid AS guid_abonents,
    NULL::double precision AS ktt,
    NULL::double precision AS ktn,
    NULL::double precision AS a,
    NULL::character varying(100) AS name_parent,
    NULL::character varying(16) AS lic_num,
    NULL::character varying(16) AS order_num;


ALTER VIEW public.electric_abons_2 OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 156072)
-- Name: link_balance_groups_meters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_balance_groups_meters (
    guid uuid NOT NULL,
    type boolean NOT NULL,
    guid_balance_groups uuid NOT NULL,
    guid_meters uuid NOT NULL
);


ALTER TABLE public.link_balance_groups_meters OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 156075)
-- Name: electric_groups; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.electric_groups AS
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents
           FROM public.comments
        )
 SELECT z1.guid,
    z1.ab_guid,
    z1.name_abonents,
    z1.name_group,
    z1.number_manual,
    z1.res_name,
    last_comment.date,
    last_comment.name,
    last_comment.comment,
    last_comment.guid_abonents,
    z1.type,
    z1.ktt,
    z1.ktn,
    z1.a,
    z1.lic_num
   FROM (( SELECT abonents.account_1 AS lic_num,
            balance_groups.guid,
            balance_groups.name AS name_group,
            abonents.name AS name_abonents,
            meters.factory_number_manual AS number_manual,
            resources.name AS res_name,
            abonents.guid AS ab_guid,
            link_balance_groups_meters.type,
            link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a
           FROM public.abonents,
            public.link_abonents_taken_params,
            public.taken_params,
            public.meters,
            public.link_balance_groups_meters,
            public.balance_groups,
            public.names_params,
            public.params,
            public.resources
          WHERE (((taken_params.guid)::text = (link_abonents_taken_params.guid_taken_params)::text) AND ((abonents.guid)::text = (link_abonents_taken_params.guid_abonents)::text) AND ((taken_params.guid_params)::text = (params.guid)::text) AND ((names_params.guid)::text = (params.guid_names_params)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((meters.guid)::text = (link_balance_groups_meters.guid_meters)::text) AND ((balance_groups.guid)::text = (link_balance_groups_meters.guid_balance_groups)::text) AND ((resources.name)::text = 'Электричество'::text))
          GROUP BY abonents.account_1, balance_groups.guid, balance_groups.name, abonents.name, meters.factory_number_manual, resources.name, abonents.guid, link_balance_groups_meters.type, link_abonents_taken_params.coefficient, link_abonents_taken_params.coefficient_2, link_abonents_taken_params.coefficient_3
          ORDER BY balance_groups.name, abonents.name) z1
     LEFT JOIN last_comment ON (((last_comment.guid_abonents)::text = (z1.ab_guid)::text)))
  GROUP BY z1.lic_num, z1.guid, z1.ab_guid, z1.name_abonents, z1.name_group, z1.number_manual, z1.res_name, last_comment.date, last_comment.name, last_comment.comment, last_comment.guid_abonents, z1.type, z1.ktt, z1.ktn, z1.a;


ALTER VIEW public.electric_groups OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 156080)
-- Name: groups_80020; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups_80020 (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    name_sender character varying(250) NOT NULL,
    inn_sender character varying(250) NOT NULL,
    name_postavshik character varying(250) NOT NULL,
    inn_postavshik character varying(250) NOT NULL,
    dogovor_number character varying(50) NOT NULL
);


ALTER TABLE public.groups_80020 OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 156085)
-- Name: heat_abons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.heat_abons AS
SELECT
    NULL::uuid AS ab_guid,
    NULL::character varying(50) AS ab_name,
    NULL::character varying(100) AS obj_name,
    NULL::character varying(16) AS factory_number_manual,
    NULL::character varying(50) AS res_name,
    NULL::timestamp with time zone AS date,
    NULL::character varying(50) AS name,
    NULL::text AS comment,
    NULL::character varying(16) AS account_1,
    NULL::character varying(16) AS account_2,
    NULL::character varying(50) AS type_meter;


ALTER VIEW public.heat_abons OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 156089)
-- Name: link_abonents_auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_abonents_auth_user (
    guid uuid NOT NULL,
    name character varying(200) NOT NULL,
    guid_abonents uuid NOT NULL,
    id_auth_user integer NOT NULL
);


ALTER TABLE public.link_abonents_auth_user OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 156092)
-- Name: link_groups_80020_meters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_groups_80020_meters (
    guid uuid NOT NULL,
    measuringpoint_code character varying(250) NOT NULL,
    measuringpoint_name character varying(250) NOT NULL,
    guid_groups_80020 uuid NOT NULL,
    guid_meters uuid NOT NULL
);


ALTER TABLE public.link_groups_80020_meters OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 156097)
-- Name: link_meters_comport_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link_meters_comport_settings (
    guid uuid NOT NULL,
    guid_comport_settings uuid NOT NULL,
    guid_meters uuid NOT NULL
);


ALTER TABLE public.link_meters_comport_settings OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 156100)
-- Name: measurement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.measurement (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    comments character varying(50) NOT NULL
);


ALTER TABLE public.measurement OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 156103)
-- Name: monthly_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monthly_values (
    id integer NOT NULL,
    date date NOT NULL,
    value double precision NOT NULL,
    status boolean NOT NULL,
    id_taken_params integer NOT NULL
);


ALTER TABLE public.monthly_values OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 156106)
-- Name: monthly_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monthly_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monthly_values_id_seq OWNER TO postgres;

--
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 264
-- Name: monthly_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monthly_values_id_seq OWNED BY public.monthly_values.id;


--
-- TOC entry 265 (class 1259 OID 156107)
-- Name: parent_objects_for_progruz; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.parent_objects_for_progruz AS
 WITH parent_obj2 AS (
         WITH parent_obj AS (
                 SELECT objects_2.guid AS obj_guid,
                    objects_2.name AS obj_name,
                    objects_2.level,
                    objects_2.guid_parent AS parent1_guid
                   FROM public.objects objects_2
                )
         SELECT objects_1.guid AS obj_guid2,
            objects_1.name AS obj_name2,
            objects_1.level AS level2,
            objects_1.guid_parent AS parent_guid2,
            parent_obj.obj_name
           FROM public.objects objects_1,
            parent_obj
          WHERE ((objects_1.guid_parent)::text = (parent_obj.obj_guid)::text)
        )
 SELECT parent_obj2.obj_name AS obj_name2,
    parent_obj2.obj_name2 AS obj_name1,
    objects.name AS obj_name0,
    abonents.name AS ab_name,
    objects.guid AS obj_guid,
    abonents.guid AS ab_guid
   FROM public.abonents,
    public.objects,
    parent_obj2
  WHERE (((abonents.guid_objects)::text = (objects.guid)::text) AND ((objects.guid_parent)::text = (parent_obj2.obj_guid2)::text));


ALTER VIEW public.parent_objects_for_progruz OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 156112)
-- Name: product_coefficients_kilns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_coefficients_kilns (
    id integer NOT NULL,
    sfid integer NOT NULL,
    coefficient double precision NOT NULL
);


ALTER TABLE public.product_coefficients_kilns OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 156115)
-- Name: product_coefficients_kilns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_coefficients_kilns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_coefficients_kilns_id_seq OWNER TO postgres;

--
-- TOC entry 3853 (class 0 OID 0)
-- Dependencies: 267
-- Name: product_coefficients_kilns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_coefficients_kilns_id_seq OWNED BY public.product_coefficients_kilns.id;


--
-- TOC entry 268 (class 1259 OID 156116)
-- Name: product_info_kilns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_info_kilns (
    id integer NOT NULL,
    dt date NOT NULL,
    kiln_code integer NOT NULL,
    product_caption character varying(50) NOT NULL,
    product_count integer NOT NULL,
    product_coefficient double precision NOT NULL,
    product_weight double precision NOT NULL
);


ALTER TABLE public.product_info_kilns OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 156119)
-- Name: product_info_kilns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_info_kilns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_info_kilns_id_seq OWNER TO postgres;

--
-- TOC entry 3854 (class 0 OID 0)
-- Dependencies: 269
-- Name: product_info_kilns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_info_kilns_id_seq OWNED BY public.product_info_kilns.id;


--
-- TOC entry 270 (class 1259 OID 156120)
-- Name: product_type_kilns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type_kilns (
    id integer NOT NULL,
    nm character varying(80) NOT NULL,
    kind_id integer NOT NULL
);


ALTER TABLE public.product_type_kilns OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 156123)
-- Name: product_type_kilns_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_type_kilns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_type_kilns_id_seq OWNER TO postgres;

--
-- TOC entry 3855 (class 0 OID 0)
-- Dependencies: 271
-- Name: product_type_kilns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_type_kilns_id_seq OWNED BY public.product_type_kilns.id;


--
-- TOC entry 280 (class 1259 OID 174775)
-- Name: report_80020; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.report_80020 AS
 SELECT groups_80020.name AS group_name,
    groups_80020.name_sender,
    groups_80020.inn_sender,
    groups_80020.name_postavshik,
    groups_80020.inn_postavshik,
    groups_80020.dogovor_number,
    meters.factory_number_manual,
    link_groups_80020_meters.measuringpoint_code,
    link_groups_80020_meters.measuringpoint_name,
    meters.dt_last_read
   FROM public.meters,
    public.link_groups_80020_meters,
    public.groups_80020
  WHERE ((link_groups_80020_meters.guid_groups_80020 = groups_80020.guid) AND (link_groups_80020_meters.guid_meters = meters.guid));


ALTER VIEW public.report_80020 OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 174760)
-- Name: report_configs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_configs (
    guid uuid NOT NULL,
    number integer NOT NULL,
    name character varying(200) NOT NULL,
    show_lic_num boolean NOT NULL,
    separator character varying(5) NOT NULL,
    round_size smallint NOT NULL,
    comment_to_excel boolean NOT NULL,
    show_stoyak boolean NOT NULL,
    show_floors boolean NOT NULL,
    num_is_string boolean NOT NULL,
    null_field character varying(20) NOT NULL,
    order_fields character varying(200) NOT NULL,
    order_direction character varying(4) NOT NULL,
    is_active boolean NOT NULL,
    guid_resources uuid NOT NULL,
    CONSTRAINT report_configs_number_check CHECK ((number >= 0)),
    CONSTRAINT report_configs_round_size_check CHECK ((round_size >= 0))
);


ALTER TABLE public.report_configs OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 156128)
-- Name: taken_params_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taken_params_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.taken_params_id_seq OWNER TO postgres;

--
-- TOC entry 3856 (class 0 OID 0)
-- Dependencies: 272
-- Name: taken_params_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taken_params_id_seq OWNED BY public.taken_params.id;


--
-- TOC entry 273 (class 1259 OID 156129)
-- Name: types_abonents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types_abonents (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.types_abonents OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 156132)
-- Name: types_params; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.types_params (
    guid uuid NOT NULL,
    name character varying(50) NOT NULL,
    period integer,
    type numeric(3,0) NOT NULL
);


ALTER TABLE public.types_params OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 156135)
-- Name: various_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.various_values (
    id integer NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    value double precision NOT NULL,
    status boolean NOT NULL,
    id_taken_params integer NOT NULL
);


ALTER TABLE public.various_values OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 156138)
-- Name: various_values_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.various_values_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.various_values_id_seq OWNER TO postgres;

--
-- TOC entry 3857 (class 0 OID 0)
-- Dependencies: 276
-- Name: various_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.various_values_id_seq OWNED BY public.various_values.id;


--
-- TOC entry 277 (class 1259 OID 156139)
-- Name: water_abons_report; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.water_abons_report AS
 WITH korp AS (
         SELECT objects_1.name,
            objects_1.guid_parent,
            objects_1.guid
           FROM public.objects objects_1
          WHERE ((objects_1.name)::text ~~ '%Вода%'::text)
        )
 SELECT korp.name,
    abonents.account_2,
    abonents.name AS ab_name,
        CASE
            WHEN ((abonents.name)::text ~~ '%ГВС%'::text) THEN 'Горячее водоснабжение'::text
            ELSE 'Холодное водоснабжение'::text
        END AS type_energo,
    '2015-01-01'::date AS date_install,
    objects.name AS obj_name,
    meters.name AS meter_name,
    names_params.name AS channel,
    meters.factory_number_manual
   FROM korp,
    public.meters,
    public.abonents,
    public.objects,
    public.taken_params,
    public.link_abonents_taken_params,
    public.types_meters,
    public.params,
    public.names_params,
    public.types_params,
    public.resources
  WHERE (((params.guid)::text = (taken_params.guid_params)::text) AND ((names_params.guid)::text = (params.guid_names_params)::text) AND ((meters.guid_types_meters)::text = (types_meters.guid)::text) AND ((abonents.guid_objects)::text = (objects.guid)::text) AND ((objects.guid_parent)::text = (korp.guid)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND (resources.guid = names_params.guid_resources) AND ((resources.name)::text = 'Импульс'::text) AND ((types_params.guid)::text = (params.guid_types_params)::text))
  GROUP BY korp.name, abonents.account_2, abonents.name, objects.name, meters.name, names_params.name, meters.factory_number_manual
  ORDER BY korp.name, objects.name, abonents.name;


ALTER VIEW public.water_abons_report OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 156144)
-- Name: water_pulsar_abons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.water_pulsar_abons AS
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents,
            comments.date AS date_comment,
            comments.guid_resources
           FROM public.comments
          WHERE ((comments.guid_resources = '47f0b64c-2bf6-45b4-972b-601f473a3752'::uuid) OR (comments.guid_resources = '57ec8f42-69c6-4f79-81bb-8ea139407aa9'::uuid))
          ORDER BY comments.name, comments.date DESC
        )
 SELECT z1.obj_guid,
    z1.obj_name,
    z1.ab_guid,
    z1.ab_name,
    z1.meter_name,
    z1.factory_number_manual,
    z1.name,
    z1.type_meter,
    z1.attr1,
    last_comment.name AS comment_name,
    last_comment.comment,
    last_comment.guid_abonents,
    last_comment.date_comment,
    last_comment.guid_resources
   FROM (( SELECT objects.guid AS obj_guid,
            objects.name AS obj_name,
            abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            meters.name AS meter_name,
            meters.factory_number_manual,
            types_meters.name,
                CASE
                    WHEN (((types_meters.name)::text = 'Пульс СТК ХВС'::text) OR ((types_meters.name)::text = 'Пульс СТК ГВС'::text)) THEN "substring"((types_meters.name)::text, 11, 13)
                    ELSE "substring"((types_meters.name)::text, 9, 11)
                END AS type_meter,
            meters.attr1
           FROM public.abonents,
            public.objects,
            public.link_abonents_taken_params,
            public.taken_params,
            public.meters,
            public.types_meters
          WHERE (((abonents.guid_objects)::text = (objects.guid)::text) AND ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((meters.guid_types_meters)::text = (types_meters.guid)::text) AND (((types_meters.name)::text ~~ 'Пульс%ГВС'::text) OR ((types_meters.name)::text ~~ 'Пульс%ХВС'::text)))
          GROUP BY objects.guid, objects.name, abonents.guid, abonents.name, meters.name, meters.factory_number_manual, types_meters.name, meters.attr1) z1
     LEFT JOIN last_comment ON (((last_comment.guid_abonents)::text = (z1.ab_guid)::text)));


ALTER VIEW public.water_pulsar_abons OWNER TO postgres;

--
-- TOC entry 3387 (class 2604 OID 156149)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 3388 (class 2604 OID 156150)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 3389 (class 2604 OID 156151)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 3390 (class 2604 OID 156152)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 3391 (class 2604 OID 156153)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 3392 (class 2604 OID 156154)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 3393 (class 2604 OID 156155)
-- Name: current_values id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_values ALTER COLUMN id SET DEFAULT nextval('public.current_values_id_seq'::regclass);


--
-- TOC entry 3394 (class 2604 OID 156156)
-- Name: current_values_archive id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_values_archive ALTER COLUMN id SET DEFAULT nextval('public.current_values_archive_id_seq'::regclass);


--
-- TOC entry 3395 (class 2604 OID 156157)
-- Name: daily_values id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_values ALTER COLUMN id SET DEFAULT nextval('public.daily_values_id_seq'::regclass);


--
-- TOC entry 3396 (class 2604 OID 156158)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 3397 (class 2604 OID 156159)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 3398 (class 2604 OID 156160)
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- TOC entry 3399 (class 2604 OID 156161)
-- Name: monthly_values id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_values ALTER COLUMN id SET DEFAULT nextval('public.monthly_values_id_seq'::regclass);


--
-- TOC entry 3400 (class 2604 OID 156162)
-- Name: product_coefficients_kilns id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_coefficients_kilns ALTER COLUMN id SET DEFAULT nextval('public.product_coefficients_kilns_id_seq'::regclass);


--
-- TOC entry 3401 (class 2604 OID 156163)
-- Name: product_info_kilns id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_info_kilns ALTER COLUMN id SET DEFAULT nextval('public.product_info_kilns_id_seq'::regclass);


--
-- TOC entry 3402 (class 2604 OID 156164)
-- Name: product_type_kilns id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type_kilns ALTER COLUMN id SET DEFAULT nextval('public.product_type_kilns_id_seq'::regclass);


--
-- TOC entry 3386 (class 2604 OID 156165)
-- Name: taken_params id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taken_params ALTER COLUMN id SET DEFAULT nextval('public.taken_params_id_seq'::regclass);


--
-- TOC entry 3403 (class 2604 OID 156166)
-- Name: various_values id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.various_values ALTER COLUMN id SET DEFAULT nextval('public.various_values_id_seq'::regclass);


--
-- TOC entry 3775 (class 0 OID 155953)
-- Dependencies: 214
-- Data for Name: abonents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.abonents (guid, name, account_1, account_2, flat_number, guid_objects, guid_types_abonents) FROM stdin;
\.


--
-- TOC entry 3783 (class 0 OID 155982)
-- Dependencies: 223
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 3785 (class 0 OID 155986)
-- Dependencies: 225
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 3787 (class 0 OID 155990)
-- Dependencies: 227
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add Абонент	7	add_abonents
26	Can change Абонент	7	change_abonents
27	Can delete Абонент	7	delete_abonents
28	Can view Абонент	7	view_abonents
29	Can add Балансная Группа	8	add_balancegroups
30	Can change Балансная Группа	8	change_balancegroups
31	Can delete Балансная Группа	8	delete_balancegroups
32	Can view Балансная Группа	8	view_balancegroups
33	Can add Com порт	9	add_comportsettings
34	Can change Com порт	9	change_comportsettings
35	Can delete Com порт	9	delete_comportsettings
36	Can view Com порт	9	view_comportsettings
37	Can add Группа отчётов 80020	10	add_groups80020
38	Can change Группа отчётов 80020	10	change_groups80020
39	Can delete Группа отчётов 80020	10	delete_groups80020
40	Can view Группа отчётов 80020	10	view_groups80020
41	Can add Единица измерения	11	add_measurement
42	Can change Единица измерения	11	change_measurement
43	Can delete Единица измерения	11	delete_measurement
44	Can view Единица измерения	11	view_measurement
45	Can add Счётчик	12	add_meters
46	Can change Счётчик	12	change_meters
47	Can delete Счётчик	12	delete_meters
48	Can view Счётчик	12	view_meters
49	Can add Наименование параметра	13	add_namesparams
50	Can change Наименование параметра	13	change_namesparams
51	Can delete Наименование параметра	13	delete_namesparams
52	Can view Наименование параметра	13	view_namesparams
53	Can add Параметр	14	add_params
54	Can change Параметр	14	change_params
55	Can delete Параметр	14	delete_params
56	Can view Параметр	14	view_params
57	Can add Удельный коэффициент продукта	15	add_productcoefficientskilns
58	Can change Удельный коэффициент продукта	15	change_productcoefficientskilns
59	Can delete Удельный коэффициент продукта	15	delete_productcoefficientskilns
60	Can view Удельный коэффициент продукта	15	view_productcoefficientskilns
61	Can add Информация по продукции	16	add_productinfokilns
62	Can change Информация по продукции	16	change_productinfokilns
63	Can delete Информация по продукции	16	delete_productinfokilns
64	Can view Информация по продукции	16	view_productinfokilns
65	Can add Типы продукции	17	add_producttypekilns
66	Can change Типы продукции	17	change_producttypekilns
67	Can delete Типы продукции	17	delete_producttypekilns
68	Can view Типы продукции	17	view_producttypekilns
69	Can add Ресурс	18	add_resources
70	Can change Ресурс	18	change_resources
71	Can delete Ресурс	18	delete_resources
72	Can view Ресурс	18	view_resources
73	Can add Считываемый параметр	19	add_takenparams
74	Can change Считываемый параметр	19	change_takenparams
75	Can delete Считываемый параметр	19	delete_takenparams
76	Can view Считываемый параметр	19	view_takenparams
77	Can add TCP/IP порт	20	add_tcpipsettings
78	Can change TCP/IP порт	20	change_tcpipsettings
79	Can delete TCP/IP порт	20	delete_tcpipsettings
80	Can view TCP/IP порт	20	view_tcpipsettings
81	Can add Тип абонента	21	add_typesabonents
82	Can change Тип абонента	21	change_typesabonents
83	Can delete Тип абонента	21	delete_typesabonents
84	Can view Тип абонента	21	view_typesabonents
85	Can add Тип счётчик	22	add_typesmeters
86	Can change Тип счётчик	22	change_typesmeters
87	Can delete Тип счётчик	22	delete_typesmeters
88	Can view Тип счётчик	22	view_typesmeters
89	Can add Тип считываемого параметра	23	add_typesparams
90	Can change Тип считываемого параметра	23	change_typesparams
91	Can delete Тип считываемого параметра	23	delete_typesparams
92	Can view Тип считываемого параметра	23	view_typesparams
93	Can add Настраиваемое значение	24	add_variousvalues
94	Can change Настраиваемое значение	24	change_variousvalues
95	Can delete Настраиваемое значение	24	delete_variousvalues
96	Can view Настраиваемое значение	24	view_variousvalues
97	Can add Объект	25	add_objects
98	Can change Объект	25	change_objects
99	Can delete Объект	25	delete_objects
100	Can view Объект	25	view_objects
101	Can add Месячное значение	26	add_monthlyvalues
102	Can change Месячное значение	26	change_monthlyvalues
103	Can delete Месячное значение	26	delete_monthlyvalues
104	Can view Месячное значение	26	view_monthlyvalues
105	Can add Привязка счётчика к tcp/ip порту	27	add_linkmeterstcpipsettings
106	Can change Привязка счётчика к tcp/ip порту	27	change_linkmeterstcpipsettings
107	Can delete Привязка счётчика к tcp/ip порту	27	delete_linkmeterstcpipsettings
108	Can view Привязка счётчика к tcp/ip порту	27	view_linkmeterstcpipsettings
109	Can add Привязка счётчика к com порту	28	add_linkmeterscomportsettings
110	Can change Привязка счётчика к com порту	28	change_linkmeterscomportsettings
111	Can delete Привязка счётчика к com порту	28	delete_linkmeterscomportsettings
112	Can view Привязка счётчика к com порту	28	view_linkmeterscomportsettings
113	Can add Связь счётчика и Групп 80020	29	add_linkgroups80020meters
114	Can change Связь счётчика и Групп 80020	29	change_linkgroups80020meters
115	Can delete Связь счётчика и Групп 80020	29	delete_linkgroups80020meters
116	Can view Связь счётчика и Групп 80020	29	view_linkgroups80020meters
117	Can add Привязка Групп к счётчику	30	add_linkbalancegroupsmeters
118	Can change Привязка Групп к счётчику	30	change_linkbalancegroupsmeters
119	Can delete Привязка Групп к счётчику	30	delete_linkbalancegroupsmeters
120	Can view Привязка Групп к счётчику	30	view_linkbalancegroupsmeters
121	Can add Привязка абонента к параметру	31	add_linkabonentstakenparams
122	Can change Привязка абонента к параметру	31	change_linkabonentstakenparams
123	Can delete Привязка абонента к параметру	31	delete_linkabonentstakenparams
124	Can view Привязка абонента к параметру	31	view_linkabonentstakenparams
125	Can add Привязка абонента к пользователю	32	add_linkabonentsauthuser
126	Can change Привязка абонента к пользователю	32	change_linkabonentsauthuser
127	Can delete Привязка абонента к пользователю	32	delete_linkabonentsauthuser
128	Can view Привязка абонента к пользователю	32	view_linkabonentsauthuser
129	Can add Суточное значение	33	add_dailyvalues
130	Can change Суточное значение	33	change_dailyvalues
131	Can delete Суточное значение	33	delete_dailyvalues
132	Can view Суточное значение	33	view_dailyvalues
133	Can add Архивное текущее значение	34	add_currentvaluesarchive
134	Can change Архивное текущее значение	34	change_currentvaluesarchive
135	Can delete Архивное текущее значение	34	delete_currentvaluesarchive
136	Can view Архивное текущее значение	34	view_currentvaluesarchive
137	Can add Текущее значение	35	add_currentvalues
138	Can change Текущее значение	35	change_currentvalues
139	Can delete Текущее значение	35	delete_currentvalues
140	Can view Текущее значение	35	view_currentvalues
141	Can add Комментарии	36	add_comments
142	Can change Комментарии	36	change_comments
143	Can delete Комментарии	36	delete_comments
144	Can view Комментарии	36	view_comments
145	Can add Настройка отчёта	37	add_reportconfig
146	Can change Настройка отчёта	37	change_reportconfig
147	Can delete Настройка отчёта	37	delete_reportconfig
148	Can view Настройка отчёта	37	view_reportconfig
\.


--
-- TOC entry 3789 (class 0 OID 155994)
-- Dependencies: 229
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
4	pbkdf2_sha256$216000$6z2UxTBd0e7t$QVQVQ6cPq3bpSwDGCuI+mq9zNprKUOwBykp9F/Zr4rA=	2020-11-12 15:24:26.569846+03	t	Gusakov				t	t	2020-07-23 11:43:15+03
3	pbkdf2_sha256$216000$O4ZPqmCDWkp6$tG5Ze3T3fX8NAOCOacNrn2DavNNfnUD94cEh0kxHWR4=	2026-08-27 15:42:08.438016+03	t	user				t	t	2015-05-21 12:10:27+03
1	pbkdf2_sha256$216000$8JtCa7TzFQ2D$X7vK74u99Ct5DLyAxz6gptzPBa1vcIc/i1/fQG7SLhI=	2026-09-29 11:53:33.152437+03	t	danilov				t	t	2014-11-11 15:12:25.60317+03
\.


--
-- TOC entry 3790 (class 0 OID 155999)
-- Dependencies: 230
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 3793 (class 0 OID 156004)
-- Dependencies: 233
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 3795 (class 0 OID 156008)
-- Dependencies: 235
-- Data for Name: balance_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.balance_groups (guid, name) FROM stdin;
\.


--
-- TOC entry 3796 (class 0 OID 156011)
-- Dependencies: 236
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (guid, name, comment, date, guid_abonents, guid_resources) FROM stdin;
\.


--
-- TOC entry 3797 (class 0 OID 156016)
-- Dependencies: 237
-- Data for Name: comport_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comport_settings (guid, name, baudrate, data_bits, parity, stop_bits, write_timeout, read_timeout, attempts, delay_between_sending, gsm_on, gsm_phone_number, gsm_init_string) FROM stdin;
a673a351-7fc5-49d6-89ef-5f1ae6ca0f1c	7	9600	8	0	1	100	100	2	100	f	8	at
9d1b5f8b-50fe-435f-bcb0-2f6abf388bc2	3	9600	8	1	1	100	1000	10	100	f	`	`
\.


--
-- TOC entry 3798 (class 0 OID 156019)
-- Dependencies: 238
-- Data for Name: current_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.current_values (id, date, "time", value, status, id_taken_params) FROM stdin;
\.


--
-- TOC entry 3799 (class 0 OID 156022)
-- Dependencies: 239
-- Data for Name: current_values_archive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.current_values_archive (id, date, "time", value, status, id_taken_params) FROM stdin;
\.


--
-- TOC entry 3802 (class 0 OID 156027)
-- Dependencies: 242
-- Data for Name: daily_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.daily_values (id, date, value, status, id_taken_params) FROM stdin;
\.


--
-- TOC entry 3804 (class 0 OID 156031)
-- Dependencies: 244
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2020-09-16 16:05:14.211639+03	243c37bb-8417-4e5f-904e-72c3986adfcd	М-230-УМ 32375394 - 32375394	3		12	1
2	2020-10-26 18:20:35.171552+03	e4ba8fb4-7dd4-4af0-9b13-1dd5bd3fa82b	ВРУ Корпус 2	3		25	1
3	2020-10-26 18:20:35.262468+03	da8111b8-6119-4a19-b9cc-c6e06b731147	Корпус 1 ВРУ	3		25	1
4	2020-10-26 18:20:35.274038+03	ccc617a2-6b87-4d9e-b405-2e33647c3806	ЖК "Московский"	3		25	1
5	2020-10-26 18:20:35.28706+03	99464bfe-ffdd-4a09-bd16-a2fa5a03f1ac	Корпус 1	3		25	1
6	2020-10-26 18:20:35.298763+03	6bb8f478-1f14-4fd4-86fb-908f269c8b68	ВРУ Корпус 1	3		25	1
7	2020-11-06 14:19:42.291279+03	fcd60f80-e848-49c7-9142-b4afbc002bbc	Ячейка №4	2	[{"changed": {"fields": ["Guid objects"]}}]	7	1
8	2020-11-06 14:20:08.677606+03	902a5564-f901-4798-bc7b-1f9688f593dc	г. Обнинск	3		25	1
9	2020-11-06 14:21:59.079488+03	fcda9070-2cb6-4f3e-9573-39429c35478f	Балансная группа Ячейка №10 - СЭТ-4ТМ.03М 806141363	1	[{"added": {}}]	30	1
10	2020-11-06 14:26:38.568546+03	fcda9070-2cb6-4f3e-9573-39429c35478f	Балансная группа Ячейка №10 - СЭТ-4ТМ.03М 806141363	2	[{"changed": {"fields": ["\\u0417\\u043d\\u0430\\u043a \\u0432\\u0445\\u043e\\u0434\\u0430 \\u0432 \\u0433\\u0440\\u0443\\u043f\\u043f\\u0443 '+' ?"]}}]	30	1
11	2020-11-06 14:45:16.531062+03	fcda9070-2cb6-4f3e-9573-39429c35478f	Балансная группа Ячейка №10 - СЭТ-4ТМ.03М 806141363	2	[{"changed": {"fields": ["\\u0417\\u043d\\u0430\\u043a \\u0432\\u0445\\u043e\\u0434\\u0430 \\u0432 \\u0433\\u0440\\u0443\\u043f\\u043f\\u0443 '+' ?"]}}]	30	1
12	2020-11-13 11:58:08.030354+03	fcd60f80-e848-49c7-9142-b4afbc002bbc	Ячейка №4	2	[{"changed": {"fields": ["Guid types abonents"]}}]	7	1
13	2020-11-17 16:57:39.07473+03	e7381c76-094c-480e-81dc-e7acbd5e4627	М-230 30581601 - 30581601	3		12	1
14	2020-11-17 16:57:39.169735+03	e55e25ea-c058-42c1-b947-3356a28fd4ac	СЭТ-4ТМ.03М 807130454 - 807130454	3		12	1
15	2020-11-17 16:57:39.177736+03	da4f0513-5457-4059-b0fa-6d33fbef9fdf	СЭТ-4ТМ.03М 803131316 - 803131316	3		12	1
16	2020-11-17 16:57:39.179736+03	d3e0bbfe-797a-4cd7-b933-6bb26a4fa804	СЭТ-4ТМ.03М 806141363 - 806141363	3		12	1
17	2020-11-17 16:57:39.183736+03	d269e37b-2c56-4547-ba13-4d527263232f	М-230 30577409 - 30577409	3		12	1
18	2020-11-17 16:57:39.188736+03	c43bdaeb-ee96-4cea-8e83-05d048cea272	СЭТ-4ТМ.03М 816201614 - 816201614	3		12	1
19	2020-11-17 16:57:39.195737+03	c4142a96-a935-4c63-b895-4e96e8827948	М-230 30577363 - 30577363	3		12	1
20	2020-11-17 16:57:39.199737+03	c2d342f3-f3fa-49df-a38b-3410b2fa931d	СЭТ-4ТМ.03М 803131337 - 803131337	3		12	1
21	2020-11-17 16:57:39.202737+03	a5b1cce5-bd2e-4512-badd-0b45b6bba050	СЭТ-4ТМ.03М 803131323 - 803131323	3		12	1
22	2020-11-17 16:57:39.204737+03	58f7a25c-a3e0-4a87-bfb6-c56b70cfd544	СЭТ-4ТМ.03М 807131584 - 807131584	3		12	1
23	2020-11-17 16:57:39.209738+03	43ab11d4-67ff-4b9c-a411-7444699858e4	М-230 34705736 - 34705736	3		12	1
24	2020-11-17 16:57:39.219738+03	3f691296-6206-4910-8d68-fc2d4aabde36	М-230 34705744 - 34705744	3		12	1
25	2020-11-17 16:57:39.223738+03	1ca637c2-fb91-48a7-82b3-32a826bda0ef	СЭТ-4ТМ.03М 811185983 - 811185983	3		12	1
26	2020-11-17 16:57:39.227739+03	0a71fdd2-1b50-42f0-aba0-6b81117cfe3d	СЭТ-4ТМ.03М 803131309 - 803131309	3		12	1
27	2020-11-17 16:57:39.230739+03	04008367-2a28-47a5-9bd1-6550cbe7d4a4	СЭТ-4ТМ.03М 816201296 - 816201296	3		12	1
28	2020-11-17 17:02:42.722097+03	f3e36ee1-99ef-442f-85d9-679af17cc173	ГРЩ	3		25	1
29	2020-11-17 17:02:42.743099+03	f1d1b98e-f7f9-4ea1-924c-3ccf2457ef15	ВРУ	3		25	1
30	2020-11-17 17:02:42.745099+03	be844a50-405d-4926-93a7-e6eceb6cac87	г.Обнинск	3		25	1
31	2020-11-17 17:02:42.747099+03	b83fcd92-8ae0-492a-8c48-0cc8b3dc6b6e	Варвикс	3		25	1
32	2020-11-17 17:02:42.749099+03	8aba4f63-1b32-4a7b-9094-394db97ca577	Объект1	3		25	1
33	2020-11-17 17:03:01.874193+03	88c990f2-7428-49ff-af3d-a40d2aa71740	Балансная группа Ячейка №20	3		8	1
34	2020-11-17 17:03:01.876193+03	42d5ea79-d579-4014-9aca-d7f949e0d7ac	Балансная группа Ячейка №10	3		8	1
35	2020-11-17 17:08:44.882812+03	90a59ecb-37bf-45dd-a720-10e1410dc14d	ООО ОМК Варвикс	3		10	1
36	2020-11-17 17:08:44.895813+03	33fa990c-8254-41d6-a538-fb68afc97151	ООО Астра	3		10	1
37	2020-11-17 17:08:44.897813+03	31e39625-127a-43ad-982e-2f0c4ff46ffd	ООО «Автомасла и Автохимия»	3		10	1
38	2020-11-17 17:08:44.898813+03	1d663687-e67e-44bc-a1ce-fd6ef4ee7c19	ООО «Обнинскоргсинтез»	3		10	1
39	2021-02-05 13:08:29.42263+03	fbc9874c-1dc4-4cb0-95e7-4ff6ca7ab17f	СТК Пульс Вода	1	[{"added": {}}]	22	1
40	2021-02-05 13:11:35.647444+03	31bc817a-2ccd-4021-a8a1-7d63d97dae2c	СТК Пульс Вода Объем ХВС Суточный -- adress: 0  channel: 1	1	[{"added": {}}]	14	1
41	2021-02-05 13:23:34.733277+03	c5b9362b-5c59-47bb-bc61-b3b556b24dc3	СТК Пульс Вода Объем ХВС Месячный -- adress: 0  channel: 1	1	[{"added": {}}]	14	1
42	2021-02-05 13:36:29.182848+03	3983f7d0-68e3-4cbf-af17-cee935ad490f	172.30.0.26:4003	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	1
43	2021-02-05 13:41:27.711331+03	cc38c4e7-56d5-42bb-832c-58a4242dd316	СТК 65534 - 65534	1	[{"added": {}}]	12	1
44	2021-02-05 13:42:29.599399+03	1	СТК 65534 СТК Пульс Вода Объем ХВС Суточный -- adress: 0  channel: 1	1	[{"added": {}}]	19	1
45	2021-02-05 13:42:44.719389+03	2	СТК 65534 СТК Пульс Вода Объем ХВС Месячный -- adress: 0  channel: 1	1	[{"added": {}}]	19	1
46	2021-02-05 13:44:12.225741+03	1254c5f5-f059-4b86-ab0a-4ac172d331ff	Офис	1	[{"added": {}}]	25	1
47	2021-02-05 13:44:48.980717+03	0cf8745a-8edc-4c21-9033-17cd9d898a61	Стенд	1	[{"added": {}}]	7	1
48	2021-02-05 13:45:48.162152+03	7785b4d1-ac88-4565-970d-00fad66dd1e1	Суточный 65534	1	[{"added": {}}]	31	1
49	2021-02-05 13:46:05.914217+03	2e33f70c-1f60-4772-89e4-fecbac4c656f	Месячный 65534	1	[{"added": {}}]	31	1
50	2021-02-05 13:46:57.92786+03	5a3fde18-4b11-403d-ad8a-7a0ade4ff805	Стенд	1	[{"added": {}}]	25	1
51	2021-02-05 13:47:18.225+03	0cf8745a-8edc-4c21-9033-17cd9d898a61	Стенд	2	[{"changed": {"fields": ["Guid objects"]}}]	7	1
52	2021-02-05 13:47:47.15265+03	0cf8745a-8edc-4c21-9033-17cd9d898a61	Счетчик	2	[{"changed": {"fields": ["Name"]}}]	7	1
53	2021-02-05 13:48:36.326371+03	496edf19-3bb8-44e6-bf39-f9515f640590	172.30.0.26:4003 - СТК 65534	1	[{"added": {}}]	27	1
54	2021-03-04 15:18:12.591622+03	14275dc3-eebb-4b95-aaf1-066ee4edab4e	Пульс СТК Теплосчётчик Энергия Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
55	2021-03-04 15:19:09.884142+03	9a97d8b8-992f-4e43-a6e0-9f1dc89d2dec	Пульс СТК Теплосчётчик Объем Суточный -- adress: 1  channel: 0	1	[{"added": {}}]	14	1
110	2021-05-20 12:09:34.466684+03	f07df604-1225-4374-a642-6d5bdcaf920c	М-230 43949862 - 43949862	3		12	1
56	2021-03-04 15:20:28.616327+03	27b8f3a1-b10d-4327-9505-31f730a3b62b	Пульс СТК Теплосчётчик Ti Суточный -- adress: 4  channel: 0	1	[{"added": {}}]	14	1
57	2021-03-04 15:20:44.536222+03	1944aeec-58a6-48d4-bbcb-24d0ce3a3e1a	Пульс СТК Теплосчётчик To Суточный -- adress: 5  channel: 0	1	[{"added": {}}]	14	1
58	2021-03-04 15:37:39.077745+03	cc38c4e7-56d5-42bb-832c-58a4242dd316	СТК 65534 - 65534	3		12	1
59	2021-03-04 15:37:39.080329+03	0dc05934-cd6d-4c7e-9728-9aa28fcbd222	Пульс СТК Теплосчётчик 19030701 - 19030701	3		12	1
60	2021-03-04 15:37:53.502272+03	b6fdbe43-232c-42e7-8090-112ea3ba8924	ЖК "Московский"	3		25	1
61	2021-03-04 15:37:53.504933+03	94e18d81-f19a-4616-b67a-af949e5301f7	Корпус 5	3		25	1
62	2021-03-04 15:37:53.506334+03	5a3fde18-4b11-403d-ad8a-7a0ade4ff805	Стенд	3		25	1
63	2021-03-04 15:37:53.507177+03	1254c5f5-f059-4b86-ab0a-4ac172d331ff	Офис	3		25	1
64	2021-03-04 16:31:53.910931+03	27b8f3a1-b10d-4327-9505-31f730a3b62b	Пульс СТК Теплосчётчик Ti Суточный -- adress: 5  channel: 0	2	[{"changed": {"fields": ["Name"]}}]	14	1
65	2021-03-04 16:32:01.656232+03	1944aeec-58a6-48d4-bbcb-24d0ce3a3e1a	Пульс СТК Теплосчётчик To Суточный -- adress: 6  channel: 0	2	[{"changed": {"fields": ["Name"]}}]	14	1
66	2021-03-04 16:32:12.885018+03	64dc3b02-3764-4514-ac38-a43fc69f7f9e	Пульс СТК Теплосчётчик 19030701 - 19030701	3		12	1
67	2021-04-13 15:57:43.598452+03	1ae0a516-2975-4a6e-95e3-23412e0f2e67	Пульс СТК ГВС Объем ГВС Суточный -- adress: 0  channel: 1	1	[{"added": {}}]	14	1
68	2021-04-13 15:58:45.556911+03	49f1197f-c6ae-4081-afbc-587ac614a3c3	Пульс СТК ГВС Объем ГВС Месячный -- adress: 0  channel: 1	1	[{"added": {}}]	14	1
69	2021-04-26 17:00:00.865642+03	ad598ea4-0f37-44da-95bb-ca1c3576708d	ЖК "Московский"	3		25	3
70	2021-04-26 17:10:42.027564+03	91ccc487-d3ec-480c-beca-fec57a843003	Договор 59259563 - д.2	2	[{"changed": {"fields": ["Name postavshik"]}}]	10	3
71	2021-04-26 17:18:34.236164+03	09b43fcd-fa41-42e0-81f6-88098ea84996	192.168.127.254:4001	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
72	2021-04-26 17:35:14.207022+03	09b43fcd-fa41-42e0-81f6-88098ea84996	192.168.15.10:4001	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
73	2021-04-26 17:47:21.516498+03	ba7f0db9-df05-4460-91bc-375d233dd5c1	172.30.0.5:10232	3		20	3
74	2021-04-26 17:47:21.519872+03	aeed0b08-6c82-40e9-a26d-8b0a3721cfa9	172.30.0.26:4001	3		20	3
75	2021-04-26 17:47:21.520874+03	6a869f51-1598-47e9-8c1a-4eaf8a3dace7	172.40.40.10:10002	3		20	3
76	2021-04-26 17:47:21.521504+03	3983f7d0-68e3-4cbf-af17-cee935ad490f	172.30.0.26:4003	3		20	3
77	2021-04-26 17:47:59.118542+03	10e68374-7324-4ddc-a4c8-3182c940ce74	192.168.15.10:4002	1	[{"added": {}}]	20	3
78	2021-04-26 17:48:27.528653+03	72292911-e988-4d48-8125-95070b3c826a	192.168.15.10:4002 - М-230 27382939	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
79	2021-04-26 17:48:49.919592+03	def3628d-abd7-4ba2-bc3e-dab295cf08b4	192.168.15.10:4002 - М-230 27383541	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
80	2021-04-26 17:48:59.629894+03	f75da33a-d42c-40d2-92d2-de506f9a9802	192.168.15.10:4002 - М-230 27383205	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
81	2021-04-26 17:49:18.181256+03	c3731982-2315-4f2a-9a57-1a0895eeee3c	192.168.15.10:4002 - М-230 27383029	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
82	2021-04-26 17:49:28.971674+03	ee0632f6-0831-4d05-9772-8bd71f9f0787	192.168.15.10:4002 - М-230 27382907	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
83	2021-04-26 17:49:38.994057+03	283dfe34-66f2-46de-b759-78a94cc4c8d5	192.168.15.10:4002 - М-230 27382903	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
84	2021-04-26 17:49:49.217147+03	72c7378b-c8d8-46ef-8122-0cf3bac138b2	192.168.15.10:4002 - М-230 27382909	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
85	2021-04-26 17:50:00.161318+03	e066a61a-a786-4a45-97b7-235470e561a7	192.168.15.10:4002 - М-230 27383030	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
86	2021-04-26 17:50:11.383503+03	bd4eca1a-1752-4ea5-9486-a81e2a82333a	192.168.15.10:4002 - М-230 27383214	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
87	2021-04-26 17:50:22.576321+03	c34976f0-970f-4407-b934-5002c49bb19c	192.168.15.10:4002 - М-230 27382941	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
88	2021-04-26 17:50:33.270284+03	8e313056-8a54-47d8-b0dd-f3154b8579ad	192.168.15.10:4002 - М-230 26616937	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
89	2021-04-26 17:50:50.578481+03	6c2aa93f-dee7-48de-aba7-d16143a463bf	192.168.15.10:4002 - М-230 27383194	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
90	2021-05-18 16:01:56.333892+03	f97718f2-7bcd-4047-b472-2ce4c781e0b1	М-230 43949862 - 43949862	3		12	1
91	2021-05-18 16:06:01.138788+03	52e67f0d-d027-49e6-9933-d05aca92d215	М-230 43949862 - 43949862	3		12	1
92	2021-05-18 16:14:47.016814+03	ef6f22a8-555b-4547-88f6-d13cfa138398	М-230 43949862 - 43949862	3		12	1
93	2021-05-18 16:16:20.270204+03	6a6ab0b7-2d8a-46f0-ae5a-cd7f4513bff1	М-230 43949862 - 43949862	3		12	1
94	2021-05-18 16:17:58.006468+03	9bc96cf7-3846-4456-8248-63592ae01058	М-230 43949862 - 43949862	3		12	1
95	2021-05-18 16:19:10.952261+03	72af3d64-197c-46e4-b804-166fbc2b574a	М-230 43949862 - 43949862	3		12	1
96	2021-05-18 16:20:31.975757+03	21676f35-04a2-4e79-9855-bbb2415aa136	М-230 43949862 - 43949862	3		12	1
97	2021-05-18 16:25:36.648094+03	1ed9d1a7-9edd-48ef-9377-1d4e4f89966a	М-230 43949862 - 43949862	3		12	1
98	2021-05-18 16:32:35.005357+03	f50f333f-2c9f-4e97-b619-2036491a24cd	М-230 43949862 - 43949862	3		12	1
99	2021-05-18 16:32:58.456456+03	8df99352-96b8-4ced-b23b-76843176a249	М-230 43949770 - 43949770	3		12	1
100	2021-05-18 16:33:32.412704+03	1056ae12-e36e-4f7d-b197-9697f07409b5	М-230 43949862 - 43949862	3		12	1
101	2021-05-18 16:34:53.961552+03	b5db8f49-1533-4403-90a4-15f70405a480	М-230 1 - 1	3		12	1
102	2021-05-18 16:36:00.223079+03	bcbaf21e-5b63-4f12-a3ee-d106a5ec28f6	М-230 43949862 - 43949862	3		12	1
103	2021-05-18 16:37:28.553488+03	486eee86-f891-424b-81be-32a4b31877b3	М-230 43949862 - 43949862	3		12	1
104	2021-05-18 16:38:13.960685+03	803fa3b7-eb46-491b-9374-ea3016d1e573	М-230 43949862 - 43949862	3		12	1
105	2021-05-18 16:39:06.49472+03	a536d056-4892-4666-8f95-da54e67e7745	М-230 43949862 - 43949862	3		12	1
106	2021-05-18 16:39:56.35554+03	f82ba0bc-3993-499b-8e0b-ec6456322302	М-230 43949862 - 43949862	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	1
107	2021-05-20 11:54:34.263387+03	f82ba0bc-3993-499b-8e0b-ec6456322302	М-230 43949862 - 43949862	3		12	1
108	2021-05-20 11:55:55.532037+03	23610093-d3e0-4c21-ab53-83cf5825a1d7	М-230 43949862 - 43949862	3		12	1
109	2021-05-20 12:08:31.569372+03	cd619ab0-bf72-422f-8376-088603b050e2	М-230 43949862 - 43949862	3		12	1
111	2021-05-20 12:11:42.639874+03	e6ba508d-fa18-4bec-9ee3-de9b3849eb09	М-230 1111 - 1111	3		12	1
112	2021-05-20 12:13:42.765721+03	c4c5a231-edcd-4c21-abd5-43d1cc281189	М-230 1111 - 1111	3		12	1
113	2021-05-20 12:31:08.364406+03	8c1be4ea-7b11-4338-be61-9ad9f491f5ba	М-230 43949770 - 43949770	3		12	1
114	2021-05-20 12:31:28.022488+03	1d3c7f96-6f73-4189-9290-d4472234f8aa	М-230 43949862 - 43949862	3		12	1
115	2021-05-20 12:35:53.447112+03	1db81b39-a146-4fa4-bfbb-af133564570c	М-230 43949770 - 43949770	3		12	1
116	2021-05-24 16:25:07.118823+03	fa7aa796-829f-4c16-ad18-e1d969249911	ВРУ-4.БКФН-5	2	[]	7	1
117	2021-05-24 16:34:49.179027+03	fa7aa796-829f-4c16-ad18-e1d969249911	ВРУ-4.БКФН-5	3		7	1
118	2021-05-24 16:38:08.243867+03	d8275d49-92f0-4b9d-a354-e0c232d19dcf	ВРУ-4.БКФН-5	3		7	1
119	2021-05-24 16:39:41.692649+03	55d6d381-3241-495a-8130-58c91c7c5c08	ВРУ-4.БКФН-5	3		7	1
120	2021-06-02 17:31:50.4173+03	cf8ae136-499b-47d0-a92c-b4d45d05cf2b	Ховрино-Север	2	[{"changed": {"fields": ["Name postavshik"]}}]	10	1
121	2021-06-03 10:42:29.497153+03	fd77a2fa-bfde-417d-afbf-8a0b82ffa1d6	М-230 43070222 - 43070222	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	1
122	2021-06-03 10:43:01.898949+03	f10a2905-cb00-4315-81cc-312d3fec7f3e	М-230 43070237 - 43070237	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	1
123	2021-06-03 10:43:40.743853+03	0b519c14-94d4-498f-9d0d-658c6cb87272	М-230 43258197 - 43258197	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	1
124	2021-06-18 11:03:44.858804+03	eefe39a1-2b44-4db9-97ac-39d6fe9b9de3	Пульсар 16M 2638850 - 2638850	3		12	1
125	2021-06-18 11:16:55.325012+03	795166e4-b702-41ac-a7bb-5b944fcd108f	Пульсар 16M 2638850 - 2638850	3		12	1
126	2021-06-18 11:18:37.772654+03	4bc18a97-b591-43c7-b695-e7ca5369b004	Пульсар 16M 2638850 - 2638850	3		12	1
127	2021-06-18 11:23:33.149281+03	be4b4b9d-c5b0-4400-a8e2-fbe599c106b6	Пульсар 16M 2638850 - 2638850	3		12	1
128	2021-06-18 11:26:19.332918+03	739f7424-af82-4007-8494-f76991bb950f	Пульсар 16M 2638850 - 2638850	3		12	1
129	2021-06-18 11:30:24.103044+03	33d1448c-c1fc-4cce-83b8-f9b0b4db1283	Пульсар 16M 2638850 - 2638850	3		12	1
130	2021-06-18 11:32:46.059834+03	d7e004ce-0b36-4b5a-b37c-ed80a43aced5	Пульсар 16M 2638850 - 2638850	3		12	1
131	2021-06-18 14:38:06.341366+03	dc579ea2-62d4-4e61-8f7b-97a66bd2dad5	М-230 43196631 - 43196631	3		12	1
132	2021-06-18 14:38:06.347175+03	b86dbcde-1215-4864-8686-96c87a8ee9d0	М-230 43334609 - 43334609	3		12	1
133	2021-06-18 14:38:06.349147+03	a7e05756-093d-4db9-b2f5-3c2df37b244b	М-230 43574577 - 43574577	3		12	1
134	2021-06-18 14:38:06.351261+03	67ce68bb-6447-49a2-9a6c-0739c93e9416	Пульс СТК Теплосчётчик 19030701 - 19030701	3		12	1
135	2021-06-18 14:38:06.353266+03	50e53dde-9495-47fa-916a-674aaa7332cc	Пульсар 16M 2638850 - 2638850	3		12	1
136	2021-06-18 14:38:35.791986+03	cf8ae136-499b-47d0-a92c-b4d45d05cf2b	Ховрино-Север	3		10	1
137	2021-06-18 14:38:35.796471+03	91ccc487-d3ec-480c-beca-fec57a843003	Договор 59259563 - д.2	3		10	1
138	2021-06-18 14:39:13.633089+03	f9d1b54a-203a-4d2b-8104-aee8b4baf705	Импульсные Вода	3		25	1
139	2021-06-18 14:39:13.638015+03	f17c8a63-f2c6-4582-b6fa-9846d822679a	ВРУ Хорошевское ш., 2	3		25	1
140	2021-06-18 14:39:13.639955+03	d4b6b9d3-346d-4eff-af3f-ac1166130bee	2к1А ВРУ	3		25	1
141	2021-06-18 14:39:13.642055+03	bbd413b6-1d48-4a6d-bd7e-5aeeb5c00ed9	ООО "МонАрх"	3		25	1
142	2021-06-18 14:39:13.644751+03	b4da9e54-9ee9-4ada-b7d4-e5500c2a40af	БКФН 1	3		25	1
143	2021-06-18 14:39:13.646745+03	9bb31230-9be4-4a43-bd18-ea7e861ff6de	ЖК "Лайнер"	3		25	1
144	2021-06-18 14:39:13.648716+03	9ac6688d-e664-4d9c-a43e-0d03254e5fbc	ЖК "Московский"	3		25	1
145	2021-06-18 14:39:13.65067+03	96995583-6494-49cf-aeaf-665e77baa5f2	Вертолётная площадка	3		25	1
146	2021-06-18 14:39:13.652595+03	90ae826a-4397-4526-a502-d63c2408ec1a	ГРЩ	3		25	1
147	2021-06-18 14:39:13.654482+03	6662d40d-169e-4d70-ab49-5acac12ce520	Ховрино-Север	3		25	1
148	2021-06-18 14:39:13.656418+03	4ea543a7-6ae4-444c-a0f3-4f7c00546acd	ВРУ Корпус 1	3		25	1
149	2021-06-18 14:39:13.657481+03	3b8db054-98c3-4e83-b3e7-5cc5003a155a	Корпус 1 ВРУ	3		25	1
150	2021-06-18 14:39:13.659343+03	39da9450-d162-48b7-aa43-92da2dc72551	Корпус 1	3		25	1
151	2021-06-18 14:39:13.661367+03	2602594c-00dc-4361-bfef-3a5899d3a1a4	ВРУ Корпус 2	3		25	1
152	2021-06-18 14:39:13.662414+03	1543b53c-36c3-4bf0-86b3-66380780b0ec	ул. Новодмитровская	3		25	1
153	2021-06-18 14:39:44.200219+03	b16e7425-1a9b-4545-a055-a591e498db80	172.40.40.32:5004	3		20	1
154	2021-06-18 14:39:44.205136+03	8e3d75cb-5f5a-4be9-bfe1-0bf2b9893fef	192.168.0.11:4001	3		20	1
155	2021-06-18 14:39:44.207084+03	64115eb1-b8a9-4369-957f-c2a7c85326ca	192.168.14.51:4001	3		20	1
156	2021-06-18 14:39:44.209085+03	4bdab733-27b9-4017-b963-0b1f908a971c	172.40.40.52:4003	3		20	1
157	2021-06-18 14:39:44.211151+03	10e68374-7324-4ddc-a4c8-3182c940ce74	192.168.15.10:4002	3		20	1
158	2021-06-18 14:39:44.213129+03	09b43fcd-fa41-42e0-81f6-88098ea84996	192.168.15.10:4001	3		20	1
159	2022-02-01 13:07:41.716232+03	dd36faff-b216-4948-bb7c-040e9c5751a7	М-230 43305912 - 43305912	3		12	1
160	2022-02-01 13:07:41.721265+03	88aab461-33f3-4499-8c59-bdf24c4ce4ff	М-230 43300036 - 43300036	3		12	1
161	2022-02-01 13:07:41.724972+03	81fdead8-e079-465a-aaa8-d60e083f0a9b	М-230 43299927 - 43299927	3		12	1
162	2022-02-01 13:07:41.727915+03	71c04876-afc7-42fa-bdb5-cc0ad20e528d	М-230 43300018 - 43300018	3		12	1
163	2022-02-01 13:07:41.730823+03	6f3d8681-33a9-4fdd-857b-79938f01d896	М-230 43300015 - 43300015	3		12	1
164	2022-02-01 13:07:41.733812+03	532ddd1f-84e4-4fb1-ab27-cb66d7ee4cca	М-230 43305898 - 43305898	3		12	1
165	2022-02-01 13:07:41.736677+03	2de1c7f0-835b-45f7-8e2e-ca9432308984	М-230 43305921 - 43305921	3		12	1
166	2022-02-01 13:07:41.739548+03	03af8f9d-cf9f-4ada-bcb3-a5c2893649a9	М-230 43299990 - 43299990	3		12	1
167	2022-02-01 13:08:04.252088+03	e6dcfd6d-bef4-4cac-8442-e7c5dfccb9ec	43305898	3		7	1
168	2022-02-01 13:08:04.256034+03	e18b6caf-1e37-4e8d-8aaa-0bc6b532a0d5	43300018	3		7	1
169	2022-02-01 13:08:04.258207+03	c71a545d-b1c9-4d89-a316-df8d2e8e3d6c	43299990	3		7	1
170	2022-02-01 13:08:04.260751+03	bf650f1e-796e-4afa-bc8e-956e7925db88	43300036	3		7	1
171	2022-02-01 13:08:04.262854+03	5682d6cf-bbd5-470d-b8d0-d49ca9beb2c1	43305912	3		7	1
172	2022-02-01 13:08:04.264941+03	3e4b5d92-fc99-4a54-bca6-66c106f8d6e9	43299927	3		7	1
173	2022-02-01 13:08:04.266717+03	2cb6436f-42c8-46ce-82fb-cca8a3631eec	43305921	3		7	1
174	2022-02-01 13:08:04.26878+03	20fe3137-ee30-4966-a66f-aaefc475ed93	43300015	3		7	1
175	2022-02-01 13:08:17.331038+03	b058639b-b2f0-4d36-8851-c6702c6de061	Москва Река 4	3		25	1
176	2022-02-01 13:08:17.336125+03	2f13c165-48c7-4aa2-8927-7d70599c5d2f	ТП	3		25	1
177	2022-02-01 13:08:46.457721+03	ab8cd3f8-6e99-4fb3-8584-11e1988d7752	Отчёт 80020 МР4	3		10	1
178	2022-02-01 14:04:02.178175+03	e8a7e820-d57e-45b5-9ebd-cb2d61d4ddb3	М-200 39793637 - 39793637	3		12	1
179	2022-02-01 14:04:02.18382+03	e5c43902-c943-4463-8634-3a8189b2111c	М-230 39793614 - 39793614	3		12	1
180	2022-02-01 14:04:02.185844+03	3a3affdd-dc96-49c1-9497-8ee0168c8a40	М-230 39793632 - 39793632	3		12	1
181	2022-02-01 14:04:28.698484+03	7406f266-7c82-4941-a519-7298a8fcead9	Отчёт 80020	3		10	1
182	2022-02-01 15:56:33.579105+03	e20eac6c-c45c-4445-a2a2-c8f9812c1d6f	Отчёт 80020 - М-230 39793632	2	[{"changed": {"fields": ["Measuringpoint code"]}}]	29	1
183	2022-02-01 15:56:55.83176+03	147e11ba-8da6-4635-9c8a-3baa7d3e4b20	Отчёт 80020 - М-230 39793614	2	[{"changed": {"fields": ["Measuringpoint code"]}}]	29	1
184	2022-02-01 15:57:13.044526+03	09962780-3ab5-4003-95c8-905cf4f63c69	Отчёт 80020 - М-230 39793637	2	[{"changed": {"fields": ["Measuringpoint code"]}}]	29	1
185	2022-03-14 14:38:53.785249+03	980c16d4-2d42-4947-9bcb-72a80d1048ba	М-230 39793637 - 39793637	3		12	1
186	2022-03-14 14:38:53.795231+03	4bf06570-a1c6-4777-89a7-4c252177c717	М-230 39793632 - 39793632	3		12	1
187	2022-03-14 14:38:53.797217+03	42b71319-e6e3-45d0-9318-db87534f1319	М-230 39793614 - 39793614	3		12	1
188	2022-03-14 14:39:10.568478+03	cef9dd79-c534-4608-8f75-ee40d386bc90	Совет	3		25	1
189	2022-03-14 14:39:10.572468+03	945ac9c7-cd0d-45c9-93aa-9592ccd9b90f	ТП 22288	3		25	1
190	2022-03-14 14:39:36.730715+03	59eac1a7-6850-464b-85ec-720085f70c02	Отчёт 80020	3		10	1
191	2022-03-16 10:46:09.988219+03	aafa36b0-9198-4922-acb0-6deb8bf4137d	пом. 1.9.1	3		7	1
192	2022-03-16 10:55:50.033825+03	73116ba1-824e-4115-80f8-5565ad39ccbc	Пульсар Теплосчётчик 4298857 - 4298857	3		12	1
193	2022-03-16 13:44:58.781557+03	379f1653-834b-4350-979f-112984549531	Пульсар Теплосчётчик 5573718 - 5573718	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	1
194	2022-03-24 11:48:37.172285+03	03b33b03-eb39-4c2c-bf88-487ac90e28ea	пом. 1.48.9	2	[{"changed": {"fields": ["Name"]}}]	7	1
195	2022-03-24 11:48:54.599036+03	0ef5d26f-b633-4d1a-a460-4f185ffa8233	пом. 1.48.8	2	[{"changed": {"fields": ["Name"]}}]	7	1
196	2022-03-24 11:49:50.296234+03	6b038740-fb61-4501-9441-e0320a758b64	пом. 1.48.6	2	[{"changed": {"fields": ["Name"]}}]	7	1
197	2022-03-24 12:12:57.526364+03	5e792940-718c-4268-acf3-28d51c8638b7	пом. 1.4.1	2	[{"changed": {"fields": ["Name"]}}]	7	1
198	2022-03-24 12:50:25.620674+03	bc794764-f53b-157f-dc7b-8423179c8704	Пом. 1.3.1 - Пульсар Теплосчётчик 6114797	2	[{"changed": {"fields": ["Guid abonents"]}}]	31	1
199	2022-03-24 12:50:47.364792+03	67b91a7d-ced0-9623-3017-e12e688a29b5	Пом. 1.3.1 - Пульсар Теплосчётчик 6114797	2	[{"changed": {"fields": ["Guid abonents"]}}]	31	1
200	2022-03-24 12:51:10.335757+03	59c1dd05-393d-0365-b9b2-7c4c9e003d02	Пом. 1.3.1 - Пульсар Теплосчётчик 6114797	2	[{"changed": {"fields": ["Guid abonents"]}}]	31	1
201	2022-03-24 12:51:22.561627+03	177f83c7-1d69-12d2-3980-b19a11567785	Пом. 1.3.1 - Пульсар Теплосчётчик 6114797	2	[{"changed": {"fields": ["Guid abonents"]}}]	31	1
202	2022-03-24 12:53:18.382553+03	307612ca-189f-456a-8c56-3bafb485217e	Пом. 1.3.1	3		7	1
203	2022-03-30 11:55:39.692642+03	2051fdad-76c4-4ba9-8887-1444a1c23563	192.168.1.10:4001 - Пульсар Теплосчётчик 2420952	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	1
204	2022-03-30 11:56:03.7355+03	b0a8c411-a692-4c10-97a7-1964be0c7cd9	192.168.1.10:4002 - Пульсар Теплосчётчик 4771560	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	1
205	2022-04-12 16:10:26.263062+03	c1ae0de6-f071-4e07-8452-09059eef187b	Пульсар Холодосчётчик	1	[{"added": {}}]	22	3
206	2022-04-12 16:13:12.738936+03	ba344ec3-d390-48e0-811c-991b25d9734d	Пульсар Холодосчётчик Энергия Суточный -- adress: 20  channel: 0	1	[{"added": {}}]	14	3
207	2022-04-12 16:16:37.732764+03	6a50c871-8101-4a44-82c6-6214bd7a5ddd	Пульсар Холодосчётчик Ti Суточный -- adress: 21  channel: 0	1	[{"added": {}}]	14	3
208	2022-04-12 16:17:21.689638+03	244de93e-4dcd-41e2-bcc4-db1a113ead0a	Пульсар Холодосчётчик To Суточный -- adress: 22  channel: 0	1	[{"added": {}}]	14	3
209	2022-04-12 22:44:21.211775+03	8fd07daa-4ad0-4124-acbe-aca6da2301d0	Пульсар Холодосчётчик Объем Суточный -- adress: 23  channel: 0	1	[{"added": {}}]	14	3
210	2022-04-15 15:39:07.90408+03	c06558d9-375b-47e0-a442-932be9740494	4 этаж	2	[{"changed": {"fields": ["Name"]}}]	7	3
211	2022-04-15 15:40:38.655026+03	5edfc287-b409-435c-a722-f7a20653b884	2 этаж Б7	2	[{"changed": {"fields": ["Name"]}}]	7	3
212	2022-04-15 15:42:02.391004+03	e3548cb1-347d-4a49-8958-e77a2ca6d34b	2 этаж М.Видео	2	[{"changed": {"fields": ["Name"]}}]	7	3
213	2022-04-19 14:18:08.330446+03	7c604fb0-d2df-4157-9526-92c5960f04d1	192.168.1.10:4001 - Пульсар ХВС 3980479	3		27	3
214	2022-04-19 14:23:25.792886+03	c2c30fcd-b483-41a7-89ab-59971e457e23	Пульсар ХВС 3980479 - 39804799	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
215	2022-04-19 14:30:10.347015+03	c2c30fcd-b483-41a7-89ab-59971e457e23	Пульсар ХВС 3980479 - 3980479	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
216	2022-04-19 14:39:59.592339+03	c2c30fcd-b483-41a7-89ab-59971e457e23	Пульсар ХВС 3980479 - 3980479	3		12	3
217	2022-04-20 11:10:38.010954+03	d45f1673-24f9-4814-ade9-0e18a69689af	Пульсар ГВС 2817050 - 2817050	3		12	3
218	2022-04-20 11:11:01.841282+03	5456a4e7-2a28-4689-afdd-757554257b65	Пульсар ХВС 2817054 - 2817054	3		12	3
219	2022-04-20 11:11:20.895307+03	9a932dbf-f026-4acb-9f71-b86774e66421	Пульсар ГВС 4298751 - 4298751	3		12	3
220	2022-05-25 12:16:55.48227+03	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	Пульсар 3Ф4Т	1	[{"added": {}}]	22	1
221	2022-05-25 12:18:38.147179+03	2161a1c4-6d66-4e9b-8dbb-9f7ab1bab67d	Пульсар 3Ф4Т T0 A+ Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
222	2022-05-25 12:19:58.51192+03	5f11bcf5-b058-4062-b259-6b96c80367b7	Пульсар 3Ф4Т T1 A+ Суточный -- adress: 1  channel: 0	1	[{"added": {}}]	14	1
223	2022-05-25 12:20:19.504759+03	e3b0a6c1-20d7-4753-b165-e29c78a1d9e9	Пульсар 3Ф4Т T2 A+ Суточный -- adress: 2  channel: 0	1	[{"added": {}}]	14	1
224	2022-05-25 12:21:22.452449+03	3aff9cc3-110b-4467-add7-c19d319a01cc	Пульсар 3Ф4Т T3 A+ Суточный -- adress: 3  channel: 0	1	[{"added": {}}]	14	1
225	2022-05-25 12:23:32.175283+03	7f273543-3985-43b0-a027-21311961ecb7	Пульсар 3Ф4Т T4 A+ Суточный -- adress: 4  channel: 0	1	[{"added": {}}]	14	1
226	2022-05-25 15:36:16.507982+03	ffc3c2da-dd61-4a87-9d6c-c0cb5077244c	Пульсар ГВС 3357502 - 3357502	3		12	1
227	2022-05-25 15:36:16.512176+03	ffc37ca3-0600-4eaa-b6ce-67538034545e	Пульсар Теплосчётчик 4829965 - 4829965	3		12	1
228	2022-05-25 15:36:16.513235+03	ff1d3793-c642-4852-b2a4-96a30525ba8c	Пульсар ГВС 3976084 - 3976084	3		12	1
229	2022-05-25 15:36:16.515255+03	fee9eb9b-9c32-4276-9aa8-07c4ab1fe2fd	Пульсар Теплосчётчик 4771559 - 4771559	3		12	1
230	2022-05-25 15:36:16.521966+03	fe7a794c-09c6-4e9e-b1ce-e98352ae7c85	Пульсар ХВС 3980473 - 3980473	3		12	1
231	2022-05-25 15:36:16.523913+03	fe017641-d492-4229-acda-247679aa189b	Пульсар ГВС 3732501 - 3732501	3		12	1
232	2022-05-25 15:36:16.527004+03	fc8943e0-abdf-475f-b166-80b7825d6e09	Пульсар ХВС 4792927 - 4792927	3		12	1
233	2022-05-25 15:36:16.52793+03	fbcbf3a4-f485-4e9e-b685-0d03678dacfb	Пульсар ХВС 3670755 - 3670755	3		12	1
234	2022-05-25 15:36:16.52983+03	fb7f3ace-8d4d-4e35-8e3c-238e3b5c8f0e	Пульсар ХВС 5638224 - 5638224	3		12	1
235	2022-05-25 15:36:16.531811+03	fb58a7cf-dbad-4805-9341-02872d8dc19a	Пульсар Холодосчётчик 6114797 - 6114797	3		12	1
236	2022-05-25 15:36:16.533768+03	f885bcbd-a415-440d-a5a4-7960be6ccb5e	Пульсар Холодосчётчик 2420953 - 2420953	3		12	1
237	2022-05-25 15:36:16.535681+03	f83f49dc-9310-4e9a-a5fa-9c397639c353	Пульсар ХВС 3349210 - 3349210	3		12	1
238	2022-05-25 15:36:16.536673+03	f43a307d-9290-411c-abe5-39d43b1d88b4	Пульсар Теплосчётчик 4829964 - 4829964	3		12	1
239	2022-05-25 15:36:16.539632+03	f39c48a9-9ec7-475d-b10a-d99f36dabd80	Пульсар Холодосчётчик 5573727 - 5573727	3		12	1
240	2022-05-25 15:36:16.541615+03	f3322856-6fc0-48d4-a58e-ff10e3003b8f	Пульсар Холодосчётчик 2420955 - 2420955	3		12	1
241	2022-05-25 15:36:16.543175+03	f294e1c7-63d9-4de7-8827-ab84b203abaf	Пульсар ХВС 3361049 - 3361049	3		12	1
242	2022-05-25 15:36:16.545261+03	f0f81d78-25b8-4d12-b010-40f2749d4bc9	Пульсар Теплосчётчик 2429404 - 2429404	3		12	1
243	2022-05-25 15:36:16.547325+03	f0d69eda-5617-42c8-829f-207c0e4d1eaf	Пульсар ХВС 3358849 - 3358849	3		12	1
244	2022-05-25 15:36:16.548368+03	f02e2b7b-d285-4c48-aed3-f5c45144fef6	Пульсар Холодосчётчик 5573723 - 5573723	3		12	1
245	2022-05-25 15:36:16.550205+03	eda53ead-9020-4d83-bf63-6c098aff7f37	Пульсар Теплосчётчик 2817052 - 2817052	3		12	1
246	2022-05-25 15:36:16.551313+03	ed3ba699-594d-4c02-84b9-1cf2b2eb3c1c	Пульсар ГВС 3729890 - 3729890	3		12	1
247	2022-05-25 15:36:16.553304+03	ecb7151d-c76a-4c76-a0a0-1343a5cc412e	Пульсар ГВС 3361046 - 3361046	3		12	1
248	2022-05-25 15:36:16.555243+03	ec5f5525-69eb-4138-9031-703d382afa7a	Пульсар ХВС 3980491 - 3980491	3		12	1
249	2022-05-25 15:36:16.557221+03	ec138e9a-9988-4261-a0f1-b10503f565cd	Пульсар ХВС 5636589 - 5636589	3		12	1
250	2022-05-25 15:36:16.558177+03	ebf1089f-fab4-4e26-923a-85e3fba28186	Пульсар Холодосчётчик 5573721 - 5573721	3		12	1
251	2022-05-25 15:36:16.56005+03	eb17d5fa-7c55-4135-9737-8ba44e6e4927	Пульсар ГВС 5636622 - 5636622	3		12	1
252	2022-05-25 15:36:16.562118+03	eb036d64-9aa2-4c31-a9df-c31f78ae819a	Пульсар ГВС 5638448 - 5638448	3		12	1
253	2022-05-25 15:36:16.563798+03	eaeb4437-ded4-4ca0-b9d8-4472b93a074c	Пульсар ГВС 3970516 - 3970516	3		12	1
254	2022-05-25 15:36:16.564875+03	eadfe08a-d5c6-4670-962d-af16f9abaef8	Пульсар Холодосчётчик 2420954 - 2420954	3		12	1
255	2022-05-25 15:36:16.566897+03	e3dcf352-4dc5-4b55-8285-8d1efaf87007	Пульсар Теплосчётчик 4829966 - 4829966	3		12	1
256	2022-05-25 15:36:16.568139+03	e2cd8821-fa32-4f74-b6e4-3878971899c1	Пульсар ГВС 3357507 - 3357507	3		12	1
257	2022-05-25 15:36:16.569736+03	e257661f-5df9-4b3c-8695-94039787ffc9	Пульсар Холодосчётчик 5578524 - 5578524	3		12	1
258	2022-05-25 15:36:16.571709+03	df1007d4-0dd1-4bf4-a556-325cb420088a	Пульсар Теплосчётчик 4772806 - 4772806	3		12	1
259	2022-05-25 15:36:16.572731+03	ddcb72e2-d527-4454-b8f9-45a053895f2c	Пульсар ХВС 5638789 - 5638789	3		12	1
260	2022-05-25 15:36:16.574698+03	ddb427f7-3c7d-42c8-9ec4-aab9d484fc0c	Пульсар ХВС 3980478 - 3980478	3		12	1
261	2022-05-25 15:36:16.575728+03	dccce8d2-58cf-41a6-898a-237f7f8ef533	Пульсар Холодосчётчик 5573718 - 5573718	3		12	1
262	2022-05-25 15:36:16.577634+03	db6b7bee-a327-40fd-90c2-30d7e271575b	Пульсар ХВС 3508450 - 3508450	3		12	1
263	2022-05-25 15:36:16.578638+03	db38bcd4-c7b8-4ac0-9c7d-3744bbc501ad	Пульсар ХВС 3980474 - 3980474	3		12	1
264	2022-05-25 15:36:16.5806+03	d932fbea-151a-48f7-b76b-532a7fd4b241	Пульсар Теплосчётчик 4829962 - 4829962	3		12	1
265	2022-05-25 15:36:16.582077+03	d8664589-08b6-492f-addc-758c19015b75	Пульсар ХВС 3520381 - 3520381	3		12	1
266	2022-05-25 15:36:16.583604+03	d777ab3b-dcd4-430d-b1c3-851232f50ddf	Пульсар Холодосчётчик 2420962 - 2420962	3		12	1
267	2022-05-25 15:36:16.585531+03	d62daaaf-3dd2-4a12-a61b-8c8394026856	Пульсар ГВС 5638220 - 5638220	3		12	1
268	2022-05-25 15:36:16.587098+03	d5407585-e905-49a9-bd40-12c7f7a3c734	Пульсар ГВС 5636613 - 5636613	3		12	1
269	2022-05-25 15:36:16.588152+03	d4ea0f3b-be44-4e4c-94ed-04e7d91bc166	Пульсар ГВС 3106794 - 3106794	3		12	1
270	2022-05-25 15:36:16.590277+03	d35d641b-a494-46c5-b78e-96e22bbfadf1	Пульсар Теплосчётчик 4772807 - 4772807	3		12	1
271	2022-05-25 15:36:16.591374+03	d285089b-f1bc-46fe-be6a-1ecd88942b5f	Пульсар Холодосчётчик 5578519 - 5578519	3		12	1
272	2022-05-25 15:36:16.59332+03	d2276e21-a5e7-406b-a568-9896a9c8433c	Пульсар ГВС 3676822 - 3676822	3		12	1
273	2022-05-25 15:36:16.594939+03	d1687fd1-4986-46e9-871f-c116d4bd5476	Пульсар Теплосчётчик 4771585 - 4771585	3		12	1
274	2022-05-25 15:36:16.595977+03	d150eca8-29bb-4461-80c8-aa4ba4d8c19c	Пульсар ГВС 3732506 - 3732506	3		12	1
275	2022-05-25 15:36:16.597056+03	d0b30963-8388-4fbc-a978-be552178cacc	Пульсар Теплосчётчик 4771564 - 4771564	3		12	1
276	2022-05-25 15:36:16.599728+03	cff6bf9b-74db-447c-be01-435a7150224a	Пульсар ГВС 3349215 - 3349215	3		12	1
881	2023-08-29 21:06:18.403036+03	d65f64b9-a4cd-4077-a63c-1ecbc3c1866c	Пульсар 16M 4741162 - 4741162	3		12	1
277	2022-05-25 15:36:16.600797+03	cf0b7503-7a28-4729-a344-1f26b54ddb12	Пульсар ХВС 3356130 - 3356130	3		12	1
278	2022-05-25 15:36:16.603675+03	ce6733c3-673c-4a0b-be05-7fc90678cc1d	Пульсар ГВС 3980490 - 3980490	3		12	1
279	2022-05-25 15:36:16.604732+03	cd3ed48b-c3c7-425e-88f6-514540514b46	Пульсар ХВС 3358110 - 3358110	3		12	1
280	2022-05-25 15:36:16.60577+03	cb632174-ecfb-4ba3-99df-be60bceb4327	Пульсар ГВС 3508458 - 3508458	3		12	1
281	2022-05-25 15:36:16.607808+03	c924160e-6e1a-43bb-922a-1fd98fc6d9ee	Пульсар ХВС 3358115 - 3358115	3		12	1
282	2022-05-25 15:36:16.60886+03	c8d5ed1d-affb-45be-9261-82ca57218f06	Пульсар Холодосчётчик 5578523 - 5578523	3		12	1
283	2022-05-25 15:36:16.610856+03	c836af7b-4369-486e-9647-77d2d2c0db19	Пульсар ХВС 3936081 - 3936081	3		12	1
284	2022-05-25 15:36:16.611849+03	c80f1677-3da6-455e-8d3a-23abaa92bcfe	Пульсар ГВС 3676810 - 3676810	3		12	1
285	2022-05-25 15:36:16.613852+03	c786662e-7a8e-4791-b66a-71ecd882155b	Пульсар ГВС 3520388 - 3520388	3		12	1
286	2022-05-25 15:36:16.61543+03	c7062303-d970-4e6a-a844-e3187714c3ba	Пульсар Теплосчётчик 4298748 - 4298748	3		12	1
287	2022-05-25 15:36:16.616485+03	c576a375-7851-4d24-8b3e-98ec1eeb10d6	Пульсар ХВС 5636601 - 5636601	3		12	1
288	2022-05-25 15:36:16.618517+03	c52591b1-4b49-4cc7-a2d3-f5a1b8547384	Пульсар ХВС 3349216 - 3349216	3		12	1
289	2022-05-25 15:36:16.619574+03	c45b44e6-315a-4cdd-9f12-79a8b9733123	Пульсар ХВС 5638796 - 5638796	3		12	1
290	2022-05-25 15:36:16.62165+03	c325518c-4cce-4f52-9688-1b88b71b786b	Пульсар ГВС 3980489 - 3980489	3		12	1
291	2022-05-25 15:36:16.62327+03	c2b0575d-55f3-4b37-a0ae-b50ca65f16a7	Пульсар ХВС 3508456 - 3508456	3		12	1
292	2022-05-25 15:36:16.62431+03	c0efe67a-1601-4191-bb6a-52b9ddfd6497	Пульсар ХВС 3520393 - 3520393	3		12	1
293	2022-05-25 15:36:16.62637+03	be439d39-bc12-4cc1-a142-0c182da61ad4	Пульсар Холодосчётчик 2420952 - 2420952	3		12	1
294	2022-05-25 15:36:16.627463+03	be340b2a-5c63-4a59-83d8-19fab86b7dd6	Пульсар ХВС 3106727 - 3106727	3		12	1
295	2022-05-25 15:36:16.628338+03	bda8b321-be88-426a-85b7-93cf823a6aad	Пульсар ХВС 3976088 - 3976088	3		12	1
296	2022-05-25 15:36:16.63051+03	bd4323e3-987a-4655-a9c9-823bd119602e	Пульсар ХВС 5636595 - 5636595	3		12	1
297	2022-05-25 15:36:16.632074+03	bd24aa35-9a29-4b88-9b42-6423f7631b48	Пульсар Холодосчётчик 4298851 - 4298851	3		12	1
298	2022-05-25 15:36:16.634006+03	bc2ddd25-3a01-4a4b-b1cc-3eaf9542dacc	Пульсар ХВС 3676818 - 3676818	3		12	1
299	2022-05-25 15:36:16.6351+03	bc1a03ae-3597-4838-981a-b41ae7b55bd3	Пульсар ГВС 3976085 - 3976085	3		12	1
300	2022-05-25 15:36:16.637126+03	bb80a6be-89e0-42df-b23c-30e175549f8d	Пульсар Холодосчётчик 4298860 - 4298860	3		12	1
301	2022-05-25 15:36:16.638218+03	badce898-a508-4f2a-973a-518c5ce2217a	Пульсар ХВС 5638446 - 5638446	3		12	1
302	2022-05-25 15:36:16.639288+03	b982afe9-6e17-46aa-8086-0f37fcb55419	Пульсар Холодосчётчик 4298857 - 4298857	3		12	1
303	2022-05-25 15:36:16.641152+03	b93b8554-c463-468e-a5e3-7d2851e8588f	Пульсар ГВС 3520385 - 3520385	3		12	1
304	2022-05-25 15:36:16.642165+03	b9168831-2e95-4320-9278-42b49315263a	Пульсар ГВС 4682193 - 4682193	3		12	1
305	2022-05-25 15:36:16.644023+03	b5f242c2-3998-4848-bfd7-ad9e952349ab	Пульсар ГВС 3356131 - 3356131	3		12	1
306	2022-05-25 15:36:16.644934+03	b3f6261e-116e-47b2-9fe1-eb35689ec9da	Пульсар ГВС 3980484 - 3980484	3		12	1
307	2022-05-25 15:36:16.647075+03	b2e843b3-5e99-4ea2-9e99-8132e49ec2e5	Пульсар ХВС 5638221 - 5638221	3		12	1
308	2022-05-25 15:36:16.648062+03	b2c14a86-5cb1-4d7c-9599-7ebe8ea38728	Пульсар Теплосчётчик 3556510 - 3556510	3		12	1
309	2022-05-25 15:36:16.650665+03	b220ac56-94e1-4d38-845b-96297bf66f2c	Пульсар ГВС 3106731 - 3106731	3		12	1
310	2022-05-25 15:36:16.651848+03	b21bdc63-3d04-49ca-a9b9-0e4848e3f5dd	Пульсар ХВС 5636605 - 5636605	3		12	1
311	2022-05-25 15:36:16.653836+03	b15e4ffe-79f7-45a9-a9a0-3ddbf1c6f077	Пульсар ГВС 5638445 - 5638445	3		12	1
312	2022-05-25 15:36:16.655515+03	af73d5cb-49a2-48b5-84eb-b079f67d7896	Пульсар Холодосчётчик 5573717 - 5573717	3		12	1
313	2022-05-25 15:36:16.656549+03	aefed208-c786-48fc-a520-f081fab340c4	Пульсар ГВС 3106726 - 3106726	3		12	1
314	2022-05-25 15:36:16.65854+03	aed79cbd-56b2-4ec6-912c-45f1d67369e3	Пульсар ХВС 3358839 - 3358839	3		12	1
315	2022-05-25 15:36:16.659584+03	adcb67d6-31ad-4720-a022-b06d20b00a20	Пульсар Теплосчётчик 4829959 - 4829959	3		12	1
316	2022-05-25 15:36:16.6616+03	ad8c42b8-2b7e-4266-af81-61eabc386886	Пульсар ГВС 3670766 - 3670766	3		12	1
317	2022-05-25 15:36:16.663566+03	ad334edc-107f-4dfa-8bf4-d4f1dda71506	Пульсар ГВС 3358098 - 3358098	3		12	1
318	2022-05-25 15:36:16.66451+03	ad1ddf3e-0cd9-4002-ae2b-e8473761bf23	Пульсар ГВС 3358108 - 3358108	3		12	1
319	2022-05-25 15:36:16.665457+03	ac8371ae-d455-4ea3-b5f8-399aea8fc703	Пульсар ГВС 5638787 - 5638787	3		12	1
320	2022-05-25 15:36:16.667494+03	abf1ef0b-f838-42cf-aefc-7d012441fdcf	Пульсар ГВС 3358845 - 3358845	3		12	1
321	2022-05-25 15:36:16.669494+03	ab87088f-9e2f-4010-ac82-9e71fc292792	Пульсар ГВС 5638793 - 5638793	3		12	1
322	2022-05-25 15:36:16.670483+03	ab627641-8ea0-4721-9159-9de65653e9c0	Пульсар ХВС 3676824 - 3676824	3		12	1
323	2022-05-25 15:36:16.672061+03	ab233100-ad61-4fdf-924e-29dd259462d8	Пульсар ХВС 3729879 - 3729879	3		12	1
324	2022-05-25 15:36:16.674146+03	aa3d8c71-c450-43f1-ae1c-357d732fced4	Пульсар Теплосчётчик 4771566 - 4771566	3		12	1
325	2022-05-25 15:36:16.675217+03	aa2f2f0d-c7ae-4599-935e-157cdc5e7d3f	Пульсар ГВС 5638442 - 5638442	3		12	1
326	2022-05-25 15:39:18.620311+03	a9aea9c6-c1f6-4c95-994d-4d21fd063f66	Пульсар ХВС 5636607 - 5636607	3		12	1
327	2022-05-25 15:39:18.627327+03	a8cb0e46-41b3-4098-82e6-53b094fc0cdc	Пульсар ХВС 5636604 - 5636604	3		12	1
328	2022-05-25 15:39:18.629824+03	a804276a-10e6-476e-a5dd-3f15a9cc8a24	Пульсар ХВС 3349203 - 3349203	3		12	1
329	2022-05-25 15:39:18.630862+03	a661a1cb-cf38-4188-aaf1-a0f63e308dce	Пульсар Холодосчётчик 5573719 - 5573719	3		12	1
330	2022-05-25 15:39:18.632854+03	a598b7a5-64df-41a0-88bc-099ec326c739	Пульсар ГВС 3674089 - 3674089	3		12	1
331	2022-05-25 15:39:18.63499+03	a4a50ddc-5616-43b3-af69-32cad94279b2	Пульсар ГВС 3732498 - 3732498	3		12	1
332	2022-05-25 15:39:18.637128+03	a3b591a0-0d18-435d-a9cb-23fdd1ace3e6	Пульсар ХВС 3676829 - 3676829	3		12	1
333	2022-05-25 15:39:18.63863+03	a2e74600-f4a4-4a4e-b109-85dd76370ad1	Пульсар ГВС 3676821 - 3676821	3		12	1
334	2022-05-25 15:39:18.63975+03	a13f7640-2f59-4063-a74e-8f279407e075	Пульсар Теплосчётчик 2817051 - 2817051	3		12	1
335	2022-05-25 15:39:18.642994+03	9fe81796-159b-4833-ae99-18380b18fe88	Пульсар ГВС 3729893 - 3729893	3		12	1
336	2022-05-25 15:39:18.644587+03	9f9a9635-7a82-41e1-bac7-ab5a3a090f45	Пульсар ГВС 3976082 - 3976082	3		12	1
337	2022-05-25 15:39:18.646709+03	9f107750-37b3-4c7e-a6fc-f9845b281a64	Пульсар ГВС 5636592 - 5636592	3		12	1
338	2022-05-25 15:39:18.648317+03	9eaca8b0-bd9a-4f71-9eb8-e0006d01efbe	Пульсар Теплосчётчик 4298746 - 4298746	3		12	1
339	2022-05-25 15:39:18.650348+03	9d6ea4a6-61c5-4fcc-8bd1-14d465e508ce	Пульсар ГВС 5636497 - 5636497	3		12	1
340	2022-05-25 15:39:18.651311+03	9d521060-88cb-43c8-acf3-847f7109f591	Пульсар ХВС 3732504 - 3732504	3		12	1
341	2022-05-25 15:39:18.653296+03	97c248df-b9e1-452b-9db3-0016bfe6837f	Пульсар ГВС 3508444 - 3508444	3		12	1
342	2022-05-25 15:39:18.654432+03	97454581-887e-4f3d-a9b6-915c643d215c	Пульсар ГВС 5636491 - 5636491	3		12	1
343	2022-05-25 15:39:18.656356+03	9714a12f-da84-41de-a5a8-0a8fbb477276	Пульсар ХВС 5636498 - 5636498	3		12	1
344	2022-05-25 15:39:18.658567+03	9674a47d-566f-4fd1-af0b-e3729d598733	Пульсар ГВС 3106798 - 3106798	3		12	1
345	2022-05-25 15:39:18.660094+03	9646b823-6af3-4ede-927d-a0eac9d68ab4	Пульсар ХВС 3508441 - 3508441	3		12	1
346	2022-05-25 15:39:18.662094+03	95e00707-babb-42f3-949c-c45c8f073fe2	Пульсар ХВС 3674086 - 3674086	3		12	1
347	2022-05-25 15:39:18.663208+03	952d3e7e-4cff-429e-acea-2aa3bcf8c192	Пульсар Холодосчётчик 5578513 - 5578513	3		12	1
348	2022-05-25 15:39:18.665345+03	94e9b9e4-38da-4e2d-b39d-4b2af2b95073	Пульсар Теплосчётчик 4829955 - 4829955	3		12	1
349	2022-05-25 15:39:18.666995+03	9377d1cc-4788-4a22-9392-5a3e3683f7d9	Пульсар ГВС 3936080 - 3936080	3		12	1
350	2022-05-25 15:39:18.66892+03	9362451e-f7c5-4df7-b9f8-070d70d0173d	Пульсар ГВС 3358840 - 3358840	3		12	1
351	2022-05-25 15:39:18.670014+03	930f689c-c81d-4036-b34d-a7d13c7a606a	Пульсар ХВС 3732512 - 3732512	3		12	1
352	2022-05-25 15:39:18.672217+03	926f1439-2cd7-4d1f-89bc-eb9532ef6e93	Пульсар ХВС 3358107 - 3358107	3		12	1
353	2022-05-25 15:39:18.67334+03	91903154-8f48-480e-b6cf-7c7f2e034984	Пульсар ХВС 3729653 - 3729653	3		12	1
354	2022-05-25 15:39:18.674771+03	900e042e-b0db-46d0-badf-2d122312f99d	Пульсар Теплосчётчик 4829960 - 4829960	3		12	1
355	2022-05-25 15:39:18.676878+03	8e6956fe-8db4-47ae-8677-1100ba0fc579	Пульсар Теплосчётчик 4829975 - 4829975	3		12	1
356	2022-05-25 15:39:18.679004+03	8d40ca58-7529-4ec5-a6c2-804bfbb8cde1	Пульсар ХВС 5636603 - 5636603	3		12	1
357	2022-05-25 15:39:18.68003+03	8c8b43a1-512d-48b4-9f22-335fad5240df	Пульсар ХВС 3976086 - 3976086	3		12	1
358	2022-05-25 15:39:18.681962+03	8bffa809-ed2e-4770-9a6f-eebf6956db06	Пульсар Теплосчётчик 2817055 - 2817055	3		12	1
359	2022-05-25 15:39:18.683551+03	8a023343-116c-4e56-93bb-9cc0b2a6c96e	Пульсар ГВС 3980487 - 3980487	3		12	1
360	2022-05-25 15:39:18.685591+03	890e8615-7d1a-4dfa-9deb-2b85a3f9cd5e	Пульсар ХВС 3732510 - 3732510	3		12	1
361	2022-05-25 15:39:18.686554+03	88652016-d27f-496f-abbe-27ff0147340f	Пульсар ГВС 5636597 - 5636597	3		12	1
362	2022-05-25 15:39:18.688547+03	87ad0886-807e-495e-9cc0-a44ab4b1ce75	Пульсар ХВС 5638462 - 5638462	3		12	1
363	2022-05-25 15:39:18.689707+03	87a76c4b-5777-4dc7-9606-c1a61beb8459	Пульсар ХВС 3676815 - 3676815	3		12	1
364	2022-05-25 15:39:18.691765+03	85caca18-4648-4a10-9087-47dcd23c6072	Пульсар ХВС 3356122 - 3356122	3		12	1
365	2022-05-25 15:39:18.693431+03	852f3218-b7b1-4905-bb3f-c32b0d9b6f01	Пульсар Теплосчётчик 4771591 - 4771591	3		12	1
366	2022-05-25 15:39:18.695565+03	8468554e-5043-47f4-a96d-8d5f32421b82	Пульсар Теплосчётчик 4772812 - 4772812	3		12	1
367	2022-05-25 15:39:18.69662+03	83e633dd-bd16-4991-b9b5-56a9232fc4a9	Пульсар ХВС 3980480 - 3980480	3		12	1
368	2022-05-25 15:39:18.698211+03	7fcd88ee-5b86-4ccc-b006-6c61eb6440a8	Пульсар ГВС 3106732 - 3106732	3		12	1
369	2022-05-25 15:39:18.700209+03	7f4728d1-6706-490e-8892-47612c66095f	Пульсар ГВС 3729883 - 3729883	3		12	1
370	2022-05-25 15:39:18.701175+03	7e71f82f-a427-4567-a371-5a4a9d87bff2	Пульсар ХВС 3670769 - 3670769	3		12	1
371	2022-05-25 15:39:18.703184+03	7cb03aac-3e83-4857-aa94-080e8b2711f4	Пульсар Теплосчётчик 4298749 - 4298749	3		12	1
372	2022-05-25 15:39:18.70534+03	7c2a1cfd-108b-4494-893b-5c91df686350	Пульсар ГВС 3508460 - 3508460	3		12	1
373	2022-05-25 15:39:18.707015+03	7beca1f3-8dcf-4f18-94d0-f0a14e8d1833	Пульсар ХВС 3729894 - 3729894	3		12	1
374	2022-05-25 15:39:18.708005+03	7b8f3305-ce1a-419c-830d-3423d25a1703	Пульсар Теплосчётчик 4298737 - 4298737	3		12	1
375	2022-05-25 15:39:18.710098+03	7b319afc-d02d-422c-953c-85cf379a1596	Пульсар ГВС 3670765 - 3670765	3		12	1
376	2022-05-25 15:39:18.711122+03	79aa1187-4b8d-4431-b3cc-3869986dbd78	Пульсар ГВС 3670760 - 3670760	3		12	1
377	2022-05-25 15:39:18.713323+03	795f6d46-57f6-477c-9d64-e47d466bf1f5	Пульсар Холодосчётчик 6114792 - 6114792	3		12	1
378	2022-05-25 15:39:18.7151+03	794e88a7-78ab-4cbb-a8fd-8de0559fdf52	Пульсар ГВС 3106737 - 3106737	3		12	1
379	2022-05-25 15:39:18.716071+03	7946c5d4-27d2-4396-a9f2-619d0c895c79	Пульсар Теплосчётчик 2817059 - 2817059	3		12	1
380	2022-05-25 15:39:18.717676+03	789e3663-b7c7-488e-a640-1c50ce90d1d3	Пульсар ХВС 3106781 - 3106781	3		12	1
381	2022-05-25 15:39:18.718714+03	77fe9371-ed6b-4675-9fa7-f24dc68abb5c	Пульсар Теплосчётчик 4771556 - 4771556	3		12	1
382	2022-05-25 15:39:18.720843+03	76c2d526-77ba-4ff9-81b2-31375ad5cc2a	Пульсар ГВС 3732496 - 3732496	3		12	1
383	2022-05-25 15:39:18.721938+03	76b2af1b-c626-40a6-b3e1-7f7e83e728ba	Пульсар Холодосчётчик 2429543 - 2429543	3		12	1
384	2022-05-25 15:39:18.723926+03	74fbe68f-7598-4d69-96d7-483fa03657b6	Пульсар ХВС 3358102 - 3358102	3		12	1
385	2022-05-25 15:39:18.725565+03	726d1644-b2c6-4014-a20f-619d9dd8f663	Пульсар ГВС 3361054 - 3361054	3		12	1
386	2022-05-25 15:39:18.72759+03	7229182b-d131-444a-9b2c-2be95988c61e	Пульсар ХВС 3676826 - 3676826	3		12	1
387	2022-05-25 15:39:18.728624+03	71f3ee4b-ad03-4858-ba7f-8b5d2ec9e7a8	Пульсар Теплосчётчик 4298753 - 4298753	3		12	1
388	2022-05-25 15:39:18.730802+03	7190ab49-b4e2-4d4a-84b0-a627fdf0f6c4	Пульсар ХВС 5638794 - 5638794	3		12	1
389	2022-05-25 15:39:18.731881+03	6fa14f13-8987-4417-9c45-4d80ff530492	Пульсар ХВС 5638223 - 5638223	3		12	1
390	2022-05-25 15:39:18.733562+03	6f7e923d-f3f5-4414-b69c-bc454a6a9090	Пульсар ГВС 5636598 - 5636598	3		12	1
391	2022-05-25 15:39:18.734608+03	6daed695-7e4f-40c7-9106-5f66f1763938	Пульсар Холодосчётчик 5578520 - 5578520	3		12	1
392	2022-05-25 15:39:18.735663+03	6cf13427-c554-4124-8bad-b2641f328b60	Пульсар Теплосчётчик 4771560 - 4771560	3		12	1
393	2022-05-25 15:39:18.738445+03	6cb09027-6337-4e6d-a1ea-5b9e11cca173	Пульсар Холодосчётчик 4298855 - 4298855	3		12	1
394	2022-05-25 15:39:18.739528+03	6a852569-02f9-43c9-bf9d-c2de4b154fc8	Пульсар ГВС 4682191 - 4682191	3		12	1
395	2022-05-25 15:39:18.74165+03	68dad0ba-107a-43f7-988c-811dbdbd23a7	Пульсар ХВС 3357512 - 3357512	3		12	1
396	2022-05-25 15:39:18.743087+03	6817a377-c0c2-49de-a8dc-afe74fa36bbf	Пульсар ХВС 4682253 - 4682253	3		12	1
397	2022-05-25 15:39:18.745339+03	64f55fed-42a9-42fc-99f2-2686282d2703	Пульсар ХВС 3106782 - 3106782	3		12	1
398	2022-05-25 15:39:18.746351+03	64b70be0-de75-4e9d-9c0f-e4e33916c324	Пульсар Теплосчётчик 4298756 - 4298756	3		12	1
399	2022-05-25 15:39:18.747391+03	64b12410-5a6f-4444-aff9-11057b979332	Пульсар ХВС 4682173 - 4682173	3		12	1
400	2022-05-25 15:39:18.750107+03	64883813-70a7-4198-b7ce-b04e982bab53	Пульсар ХВС 5638788 - 5638788	3		12	1
401	2022-05-25 15:39:18.751247+03	619fa814-57ac-4126-90bf-0bdfbc28b18e	Пульсар ГВС 5636600 - 5636600	3		12	1
402	2022-05-25 15:39:18.753309+03	60f11bd5-0a5a-421b-b357-a9e409a1af84	Пульсар ГВС 5636560 - 5636560	3		12	1
403	2022-05-25 15:39:18.754985+03	60946cf1-9909-4c6d-99e4-eb619bd051e7	Пульсар Холодосчётчик 4298853 - 4298853	3		12	1
404	2022-05-25 15:39:18.756082+03	60109ce5-c8df-4b43-993b-cd5e0e82cce0	Пульсар ГВС 5640832 - 5640832	3		12	1
405	2022-05-25 15:39:18.758141+03	5f62ac85-8bfa-483b-a912-3121b4927a16	Пульсар Холодосчётчик 5573725 - 5573725	3		12	1
406	2022-05-25 15:39:18.759199+03	5dcabd3c-3d71-4f7b-9969-078c45c20a80	Пульсар ХВС 5638444 - 5638444	3		12	1
407	2022-05-25 15:39:18.760719+03	5c841d73-5230-47a9-aec1-63220e51aefc	Пульсар ГВС 5636559 - 5636559	3		12	1
408	2022-05-25 15:39:18.761642+03	5bf61e31-9814-412d-a72f-dcc3c8e9c935	Пульсар ХВС 5636594 - 5636594	3		12	1
409	2022-05-25 15:39:18.763746+03	5b72df42-2486-4da4-84fa-312390f8a3d3	Пульсар ГВС 5638455 - 5638455	3		12	1
410	2022-05-25 15:39:18.765889+03	58940bdc-4d1e-4cbb-903d-e920547fe0e4	Пульсар Теплосчётчик 4772813 - 4772813	3		12	1
411	2022-05-25 15:39:18.766939+03	588c9e2f-57f7-4db6-bcd9-59ef106b4643	Пульсар ГВС 5636606 - 5636606	3		12	1
412	2022-05-25 15:39:18.768434+03	56caf32f-aa17-4fd2-a93a-1e7442396c7d	Пульсар Холодосчётчик 6114791 - 6114791	3		12	1
413	2022-05-25 15:39:18.77046+03	56322a3b-a3ae-4441-af83-f39c74e6e215	Пульсар ГВС 3676828 - 3676828	3		12	1
414	2022-05-25 15:39:18.771608+03	55941da9-88b0-4555-89a8-d486e5187b3f	Пульсар Теплосчётчик 4772808 - 4772808	3		12	1
415	2022-05-25 15:39:18.773635+03	5527c3c7-d1ce-444d-9453-3b1e8ea61d11	Пульсар ХВС 3670752 - 3670752	3		12	1
416	2022-05-25 15:39:18.775639+03	5526d666-ec7e-4f67-a565-9e85f5923735	Пульсар ГВС 3518911 - 3518911	3		12	1
417	2022-05-25 15:39:18.777721+03	52903949-1164-4ad8-8db0-2823d02a4f38	Пульсар ХВС 5636593 - 5636593	3		12	1
418	2022-05-25 15:39:18.779157+03	522ad3d8-322f-4370-ad9a-1047b79e22db	Пульсар ХВС 3361047 - 3361047	3		12	1
419	2022-05-25 15:39:18.780227+03	4f4f82f5-1106-4657-ae6c-42087bd76491	Пульсар ХВС 5636590 - 5636590	3		12	1
420	2022-05-25 15:39:18.782259+03	4f2b5a7b-b0d1-43f4-a18a-97822263f846	Пульсар ГВС 3358101 - 3358101	3		12	1
421	2022-05-25 15:39:18.783269+03	4f2907c2-d9bb-498f-85b4-85972ac4fba9	Пульсар ГВС 3361040 - 3361040	3		12	1
422	2022-05-25 15:39:18.785424+03	4ee10628-6e0b-493a-956f-d9bfdf60e8e2	Пульсар ХВС 3356117 - 3356117	3		12	1
423	2022-05-25 15:39:18.787091+03	4de8a081-c493-4fe3-94c5-0b7ce66f83ca	Пульсар Холодосчётчик 5578515 - 5578515	3		12	1
424	2022-05-25 15:39:18.78927+03	4cf7c244-a978-4017-8591-cd529a3eafbf	Пульсар Холодосчётчик 4298861 - 4298861	3		12	1
425	2022-05-25 15:46:50.903893+03	4cf06e13-7419-4214-a3c2-233222ceacff	Пульсар ГВС 3676827 - 3676827	3		12	1
426	2022-05-25 15:46:50.909513+03	4c0c7249-0e86-4d6d-973e-430cb3ab1a17	Пульсар ГВС 3106733 - 3106733	3		12	1
427	2022-05-25 15:46:50.911579+03	4b9d5a12-0e4e-400b-9347-54d7e1858d8e	Пульсар ГВС 3349197 - 3349197	3		12	1
428	2022-05-25 15:46:50.916266+03	4aa961ea-ab23-4f06-a56f-1d2760ade028	Пульсар Теплосчётчик 3556508 - 3556508	3		12	1
429	2022-05-25 15:46:50.919265+03	4a5528a7-f890-4eb2-9a6a-2ebc31bfa9b1	Пульсар Теплосчётчик 3556519 - 3556519	3		12	1
430	2022-05-25 15:46:50.921344+03	493ae79f-a9a3-4ea9-a128-3472298b3fd1	Пульсар Теплосчётчик 4772799 - 4772799	3		12	1
431	2022-05-25 15:46:50.92497+03	48d3ce86-349c-4a02-a956-9ce5e908cdad	Пульсар ГВС 5636599 - 5636599	3		12	1
432	2022-05-25 15:46:50.927904+03	48bc7ae3-2088-4886-a5e6-63f7843f19b1	Пульсар ГВС 3358850 - 3358850	3		12	1
433	2022-05-25 15:46:50.930948+03	45729f3f-6ef2-4caf-97ea-2d1a5f92369b	Пульсар ГВС 3358844 - 3358844	3		12	1
434	2022-05-25 15:46:50.93287+03	454258e9-660a-4acb-82bc-a081239ea9cb	Пульсар ГВС 3358854 - 3358854	3		12	1
435	2022-05-25 15:46:50.935917+03	452288e2-804a-46db-9da6-206c4b6369da	Пульсар Холодосчётчик 4298856 - 4298856	3		12	1
436	2022-05-25 15:46:50.937865+03	44d6a975-442c-4f04-a975-d8cf907b68da	Пульсар ГВС 3670751 - 3670751	3		12	1
437	2022-05-25 15:46:50.939974+03	4304166a-0276-41d9-9e30-44e0c7273e87	Пульсар ГВС 3676813 - 3676813	3		12	1
438	2022-05-25 15:46:50.941517+03	41da6f6a-8c02-4ddd-bd48-439417702783	Пульсар ГВС 4682171 - 4682171	3		12	1
439	2022-05-25 15:46:50.943544+03	41a26bc3-0f7f-4e7d-9957-e95170355dd5	Пульсар ГВС 3356124 - 3356124	3		12	1
440	2022-05-25 15:46:50.945464+03	41875b2b-063e-48ad-bedb-1cf159d0c0b9	Пульсар ГВС 5640867 - 5640867	3		12	1
441	2022-05-25 15:46:50.946473+03	41489fd2-f99a-4cc5-bae9-67bb4ea30f51	Пульсар ХВС 3358838 - 3358838	3		12	1
442	2022-05-25 15:46:50.948431+03	40f6deb3-f636-4a19-a918-32a038b8ed8e	Пульсар ХВС 3676819 - 3676819	3		12	1
443	2022-05-25 15:46:50.949403+03	3ff26975-be9a-4297-a5f3-dbaa32f5e96b	Пульсар Холодосчётчик 6114796 - 6114796	3		12	1
444	2022-05-25 15:46:50.951394+03	3f116de8-0ee5-4aad-8cc8-645a62e28b76	Пульсар ХВС 3358105 - 3358105	3		12	1
445	2022-05-25 15:46:50.952373+03	3eade7b6-b0e5-4ef4-bee9-1a9778f12c99	Пульсар ГВС 3980486 - 3980486	3		12	1
446	2022-05-25 15:46:50.954285+03	3e64b04b-92c4-4a70-8720-d12eec719dd1	Пульсар Теплосчётчик 4771568 - 4771568	3		12	1
447	2022-05-25 15:46:50.956345+03	3de3a188-a941-4cce-901e-ce9c81b8dbad	Пульсар ХВС 3520382 - 3520382	3		12	1
448	2022-05-25 15:46:50.958349+03	3d6c34f0-3a47-4265-8f2b-322dc02fdc2d	Пульсар Теплосчётчик 4828162 - 4828162	3		12	1
449	2022-05-25 15:46:50.959421+03	3ca8ef61-442d-4e2a-afb2-e8f24f69e7e4	Пульсар ГВС 3980476 - 3980476	3		12	1
450	2022-05-25 15:46:50.96134+03	3b9451a9-f9ba-41f6-8d89-84fdd30724d5	Пульсар ХВС 3676812 - 3676812	3		12	1
451	2022-05-25 15:46:50.963253+03	396caf94-3157-4962-81a1-0ec280566856	Пульсар Теплосчётчик 2429402 - 2429402	3		12	1
452	2022-05-25 15:46:50.965246+03	394d131b-500b-40c1-9926-1440fa8b135e	Пульсар ХВС 3106790 - 3106790	3		12	1
453	2022-05-25 15:46:50.966267+03	3855c69c-7b30-4f30-96df-e2c4f8a54aef	Пульсар ГВС 3358114 - 3358114	3		12	1
454	2022-05-25 15:46:50.968362+03	38307286-faaa-4212-a212-9a88281355f1	Пульсар Теплосчётчик 4772811 - 4772811	3		12	1
455	2022-05-25 15:46:50.969925+03	37ad7d07-8b6c-42eb-a86d-d2adb14daba3	Пульсар ГВС 3676823 - 3676823	3		12	1
456	2022-05-25 15:46:50.970913+03	36b1f7b9-0883-4943-adab-84d556204f6b	Пульсар Холодосчётчик 2420959 - 2420959	3		12	1
457	2022-05-25 15:46:50.973105+03	368732e5-0d6b-4973-b578-7253333fcd03	Пульсар ГВС 3732502 - 3732502	3		12	1
458	2022-05-25 15:46:50.974754+03	363196be-0767-4afd-a2b5-4f8a57cc8fc6	Пульсар Теплосчётчик 4771555 - 4771555	3		12	1
459	2022-05-25 15:46:50.976827+03	3451d75e-3bb4-4f4e-bc99-9b7af21a64f0	Пульсар Холодосчётчик 6114794 - 6114794	3		12	1
460	2022-05-25 15:46:50.977928+03	3440b8bc-0488-4733-b02d-35300cc91985	Пульсар Теплосчётчик 4771561 - 4771561	3		12	1
461	2022-05-25 15:46:50.979029+03	33daa6e2-1cb4-4d68-b3cf-ee7bae2ad82f	Пульсар Холодосчётчик 5578521 - 5578521	3		12	1
462	2022-05-25 15:46:50.980616+03	32b8b605-4a63-4034-a2e0-9f1a5f17e3b5	Пульсар ХВС 3980475 - 3980475	3		12	1
463	2022-05-25 15:46:50.982594+03	326ca42e-19f5-4e69-af5b-9d42688df641	Пульсар ХВС 3980479 - 3980479	3		12	1
464	2022-05-25 15:46:50.984694+03	31a01222-b7b9-4880-8853-58b0fd366fd2	Пульсар ХВС 3729877 - 3729877	3		12	1
465	2022-05-25 15:46:50.985735+03	30c626a3-da04-43c9-a0ed-b5c372742573	Пульсар ХВС 3106793 - 3106793	3		12	1
466	2022-05-25 15:46:50.986702+03	2edbe221-6809-41b0-9845-6ae31646f009	Пульсар ГВС 3732497 - 3732497	3		12	1
467	2022-05-25 15:46:50.98834+03	2e96aff6-b706-467c-8b2b-8b021c491931	Пульсар ХВС 5638452 - 5638452	3		12	1
468	2022-05-25 15:46:50.990376+03	2da96e22-39b7-48af-8099-6494a876e60e	Пульсар ХВС 3520387 - 3520387	3		12	1
469	2022-05-25 15:46:50.991346+03	2d0d40c3-6b0f-4cac-ae13-3584f5ccf099	Пульсар ГВС 3508445 - 3508445	3		12	1
470	2022-05-25 15:46:50.993393+03	2bb52931-cd66-4fc5-ba55-2a313c9aac23	Пульсар ГВС 3980485 - 3980485	3		12	1
471	2022-05-25 15:46:50.994492+03	2b8416ce-9410-495b-ac54-75febe00c8c0	Пульсар Теплосчётчик 2817049 - 2817049	3		12	1
472	2022-05-25 15:46:50.995587+03	2b2abd5c-0833-488a-9a3c-3e83d226737c	Пульсар Холодосчётчик 5573729 - 5573729	3		12	1
473	2022-05-25 15:46:50.998228+03	2b1ef332-739d-4324-9562-1c5edabb61f9	Пульсар ГВС 4682192 - 4682192	3		12	1
474	2022-05-25 15:46:50.999318+03	2a969a0b-3ded-4952-a7bc-f8ca5d26bba9	Пульсар ГВС 3358841 - 3358841	3		12	1
475	2022-05-25 15:46:51.001118+03	283939ca-5c24-4c3f-beaf-8000f731fabf	Пульсар ГВС 5636566 - 5636566	3		12	1
476	2022-05-25 15:46:51.002157+03	2716a848-fbba-4560-8f12-fb37e7486670	Пульсар ХВС 3106786 - 3106786	3		12	1
477	2022-05-25 15:46:51.004118+03	26cc99fd-d3af-44ed-a6ee-17cb2b1587c0	Пульсар ХВС 3361048 - 3361048	3		12	1
478	2022-05-25 15:46:51.005072+03	25cbe7ea-94e3-4ec5-a1fc-2863348bbacc	Пульсар Холодосчётчик 5573726 - 5573726	3		12	1
479	2022-05-25 15:46:51.007085+03	24f7cffc-1f4e-4378-a029-f09870cb2208	Пульсар Теплосчётчик 2817053 - 2817053	3		12	1
480	2022-05-25 15:46:51.008183+03	24e60f05-99ee-4338-9ace-e07e6eddddc3	Пульсар ХВС 3106740 - 3106740	3		12	1
481	2022-05-25 15:46:51.010364+03	22ddcdfe-3436-4574-8e2f-ba03e1940c63	Пульсар ГВС 4682211 - 4682211	3		12	1
482	2022-05-25 15:46:51.010891+03	2101efe5-5978-476e-8ced-d29474e589b6	Пульсар Холодосчётчик 2429544 - 2429544	3		12	1
483	2022-05-25 15:46:51.01299+03	2072dee9-a2f7-4daf-82dd-41557292563b	Пульсар ХВС 3361043 - 3361043	3		12	1
484	2022-05-25 15:46:51.01403+03	1e4204fa-f818-41c3-b18b-5b6501279c8b	Пульсар ХВС 3670756 - 3670756	3		12	1
485	2022-05-25 15:46:51.016195+03	1e19f7c1-1893-4521-9d0f-a06019a5a17f	Пульсар Теплосчётчик 4771590 - 4771590	3		12	1
486	2022-05-25 15:46:51.017708+03	1c8ed481-d458-486d-b5a3-88fa8c9a39ce	Пульсар ХВС 3681510 - 3681510	3		12	1
487	2022-05-25 15:46:51.018754+03	1bb0d89a-c1b4-45c2-857d-782cc5ed3f9b	Пульсар ГВС 3508443 - 3508443	3		12	1
488	2022-05-25 15:46:51.020715+03	1b975777-cee4-42d7-8f75-01a0252b1724	Пульсар ХВС 3106724 - 3106724	3		12	1
489	2022-05-25 15:46:51.022774+03	1b2ae7de-74c2-4d81-aab7-215a2279f576	Пульсар Теплосчётчик 4298738 - 4298738	3		12	1
490	2022-05-25 15:46:51.023672+03	1ad0fd19-f492-4313-b1cb-33f69bc61544	Пульсар ГВС 5636602 - 5636602	3		12	1
491	2022-05-25 15:46:51.02588+03	1a906128-786e-4505-83e9-8e3dc5fe4c4d	Пульсар Теплосчётчик 4015669 - 4015669	3		12	1
492	2022-05-25 15:46:51.026818+03	1a6ed2a2-8841-4cfd-bbfa-fd4491ff1285	Пульсар ХВС 5638728 - 5638728	3		12	1
493	2022-05-25 15:46:51.028442+03	19ef2cbb-71c0-4cd0-a001-2953670b9d32	Пульсар Теплосчётчик 4829953 - 4829953	3		12	1
494	2022-05-25 15:46:51.030489+03	19950cf4-8714-4239-ad24-474e233247ff	Пульсар Холодосчётчик 4298854 - 4298854	3		12	1
495	2022-05-25 15:46:51.031626+03	185bae7d-9f15-4b63-98e7-ea72b6bdc4f3	Пульсар ГВС 3106796 - 3106796	3		12	1
496	2022-05-25 15:46:51.033689+03	17a23f35-9227-4140-9591-7eeda945fcdd	Пульсар Теплосчётчик 4771565 - 4771565	3		12	1
497	2022-05-25 15:46:51.035256+03	164f4263-c9ce-47ee-b484-e14062419ede	Пульсар ХВС 5636488 - 5636488	3		12	1
498	2022-05-25 15:46:51.036308+03	15e2dae5-5823-47a4-bd1f-14f4229e5a94	Пульсар ХВС 3732508 - 3732508	3		12	1
499	2022-05-25 15:46:51.038295+03	159c8c76-2c0a-460f-a7ff-b23bb79af370	Пульсар ГВС 3106792 - 3106792	3		12	1
500	2022-05-25 15:46:51.039283+03	12f63352-97eb-470a-8981-632a230f99c8	Пульсар ХВС 5638227 - 5638227	3		12	1
882	2023-08-29 21:06:18.404981+03	d5a597ab-f096-4f0d-b55c-4e29a6d14c29	Пульсар 16M 4741122 - 4741122	3		12	1
501	2022-05-25 15:46:51.041448+03	11bc8aed-feb0-4896-aa52-b5e53b50840e	Пульсар Холодосчётчик 5578518 - 5578518	3		12	1
502	2022-05-25 15:46:51.043516+03	0f71a832-cff5-48d3-b4f8-cd595926b896	Пульсар ХВС 3358111 - 3358111	3		12	1
503	2022-05-25 15:46:51.044073+03	0deada89-f1c4-4965-bef9-a896c7442ef1	Пульсар ГВС 3980483 - 3980483	3		12	1
504	2022-05-25 15:46:51.046091+03	0ca33495-94d0-4407-8b3a-e01f29cbcb27	Пульсар ГВС 3729638 - 3729638	3		12	1
505	2022-05-25 15:46:51.047161+03	099e13af-424a-4489-93af-58fa6ef1d99e	Пульсар Теплосчётчик 4827734 - 4827734	3		12	1
506	2022-05-25 15:46:51.048992+03	099a0479-ce7a-4c7e-8a5d-7e49c47bc0e2	Пульсар Холодосчётчик 4298849 - 4298849	3		12	1
507	2022-05-25 15:46:51.050103+03	08bd1c80-c356-4bfc-a0db-df27ff7497a5	Пульсар ГВС 3732507 - 3732507	3		12	1
508	2022-05-25 15:46:51.052088+03	088e0129-0a5f-42d0-96bc-bafed6e0b440	Пульсар Теплосчётчик 4772800 - 4772800	3		12	1
509	2022-05-25 15:46:51.054178+03	085a24ef-7823-4888-bb9d-87e38ef01a38	Пульсар ГВС 5636490 - 5636490	3		12	1
510	2022-05-25 15:46:51.055639+03	0741085d-8d3e-4af0-8bc8-27a101fab2d2	Пульсар ХВС 3976083 - 3976083	3		12	1
511	2022-05-25 15:46:51.056791+03	0675d85b-a0e3-40da-b094-c1cdb0c4065f	Пульсар Теплосчётчик 4771595 - 4771595	3		12	1
512	2022-05-25 15:46:51.057731+03	06542a59-1d26-49fb-a707-abbb4310d3bf	Пульсар Теплосчётчик 2817058 - 2817058	3		12	1
513	2022-05-25 15:46:51.059811+03	063ff8ce-b0cb-42c4-86a0-c99200e85cff	Пульсар ХВС 5638443 - 5638443	3		12	1
514	2022-05-25 15:46:51.061983+03	055adab5-65b7-43a6-a93c-203610d204f8	Пульсар ХВС 3106785 - 3106785	3		12	1
515	2022-05-25 15:46:51.063602+03	050f5616-7a55-4302-8cf9-7fc55df97216	Пульсар Теплосчётчик 3556521 - 3556521	3		12	1
516	2022-05-25 15:46:51.064644+03	04608d1e-ca45-434d-8634-27b2fff89129	Пульсар ХВС 5636496 - 5636496	3		12	1
517	2022-05-25 15:46:51.066547+03	01dddfed-56f5-4992-9afc-51d0e052f193	Пульсар Теплосчётчик 4771563 - 4771563	3		12	1
518	2022-05-25 15:46:51.067621+03	00ecdd89-4382-4ac0-9b7e-97b8f4d5953d	Пульсар ХВС 3358847 - 3358847	3		12	1
519	2022-05-25 15:46:51.069771+03	00387dbf-b1bd-4ad9-b629-19dbde1b3b2c	Пульсар ХВС 3976091 - 3976091	3		12	1
520	2022-05-25 15:47:07.635365+03	af32c18d-0bca-4379-8cfa-3f0d7a1d9249	ТРЦ	3		25	1
521	2022-05-25 15:47:07.639458+03	1b1a7548-ceb3-4803-ae32-301851b96dbd	ул. Дыбенко, вл. 7/1	3		25	1
522	2022-05-25 15:47:34.391614+03	c5f3cd22-cd85-4ee6-828f-135665c672c8	172.40.40.32:10001	3		20	1
523	2022-05-25 15:47:34.395643+03	b730f4c4-8406-46e3-9bee-41a9e4ad82ec	192.168.1.10:4002	3		20	1
524	2022-05-25 15:47:34.399104+03	b233e2a0-c151-4663-97d5-b012699b67d5	192.168.0.10:4001	3		20	1
525	2022-05-25 15:47:34.400561+03	b0134339-a85f-4d4b-bb10-2d63d3c933c8	172.40.40.52:10001	3		20	1
526	2022-05-25 15:47:34.402583+03	223d24d6-bef4-4487-94ad-e1af98e44f4e	192.168.1.10:4001	3		20	1
527	2022-11-23 14:54:01.698451+03	17d88dbc-23b9-490a-9895-58ad24fe459d	Энергомера СЕ301	1	[{"added": {}}]	22	1
528	2022-11-23 19:20:50.258985+03	a02431c6-7daf-4f0e-b35d-b19916c5a940	Энергомера СЕ301 A+ Профиль Получасовой -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
529	2022-11-23 19:21:30.99922+03	610a6bf6-d00a-4fd4-a41e-0a0d9ffcba2f	Энергомера СЕ301 R+ Профиль Получасовой -- adress: 2  channel: 0	1	[{"added": {}}]	14	1
530	2022-11-23 19:24:02.452928+03	dc142b91-20a3-4048-bbfb-571bd969fd66	Энергомера СЕ301 T0 A+ Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
531	2022-11-23 19:51:40.343901+03	63594901-393e-4fd9-bb1c-1da237d1264d	Энергомера СЕ301 T1 A+ Суточный -- adress: 1  channel: 0	1	[{"added": {}}]	14	1
532	2022-11-23 19:52:07.565891+03	ff7837a5-5552-4fc0-a66e-a554f92c1f02	Энергомера СЕ301 T2 A+ Суточный -- adress: 2  channel: 0	1	[{"added": {}}]	14	1
533	2022-11-23 19:52:50.696316+03	15e387b9-45ef-44fc-8110-a8d823af9140	Энергомера СЕ301 T3 A+ Суточный -- adress: 3  channel: 0	1	[{"added": {}}]	14	1
534	2023-04-04 11:31:54.324894+03	53972ced-62fc-4d02-a537-3dec68d8000c	Пульсар ХВС 8942678 - 8942678	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
535	2023-04-06 14:58:24.765181+03	dc113849-16b9-4400-b3e9-251016f8c670	Пульсар ХВС 7877594 - 7877594	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
536	2023-04-06 14:59:23.062092+03	f5c3f1bc-57ca-4387-b070-c5971d04983c	Пульсар ГВС 7879506 - 7879506	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
537	2023-04-06 15:02:16.987158+03	8f26fc49-5c7c-42ca-b821-c0bd1493e1b3	Пульсар Теплосчётчик 7612426 - 7612426	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
538	2023-04-25 12:56:09.975248+03	4be7c532-b12a-4936-a6c9-1f5ae2ae680b	М-230 47133412 - 47133412	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
539	2023-04-25 12:57:51.978058+03	61446480-2f06-44bf-805f-6eb7a9141933	М-230 47179412 - 47179412	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
540	2023-04-27 21:41:07.31597+03	4428e4f5-d1fb-4234-bf56-d91081bab3d2	М-230 47133386 - 47133386	3		12	3
541	2023-04-27 21:57:20.854214+03	601c24d8-1767-4c1f-8c61-59177283843c	Пульсар Теплосчётчик 7612722 - 7612722	3		12	3
542	2023-04-29 13:03:46.847792+03	0ddae16a-494c-403f-960a-1997eaf9217e	Пульсар ХВС 8004135 - 8004135	3		12	3
543	2023-04-29 13:05:51.659133+03	61fb5656-4163-42f3-aa5f-277395d4709e	Пульсар ГВС 8187716 - 8187716	3		12	3
544	2023-04-29 13:08:14.063613+03	d63a8ff3-2667-4c82-a43f-b344b3c74fb5	Пульсар ХВС 5915550 - 5915550	3		12	3
545	2023-05-05 09:49:40.724679+03	9f762bf3-bff3-4de4-8844-72b707b10534	М-230 47180120 - 47180120	3		12	3
546	2023-05-05 09:51:11.293835+03	e69880b0-2ce5-4e7a-a993-162602e83a9a	М-230 47179937 - 47179937	3		12	3
547	2023-05-05 10:19:11.658981+03	1bf96ace-7d2d-4c01-9db8-c794756e8c01	Пульсар Теплосчётчик 7611489 - 7611489	3		12	3
548	2023-05-05 10:29:31.225284+03	4e8f88d8-4801-475a-982f-c2071bab67f9	Пульсар Теплосчётчик 7611562 - 7611562	3		12	3
549	2023-05-10 11:27:56.461133+03	cdaa9e7a-a330-4b5d-bd3b-4d0695e3b21c	Пульсар Теплосчётчик 76120444 - 76120444	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
550	2023-05-10 11:28:27.720078+03	54241938-4b49-42cb-b945-672dc475583d	Пульсар Теплосчётчик 7612033 - 7612033	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
551	2023-05-10 11:28:44.907108+03	cdaa9e7a-a330-4b5d-bd3b-4d0695e3b21c	Пульсар Теплосчётчик 7612044 - 7612044	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
552	2023-05-17 09:28:06.917585+03	f13d6f61-f89b-40ef-9cb7-7dba8a2d9f9d	Пульсар ХВС 8004013 - 8004013	3		12	3
553	2023-05-17 09:28:45.995121+03	6ef32f6b-13ba-43c3-86e6-4b3fa17a537c	Пульсар ГВС 5915114 - 5915114	3		12	3
554	2023-05-17 09:31:54.318084+03	5a6c976b-29ce-4d5a-8847-454e0a124430	улица Дубининская 59	3		25	3
555	2023-05-17 09:32:31.769095+03	73bd5d60-1fb0-4dfb-ac56-b59eee83e127	Пульсар ГВС 8187368 - 8187368	3		12	3
556	2023-05-17 09:57:31.054102+03	16f4b99f-3a11-4b16-9a84-a66d2da29035	Пульсар Теплосчётчик 7611822 - 7611822	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
557	2023-05-17 09:59:28.302557+03	0ec53f11-5500-4365-83a4-f2d3fd82d3ea	Пульсар ХВС 8942681 - 8942681	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
558	2023-05-17 10:00:10.194399+03	2327851e-3ef9-4db5-b97a-33c64f02e769	Пульсар ХВС 8942682 - 8942682	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
559	2023-05-18 22:54:27.222769+03	ced7d967-aab1-45d8-adf3-fe486ee6e06c	Пульсар ХВС 8941360 - 8941360	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
560	2023-05-31 08:47:36.429456+03	f5c3f1bc-57ca-4387-b070-c5971d04983c	Пульсар ГВС 7879505 - 7879505	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
561	2023-05-31 08:57:37.370001+03	86381f09-38b7-010c-aabc-fd4ef67c004c	Квартира 41202 - Пульсар ГВС 7879505	3		31	3
562	2023-06-01 09:56:08.30975+03	8773f490-8567-4998-a706-003612f8de90	Пульсар ГВС 8187368 - 8187368	3		12	3
563	2023-06-01 09:56:29.48292+03	2d8fbd63-4214-4da7-bd7c-56086650fd88	Пульсар ХВС 8004155 - 8004155	3		12	3
564	2023-06-01 09:56:45.787851+03	8478eabe-a735-4065-9c2d-dd51b3dcb5d5	Пульсар ХВС 5915199 - 5915199	3		12	3
565	2023-06-01 09:56:59.454438+03	0d95ab07-3ad6-43f0-b89f-bec5db5b46a0	Пульсар ГВС 8769246 - 8769246	3		12	3
566	2023-06-08 20:15:35.683858+03	12c4d14d-8de0-4dc5-ab60-4d38a2b3f4e7	М-230 48298512 - 48298512	3		12	3
567	2023-06-08 20:52:22.32955+03	edd5c767-6d4c-4f38-9873-a87334f01c50	М-230 47046763 - 47046763	3		12	3
568	2023-06-08 20:54:25.934266+03	9c38a375-f4dc-406b-b8d0-47d835b70c01	М-230 47179728 - 47179728	3		12	3
569	2023-06-13 11:43:36.145063+03	cfe73605-857d-4f55-a962-75a4db34e949	10.10.152.9:4007 - М-230 47047050	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
570	2023-06-13 11:43:59.828988+03	bef1aaf5-0f5d-4c45-ab42-c2507d014c31	10.10.152.9:4007 - М-230 47046502	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
571	2023-06-13 11:44:23.116004+03	c1194300-309c-4ad4-97c3-3ce9e0ca9496	10.10.152.9:4007 - М-230 47133398	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
572	2023-06-13 11:44:42.217761+03	d73226b3-758d-4f42-8bea-86755476b6cc	10.10.152.9:4007 - М-230 47047239	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
573	2023-06-13 11:45:01.971304+03	48ca029f-3047-42d4-adbb-ee0b1b47c1c8	10.10.152.9:4007 - М-230 47179354	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
574	2023-06-13 11:45:23.049125+03	6d9265af-f012-41a3-9b7e-e66acee706ed	10.10.152.9:4007 - М-230 47179690	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
575	2023-06-13 11:45:42.746904+03	1fe8581f-bd51-405c-b601-de39abae70d7	10.10.152.9:4007 - М-230 47179945	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
576	2023-06-13 11:46:00.881693+03	29680085-66c9-44ed-b040-04fd1b3b4e24	10.10.152.9:4007 - М-230 47179326	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
577	2023-06-13 11:46:22.364432+03	6b401fd0-42e0-4e6e-925b-c850dde302e1	10.10.152.9:4007 - М-230 46899977	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
578	2023-06-13 11:47:07.217431+03	c8fd205c-5cce-46dc-843d-eb57531d5ee9	10.10.152.9:4007 - М-230 47045408	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
579	2023-06-13 11:47:26.60868+03	cc22f97d-7ce9-499b-b362-f0a57536e724	10.10.152.9:4007 - М-230 47045174	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
580	2023-06-13 11:47:47.969056+03	571fa8ee-f146-4332-9f3e-3a5638187caa	10.10.152.9:4007 - М-230 47041246	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
581	2023-06-13 11:48:17.243943+03	2827f6d6-3aaf-4eca-a451-52d604153295	10.10.152.9:4007 - М-230 47179962	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
582	2023-06-13 11:48:39.37637+03	df2e1745-ce5c-4e25-95e2-a6a889f0f693	10.10.152.9:4007 - М-230 47179793	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
583	2023-06-13 11:48:58.686613+03	6d9784a9-05f9-4b40-89d8-bb90ab1596ec	10.10.152.9:4007 - М-230 47179586	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
584	2023-06-13 11:49:17.185806+03	4ecf00ba-966a-43f3-a501-4e23804aa387	10.10.152.9:4007 - М-230 47179700	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
585	2023-06-13 11:49:49.000857+03	dad94e0a-5fb1-46ee-bc08-9f7478dce98a	10.10.152.9:4007 - М-230 47041502	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
586	2023-06-13 11:50:07.96308+03	4fa7263e-c874-4094-8072-471780210912	10.10.152.9:4007 - М-230 46899973	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
587	2023-06-13 11:50:25.939238+03	147c4eef-4fd0-4b7c-824e-6c55e3145c09	10.10.152.9:4007 - М-230 47045393	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
588	2023-06-13 11:50:46.907588+03	8a8a62bc-1d02-40d2-b5c4-298cfd1148ec	10.10.152.9:4007 - М-230 47045415	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
589	2023-06-13 11:51:02.343584+03	46b796fa-8fc7-4dac-8fc6-701b9d64cda4	10.10.152.9:4007 - М-230 47133195	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
590	2023-06-13 11:51:30.916425+03	46b796fa-8fc7-4dac-8fc6-701b9d64cda4	10.10.152.9:4006 - М-230 47133195	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
591	2023-06-13 11:51:55.03998+03	ec1e929d-4694-4364-9e32-0b59ba53d254	10.10.152.9:4007 - М-230 47046536	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
592	2023-06-13 11:52:10.341965+03	9abb1ebf-6757-4750-9942-ccf5c761c0bc	10.10.152.9:4007 - М-230 47046574	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
593	2023-06-13 11:52:28.527138+03	dbf2f7ba-e360-49e4-9562-ca4c5582775e	10.10.152.9:4007 - М-230 47133077	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
594	2023-06-13 11:52:47.387353+03	dd9edfed-461c-4d23-bb02-8b8a4e0941d1	10.10.152.9:4007 - М-230 47133683	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
595	2023-06-13 11:53:10.884868+03	c297ada4-96fc-4f74-8dab-cdf44897161b	10.10.152.9:4007 - М-230 47179397	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
596	2023-06-13 11:53:27.218919+03	f6c02242-bc5e-4700-8fa5-b302137d461e	10.10.152.9:4007 - М-230 47179358	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
597	2023-06-13 11:53:43.401962+03	693a8db8-5839-4193-8e28-c37819cf9fec	10.10.152.9:4007 - М-230 47133402	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
598	2023-06-13 11:53:58.925963+03	71ebecbb-e1da-4900-bf1a-61cdb6bb671c	10.10.152.9:4007 - М-230 47179562	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
599	2023-06-13 11:54:17.896186+03	afae8914-e3c9-4df9-b5d2-e74c3d37a1b8	10.10.152.9:4007 - М-230 47041888	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
600	2023-06-13 11:54:41.437703+03	4367e7b1-cb19-4a38-ab4c-fa5e48b52cbd	10.10.152.9:4007 - М-230 47041738	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
601	2023-06-13 11:54:59.160845+03	5ab166d4-1b48-4d4f-8e69-0e4a2698b1d0	10.10.152.9:4007 - М-230 47041559	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
602	2023-06-13 11:55:14.662846+03	b375c240-c178-4326-979e-c1a79598d75d	10.10.152.9:4007 - М-230 47041803	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
603	2023-06-13 12:45:39.411037+03	49235f93-26de-469a-a3be-5bae576305e3	10.10.152.9:4006 - М-230 47180185	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
604	2023-06-13 12:45:57.812954+03	c89fce0e-714a-4a73-82b3-43423bf64243	10.10.152.9:4006 - М-230 47180103	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
605	2023-06-13 12:46:16.662588+03	033d67bd-560d-4fa9-a5b2-b4ee82585469	10.10.152.9:4006 - М-230 47179963	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
606	2023-06-13 12:46:31.339429+03	5cf80234-0cc5-4711-b751-b7baa9668b52	10.10.152.9:4006 - М-230 47179828	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
607	2023-06-13 12:46:47.013456+03	7bdf3ff7-e0fa-41f2-be66-f06bcaa73421	10.10.152.9:4006 - М-230 47180025	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
608	2023-06-13 12:47:08.670036+03	218ee52f-cb91-4207-87d7-bc349512e106	10.10.152.9:4006 - М-230 47180263	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
609	2023-06-13 12:47:25.077922+03	10b3ad0a-285d-4794-b16e-5070df0e7a55	10.10.152.9:4006 - М-230 47180094	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
610	2023-06-13 12:47:41.846905+03	03e0d3d8-f52b-4151-ad2a-3512e42cf6ec	10.10.152.9:4006 - М-230 47179856	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
611	2023-06-13 12:47:56.219636+03	dc1fd0df-a97f-458f-9ea1-d3231aebffd5	10.10.152.9:4006 - М-230 47180234	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
612	2023-06-13 12:48:15.444475+03	282a4e3b-fd10-4a90-b0e5-bc80a88a154a	10.10.152.9:4006 - М-230 47041252	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
613	2023-06-13 12:48:32.490424+03	090803fc-7203-4a66-a2e6-ef99658847e9	10.10.152.9:4006 - М-230 47042101	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
614	2023-06-13 12:49:09.467055+03	cbedc305-1c01-48fa-90b6-69e806b2181f	10.10.152.9:4006 - М-230 47042214	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
615	2023-06-13 12:49:29.504847+03	6e54ec6e-5ed7-4b8b-990b-36da3de295e7	10.10.152.9:4006 - М-230 47133362	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
616	2023-06-13 12:49:51.55962+03	8ee5ec00-aaba-4ea5-8b7f-123377973f25	10.10.152.9:4006 - М-230 47179531	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
617	2023-06-13 12:50:07.592445+03	3da34b59-b2ba-45b0-abb8-cee2ef85ccb4	10.10.152.9:4006 - М-230 47133158	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
618	2023-06-13 12:50:22.431336+03	1f40a6a1-4567-47c3-af4a-aa9a08a5aa0d	10.10.152.9:4006 - М-230 47046562	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
619	2023-06-13 12:50:41.718995+03	acc6f765-c184-431f-a48d-01637bee2e03	10.10.152.9:4006 - М-230 47133200	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
620	2023-06-13 12:50:58.584936+03	b27eeb3a-b93d-4b92-a465-a7c6fc69b0f7	10.10.152.9:4006 - М-230 47133249	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
621	2023-06-13 12:51:13.380867+03	c8e90403-489b-47f7-843a-543e74e9fe61	10.10.152.9:4006 - М-230 47046555	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
622	2023-06-13 12:51:29.115793+03	990ad889-2f99-4d3c-b532-1427b4e177a4	10.10.152.9:4006 - М-230 47133395	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
623	2023-06-13 12:51:45.899439+03	d90b93af-7088-40c8-b0c5-b0cda5fb80a8	10.10.152.9:4006 - М-230 47133180	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
624	2023-06-15 10:11:57.798707+03	c3d1cc50-084d-48e8-b200-e99ae58849a6	Пульсар ГВС 8343612 - 8343612	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
625	2023-06-15 10:13:08.792179+03	743fa606-4061-4a8a-a138-0deec4ed1524	Пульсар ХВС 8343616 - 8343616	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
657	2023-07-17 10:22:04.230443+03	5c6d51d0-8344-444e-ad72-c16edf1be308	Пульсар ХВС 6440443 - 6440443	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
883	2023-08-29 21:06:18.40597+03	d159f5e9-46ae-465c-895c-75b724d0a4b6	Пульсар 16M 4741269 - 4741269	3		12	1
626	2023-06-15 10:14:06.940855+03	bab90017-a08e-4547-9916-065d69800cfd	Пульсар ХВС 8343619 - 8343619	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
627	2023-06-15 10:17:26.088319+03	ef0050f7-6273-45e2-8c9b-37cc44051d82	Пульсар ГВС 8343622 - 8343622	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
628	2023-06-15 10:21:05.22066+03	7aaee529-873e-4994-9177-ea5be9ec715d	Пульсар Теплосчётчик 7665607 - 7665607	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
629	2023-06-15 20:45:51.483684+03	d462bbac-6529-44f7-a881-37322a864087	Пульсар ГВС 8186635 - 8186635	3		12	3
630	2023-06-15 20:51:52.287002+03	ca8aeb9c-bc07-4e48-9953-25674a9895be	Пульсар ГВС 8187572 - 8187572	3		12	3
631	2023-06-15 20:55:18.075188+03	bd2fb2f3-34e5-41fe-ba32-cad6ea8f4c47	Пульсар ХВС 8186656 - 8186656	3		12	3
632	2023-06-15 21:00:49.214287+03	3578b8ae-eb1a-4c77-b5f6-27c126279f52	Пульсар ГВС 8187044 - 8187044	3		12	3
633	2023-06-15 21:05:32.767406+03	a94d9b38-e288-42af-b119-97e1071599bd	Пульсар ХВС 8187056 - 8187056	3		12	3
634	2023-06-15 21:17:14.100569+03	23347a6d-3fd6-4031-a429-60c0624f97e1	Пульсар ХВС 8187643 - 8187643	3		12	3
635	2023-06-20 12:05:30.89938+03	ee3c62e8-854b-45bd-84b4-7e2d8edd1668	Пульсар ХВС 9005848 - 9005848	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
636	2023-06-20 12:21:39.112587+03	61fd5315-0970-40e7-9d37-31a225be2dba	Пульсар ГВС 8188177 - 8188177	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
637	2023-06-20 12:30:21.173783+03	ef81d4c7-4c09-417f-ba70-263b628f008e	Пульсар ГВС 9070333 - 9070333	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
638	2023-06-20 12:56:52.09972+03	970521d7-3c32-4a2b-bf18-2e818316d082	Пульсар ХВС 9688119 - 9688119	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
639	2023-06-20 13:42:55.47732+03	df7706ca-0f85-4060-a0e1-7a98a2746b48	Пульсар ХВС 8186705 - 8186705	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
640	2023-06-23 12:01:40.286188+03	b5a64bfc-bb57-4303-a250-c0c3f4533333	Пульсар Теплосчётчик 9200966 - 9200966	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
641	2023-06-28 12:17:34.465603+03	d4640e5f-cc83-4a1b-a951-4df26da0a83b	Пульсар ГВС 9654016 - 9654016	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
642	2023-06-28 12:20:22.602863+03	8c12b011-71fe-4e74-992e-8ff43e501a74	Пульсар ГВС 8955942 - 8955942	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
643	2023-07-17 10:14:41.8472+03	5f57bef6-1b6a-4b1e-87d7-47d2a7e47ef5	Пульсар ХВС 8188186 - 8188186	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
644	2023-07-17 10:15:01.547622+03	ba4942cc-f06a-476a-a39e-dcf4c0dbec7e	Пульсар ГВС 8188195 - 8188195	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
645	2023-07-17 10:15:55.332357+03	0933ee13-d87c-4de3-9c6b-d00ddaf2c6c7	Пульсар ХВС 8186702 - 8186702	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
646	2023-07-17 10:16:15.062146+03	df7706ca-0f85-4060-a0e1-7a98a2746b48	Пульсар ГВС 8186705 - 8186705	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
647	2023-07-17 10:16:54.699456+03	6165a47a-08e7-4449-95d9-a54e6c9d5894	Пульсар ХВС 8186708 - 8186708	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
648	2023-07-17 10:17:27.511875+03	4db31e98-122d-4a01-993a-99da08e7945a	Пульсар ГВС 8187002 - 8187002	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
649	2023-07-17 10:18:11.323147+03	01755579-6a00-4f4a-93c5-d3c88f0575c4	Пульсар ХВС 8187005 - 8187005	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
650	2023-07-17 10:18:34.362397+03	9a36f90f-78b7-4cb3-bc95-607965e563bc	Пульсар ГВС 8186998 - 8186998	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
651	2023-07-17 10:19:19.832456+03	67600938-c09b-43d4-a2ce-29587a72fab4	Пульсар ХВС 8187860 - 8187860	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
652	2023-07-17 10:19:43.498989+03	71221288-78d5-4736-ab08-2f2a50cfef6d	Пульсар ГВС 8187859 - 8187859	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
653	2023-07-17 10:20:35.355163+03	6f2067d9-08fe-4e00-a497-1c17b6c72767	Пульсар ХВС 8187856 - 8187856	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
654	2023-07-17 10:20:54.851785+03	a3e86b7b-16f0-4479-ab36-d098085d27c4	Пульсар ГВС 8187852 - 8187852	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
655	2023-07-17 10:21:16.945187+03	fe6f228e-76ae-43ac-8e25-e9c625b88d29	Пульсар ХВС 8187544 - 8187544	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
656	2023-07-17 10:21:41.48006+03	09ca5707-c261-4b24-b4f9-80b89edbb5a9	Пульсар ГВС 8187538 - 8187538	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
658	2023-07-17 10:22:21.926534+03	8877675c-2cac-4565-a315-4fa5321620bb	Пульсар ГВС 7999619 - 7999619	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
659	2023-07-17 10:24:47.416775+03	c4dbdf79-e4d8-4485-949c-5ca973d2a8b0	Пульсар ХВС 7999620 - 7999620	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
660	2023-07-17 10:25:07.936968+03	2e415667-1539-4a99-ac97-c3f8805f9abb	Пульсар ГВС 8002574 - 8002574	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
661	2023-07-17 10:25:37.687759+03	ac5cc70a-d2fd-4c78-98f8-89c62dc282a3	Пульсар ХВС 8187564 - 8187564	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
662	2023-07-17 10:25:56.855503+03	1113f8ed-be5c-4143-91fc-e9864998b82d	Пульсар ГВС 8187569 - 8187569	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
663	2023-07-17 10:26:20.833124+03	42a04639-183e-4ce9-9b9f-4ffbb58e2771	Пульсар ХВС 8187563 - 8187563	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
664	2023-07-17 10:26:44.117509+03	e4affe9c-0d49-43a8-8307-0b079fd2689c	Пульсар ГВС 9070326 - 9070326	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
665	2023-07-17 10:27:08.726493+03	8da75138-7161-459c-a07b-13b870c97d9e	Пульсар ХВС 8187446 - 8187446	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
666	2023-07-17 10:27:27.081052+03	c22829df-f1fa-4e37-8fd1-aadac0cb75cb	Пульсар ГВС 8187449 - 8187449	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
667	2023-07-17 10:28:14.379093+03	a9f55588-e815-4538-a1e0-586aad8cc506	Пульсар ГВС 8188099 - 8188099	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
668	2023-07-17 10:28:35.103238+03	9824d31a-cdcc-4aff-beaf-a613d32c0723	Пульсар ХВС 8188098 - 8188098	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
669	2023-07-17 10:29:09.441566+03	599a1fed-20f8-45c2-8f17-ac8d8f1c1a2c	Пульсар ХВС 8188092 - 8188092	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
670	2023-07-17 10:29:25.920525+03	8bcd50fd-1ef3-4bcc-a4ea-be4798222c5a	Пульсар ГВС 8188091 - 8188091	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
671	2023-07-17 10:29:44.643132+03	0b4b4ba8-fe62-40c6-b7d7-fbadbd5df136	Пульсар ХВС 8187865 - 8187865	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
672	2023-07-17 10:30:02.949247+03	f679bc61-f6be-433a-94e5-d0ec830c7b43	Пульсар ГВС 8187864 - 8187864	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
673	2023-07-17 10:37:25.975328+03	be74c59e-bde4-45fe-a7a1-349ba70f30ac	Пульсар ХВС 5915152 - 5915152	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
674	2023-07-17 10:37:42.843132+03	c05baf90-04b6-4cff-a46f-345dc95a521d	Пульсар ГВС 5915155 - 5915155	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
675	2023-07-17 10:38:03.818788+03	bd94531c-e42e-4124-a5fa-027ddd237e19	Пульсар ХВС 5915116 - 5915116	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
676	2023-07-17 10:38:22.750221+03	f127cdfa-035c-41cb-9209-b3577d47608e	Пульсар ГВС 9070329 - 9070329	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
677	2023-07-17 10:38:51.099133+03	489bb243-56bc-4142-96ab-b4fccc91286b	Пульсар ХВС 8006275 - 8006275	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
678	2023-07-17 10:39:12.198501+03	6593f73d-9645-458f-a947-26bc0fd3e55d	Пульсар ГВС 8006267 - 8006267	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
679	2023-07-17 10:39:40.736303+03	dfb1212d-9ea7-4149-9104-42cc078dd1df	Пульсар ХВС 8188533 - 8188533	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
680	2023-07-17 10:40:02.925231+03	f83e2eed-2e64-4705-94ec-b500aec8243c	Пульсар ГВС 8188531 - 8188531	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
681	2023-07-17 10:40:35.402474+03	a633d0a7-47d1-4a81-9a28-74eb1d9338a5	Пульсар ХВС 8186850 - 8186850	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
682	2023-07-17 10:40:56.771748+03	ad790f3e-6eb4-4df5-b698-a96d8c7cd278	Пульсар ГВС 8186843 - 8186843	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
683	2023-07-20 10:14:19.774561+03	f70ff64d-ba48-4309-9e01-e4ce4df516ef	Пульсар ХВС 8187139 - 8187139	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
684	2023-07-20 10:14:41.518218+03	51ff21a4-27ae-4b62-a946-e920ccb04cbf	Пульсар ГВС 8186641 - 8186641	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
685	2023-07-25 20:14:55.614707+03	73d0e7c8-8a0b-442d-906a-f84f51fa9e13	Пульсар ГВС 8187416 - 8186166	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
686	2023-07-25 20:15:45.901962+03	64ffcab1-58d1-405b-9eec-f9bb1500ded6	Пульсар ГВС 8186040 - 8187389	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
687	2023-07-25 20:16:59.80693+03	dc17d491-2a52-472c-bbfd-81201dd755ec	Пульсар ГВС 8187411 - 8187441	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
688	2023-07-25 20:33:43.533667+03	dc17d491-2a52-472c-bbfd-81201dd755ec	Пульсар ГВС 8187411 - 8187441	2	[]	12	3
689	2023-07-25 20:34:00.852144+03	dc17d491-2a52-472c-bbfd-81201dd755ec	Пульсар ГВС 8187411 - 8187411	2	[{"changed": {"fields": ["\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
690	2023-07-25 20:36:14.607554+03	73d0e7c8-8a0b-442d-906a-f84f51fa9e13	Пульсар ГВС 8187416 - 8187416	2	[{"changed": {"fields": ["\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
691	2023-07-25 20:37:06.476708+03	64ffcab1-58d1-405b-9eec-f9bb1500ded6	Пульсар ГВС 8186040 - 8186040	2	[{"changed": {"fields": ["\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
692	2023-07-25 20:38:24.714395+03	da6cadcd-4049-4481-aed7-c19b3be273f9	Пульсар ХВС 8187388 - 8187388	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
693	2023-07-26 10:26:06.113353+03	a8659808-d1f1-408f-a60f-216e23adc0a8	Пульсар Теплосчётчик 7647827 - 7647827	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
694	2023-07-26 10:37:31.244549+03	eb198858-8ddb-4245-8730-b9d3b8c7aeb9	М-200 47555915 - 47555915	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
695	2023-07-26 13:12:29.847757+03	9eb82aaa-e3cb-413a-bbca-4e31d5078f81	Пульсар ХВС 8187252 - 8187252	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
696	2023-07-26 13:12:51.382189+03	3d1248ec-4e42-476c-addd-aa61192521f0	Пульсар ГВС 8186348 - 8186348	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
697	2023-07-26 13:13:26.186018+03	fda55525-0815-4679-95b0-1fc6fb4d12ca	Пульсар ХВС 8187349 - 8187349	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
698	2023-07-26 13:13:47.035939+03	c5f4564a-9411-425e-9ccf-67ac10249713	Пульсар ГВС 8186660 - 8186660	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
699	2023-07-27 15:46:45.589572+03	116308e2-6c84-4c22-8a0c-cd4015aaacaf	2 ВРУ 4	2	[{"changed": {"fields": ["Name"]}}]	25	3
700	2023-07-27 15:46:54.840186+03	2d829faa-134e-4130-8002-79815518024e	1 ВРУ 6	2	[{"changed": {"fields": ["Name"]}}]	25	3
701	2023-07-27 15:47:10.268219+03	61e72c07-b021-4595-b0ab-4fa5c67d7c4b	2 ВРУ 5	2	[{"changed": {"fields": ["Name"]}}]	25	3
702	2023-07-27 15:47:26.214782+03	758c6440-d6dd-458b-bb6b-4e11cff24f7e	2 ВРУ 3	2	[{"changed": {"fields": ["Name"]}}]	25	3
703	2023-07-27 15:47:38.972631+03	9a191199-01c7-42ae-a4bd-4f3489191cbe	2 ВРУ 13	2	[{"changed": {"fields": ["Name"]}}]	25	3
704	2023-07-27 15:47:48.679786+03	e18eec59-24c5-4a64-a173-e14bd25686d1	1 ВРУ 10	2	[{"changed": {"fields": ["Name"]}}]	25	3
705	2023-07-27 15:47:58.143417+03	d8715dfe-3002-460c-810d-7a475c88bc7a	2 ВРУ 17	2	[{"changed": {"fields": ["Name"]}}]	25	3
706	2023-07-27 18:10:40.548696+03	4d5ce9d7-30e3-448b-863a-a31c28c66be4	М-230 47181659 - 47181659	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
707	2023-07-28 10:30:39.843024+03	c8779c5e-40c5-42c0-bbe3-b160dcfad081	ГРЩ 1	2	[{"changed": {"fields": ["Name"]}}]	25	3
708	2023-07-28 10:30:54.792507+03	b955dde5-f702-40f9-8547-19a733162878	ГРЩ 2	2	[{"changed": {"fields": ["Name"]}}]	25	3
709	2023-07-28 13:08:30.80298+03	da33e858-64e5-4e45-afbc-a8b090b17a19	М-230 47318760 - 47318760	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
710	2023-07-31 14:57:54.243378+03	3adff8c2-6e01-41d4-beaa-c95d0d6a906c	Учет 1.1 РП b1.1/10 (1ВРУ15.ВВ1)	2	[{"changed": {"fields": ["Name"]}}]	7	3
711	2023-07-31 14:58:18.753612+03	51758644-8024-492f-b665-37a8581cbeef	Учет 2.2 РП b1.1/10 (ЩСН)	2	[{"changed": {"fields": ["Name"]}}]	7	3
712	2023-07-31 14:59:06.650227+03	6f74f6fa-66cc-4609-83f6-f13b735a1457	Учет 1.1 РП b1.1/11 (ЩСН ДЭС )	2	[{"changed": {"fields": ["Name"]}}]	7	3
713	2023-07-31 14:59:26.616363+03	6f74f6fa-66cc-4609-83f6-f13b735a1457	Учет 1.1 РП b1.1/11 (ЩСН ДЭС)	2	[{"changed": {"fields": ["Name"]}}]	7	3
714	2023-07-31 14:59:46.812645+03	1b6884cb-3aa8-4190-aeef-411fd1c1bce9	Учет 1.1 РП b1.1/14 (1.1 ППУ-47.1.ВВ1)	2	[{"changed": {"fields": ["Name"]}}]	7	3
715	2023-07-31 15:01:41.957967+03	54b6f765-e81d-4163-af47-201b359c9695	Учет 1.1 РП b1.1/8 (1ВРУ12.ВВ1)	2	[{"changed": {"fields": ["Name"]}}]	7	3
716	2023-07-31 15:02:17.127698+03	464cf543-7378-42c5-ac86-856617d567d6	Учет 1.1 РП b1.1/9 (1ВРУ14.ВВ1)	2	[{"changed": {"fields": ["Name"]}}]	7	3
717	2023-07-31 15:03:44.251902+03	98f0e90e-d494-4925-b099-ac904026afa0	Учет 1.1 РП b1.2/10 (1ВРУ15.ВВ2)	2	[{"changed": {"fields": ["Name"]}}]	7	3
718	2023-07-31 15:04:36.068338+03	22540680-40a6-460c-8a0f-430f267b3c94	Учет 1.1 РП b1.2/11 (ЩНО)	2	[{"changed": {"fields": ["Name"]}}]	7	3
719	2023-07-31 15:05:11.819542+03	3b27404d-cc7c-49aa-b4f4-e67f6466a3c5	Учет 1.1 РП b1.2/13 (Щ.АСУД)	2	[{"changed": {"fields": ["Name"]}}]	7	3
720	2023-07-31 15:05:41.890091+03	027cd0ec-d2bf-4ff9-bd5a-492c9224b19c	Учет 1.1 РП b1.2/14 (1.1 ППУ-47.1.ВВ2)	2	[{"changed": {"fields": ["Name"]}}]	7	3
721	2023-07-31 15:06:55.766642+03	54ddc503-f2d0-4623-9bbb-a17b2c0d895f	Учет 1.1 РП b1.2/8 (1ВРУ12.ВВ2)	2	[{"changed": {"fields": ["Name"]}}]	7	3
722	2023-07-31 15:07:27.15+03	2217971f-766f-4a93-ad9a-4d46fc6ffbc0	Учет 1.1 РП b1.2/9 (1ВРУ14.ВВ2)	2	[{"changed": {"fields": ["Name"]}}]	7	3
723	2023-07-31 15:08:24.264636+03	b36c0144-4f6a-4dc3-9782-3aa5706e0afb	Учет 2.2 РП b1.1/6 (2ВРУ11.ВВ1)	2	[{"changed": {"fields": ["Name"]}}]	7	3
724	2023-07-31 15:08:39.721364+03	e9bf185b-780c-4b6e-97d7-a503df91be26	Учет 2.2 РП b1.1/6_7 (2ВРУ13.ВВ1)	2	[{"changed": {"fields": ["Name"]}}]	7	3
725	2023-07-31 15:09:21.492123+03	e27987a9-ebb6-453b-8e0d-5c0e1c8868a6	Учет 2.2 РП b1.1/9 (2.2 ППУ-47.1.ВВ1)	2	[{"changed": {"fields": ["Name"]}}]	7	3
726	2023-07-31 15:09:51.569686+03	6d21b979-5b86-4ecf-8d27-e441de2c0472	Учет 2.2 РП b1.2/11 (2.2 ППУ-47.1.ВВ2)	2	[{"changed": {"fields": ["Name"]}}]	7	3
727	2023-07-31 15:10:27.980297+03	d8c2b9dd-0222-4740-9459-e2f3e001c0dd	Учет 2.2 РП b1.2/6 (2ВРУ11.ВВ2)	2	[{"changed": {"fields": ["Name"]}}]	7	3
728	2023-07-31 15:10:51.975542+03	c3c307fd-68c8-49b3-b67c-998dd4dff326	Учет 2.2 РП b1.2/7 (2ВРУ13.ВВ2)	2	[{"changed": {"fields": ["Name"]}}]	7	3
729	2023-07-31 15:24:18.925332+03	424f1429-5609-4aa0-92cc-85a0f32d0dc6	ЩМ (фасадное освещение)	2	[{"changed": {"fields": ["Name"]}}]	7	3
730	2023-07-31 15:26:24.491866+03	08bd1d23-1474-4b38-aabe-049366c32ac5	ЩФО (фасадное освещение)	2	[{"changed": {"fields": ["Name"]}}]	7	3
731	2023-07-31 20:16:49.725343+03	e89ec606-1df0-4fbe-996f-0c13ed16ef79	М-230 48328991 - 48328991	3		12	3
732	2023-07-31 20:17:10.202031+03	af051987-ef1e-4e0b-9243-1d13baa2c1a0	М-230 48328971 - 48328971	3		12	3
733	2023-08-01 13:54:23.935481+03	650f7738-bf15-48dc-bee8-a2547d94c4bb	Помещение 4.20	2	[{"changed": {"fields": ["Guid objects"]}}]	7	3
734	2023-08-01 14:04:30.240242+03	0165cd38-ccf5-41a8-bb6c-0fbf9647dd0a	М-230 47314906 - 47314906	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
735	2023-08-02 14:32:33.767903+03	0a6de234-9ffb-4679-921a-4c54d302fee8	Пульсар ГВС 8186611 - 8186611	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "Guid types meters"]}}]	12	3
736	2023-08-03 10:24:25.702919+03	708549ad-012a-4aee-aa07-97ae65b032f9	Пульсар ГВС 9690044 - 9690044	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
775	2023-08-07 15:29:42.557243+03	bd28cbcd-b0bd-2898-d384-102f4888c3e4	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
737	2023-08-03 10:26:03.316723+03	dfbe6240-f3a6-4dff-a7fa-e20fb884d291	Пульсар ГВС 8186039 - 8186039	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
738	2023-08-03 10:33:55.360885+03	660a12d6-1369-4bb0-8872-2f78586e0c42	Пульсар ГВС 9005821 - 9005821	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
739	2023-08-03 10:57:07.11424+03	b905d1fc-68f0-4472-8a57-38ecde40862c	Пульсар ГВС 9653992 - 9653992	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
740	2023-08-03 11:19:23.089892+03	744d9045-e2a6-4dbb-b3c8-d076a9b7debc	Пульсар ХВС 9654018 - 9654018	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
741	2023-08-03 11:34:36.480078+03	6cd2f18c-cd6e-429b-87f9-2438a7f2b71a	Пульсар ГВС 8343618 - 8343618	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
742	2023-08-03 11:43:22.027839+03	2b74f14e-e2f3-45b4-94f1-b733662f61a8	10.10.152.9:4007 - М-230 48328988	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
743	2023-08-03 12:59:40.844353+03	dbc3c6d5-98c5-4eee-aa04-b2c26b12944a	М-230 47444449 - 47444449	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
744	2023-08-04 11:14:07.581602+03	5edb1d1e-d63f-45b0-b4a4-7f7e1fec1628	Меркурий СПОДЭС	1	[{"added": {}}]	22	3
745	2023-08-04 11:19:18.597994+03	acf7be90-1f6f-4a2d-a809-e3f7b8c18cc6	М-230 48328943 - 48328943	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "Guid types meters"]}}]	12	3
746	2023-08-04 12:54:47.969351+03	9db8ab25-5009-42c0-887a-2671cec9a6f0	Пульсар ГВС 8343617 - 8343617	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
747	2023-08-04 14:16:00.965782+03	024b9fa8-d69a-4781-8a97-f09541cb2bec	М-230 48329085 - 48329085	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "Guid types meters"]}}]	12	3
748	2023-08-04 14:17:03.687748+03	abcb6dbf-4009-4938-8628-54d3d13047a4	М-230 48328993 - 48328993	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "Guid types meters"]}}]	12	3
749	2023-08-04 14:19:25.677149+03	bb2dcfa2-3f09-4112-a1bd-832d932dc89e	М-230 48329016 - 48329016	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "Guid types meters"]}}]	12	3
750	2023-08-04 14:19:55.371639+03	67dc56a5-8153-4544-a64c-d4807b5bd9d4	М-230 48329018 - 48329018	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
751	2023-08-04 14:21:05.09999+03	681b5e99-5540-4799-aefe-a2269c5c5f37	М-230 48328953 - 48328953	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
752	2023-08-04 14:21:40.396164+03	b8851e42-af88-427c-80df-b73605cbcd6c	М-230 48329047 - 48329047	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
753	2023-08-04 14:22:08.386824+03	253fd614-10f0-48ba-a87b-c7a6e14de32f	М-230 48329019 - 48329019	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
754	2023-08-04 14:22:38.157118+03	78245017-f648-45b8-843d-3b677e232ba8	М-230 48329111 - 48329111	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
755	2023-08-04 14:23:03.306117+03	4d8f9123-5286-4cc4-944c-5c9acc346cfd	М-230 47845804 - 47845804	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
756	2023-08-04 14:23:30.213532+03	426eb730-0fc4-4d8f-946f-6b776d01a289	М-230 48328998 - 48328998	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
757	2023-08-04 14:24:04.336764+03	0b0905ca-63d8-43c0-a294-a3ae94b9faf1	М-230 48328971 - 48328971	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
758	2023-08-04 14:25:49.112881+03	50f1c4c0-b4ed-4f43-9221-b4ec05b54fe9	М-230 48328991 - 48328991	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
759	2023-08-04 15:53:03.084016+03	4935920b-a0d9-4f37-b891-4a4935007d99	М-230 48328988 - 48328988	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
760	2023-08-04 15:53:22.085977+03	2b26cd27-2f37-495f-94cc-803edd20b704	М-230 48329849 - 48329849	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
761	2023-08-04 15:53:38.200899+03	d9525954-ff04-4d35-9775-072a38b318db	М-230 48329033 - 48329033	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
762	2023-08-07 14:03:42.069768+03	dbd1089b-1634-3697-449d-b50c39453084	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
763	2023-08-07 14:03:50.912467+03	d7b90d6e-5031-d244-ff76-91e4af82d017	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
764	2023-08-07 14:03:59.480979+03	c6ba7488-abf6-b72e-79ba-e8f80fd1337b	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
765	2023-08-07 14:04:17.144858+03	c6ba7488-abf6-b72e-79ba-e8f80fd1337b	ШУ 1, ВП 1 - М-230 47318760	2	[]	31	3
766	2023-08-07 14:04:35.380863+03	dbd1089b-1634-3697-449d-b50c39453084	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
767	2023-08-07 14:04:44.218109+03	d7b90d6e-5031-d244-ff76-91e4af82d017	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
768	2023-08-07 14:04:52.748487+03	c6ba7488-abf6-b72e-79ba-e8f80fd1337b	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
769	2023-08-07 14:05:02.094886+03	b614727e-b3a3-eef5-0972-31707481867d	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
770	2023-08-07 14:05:18.216917+03	b2055403-f5c9-8750-5ebb-f6b5f1d7d4b5	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
771	2023-08-07 14:05:28.58741+03	ac20f99b-2ed3-49a8-75aa-092cb09a6738	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
772	2023-08-07 14:05:47.933203+03	8e413c4d-104d-612d-4abe-266f00e4b59f	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
773	2023-08-07 14:05:58.01178+03	0fb4d125-8464-85bc-a467-dc0638217dce	ШУ 1, ВП 1 - М-230 47318760	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
774	2023-08-07 15:29:30.943821+03	d2666c6a-fdca-b392-3fc3-70deec60e3b6	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
776	2023-08-07 15:29:52.664414+03	b0ddab8c-bc7c-2036-600f-7ddace343cb1	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
777	2023-08-07 15:30:19.005561+03	b0ddab8c-bc7c-2036-600f-7ddace343cb1	ВВОД 2 - М-230 46697754	2	[]	31	3
778	2023-08-07 15:30:29.381434+03	a8d5e3cc-fbdd-41e7-0001-2dcc6a242d6d	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
779	2023-08-07 15:30:40.689531+03	791de2bc-4cbc-d2d0-ffeb-68941008fd30	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
780	2023-08-07 15:30:56.603352+03	6c6d1b95-d741-d5a5-f3cf-c9f9d5dfddeb	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
781	2023-08-07 15:31:06.585716+03	37f35d67-33c7-af51-8d10-457a3d378dad	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
782	2023-08-07 15:31:17.038339+03	016915a2-d5be-2941-af95-5a353add4623	ВВОД 2 - М-230 46697754	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
783	2023-08-07 15:32:41.246137+03	9e17bd05-85a3-6a91-6465-8dc1a2b5b57e	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
784	2023-08-07 15:32:50.320501+03	969df0d8-8781-63e7-ecb3-dca9c36fde6c	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
785	2023-08-07 15:33:00.408015+03	89e227aa-c2a4-d2eb-504f-96c371f2e03b	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
786	2023-08-07 15:33:09.946743+03	74a03bd4-bce8-3e52-a67d-939449150cd6	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
787	2023-08-07 15:33:19.626368+03	7012d9d2-8a26-2b7f-baf8-661220bd6ebf	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
788	2023-08-07 15:33:29.297303+03	6db00cde-e06b-9bce-88f3-6d3ca0ec77e0	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
789	2023-08-07 15:33:49.785931+03	5c530a1c-2e24-acdb-f234-de7ff20fb8ec	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
790	2023-08-07 15:34:09.278936+03	431e95a4-7e03-aa2a-b45f-1ad6579f52a2	ВВОД 1 - М-230 46699626	2	[{"changed": {"fields": ["Coefficient"]}}]	31	3
791	2023-08-11 16:00:11.569259+03	dce68a94-2fb1-4856-acd6-2a1b13d5ec99	Пульсар Теплосчётчик Error_code Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	3
792	2023-08-11 17:58:25.16132+03	dce68a94-2fb1-4856-acd6-2a1b13d5ec99	Пульсар Теплосчётчик Error_code Суточный -- adress: 24  channel: 0	2	[{"changed": {"fields": ["Param address"]}}]	14	3
793	2023-08-14 14:05:47.180904+03	c8e90403-489b-47f7-843a-543e74e9fe61	10.10.152.9:4007 - М-230 47046555	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
794	2023-08-14 14:06:19.97181+03	990ad889-2f99-4d3c-b532-1427b4e177a4	10.10.152.9:4007 - М-230 47133395	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
795	2023-08-14 14:06:46.288598+03	09884dbd-038f-4b21-9858-629171ffef65	10.10.152.9:4007 - М-230 47133180	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
796	2023-08-16 10:55:03.285412+03	6f8c21a8-90a2-4f47-9f86-565193064644	10.10.152.6:4001	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
797	2023-08-16 10:55:25.885908+03	c4cdac5d-6ef1-42b1-87c8-34262a198d2b	10.10.152.6:4002	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
798	2023-08-16 10:55:47.918962+03	efc15026-664a-4086-8da2-68bfdc7aad7f	10.10.152.5:4001	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
799	2023-08-16 10:56:38.533641+03	452caf88-bec4-4f14-9101-08b541d0cc47	10.10.152.5:4002	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
800	2023-08-16 10:57:18.753945+03	d8240d11-5c82-40b0-8531-2dd714fb0b99	10.10.152.7:4001	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
801	2023-08-16 10:57:45.684594+03	f3bc4a53-e508-406d-94a6-fa9479963b0d	10.10.152.7:4002	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
802	2023-08-16 10:58:13.960376+03	a138e4cf-abe3-4689-9f9b-34a8de7d2cdd	10.10.152.4:4001	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
803	2023-08-16 10:58:44.82825+03	41507458-45e9-42d7-824f-e4db46027248	10.10.152.4:4002	2	[{"changed": {"fields": ["Ip address", "Ip port"]}}]	20	3
804	2023-08-16 11:57:40.560083+03	cfe73605-857d-4f55-a962-75a4db34e949	10.10.152.5:4001 - М-230 47047050	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
805	2023-08-16 11:58:03.840481+03	bef1aaf5-0f5d-4c45-ab42-c2507d014c31	10.10.152.5:4001 - М-230 47046502	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
806	2023-08-16 11:58:22.773858+03	c1194300-309c-4ad4-97c3-3ce9e0ca9496	10.10.152.5:4001 - М-230 47133398	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
807	2023-08-16 11:58:48.811889+03	d73226b3-758d-4f42-8bea-86755476b6cc	10.10.152.5:4001 - М-230 47047239	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
808	2023-08-16 11:59:08.126369+03	c8e90403-489b-47f7-843a-543e74e9fe61	10.10.152.5:4001 - М-230 47046555	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
809	2023-08-16 11:59:59.705899+03	990ad889-2f99-4d3c-b532-1427b4e177a4	10.10.152.5:4001 - М-230 47133395	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
810	2023-08-16 12:00:41.36302+03	09884dbd-038f-4b21-9858-629171ffef65	10.10.152.5:4001 - М-230 47133180	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
811	2023-08-16 22:03:24.977926+03	7e262084-9790-478a-9ba7-5ef77221d146	10.10.152.9:4007	1	[{"added": {}}]	20	3
812	2023-08-16 22:04:24.929256+03	ff6db536-bb2c-4cbf-b4f1-e6519c99413a	10.10.152.9:4007 - М-230 48329033	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
813	2023-08-16 22:04:52.624363+03	44a73121-60e1-4832-89a4-2a1a79fbe192	10.10.152.9:4007 - М-230 48329849	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
814	2023-08-16 22:05:12.844314+03	f448fbf0-d0a3-4888-b3a8-9e7c14c4a640	10.10.152.9:4007 - М-230 48328988	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
815	2023-08-16 23:08:42.329413+03	426eb730-0fc4-4d8f-946f-6b776d01a289	М-230 48328998 - 48328998	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
816	2023-08-16 23:10:15.794317+03	0b0905ca-63d8-43c0-a294-a3ae94b9faf1	М-230 48328971 - 48328971	2	[{"changed": {"fields": ["\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0438\\u0437 \\u043f\\u0440\\u0438\\u0431\\u043e\\u0440\\u0430)", "\\u0421\\u043e\\u0432\\u043f\\u0430\\u0434\\u0435\\u043d\\u0438\\u0435 \\u043d\\u043e\\u043c\\u0435\\u0440\\u043e\\u0432"]}}]	12	3
817	2023-08-17 20:28:37.726503+03	bb2dcfa2-3f09-4112-a1bd-832d932dc89e	М-230 48329016 - 48329016	2	[{"changed": {"fields": ["\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0438\\u0437 \\u043f\\u0440\\u0438\\u0431\\u043e\\u0440\\u0430)", "\\u0421\\u043e\\u0432\\u043f\\u0430\\u0434\\u0435\\u043d\\u0438\\u0435 \\u043d\\u043e\\u043c\\u0435\\u0440\\u043e\\u0432", "Guid types meters"]}}]	12	3
818	2023-08-17 20:30:34.955893+03	bb2dcfa2-3f09-4112-a1bd-832d932dc89e	М-230 48329016 - 48329016	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
819	2023-08-17 21:39:29.810956+03	4d8f9123-5286-4cc4-944c-5c9acc346cfd	М-230 47845804 - 47845804	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
820	2023-08-17 21:42:54.276461+03	4d8f9123-5286-4cc4-944c-5c9acc346cfd	М-230 47845804 - 47845804	2	[{"changed": {"fields": ["Guid types meters"]}}]	12	3
821	2023-08-17 21:43:06.105689+03	4d8f9123-5286-4cc4-944c-5c9acc346cfd	М-230 47845804 - 47845804	2	[{"changed": {"fields": ["\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0438\\u0437 \\u043f\\u0440\\u0438\\u0431\\u043e\\u0440\\u0430)", "\\u0421\\u043e\\u0432\\u043f\\u0430\\u0434\\u0435\\u043d\\u0438\\u0435 \\u043d\\u043e\\u043c\\u0435\\u0440\\u043e\\u0432"]}}]	12	3
822	2023-08-24 12:50:16.568546+03	2f9add05-ba2e-4d53-a1ec-3f32996e354a	10.10.152.11:4003 - Пульсар ХВС 8942680	2	[]	27	3
823	2023-08-24 12:51:37.535124+03	1fe87690-9ecc-4403-b677-537ace9c576e	10.10.152.11:4002	1	[{"added": {}}]	20	3
824	2023-08-24 12:52:13.608101+03	2f9add05-ba2e-4d53-a1ec-3f32996e354a	10.10.152.11:4002 - Пульсар ХВС 8942680	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
825	2023-08-24 12:52:46.600099+03	0fa1d01b-0d8b-46f5-8c56-5a80081d4c9a	10.10.152.11:4002 - Пульсар ГВС 8186885	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
826	2023-08-24 18:28:21.378647+03	e8fa5e00-e1b9-4ef3-bc39-b8439a44b540	Sanext	1	[{"added": {}}]	22	1
827	2023-08-24 18:29:18.110995+03	dd95cc37-023c-4d15-861d-8a7363f36d9c	Sanext Энергия Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
828	2023-08-24 18:33:01.007112+03	dd95cc37-023c-4d15-861d-8a7363f36d9c	Sanext Энергия Суточный -- adress: 7  channel: 1	2	[{"changed": {"fields": ["Param address", "Channel"]}}]	14	1
829	2023-08-24 18:36:10.066705+03	f83d191d-1252-4257-ab85-5d0bba9a04c2	Sanext Объем Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
830	2023-08-24 18:37:23.376902+03	e2baef4b-3cfe-4f19-aec7-0d77f5c8a822	Sanext To Суточный -- adress: 4  channel: 1	1	[{"added": {}}]	14	1
831	2023-08-24 18:38:09.140597+03	ae423b31-9b3d-4ab3-a6cf-8b745faf48f0	Sanext Ti Суточный -- adress: 3  channel: 1	1	[{"added": {}}]	14	1
832	2023-08-24 19:03:49.105655+03	fab540ab-8a02-4732-a24d-5ef5ab07bf5b	Корпус 4	3		25	1
833	2023-08-24 19:03:49.111506+03	f586ea69-3859-486b-954c-f6610e5e609d	2 ВРУ 16	3		25	1
834	2023-08-24 19:03:49.113459+03	ed075b37-66c5-42f0-a72f-14415c14fdc9	2 ВРУ 8	3		25	1
835	2023-08-24 19:03:49.116383+03	e82bb3d0-0a7a-4666-afeb-105bbf566b7b	Корпус 5, НП	3		25	1
836	2023-08-24 19:03:49.118334+03	e18eec59-24c5-4a64-a173-e14bd25686d1	1 ВРУ 10	3		25	1
837	2023-08-24 19:03:49.120286+03	dddc6657-18c2-4235-a3b4-10e9b7046a47	Корпус 2	3		25	1
838	2023-08-24 19:03:49.122235+03	dafbf5c7-33ed-42ad-8beb-d1086a4b8533	ВРУ ЦТП	3		25	1
839	2023-08-24 19:03:49.124185+03	d8715dfe-3002-460c-810d-7a475c88bc7a	2 ВРУ 17	3		25	1
840	2023-08-24 19:03:49.125163+03	c99f69f7-2c94-4d20-8f7f-ee6e59760ed2	2 ВРУ 11 ДОО	3		25	1
841	2023-08-24 19:03:49.127113+03	c8779c5e-40c5-42c0-bbe3-b160dcfad081	ГРЩ 1	3		25	1
842	2023-08-24 19:03:49.129063+03	bf5efc83-d7b0-4f2f-bec6-fbc572e616ad	1 ВРУ 2	3		25	1
843	2023-08-24 19:03:49.131014+03	b955dde5-f702-40f9-8547-19a733162878	ГРЩ 2	3		25	1
844	2023-08-24 19:03:49.132965+03	b6a44300-5aeb-4243-92f7-69d5af57cecb	Корпус 4, кладовые	3		25	1
845	2023-08-24 19:03:49.134915+03	9a191199-01c7-42ae-a4bd-4f3489191cbe	2 ВРУ 13	3		25	1
846	2023-08-24 19:03:49.136865+03	904327d2-c8ba-4ec7-9086-e1ddb9406fae	1.1ППУ47.1	3		25	1
847	2023-08-24 19:03:49.137843+03	7ed762a6-586b-44bc-a2c2-c390b2960e3d	Корпус 1, кладовые	3		25	1
848	2023-08-24 19:03:49.139792+03	758c6440-d6dd-458b-bb6b-4e11cff24f7e	2 ВРУ 3	3		25	1
849	2023-08-24 19:03:49.141742+03	6ffc50ba-defb-4885-9c38-0b401e4f7e5b	1 ВРУ 1	3		25	1
850	2023-08-24 19:03:49.143694+03	6def2ee1-996e-40a6-b762-9ce6ea16c1a7	Корпус 2, кладовые	3		25	1
851	2023-08-24 19:03:49.145643+03	6da60413-a5c3-4105-9eaf-2def017b9590	Корпус 3	3		25	1
852	2023-08-24 19:03:49.146621+03	6372ce0b-3ba4-485b-9bb7-08057080a2dc	1 ВРУ 12	3		25	1
853	2023-08-24 19:03:49.14857+03	61e72c07-b021-4595-b0ab-4fa5c67d7c4b	2 ВРУ 5	3		25	1
854	2023-08-24 19:03:49.150522+03	5b39cdd2-ade4-463f-af57-4cb669a9bab6	Корпус 4, НП	3		25	1
855	2023-08-24 19:03:49.15247+03	4bd60119-48ac-4c49-b2bb-68f6ab3f8eec	Корпус 5	3		25	1
856	2023-08-24 19:03:49.154424+03	2d829faa-134e-4130-8002-79815518024e	1 ВРУ 6	3		25	1
857	2023-08-24 19:03:49.155399+03	2c1ff636-f953-4254-ba75-0119c78ce6c1	1 ВРУ 7	3		25	1
858	2023-08-24 19:03:49.15735+03	2519bba1-c087-4613-bd89-e8996b770019	1 ВРУ 9	3		25	1
859	2023-08-24 19:03:49.159298+03	134527d1-28cb-4351-9c23-f3d61dcb8cce	ВРУ ДГУ (ВРУ-ДЭС)	3		25	1
860	2023-08-24 19:03:49.161249+03	116308e2-6c84-4c22-8a0c-cd4015aaacaf	2 ВРУ 4	3		25	1
861	2023-08-24 19:03:49.163201+03	05cf94ef-9e5c-43cf-bcd4-d9553ba47934	2.2ППУ47.1	3		25	1
862	2023-08-24 19:03:49.165151+03	04a1dd9f-ab62-4f75-ae0b-c1dd4c182a49	Корпус 1	3		25	1
863	2023-08-24 19:03:49.166128+03	036eed22-b0aa-4989-9594-eb813fa590d9	1 ВРУ 15, Насосная	3		25	1
864	2023-08-24 19:03:49.168077+03	0169b81e-2e88-4075-b1db-76d80f81d179	Корпус 3, кладовые	3		25	1
865	2023-08-24 19:03:49.170028+03	0063accb-ad5e-4a64-9b67-445c0b8a7c64	Корпус 5, кладовые	3		25	1
866	2023-08-24 19:04:14.323678+03	b29b8e21-e202-4cfa-a098-82fdeadcb7fd	Импульсные ПУ	2	[{"changed": {"fields": ["Name"]}}]	25	1
867	2023-08-24 19:04:28.003667+03	63cc4390-a41a-4574-a4e3-5c4689dea49f	улица Тестовая	2	[{"changed": {"fields": ["Name"]}}]	25	1
868	2023-08-29 17:43:07.02828+03	2e9a6a12-a597-417f-adcf-7b2fe5b646cf	Квартира 013	3		7	1
869	2023-08-29 21:06:18.376695+03	fe16f9a7-aaa9-43b1-b9b4-beb301ae10d8	Пульсар 16M 641515 - 641515	3		12	1
870	2023-08-29 21:06:18.38158+03	fc199d5d-dadc-4a65-80e3-0e967a7a1702	Пульсар 16M 4741358 - 4741358	3		12	1
871	2023-08-29 21:06:18.386448+03	f85ef8bc-de3c-4ecf-9ce6-a18f3b8086bc	Пульсар 16M 4741258 - 4741258	3		12	1
872	2023-08-29 21:06:18.388412+03	f7127a30-2937-495a-bdb1-59f18597d3f5	Пульсар 16M 4741115 - 4741115	3		12	1
873	2023-08-29 21:06:18.390363+03	f0094937-3b0b-4c39-855f-1c2117b266c5	Пульсар 16M 4741266 - 4741266	3		12	1
874	2023-08-29 21:06:18.392313+03	ed1a396a-f538-44c0-88ea-0c0740a70172	Пульсар 16M 4741157 - 4741157	3		12	1
875	2023-08-29 21:06:18.394252+03	ec00d1fd-8f30-4219-b2fb-d81b65444d6c	Пульсар 16M 4741123 - 4741123	3		12	1
876	2023-08-29 21:06:18.395232+03	ea4a5503-82f0-41e9-ab36-0220d57b5bbe	Пульсар 16M 4741307 - 4741307	3		12	1
877	2023-08-29 21:06:18.397192+03	e3721ef7-d5ae-4f12-adbf-540898dc9dad	Пульсар 16M 4741444 - 4741444	3		12	1
878	2023-08-29 21:06:18.399141+03	dc5f8bc8-e082-435f-a2d8-a2b9692c413a	Пульсар 16M 4741310 - 4741310	3		12	1
879	2023-08-29 21:06:18.400116+03	d9fc5b5a-d0f2-4a11-988b-511d35a9172a	Пульсар 16M 4741447 - 4741447	3		12	1
880	2023-08-29 21:06:18.401091+03	d70073db-4a50-4863-abb6-2c9fbdb33672	Пульсар 16M 4741118 - 4741118	3		12	1
884	2023-08-29 21:06:18.40792+03	cf461aac-8202-4c66-b1d9-17bd69a686dc	Пульсар 16M 4741163 - 4741163	3		12	1
885	2023-08-29 21:06:18.409871+03	ccd85f06-023e-4769-93a2-80ef5c4e53bc	Пульсар 16M 4741309 - 4741309	3		12	1
886	2023-08-29 21:06:18.410847+03	cc905f4a-a190-4577-b7e6-b81737e59cda	Пульсар 16M 4741278 - 4741278	3		12	1
887	2023-08-29 21:06:18.412797+03	c219fb34-2c67-4f0f-a4df-8bfe6b0bc3a0	Пульсар 16M 4771313 - 4771313	3		12	1
888	2023-08-29 21:06:18.414734+03	c1cafa70-98da-4376-a44a-df8018804332	Пульсар 16M 4741356 - 4741356	3		12	1
889	2023-08-29 21:06:18.415717+03	bcb8ebbb-ddc6-45d7-abb1-67ceabcc3905	Пульсар 16M 4741330 - 4741330	3		12	1
890	2023-08-29 21:06:18.417668+03	b00da1b3-01d3-4bbb-bdf8-58ddc13dd079	Пульсар 16M 1885594 - 1885594	3		12	1
891	2023-08-29 21:06:18.418642+03	ae31f421-68b6-40b6-a14b-562133fe298f	Пульсар 16M 4741119 - 4741119	3		12	1
892	2023-08-29 21:06:18.419624+03	a7802264-4f02-4164-8953-d2b55e76488b	Пульсар 16M 4741160 - 4741160	3		12	1
893	2023-08-29 21:06:18.421568+03	a5d34399-ef0b-4147-8d61-1a32cb468b3a	Пульсар 16M 3843906 - 3843906	3		12	1
894	2023-08-29 21:06:18.423526+03	a33c14d4-be43-4fc4-9c6e-6fdda1367a9e	Пульсар 16M 4741120 - 4741120	3		12	1
895	2023-08-29 21:06:18.424487+03	9feae956-f4a3-43c9-a601-5739cc0d9758	Пульсар 16M 4741332 - 4741332	3		12	1
896	2023-08-29 21:06:18.426448+03	9d7d00db-5ef6-4163-9c21-7c27fc392313	Пульсар 16M 4741355 - 4741355	3		12	1
897	2023-08-29 21:06:18.428402+03	9c3cc030-54a5-45d1-979d-ab2f1465eefd	Пульсар 16M 4741238 - 4741238	3		12	1
898	2023-08-29 21:06:18.429377+03	9a1d94fe-9373-49cf-8335-ac12091b7687	Пульсар 16M 4741416 - 4741416	3		12	1
899	2023-08-29 21:06:18.430351+03	9832c271-490d-4342-92af-69b0bc34cda5	Пульсар 16M 3844161 - 3844161	3		12	1
900	2023-08-29 21:06:18.432296+03	97637044-eb1d-4604-ae6c-0ecf6980db55	Пульсар 16M 3844168 - 3844168	3		12	1
901	2023-08-29 21:06:18.433277+03	96c56b33-0237-46c4-81bd-6856631dc526	Пульсар 16M 4741363 - 4741363	3		12	1
902	2023-08-29 21:06:18.435222+03	91f73b03-3290-4180-a7f9-ede4196fa616	Пульсар 16M 4741117 - 4741117	3		12	1
903	2023-08-29 21:06:18.437179+03	8baae311-fd2f-401a-bdaf-a5244e7b92d3	Пульсар 16M 4741282 - 4741282	3		12	1
904	2023-08-29 21:06:18.438154+03	863466dd-fd47-49c4-899f-d2dd3dbf5077	Пульсар 16M 4741274 - 4741274	3		12	1
905	2023-08-29 21:06:18.440105+03	7a3c3c13-d457-4339-8903-c3b852460aaa	Пульсар 16M 4741328 - 4741328	3		12	1
906	2023-08-29 21:06:18.441076+03	77f43101-9b20-4180-b538-25efa82d808b	Пульсар 16M 4741325 - 4741325	3		12	1
907	2023-08-29 21:06:18.443029+03	775beb55-1a6e-4efc-be58-6ab98f3f00ec	Пульсар 16M 4741214 - 4741214	3		12	1
908	2023-08-29 21:06:18.444969+03	6dfefc9f-89aa-4399-a0ce-038679c60081	Пульсар 16M 4741268 - 4741268	3		12	1
909	2023-08-29 21:06:18.445958+03	69b968d0-5ef6-464a-a95a-9bd698d2b5a8	Пульсар 16M 4741283 - 4741283	3		12	1
910	2023-08-29 21:06:18.447909+03	6936d5ef-2620-452d-a5e5-bede66cd48d4	Пульсар 16M 4741271 - 4741271	3		12	1
911	2023-08-29 21:06:18.448884+03	65581ea1-d0c0-44d6-b762-1bb24e9dad76	Пульсар 16M 4741308 - 4741308	3		12	1
912	2023-08-29 21:06:18.450828+03	64ed42c0-93e8-47cb-83ab-621cfc610940	Пульсар 16M 4741281 - 4741281	3		12	1
913	2023-08-29 21:06:18.451808+03	6257c890-732e-4b35-9ca2-827f4e4137f3	Пульсар 16M 4741415 - 4741415	3		12	1
914	2023-08-29 21:06:18.453756+03	5fb73cbe-013c-4801-b02d-9c38f913031b	Пульсар 16M 4741452 - 4741452	3		12	1
915	2023-08-29 21:06:18.454719+03	5f2e1121-2cdb-42c2-9c00-375a6a23dc0c	Пульсар 16M 4741311 - 4741311	3		12	1
916	2023-08-29 21:06:18.456686+03	5edcd6fb-2f69-45ad-9203-e676a4f6ce2a	Пульсар 16M 4741276 - 4741276	3		12	1
917	2023-08-29 21:06:18.45863+03	5985a79d-4202-43c7-98bf-64b636d24295	Пульсар 16M 4741324 - 4741324	3		12	1
918	2023-08-29 21:06:18.459607+03	5399a895-9e00-4197-bef6-eb2ff7ff2a49	Пульсар 16M 4741279 - 4741279	3		12	1
919	2023-08-29 21:06:18.46156+03	528979d1-3327-4697-89c8-39e316515579	Пульсар 16M 4741333 - 4741333	3		12	1
920	2023-08-29 21:06:18.462533+03	4f4e9c3e-a11b-4c9d-95bf-210272ce44e1	Пульсар 16M 4741359 - 4741359	3		12	1
921	2023-08-29 21:06:18.464476+03	480c187c-b1d3-4087-b3f6-13655713d0af	Пульсар 16M 4741264 - 4741264	3		12	1
922	2023-08-29 21:06:18.466442+03	43f3d320-74e0-495a-ab3d-fc160f811608	Пульсар 16M 3844165 - 3844165	3		12	1
923	2023-08-29 21:06:18.46741+03	3b212350-8641-48a6-bb6a-a6f0e2f0b93a	Пульсар 16M 4741414 - 4741414	3		12	1
924	2023-08-29 21:06:18.46936+03	2c152f84-ef84-4af1-b4ed-5b1b7835a6de	Пульсар 16M 4741331 - 4741331	3		12	1
925	2023-08-29 21:06:18.470345+03	2b32f38c-e5e3-4a89-975a-17e01e4a10ca	Пульсар 16M 4741418 - 4741418	3		12	1
926	2023-08-29 21:06:18.472292+03	2ad4f85c-3c76-4fb8-aaee-b5638c6cea71	Пульсар 16M 4741267 - 4741267	3		12	1
927	2023-08-29 21:06:18.473267+03	27f4c7f3-c0eb-4c4b-b437-306dd7d98051	Пульсар 16M 4741121 - 4741121	3		12	1
928	2023-08-29 21:06:18.47522+03	260b8284-a3a1-4e19-b64f-d6be8fe57e39	Пульсар 16M 4741421 - 4741421	3		12	1
929	2023-08-29 21:06:18.476184+03	1f612e30-a597-4944-bca3-3b425227dba9	Пульсар 16M 3843899 - 3843899	3		12	1
930	2023-08-29 21:06:18.478144+03	1f46ac96-1dd5-4f50-9761-93b62f7ba0d9	Пульсар 16M 4741326 - 4741326	3		12	1
931	2023-08-29 21:06:18.480093+03	1b45ead6-5a2a-4812-b5ed-7d30823b1260	Пульсар 16M 3844163 - 3844163	3		12	1
932	2023-08-29 21:06:18.481066+03	16dabcf8-646a-40c9-9afe-ec2a11cc2900	Пульсар 16M 4741357 - 4741357	3		12	1
933	2023-08-29 21:06:18.483019+03	146ee93e-803d-42a6-9d79-13c8cded40a2	Пульсар 16M 4741275 - 4741275	3		12	1
934	2023-08-29 21:06:18.483995+03	112e05b9-9a4a-442e-b498-ad7c69573404	Пульсар 16M 4741116 - 4741116	3		12	1
935	2023-08-29 21:06:18.485953+03	0ed11637-fa8b-40b9-8598-eb4b9ac3c722	Пульсар 16M 4741354 - 4741354	3		12	1
936	2023-08-29 21:06:18.487902+03	0e5c1e06-f1ce-4ada-b20c-c71eda26afd2	Пульсар 16M 4741159 - 4741159	3		12	1
937	2023-08-29 21:06:18.489842+03	0d91bcf0-12be-49d8-b17f-4aaebe7baf2d	Пульсар 16M 3844166 - 3844166	3		12	1
938	2023-08-29 21:06:18.490825+03	096b085b-61d6-4a0c-99f8-c18526673958	Пульсар 16M 4741280 - 4741280	3		12	1
939	2023-08-29 21:06:18.492763+03	06b9b497-3fe5-44a5-9180-db16d67d1fa4	Пульсар 16M 4741156 - 4741156	3		12	1
940	2023-08-29 21:06:18.494714+03	006f84fe-51ec-4bb9-bd81-c226869c348d	Пульсар 16M 3741417 - 3741417	3		12	1
941	2023-08-29 21:06:55.936477+03	fdbaace7-1b03-44cb-b743-fe75d20ed3da	Этаж 37, Мусорокамера	3		25	1
942	2023-08-29 21:06:55.941346+03	f4eb1575-3eb0-4fbc-adf8-57c753e8c585	Этаж 33, Мусорокамера	3		25	1
943	2023-08-29 21:06:55.94329+03	dd53b08b-dd7b-426f-b7d6-1c42e9de92a8	Этаж 28, Мусорокамера	3		25	1
944	2023-08-29 21:06:55.945253+03	d749f3cd-6a74-4ccd-ac2c-a02b0d990092	Этаж 29, Мусорокамера	3		25	1
945	2023-08-29 21:06:55.947205+03	d60d1d6b-1fbf-4262-a169-63b1063117da	Этаж 25, Мусорокамера	3		25	1
946	2023-08-29 21:06:55.950132+03	cc204f64-c9c0-4944-ae41-25b2e2983c0b	Этаж 13, Мусорокамера	3		25	1
947	2023-08-29 21:06:55.95208+03	c934d283-1c5c-47f3-b466-59c5076b1ba7	Этаж 26, Мусорокамера	3		25	1
948	2023-08-29 21:06:55.953055+03	c2533c6a-d13e-465e-ad54-680df2ace414	Этаж 31, Мусорокамера	3		25	1
949	2023-08-29 21:06:55.955005+03	bd908eb8-f661-4eeb-a5d8-9cb16c440514	Этаж 5, Мусорокамера	3		25	1
950	2023-08-29 21:06:55.956959+03	b3e3fd3b-729e-4b87-b0c3-a7653e1b982b	Этаж 11, Мусорокамера	3		25	1
951	2023-08-29 21:06:55.958906+03	b18c39f1-4a10-4d48-8ec5-687bed941b68	Этаж 14, Мусорокамера	3		25	1
952	2023-08-29 21:06:55.960841+03	a8f40744-6797-4610-994d-344822a96a6d	Этаж 18, Мусорокамера	3		25	1
953	2023-08-29 21:06:55.962812+03	a1821a12-dc4a-4a9e-9438-5af6b4039306	Этаж 24, Мусорокамера	3		25	1
954	2023-08-29 21:06:55.964749+03	a0c4bab3-2f79-4651-a98d-8050ae01ff99	Этаж 7, Мусорокамера	3		25	1
955	2023-08-29 21:06:55.96671+03	9f505cf4-2d6d-41f1-98aa-893194e5b022	Этаж 8, Мусорокамера	3		25	1
956	2023-08-29 21:06:55.96768+03	9a5c4a83-e41a-4fca-91c1-264bbb28be69	Этаж 15, Мусорокамера	3		25	1
957	2023-08-29 21:06:55.969638+03	890c2aeb-c59f-461a-b1b2-10490bdd5885	Этаж 21, Мусорокамера	3		25	1
958	2023-08-29 21:06:55.97159+03	82bb4567-4545-4aed-b4a1-e00a082cb3f7	Этаж 35, Мусорокамера	3		25	1
959	2023-08-29 21:06:55.97353+03	731df9b7-88e8-499f-b510-b2d0420cf531	Этаж 12, Мусорокамера	3		25	1
960	2023-08-29 21:06:55.975483+03	6d19807f-a270-439d-9aa7-ab8ff4a9b0e7	Этаж 23, Мусорокамера	3		25	1
961	2023-08-29 21:06:55.976466+03	6cecfe2f-4e6c-484f-8ae3-e5d2411f82ab	Этаж 16, Мусорокамера	3		25	1
962	2023-08-29 21:06:55.978415+03	63aa0126-bc92-4f67-871b-70421751b4c8	Этаж 22, Мусорокамера	3		25	1
963	2023-08-29 21:06:55.980354+03	62b867b6-0a62-438b-808c-e56f5dc3f573	Этаж 36, Мусорокамера	3		25	1
964	2023-08-29 21:06:55.982311+03	5ac93aa3-b949-4ae1-87ca-af78ed77a9c1	Этаж 30, Мусорокамера	3		25	1
965	2023-08-29 21:06:55.985242+03	5885c3b9-82ef-48b3-ac17-0abdc1e72ae1	Этаж 32, Мусорокамера	3		25	1
966	2023-08-29 21:06:55.986217+03	559a1d92-e2d8-477d-9611-8327de560565	Этаж 4, Мусорокамера	3		25	1
967	2023-08-29 21:06:55.988169+03	5528d9e1-dfd6-4161-9c32-1a7a043d393c	Этаж 10, Мусорокамера	3		25	1
968	2023-08-29 21:06:55.990113+03	5275fea0-e9f9-43f4-9683-7421d4ca513e	Этаж 9, Мусорокамера	3		25	1
969	2023-08-29 21:06:55.992069+03	4c846de5-6f43-4d43-a840-18cc4b63b7f8	Этаж 19, Мусорокамера	3		25	1
970	2023-08-29 21:06:55.993041+03	4ab32673-9f5b-4911-ae1f-7289ff1fdad6	Этаж 17, Мусорокамера	3		25	1
971	2023-08-29 21:06:55.995969+03	43ab34b2-b5ca-47ec-b172-cbf8b74d53b3	Этаж 2, Мусорокамера	3		25	1
972	2023-08-29 21:06:55.997925+03	3fd926af-8f3c-443c-b86d-314cb8a8890e	Этаж 6, Мусорокамера	3		25	1
973	2023-08-29 21:06:55.998896+03	18adef2f-0abd-4824-8c5a-a73e599a2ce8	Этаж 20, Мусорокамера	3		25	1
974	2023-08-29 21:06:56.000836+03	18acd4e5-54bb-4830-af5e-5885fd20def8	Этаж 27, Мусорокамера	3		25	1
975	2023-08-29 21:06:56.0028+03	055860d3-4dc0-4564-a7d1-5257497f9cf4	Этаж 34, Мусорокамера	3		25	1
976	2023-08-29 21:06:56.004749+03	00d28eaa-86f2-4d33-af1a-adcfec909fdb	Этаж 3, Мусорокамера	3		25	1
977	2023-08-29 21:08:36.333109+03	c2bf82ca-c9de-4bbc-8f2b-e83dce87411f	НП 1	3		7	1
978	2023-08-29 21:08:36.338943+03	a5c4e173-757b-45b2-89a5-323bc9df4f9f	НП 2	3		7	1
979	2023-08-29 21:08:36.340892+03	a328ca7e-7bca-49f0-9973-a51a9231e094	НП 5	3		7	1
980	2023-08-29 21:08:36.342844+03	3cd7e42e-3233-4e26-a0ed-1df173b9d5e0	НП 4	3		7	1
981	2023-08-29 21:08:36.343831+03	1ada813f-7886-4017-a1e8-c42a0fd282b9	НП 3	3		7	1
982	2023-08-29 21:13:13.966543+03	63cc4390-a41a-4574-a4e3-5c4689dea49f	улица Тестовая	3		25	1
983	2023-08-29 21:13:27.661846+03	b29b8e21-e202-4cfa-a098-82fdeadcb7fd	Импульсные ПУ	3		25	1
984	2023-08-29 21:13:38.983716+03	08c367ae-d97b-4667-95d2-3ca94dfdf45a	Импульсные ПУ	2	[{"changed": {"fields": ["Name"]}}]	25	1
985	2023-08-30 08:45:16.179104+03	24e52066-b12f-4b3f-85d8-5c3750754695	192.168.127.254:4001 - Sanext 10022317	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
986	2023-08-30 11:32:08.194623+03	d7fa1224-0d98-49f6-bbc4-2cd7ed20e6c1	Пульсар 16M 1885596 - 1885596	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
987	2023-08-30 11:34:25.516822+03	a3be5d96-3578-4b5d-bf8b-9d208474c828	Sanext 10020618 - 10020618	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
988	2023-08-30 11:35:26.205505+03	e9bd2c39-5d33-43d7-9522-fba52681097f	Sanext 10020970 - 10020970	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
989	2023-08-30 11:36:26.067341+03	621a0baa-2873-4ea3-9878-c7a1c904ea1e	Sanext 10020672 - 10020672	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
990	2023-08-30 11:37:30.951077+03	895760d7-f30a-4f4d-8559-bb9b81e719bd	Sanext 11027566 - 11027566	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
991	2023-08-30 12:29:26.668605+03	562428be-0f23-427b-bd4e-5b2496ef8e5a	Пульсар 16M 4741313 - 4741313	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
992	2023-08-30 12:39:17.108885+03	adf1253c-4185-4964-ace3-5eaf1ecaab6e	Пульсар 16M 4741417 - 4741417	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
993	2023-09-07 14:17:18.398936+03	9dd865f0-41af-481c-9084-caf1075ca72c	М-230 45189532 - 45189532	3		12	3
994	2023-09-22 12:18:21.957839+03	ee9b6804-758a-4695-9fb7-53781c3a77d4	10.222.109.21:4000	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
995	2023-09-22 12:18:47.833605+03	d3f2bdeb-4ebd-4be3-ac21-b791ef44f41b	10.222.109.21:4006	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
996	2023-09-22 12:19:06.636181+03	d0c8f2c9-2a0b-49a8-b048-cb0a53047763	10.222.109.21:4003	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
997	2023-09-22 12:19:21.89646+03	6e945803-4209-4b4e-ac98-df008b883c65	10.222.109.21:4002	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
998	2023-09-22 12:19:34.53262+03	685d957b-8ffa-4781-ad47-a9111d33a9a7	10.222.109.21:4005	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
999	2023-09-22 12:19:47.161817+03	61d0a915-c3d3-4aff-b87d-ef424c2da024	10.222.109.21:4004	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
1000	2023-09-22 12:20:05.508237+03	4e62e635-cc8f-4b56-ae46-b17c020eeac6	10.222.109.21:4007	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
1001	2023-09-22 12:20:23.875934+03	00dec37f-7568-44f5-b150-5e4be83ef4bc	10.222.109.21:4001	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
1002	2023-09-22 12:20:57.950966+03	d4683d8c-c17e-49d6-80b4-8ffc044edbc2	10.222.109.11:4000	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
1003	2023-09-22 12:21:10.332694+03	c410b11e-d672-408a-ae7d-77efa42f31fe	10.222.109.11:4002	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
1004	2023-09-22 12:21:26.285351+03	6b486cba-574e-44b1-bc3c-091dbbd2eb8e	10.222.109.11:4003	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
1005	2023-09-22 12:21:46.143883+03	55bcc31a-37e7-4918-8298-251fb224245c	10.222.109.11:4001	2	[{"changed": {"fields": ["Ip address"]}}]	20	3
1006	2023-09-26 13:07:58.000568+03	08c367ae-d97b-4667-95d2-3ca94dfdf45a	Вода	2	[{"changed": {"fields": ["Name"]}}]	25	3
1007	2023-10-02 12:14:09.112765+03	83a62c4a-c7cc-4412-bbfe-38e93bfa1110	Sanext 13023502 - 13023502	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
1008	2023-10-02 12:25:59.223162+03	10e35375-e2fd-4ff4-946c-2048031909c4	Sanext 13023681 - 13023681	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
1009	2023-10-09 11:45:08.479209+03	cdc50724-7716-4bab-8cfe-f4b645927b67	Пульсар 16M 1885650 - 1885650	2	[{"changed": {"fields": ["\\u0418\\u043c\\u044f", "\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441", "\\u0417\\u0430\\u0432\\u043e\\u0434\\u0441\\u043a\\u043e\\u0439 \\u043d\\u043e\\u043c\\u0435\\u0440(\\u0432\\u0440\\u0443\\u0447\\u043d\\u0443\\u044e)"]}}]	12	3
1010	2023-10-10 15:46:38.624657+03	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	Valtec 16M	1	[{"added": {}}]	22	1
1011	2023-10-10 16:04:16.304214+03	a11b0730-3975-40c1-bd2f-ed0c1a3132dc	Valtec 16M Канал 1 Суточный -- adress: 1  channel: 0	1	[{"added": {}}]	14	1
1012	2023-10-10 16:04:57.106679+03	9d2832c8-f116-434d-ab48-0f28cbfc03ad	Valtec 16M Канал 2 Суточный -- adress: 2  channel: 0	1	[{"added": {}}]	14	1
1013	2023-10-10 16:26:49.303601+03	4fe447ea-de07-4d97-ad4f-20ded5503ddb	Valtec 16M Канал 3 Суточный -- adress: 3  channel: 0	1	[{"added": {}}]	14	1
1014	2023-10-10 16:27:20.85154+03	f859f4ed-166e-4b44-9df3-f3a60d778c35	Valtec 16M Канал 4 Суточный -- adress: 4  channel: 0	1	[{"added": {}}]	14	1
1015	2023-10-10 16:27:38.389021+03	c1b97126-d5f8-4d8c-acc4-08eaa017d5fa	Valtec 16M Канал 5 Суточный -- adress: 5  channel: 0	1	[{"added": {}}]	14	1
1016	2023-10-10 16:28:03.766087+03	ca29cbf2-ab61-4cb0-b9fd-99121cb45b1f	Valtec 16M Канал 6 Суточный -- adress: 6  channel: 0	1	[{"added": {}}]	14	1
1017	2023-10-10 16:28:28.91191+03	28c0bd41-1281-4272-b33e-234669294644	Valtec 16M Канал 7 Суточный -- adress: 7  channel: 0	1	[{"added": {}}]	14	1
1018	2023-10-10 16:28:53.104421+03	616608c0-2343-4d22-b065-d8d5f9769731	Valtec 16M Канал 8 Суточный -- adress: 8  channel: 0	1	[{"added": {}}]	14	1
1019	2023-10-10 16:29:17.763348+03	22ff1bd3-506b-40db-9137-2f01a923698d	Valtec 16M Канал 9 Суточный -- adress: 9  channel: 0	1	[{"added": {}}]	14	1
1020	2023-10-10 16:29:34.760378+03	48a5e8d8-d065-423c-a7ac-f126048687f7	Valtec 16M Канал 10 Суточный -- adress: 10  channel: 0	1	[{"added": {}}]	14	1
1021	2023-10-10 16:29:47.218037+03	9b2cb997-1bb0-4230-92f7-3cd01032e5b9	Valtec 16M Канал 11 Суточный -- adress: 11  channel: 0	1	[{"added": {}}]	14	1
1022	2023-10-10 16:30:07.821377+03	fe4e2925-d986-4727-b3d5-bd3f809009e5	Valtec 16M Канал 12 Суточный -- adress: 12  channel: 0	1	[{"added": {}}]	14	1
1023	2023-10-10 16:30:22.255323+03	a49323aa-135d-4a3f-93b8-1e32762e64e7	Valtec 16M Канал 13 Суточный -- adress: 13  channel: 0	1	[{"added": {}}]	14	1
1024	2023-10-10 16:30:48.342778+03	aae6e088-7dcb-49a6-aafc-df4834ceca11	Valtec 16M Канал 14 Суточный -- adress: 14  channel: 0	1	[{"added": {}}]	14	1
1025	2023-10-10 16:31:02.213874+03	1e1d2cef-11fc-4b81-9201-ce19a85cacab	Valtec 16M Канал 15 Суточный -- adress: 15  channel: 0	1	[{"added": {}}]	14	1
1026	2023-10-10 16:31:15.078043+03	310b935b-e7f9-47d3-8c87-a8ae13a3c81d	Valtec 16M Канал 16 Суточный -- adress: 16  channel: 0	1	[{"added": {}}]	14	1
1027	2023-10-10 17:22:40.971354+03	ffc657fc-aa87-4f18-828d-c29785f91277	М-230 43341530 - 43341530	3		12	1
1028	2023-10-10 17:22:40.979157+03	ffbadc45-3e7b-4731-8040-a31b6c469847	Пульсар 16M 4741452 - 4741452	3		12	1
1029	2023-10-10 17:22:40.984034+03	ff9d77d7-dc7b-4743-b84e-0569624543ea	Sanext 10022057 - 10022057	3		12	1
1030	2023-10-10 17:22:40.98599+03	ff9b90f1-63a8-4bd1-bff5-a0c44e0c13a6	Пульсар 16M 3843863 - 3843863	3		12	1
1031	2023-10-10 17:22:40.987948+03	ff9a0257-ba06-4761-83b0-4161233b1470	Sanext 13023492 - 13023492	3		12	1
1032	2023-10-10 17:22:40.988915+03	feec5ab8-99b8-4da9-a1d6-8d05834904db	Sanext 13023710 - 13023710	3		12	1
1033	2023-10-10 17:22:40.99087+03	fed509e7-7144-4e98-96a8-755287867c3f	Sanext 10022198 - 10022198	3		12	1
1034	2023-10-10 17:22:40.991831+03	fed47df4-2a21-490c-b1ab-e731b78bbcb0	Sanext 10022229 - 10022229	3		12	1
1035	2023-10-10 17:22:40.993797+03	fecb5e12-3f65-4ec9-8b2a-b4b078d9fd99	М-230 42421816 - 42421816	3		12	1
1036	2023-10-10 17:22:40.994771+03	fec8ffa0-bc4f-4ba1-ac44-2442e94f01a2	Sanext 10020893 - 10020893	3		12	1
1037	2023-10-10 17:22:40.996719+03	fec8c098-542b-4e08-81c5-d7a199c70b06	Sanext 10022056 - 10022056	3		12	1
1038	2023-10-10 17:22:40.9977+03	feb2d335-e195-4ffd-b077-4759b4c081b4	Sanext 10022112 - 10022112	3		12	1
1039	2023-10-10 17:22:40.998671+03	fe839073-ba6f-4b55-af58-81dd74b6c98b	Sanext 10021742 - 10021742	3		12	1
1040	2023-10-10 17:22:41.000608+03	fe49e41f-f601-48ee-a67f-67cd74ccdfc4	Пульсар 16M 4741406 - 4741406	3		12	1
1041	2023-10-10 17:22:41.001596+03	fe367bb0-2f37-4fc4-b7d3-9cd0d4fd821a	Sanext 10020856 - 10020856	3		12	1
1042	2023-10-10 17:22:41.003541+03	fe11114e-a522-4730-8f00-0efd63469be9	Sanext 10020713 - 10020713	3		12	1
1043	2023-10-10 17:22:41.004512+03	fdce44e4-18ba-40af-be1e-989dcbc8066b	М-230 43341770 - 43341770	3		12	1
1044	2023-10-10 17:22:41.006467+03	fdc612cf-0d18-4b4b-9e13-6cee2c4644cc	Sanext 10022069 - 10022069	3		12	1
1045	2023-10-10 17:22:41.007451+03	fdb78840-88df-457b-9558-bbb7c5f1f26e	Sanext 10021960 - 10021960	3		12	1
1046	2023-10-10 17:22:41.008418+03	fdadf738-d8d3-406c-880b-f9b185e46f22	Sanext 10021716 - 10021716	3		12	1
1047	2023-10-10 17:22:41.010371+03	fd7dd936-e451-4936-85c4-c590d75e2119	Sanext 10022246 - 10022246	3		12	1
1048	2023-10-10 17:22:41.011347+03	fd4855c9-98f3-4b74-83a3-063fd04305ab	Sanext 10021927 - 10021927	3		12	1
1049	2023-10-10 17:22:41.012329+03	fd2ee847-4c5e-4424-819c-157a6379f79b	М-230 43488032 - 43488032	3		12	1
1050	2023-10-10 17:22:41.01428+03	fce2a39c-6fad-4731-a964-39035c1efec3	Sanext 10022095 - 10022095	3		12	1
1051	2023-10-10 17:22:41.015256+03	fcd97717-d423-4cdc-8865-4a694744deb0	Sanext 10022311 - 10022311	3		12	1
1052	2023-10-10 17:22:41.016229+03	fcd59946-e894-4b0e-b106-a5cfa4f4a117	Sanext 13023447 - 13023447	3		12	1
1053	2023-10-10 17:22:41.01818+03	fc979b03-abaf-4cc4-888b-696bc3f76bc6	Sanext 10022086 - 10022086	3		12	1
1054	2023-10-10 17:22:41.019151+03	fc960843-9845-4db5-8bb5-de0f76ae579e	Пульсар 16M 4741118 - 4741118	3		12	1
1055	2023-10-10 17:22:41.020746+03	fc5f79db-b25e-40a7-87a5-9d68d9576e72	М-230 43341792 - 43341792	3		12	1
1056	2023-10-10 17:22:41.021669+03	fc5bbd4a-32c1-405d-9c50-0c58de75187a	М-230 43341587 - 43341587	3		12	1
1057	2023-10-10 17:22:41.022641+03	fc34d05a-19e7-4e3b-b957-b8e3cda67192	М-230 43341505 - 43341505	3		12	1
1058	2023-10-10 17:22:41.024589+03	fc1fa3e9-b748-495a-bd9f-341fae44b9b4	М-230 43574266 - 43574266	3		12	1
1059	2023-10-10 17:22:41.025566+03	fc11b78a-b1a9-4c73-a643-537d424eab2d	М-230 43341439 - 43341439	3		12	1
1060	2023-10-10 17:22:41.026543+03	fc0f5f53-09ed-4ce2-bf4a-9578e2ac8dae	Sanext 10022300 - 10022300	3		12	1
1061	2023-10-10 17:22:41.028492+03	fbfbe72c-f4e1-407f-9dc8-da6074e75f4d	Sanext 10021656 - 10021656	3		12	1
1062	2023-10-10 17:22:41.029462+03	fbede911-0c33-47d5-9e22-001dd6ff41d6	Sanext 10020615 - 10020615	3		12	1
1063	2023-10-10 17:22:41.03044+03	fbebb65f-c680-4e07-8847-2b4e0b0a2124	М-230 43334126 - 43334126	3		12	1
1064	2023-10-10 17:22:41.032378+03	fb84c348-80db-4585-a7bd-5808a97d3ecf	Sanext 10021495 - 10021495	3		12	1
1065	2023-10-10 17:22:41.033361+03	fb8422de-1f73-45ec-b4b3-f9fc8c7543cb	Пульсар 16M 4741414 - 4741414	3		12	1
1066	2023-10-10 17:22:41.034329+03	fb6c383a-e930-406c-99f7-45e364d47bdb	М-230 43198769 - 43198769	3		12	1
1067	2023-10-10 17:22:41.036293+03	fb6c34c8-65c2-4f7d-a4a9-560496e9207e	М-230 43341948 - 43341948	3		12	1
1068	2023-10-10 17:22:41.037269+03	fb66cf11-0866-4e02-87f4-dc8261016d60	Пульсар 16M 4741289 - 4741289	3		12	1
1069	2023-10-10 17:22:41.038247+03	fb2ecd3c-a72b-4795-b87c-58694fe383c5	Пульсар 16M 3844167 - 3844167	3		12	1
1070	2023-10-10 17:22:41.039206+03	fb22fff9-8048-4e93-8eea-fe11c39b70ef	Sanext 10020914 - 10020914	3		12	1
1071	2023-10-10 17:22:41.041171+03	fae6c066-f975-4c59-8dfb-29ec76596bad	Sanext 10022384 - 10022384	3		12	1
1072	2023-10-10 17:22:41.042143+03	fab6cce3-d52d-4edc-8bdb-af194ee28d4f	Sanext 10022227 - 10022227	3		12	1
1073	2023-10-10 17:22:41.043125+03	fa7ee88f-21f9-4f3e-9521-f87a876f7f21	Sanext 10020903 - 10020903	3		12	1
1074	2023-10-10 17:22:41.045073+03	fa484e1d-1aec-4645-b410-e8662bc5421f	М-230 42750334 - 42750334	3		12	1
1075	2023-10-10 17:22:41.046045+03	fa453887-5c66-4a7c-84d6-ef94e7073064	Sanext 10021622 - 10021622	3		12	1
1076	2023-10-10 17:22:41.047024+03	fa3f4fe0-db76-4336-9e22-507db11bb504	М-230 43341856 - 43341856	3		12	1
1077	2023-10-10 17:22:41.047995+03	fa3b94d4-19f6-4db1-91b8-4b63b0aafeb5	М-230 43341952 - 43341952	3		12	1
1078	2023-10-10 17:22:41.049948+03	f9f8c6cc-5479-48ca-8076-a334e90fb24d	М-230 43587911 - 43587911	3		12	1
1079	2023-10-10 17:22:41.050926+03	f9da7154-eaa3-4f13-bd53-080386b0ec6a	Sanext 10022298 - 10022298	3		12	1
1080	2023-10-10 17:22:41.051918+03	f9d88788-0271-4a22-a447-5296cb8f767b	Sanext 10022259 - 10022259	3		12	1
1081	2023-10-10 17:22:41.053847+03	f99637b0-2088-448e-9ee6-8a2d5bd28f44	М-230 43488009 - 43488009	3		12	1
1082	2023-10-10 17:22:41.054819+03	f96e7813-6203-4b1f-97be-30d8a1d894c8	Sanext 13023338 - 13023338	3		12	1
1083	2023-10-10 17:22:41.056776+03	f96ce25a-7183-402d-9dd9-308ee2b0fd8a	Sanext 10020883 - 10020883	3		12	1
1084	2023-10-10 17:22:41.057756+03	f9584674-fecb-4e0f-a8b6-fdfba629e6e7	Sanext 13023737 - 13023737	3		12	1
1085	2023-10-10 17:22:41.059708+03	f8b9d0ae-22d2-4c9f-bbea-4b1777c4f2e8	Пульсар 16M 641515 - 641515	3		12	1
1086	2023-10-10 17:22:41.061638+03	f826f180-a369-4283-8e78-96ee163d529d	М-230 43341823 - 43341823	3		12	1
1087	2023-10-10 17:22:41.063597+03	f8048c31-2d71-435f-ad94-1b1b87f6953e	Sanext 10022167 - 10022167	3		12	1
1088	2023-10-10 17:22:41.064567+03	f7dd4e5b-afa1-4cab-859d-2339e4ef8275	Sanext 10021277 - 10021277	3		12	1
1089	2023-10-10 17:22:41.066531+03	f7c0f0a6-1b60-4b6a-bda2-952bd8154581	Sanext 10021686 - 10021686	3		12	1
1090	2023-10-10 17:22:41.067504+03	f76eac17-a1e1-42e6-ad7b-8e0428881f6e	Sanext 10022068 - 10022068	3		12	1
1091	2023-10-10 17:22:41.069462+03	f76457a2-675b-4f4c-9e81-6ff38d97ebfa	М-230 43488023 - 43488023	3		12	1
1092	2023-10-10 17:22:41.070431+03	f7354df8-a893-474b-8969-6a4dba784fa3	Sanext 10020996 - 10020996	3		12	1
1093	2023-10-10 17:22:41.072381+03	f72dfcf3-a30e-4232-a52c-847464402bd3	М-230 43341455 - 43341455	3		12	1
1094	2023-10-10 17:22:41.073356+03	f71a6e5b-5cd0-4339-9b01-d3a12b5b880e	М-230 43334137 - 43334137	3		12	1
1095	2023-10-10 17:22:41.07433+03	f6f5759e-9f06-43da-bb9d-d25ab5b56a63	Sanext 10022219 - 10022219	3		12	1
1096	2023-10-10 17:22:41.076283+03	f6d27e06-556e-4390-b7d4-ee23195ce0ae	М-230 43334129 - 43334129	3		12	1
1097	2023-10-10 17:22:41.07726+03	f6a4c1fd-aaa8-413a-99b2-0096fa8afb49	Sanext 10022131 - 10022131	3		12	1
1098	2023-10-10 17:22:41.079211+03	f68d0061-efb3-4169-b379-95b12cd99ad8	Sanext 10021466 - 10021466	3		12	1
1099	2023-10-10 17:22:41.08019+03	f6737e93-76bc-4b94-a1b8-3afab41ad07b	М-230 43341401 - 43341401	3		12	1
1100	2023-10-10 17:22:41.08213+03	f6643aaf-e29b-4ef8-9456-b6480ff5ef43	М-230 43341453 - 43341453	3		12	1
1101	2023-10-10 17:22:41.083109+03	f65d7cd3-9cb9-4fde-8fcd-4d2ec6c47ddb	М-230 43198030 - 43198030	3		12	1
1102	2023-10-10 17:22:41.085055+03	f658238a-3424-4b2e-9dda-c4aafe9a539f	Sanext 10021917 - 10021917	3		12	1
1103	2023-10-10 17:22:41.086038+03	f647b239-309d-4a44-b877-fde8f01ac54b	М-230 43341827 - 43341827	3		12	1
1104	2023-10-10 17:22:41.08799+03	f644a772-6e09-4291-ad3f-eea4b1f6cf44	М-230 43333790 - 43333790	3		12	1
1105	2023-10-10 17:22:41.088956+03	f5cd51f4-986e-4626-a4ec-54efab12aa4e	М-230 43487779 - 43487779	3		12	1
1106	2023-10-10 17:22:41.090907+03	f5ade8a9-f37c-4e80-90c7-c045f8034f9e	Sanext 10022360 - 10022360	3		12	1
1107	2023-10-10 17:22:41.091877+03	f5a7e573-544e-4d97-b99f-e724f7c18ebd	М-230 43487957 - 43487957	3		12	1
1108	2023-10-10 17:22:41.093829+03	f59a5f6d-37e8-4095-b67b-a9a6632356b6	М-230 43199254 - 43199254	3		12	1
1109	2023-10-10 17:22:41.094803+03	f5714b8a-90fa-4bb4-a501-e5ce122b90f6	Sanext 10020620 - 10020620	3		12	1
1110	2023-10-10 17:22:41.096768+03	f56a6660-79b9-4318-bc9a-f7a94a2b95d4	Sanext 10020582 - 10020582	3		12	1
1111	2023-10-10 17:22:41.098717+03	f55b4b8f-279d-4401-94a9-140c5b179157	М-230 43488074 - 43488074	3		12	1
1112	2023-10-10 17:22:41.10164+03	f546116b-7de8-491e-b4b7-eb3362154bdd	Sanext 10022071 - 10022071	3		12	1
1113	2023-10-10 17:22:41.102623+03	f4c821ba-b275-4d4d-9ea8-384587c4f941	Sanext 10022245 - 10022245	3		12	1
1114	2023-10-10 17:22:41.104555+03	f4a57df6-bbd2-46c1-be5d-a826c6a4688a	Sanext 10022332 - 10022332	3		12	1
1115	2023-10-10 17:22:41.105538+03	f46f6325-eb1d-40b4-84ef-3383f8db45f7	Sanext 10021005 - 10021005	3		12	1
1116	2023-10-10 17:22:41.106533+03	f46056a8-066d-42cf-a498-96d6e8369141	Sanext 13023722 - 13023722	3		12	1
1117	2023-10-10 17:22:41.108473+03	f45604d9-d24c-4441-b378-88281417d7f5	Sanext 10021347 - 10021347	3		12	1
1118	2023-10-10 17:22:41.109446+03	f44a5293-5c67-4033-a4b6-0a964379e032	Пульсар 16M 4741213 - 4741213	3		12	1
1119	2023-10-10 17:22:41.111395+03	f43c5a26-b9ef-4b14-b390-3b05f88f792f	М-230 43341585 - 43341585	3		12	1
1120	2023-10-10 17:22:41.11237+03	f4183156-e8df-495e-a8d5-16de6f619591	М-230 43341583 - 43341583	3		12	1
1121	2023-10-10 17:22:41.113341+03	f3ce8a90-776f-4d54-b08b-e9200f448017	М-230 43333568 - 43333568	3		12	1
1122	2023-10-10 17:22:41.115291+03	f3b4832c-cc05-4594-9040-25bb6b437165	М-230 43333794 - 43333794	3		12	1
1123	2023-10-10 17:22:41.117255+03	f3acf8da-3d45-4367-b4c3-4322c3bda52b	М-230 43487903 - 43487903	3		12	1
1124	2023-10-10 17:22:41.118218+03	f386376e-351c-424d-84d8-38d2e389dabd	Sanext 10021759 - 10021759	3		12	1
1125	2023-10-10 17:22:41.120171+03	f36197b1-803f-4492-9ff2-67db480dc999	Пульсар 16M 4741284 - 4741284	3		12	1
1126	2023-10-10 17:22:41.121682+03	f336328f-9489-4f11-a4be-b512e92fd52b	Sanext 10021235 - 10021235	3		12	1
1127	2023-10-10 17:24:44.518036+03	f2e0beba-323f-4f56-a5db-6610bcace5f2	Sanext 10020840 - 10020840	3		12	1
1128	2023-10-10 17:24:44.521932+03	f29ea00a-bb43-4af9-8ef6-4d3148293b79	Sanext 13023677 - 13023677	3		12	1
1129	2023-10-10 17:24:44.523881+03	f25e72a7-784d-4249-b8b0-431bd855f97f	М-230 43341386 - 43341386	3		12	1
1130	2023-10-10 17:24:44.525838+03	f24bdbc8-6c93-432f-b98b-61dd72a1483a	М-230 43341740 - 43341740	3		12	1
1131	2023-10-10 17:24:44.526809+03	f2327e70-92b0-40be-8043-9e8186b9d507	Sanext 10020558 - 10020558	3		12	1
1132	2023-10-10 17:24:44.528763+03	f2298c93-7075-4cc9-a242-e03b4c423918	М-230 43348089 - 43348089	3		12	1
1133	2023-10-10 17:24:44.530705+03	f21b1944-00c8-48ed-a4d4-3b6c54e5dcfc	М-230 43341476 - 43341476	3		12	1
1134	2023-10-10 17:24:44.531682+03	f1f64517-4415-4b8e-af74-b988c597aaaf	Sanext 10020446 - 10020446	3		12	1
1135	2023-10-10 17:24:44.533631+03	f1dcf6e7-98b5-4eb4-b27f-291a00a03977	Sanext 13023728 - 13023728	3		12	1
1136	2023-10-10 17:24:44.535575+03	f1d575d2-4f1e-45cc-ba2b-0edb095073e0	М-230 43487945 - 43487945	3		12	1
1137	2023-10-10 17:24:44.536565+03	f1c7ee3c-2794-421f-bc4b-60408d15e5d9	Sanext 10021473 - 10021473	3		12	1
1138	2023-10-10 17:24:44.538514+03	f1c45962-95d3-49f5-bfd5-d29186065b82	М-230 43487808 - 43487808	3		12	1
1139	2023-10-10 17:24:44.539485+03	f1c4479f-8923-42bb-993c-ddeea7339b5f	М-230 43341502 - 43341502	3		12	1
1140	2023-10-10 17:24:44.541445+03	f1c02d9d-376f-4d47-9e23-a6df89093048	Sanext 10020823 - 10020823	3		12	1
1141	2023-10-10 17:24:44.543396+03	f1aa5774-803d-416f-a00b-0cb231a9b36b	М-230 43341657 - 43341657	3		12	1
1142	2023-10-10 17:24:44.545336+03	f1425fb8-71a3-433f-aa7f-db5ee4d19ee0	Sanext 10021558 - 10021558	3		12	1
1143	2023-10-10 17:24:44.546311+03	f0e9fb2e-a731-478f-87ab-ba1989043110	Sanext 10020697 - 10020697	3		12	1
1144	2023-10-10 17:24:44.548265+03	f0d311b8-9c60-4547-86c7-95f2142fa0f1	М-230 43341779 - 43341779	3		12	1
1145	2023-10-10 17:24:44.550223+03	f0aaa84e-60ad-4564-9518-a61fc12482e7	Sanext 10021224 - 10021224	3		12	1
1146	2023-10-10 17:24:44.551188+03	f09dca12-80ad-4f8f-b32a-d9968f77d748	Sanext 12004493 - 12004493	3		12	1
1147	2023-10-10 17:24:44.553148+03	f085e879-cda1-4512-a49f-5ca71d222739	Sanext 13023420 - 13023420	3		12	1
1148	2023-10-10 17:24:44.554114+03	f0748a23-1d8a-4753-a3c8-b6e2476882d5	Пульсар 16M 4741433 - 4741433	3		12	1
1149	2023-10-10 17:24:44.556065+03	f0570e76-b0bc-44af-ae85-264534fc0c72	М-230 43334171 - 43334171	3		12	1
1150	2023-10-10 17:24:44.557051+03	f051af5d-58b5-42b0-b94a-ed529a86abe2	Sanext 10021571 - 10021571	3		12	1
1151	2023-10-10 17:24:44.559057+03	f03672c2-addb-4558-ab64-9cfcfe0f7abf	М-230 43341819 - 43341819	3		12	1
1152	2023-10-10 17:24:44.559979+03	eff3239d-2615-496e-a956-aea32317e616	М-230 43334079 - 43334079	3		12	1
1153	2023-10-10 17:24:44.561925+03	efea5402-3964-4441-b37c-ee2da88fdd75	Sanext 10021944 - 10021944	3		12	1
1154	2023-10-10 17:24:44.562892+03	efd95c50-622d-4d9f-a101-bb3a0ae621b8	М-230 43341482 - 43341482	3		12	1
1155	2023-10-10 17:24:44.563862+03	efcb247f-5229-4965-ba9f-b140abffbb43	М-230 41211917 - 41211917	3		12	1
1156	2023-10-10 17:24:44.565814+03	efb87b43-7b23-4936-b332-be838af61e88	М-230 43333403 - 43333403	3		12	1
1157	2023-10-10 17:24:44.567777+03	ef90aaab-95ed-46b9-88e1-3de3aba81c7a	М-230 43341400 - 43341400	3		12	1
1158	2023-10-10 17:24:44.568749+03	ef3df3fe-d21f-481f-acad-70f61c2517c5	М-230 43341518 - 43341518	3		12	1
1159	2023-10-10 17:24:44.569715+03	ef0fa1e8-2152-4807-bd2c-6ab3a15d0390	М-230 43341715 - 43341715	3		12	1
1160	2023-10-10 17:24:44.571678+03	eef1fb24-f3aa-42ea-a743-1607533979d3	Sanext 10022381 - 10022381	3		12	1
1161	2023-10-10 17:24:44.572656+03	ee9e2274-8fa7-47b9-8b2c-c98cdfe420c7	Sanext 10022254 - 10022254	3		12	1
1162	2023-10-10 17:24:44.574606+03	ee8252c1-5f67-454c-a2aa-2da2766b5d49	М-230 43341623 - 43341623	3		12	1
1163	2023-10-10 17:24:44.575573+03	ee127f3d-5b01-4f9d-bbba-78e5eac1d78a	Sanext 10021608 - 10021608	3		12	1
1164	2023-10-10 17:24:44.577535+03	edfec40c-e77e-4aa8-ba56-138a76a05c9d	Sanext 10022319 - 10022319	3		12	1
1165	2023-10-10 17:24:44.579478+03	edd4249a-3aec-4f7a-b58e-24aa1b2ee697	М-230 43341676 - 43341676	3		12	1
1166	2023-10-10 17:24:44.580457+03	edafa6b9-5be2-463e-850b-82192bffdc6f	Sanext 10020879 - 10020879	3		12	1
1167	2023-10-10 17:24:44.582411+03	ed9e8894-97b6-497e-a45e-b6a2ef23ebe0	Sanext 10022199 - 10022199	3		12	1
1168	2023-10-10 17:24:44.583384+03	ed9e3eb5-54ee-4352-91c5-0f3d9deee78e	Sanext 10020927 - 10020927	3		12	1
1169	2023-10-10 17:24:44.584361+03	ed94abb6-a8b2-498e-b11b-e4b1cb8c2f2e	М-230 43341631 - 43341631	3		12	1
1170	2023-10-10 17:24:44.586322+03	ed861567-9125-4c6e-a6aa-b3498ea30649	М-230 43487872 - 43487872	3		12	1
1171	2023-10-10 17:24:44.587271+03	ed65587a-c45e-4034-95b8-4bb8bc5e530d	Пульсар 16M 4741234 - 4741234	3		12	1
1172	2023-10-10 17:24:44.589243+03	ed37e618-5ba1-48eb-a9e4-c9e609317727	М-230 45271718 - 45271718	3		12	1
1173	2023-10-10 17:24:44.59119+03	eccc2711-4481-4ef6-95ba-32bbb8b4f0fe	М-230 43332219 - 43332219	3		12	1
1174	2023-10-10 17:24:44.592156+03	eccb0235-5a03-4ec8-9dcb-28d40d84e37a	Sanext 10022109 - 10022109	3		12	1
1175	2023-10-10 17:24:44.594117+03	ecca6979-3ed0-4c78-8f0a-26544a882331	М-230 43341521 - 43341521	3		12	1
1176	2023-10-10 17:24:44.59508+03	ecbc22ec-35c9-45eb-99a8-010da042ea60	Sanext 10021337 - 10021337	3		12	1
1177	2023-10-10 17:24:44.59704+03	ecb6d2ed-1a9c-4516-8569-415daf765a28	М-230 43341438 - 43341438	3		12	1
1178	2023-10-10 17:24:44.598987+03	eca02e01-6c4e-4f36-9576-a1fe34e5ebeb	М-230 43341736 - 43341736	3		12	1
1179	2023-10-10 17:24:44.599965+03	ec9b57c6-f6b3-4464-b726-5a3c7ec3eed1	Sanext 10021741 - 10021741	3		12	1
1180	2023-10-10 17:24:44.601907+03	ec902249-609d-47f4-b346-b18bbd7e48d8	Sanext 10021901 - 10021901	3		12	1
1181	2023-10-10 17:24:44.602882+03	ec8e6c6c-04de-4fe5-9d01-13bfb970647b	М-230 43334159 - 43334159	3		12	1
1182	2023-10-10 17:24:44.604833+03	ec766019-3bf3-4f19-a99f-5e915acc9c0a	Пульсар 16M 4741357 - 4741357	3		12	1
1183	2023-10-10 17:24:44.606791+03	ec2565ef-14d7-4473-ae92-582486a375a0	Sanext 10021948 - 10021948	3		12	1
1184	2023-10-10 17:24:44.607765+03	ec0674a3-ff3b-45b2-904f-3c9b2175c88d	Sanext 10021748 - 10021748	3		12	1
1185	2023-10-10 17:24:44.60972+03	ebf7b271-d64b-40c9-b0c6-818082519730	Пульсар 16M 4741254 - 4741254	3		12	1
1186	2023-10-10 17:24:44.610764+03	ebd7bf05-daeb-49a4-9479-6b19249eb24d	Sanext 10022293 - 10022293	3		12	1
1187	2023-10-10 17:24:44.612664+03	ebaadd7f-9380-4880-b3b7-f87ac3649334	М-230 43488062 - 43488062	3		12	1
1188	2023-10-10 17:24:44.614621+03	eb41bba7-91e4-4f8f-81d6-ab8f3d142be3	М-230 43487916 - 43487916	3		12	1
1189	2023-10-10 17:24:44.616568+03	eb2fa9e3-ed12-4ffc-87b5-313b80dbce12	Sanext 10020951 - 10020951	3		12	1
1190	2023-10-10 17:24:44.617551+03	eb274660-194a-411b-8d71-5a10d41520f5	М-230 42749823 - 42749823	3		12	1
1191	2023-10-10 17:24:44.619495+03	eaebc18f-d051-414d-95e8-cd3ce3273651	М-230 42988809 - 42988809	3		12	1
1192	2023-10-10 17:24:44.620472+03	eae738e0-a2b5-4291-ad9e-0ddaa0f73279	М-230 43341824 - 43341824	3		12	1
1193	2023-10-10 17:24:44.622422+03	ea9745f7-17b0-4e8c-8c4b-8959a31013c8	М-230 43488056 - 43488056	3		12	1
1194	2023-10-10 17:24:44.624366+03	ea73d5c2-112b-407a-aa67-71b0148555c3	Sanext 10020920 - 10020920	3		12	1
1195	2023-10-10 17:24:44.625338+03	e9f07526-96c0-4b51-88f3-07ce93804e2d	М-230 43487890 - 43487890	3		12	1
1196	2023-10-10 17:24:44.627296+03	e9e7eed4-1c44-42fb-9471-b76640150457	М-230 43333809 - 43333809	3		12	1
1197	2023-10-10 17:24:44.629253+03	e9e011b3-2bb3-4aeb-9834-bca31d5c1fda	Sanext 10021046 - 10021046	3		12	1
1198	2023-10-10 17:24:44.630215+03	e9d91f01-a157-41bc-946c-4a3bfdee727a	М-230 43332628 - 43332628	3		12	1
1199	2023-10-10 17:24:44.632175+03	e9bd2c39-5d33-43d7-9522-fba52681097f	Sanext 10020970 - 10020970	3		12	1
1200	2023-10-10 17:24:44.634126+03	e96f5974-5a1f-453c-9c6c-9d709265448d	Пульсар 16M 4741122 - 4741122	3		12	1
1201	2023-10-10 17:24:44.635093+03	e9693f63-17d7-4025-a23a-b51d0408ba70	М-230 43574103 - 43574103	3		12	1
1202	2023-10-10 17:24:44.63705+03	e9594bdc-4f31-4f6a-bc34-499c948da9de	М-230 43199221 - 43199221	3		12	1
1203	2023-10-10 17:24:44.638025+03	e8fb2272-01b7-44de-858e-dce7efd46697	М-230 43341744 - 43341744	3		12	1
1204	2023-10-10 17:24:44.639983+03	e8db21f1-1c4d-4246-bdcf-90f14274ddfb	М-230 43341405 - 43341405	3		12	1
1205	2023-10-10 17:24:44.641931+03	e8cf3d68-8325-460a-8156-deee73469629	М-230 43341503 - 43341503	3		12	1
1206	2023-10-10 17:24:44.642907+03	e8bbe7ea-48ba-42a3-b984-312f46e3f927	М-230 43348117 - 43348117	3		12	1
1207	2023-10-10 17:24:44.644858+03	e82c4206-2520-4aee-a759-f43c1223c9da	М-230 43341765 - 43341765	3		12	1
1208	2023-10-10 17:24:44.645832+03	e7f906d9-6be3-4906-8d78-25be17d39e67	М-230 43341531 - 43341531	3		12	1
1209	2023-10-10 17:24:44.647787+03	e7ccf6e6-a92f-49f0-a7be-0a1befc1fd21	Sanext 10020712 - 10020712	3		12	1
1210	2023-10-10 17:24:44.649744+03	e7706335-adc5-4697-83c5-e102bd9314d2	Sanext 10022039 - 10022039	3		12	1
1211	2023-10-10 17:24:44.650698+03	e7477900-31c4-41c6-ae1b-d4ea86700252	Sanext 10020548 - 10020548	3		12	1
1212	2023-10-10 17:24:44.652657+03	e70b95e9-f398-4b57-858d-e2b2e81a33c6	М-230 43574167 - 43574167	3		12	1
1213	2023-10-10 17:24:44.653637+03	e7080d28-5d0c-42ea-82db-0766b87f755f	М-230 43341695 - 43341695	3		12	1
1214	2023-10-10 17:24:44.655574+03	e6e69b1a-3291-40e1-8f79-d0c537345420	М-230 41218602 - 41218602	3		12	1
1215	2023-10-10 17:24:44.657538+03	e6c6ed18-fd7d-43ea-813f-dde851ef20b2	М-230 43487891 - 43487891	3		12	1
1216	2023-10-10 17:24:44.658508+03	e6b0a4fc-708a-4e9c-a434-2f67533cc597	Sanext 10021893 - 10021893	3		12	1
1217	2023-10-10 17:24:44.660466+03	e660531f-d0d3-47aa-abc2-ad2495ecc87f	Sanext 10021339 - 10021339	3		12	1
1218	2023-10-10 17:24:44.662417+03	e627927d-7fc8-4c3f-9668-10ae89ce3036	Sanext 10021540 - 10021540	3		12	1
1219	2023-10-10 17:24:44.663382+03	e623bd33-4380-4469-b88a-9cfd16cd756f	Sanext 10020833 - 10020833	3		12	1
1220	2023-10-10 17:24:44.665342+03	e6215a2d-81c7-4847-97ad-a86982b138a6	М-230 43341982 - 43341982	3		12	1
1221	2023-10-10 17:24:44.666314+03	e5f37419-0448-4b5c-a429-80259386e109	М-230 43488060 - 43488060	3		12	1
1222	2023-10-10 17:24:44.668269+03	e5e0d595-0adb-42a4-a782-6265e0f71af6	М-230 43341788 - 43341788	3		12	1
1223	2023-10-10 17:24:44.66923+03	e5c546b9-183c-444c-b5d9-d2d1d8375b80	Sanext 10022325 - 10022325	3		12	1
1224	2023-10-10 17:24:44.671195+03	e5a41ed5-7c44-46b5-b3b6-3a07820767d6	Sanext 10020811 - 10020811	3		12	1
1225	2023-10-10 17:24:44.67314+03	e59ae34b-f24f-4a66-af40-9f727f7bc438	Sanext 10022307 - 10022307	3		12	1
1226	2023-10-10 17:24:44.674119+03	e5359a66-9b15-47ab-993a-7b07339b6549	Sanext 10021564 - 10021564	3		12	1
1227	2023-10-10 17:34:14.050147+03	e042a38f-8366-4166-8b5c-05a70438d119	Пульсар 16M 4741254 - 4741254	3		12	1
1228	2023-10-10 17:34:14.054063+03	bc4170ef-cc10-4e9d-a87a-6c2d917ae109	Пульсар 16M 4741158 - 4741158	3		12	1
1229	2023-10-10 17:34:14.056015+03	102dc273-1544-42bb-90bb-6e29d07c81e5	Пульсар 16M 4741451 - 4741451	3		12	1
1230	2023-10-10 17:34:14.057961+03	03214fce-d409-417c-bf5a-751d7f4ddf23	Пульсар 16M 4741154 - 4741154	3		12	1
1231	2023-10-10 18:23:29.612443+03	b6b24d42-72b3-456e-940b-40113e0914d6	Valtec 16M 30407256 - 30407256	3		12	1
1232	2023-10-10 18:24:23.069956+03	01ce85c3-325a-47e2-a46e-8ca871424b6b	Valtec 16M 30407256 - 30407256	3		12	1
1233	2023-10-10 18:52:11.438945+03	ec61cfe6-f1e2-4934-852d-0544500ea8bd	Valtec 16M 30407256 - 30407256	3		12	1
1234	2023-10-10 21:21:25.93607+03	11410326-5f50-42e2-832f-18fedc1eacdd	Valtec 16M 30407256 - 30407256	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	1
1235	2023-10-10 21:56:30.098913+03	30	Valtec 16M 30407256 Valtec 16M Канал 16 Суточный -- adress: 16  channel: 0	2	[{"changed": {"fields": ["Guid params"]}}]	19	1
1236	2023-10-11 13:11:01.655558+03	11410326-5f50-42e2-832f-18fedc1eacdd	Valtec 16M 30407256 - 30407256	3		12	1
1237	2023-10-11 13:13:44.014919+03	544b297d-9a69-4b8d-a647-32245258f7ef	Valtec 16M 30407256 - 30407256	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	1
1238	2023-10-11 18:42:24.184561+03	544b297d-9a69-4b8d-a647-32245258f7ef	Valtec 16M 30407256 - 30407256	3		12	1
1239	2023-10-11 18:48:35.193889+03	3746334a-647a-472f-8bdd-5de6414e65d6	Valtec 16M 30407256 - 30407256	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
1240	2023-10-11 18:48:53.696033+03	74a6700b-6dc1-4ffb-b3b4-3cb99a944798	Valtec 16M 30407258 - 30407258	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
1241	2023-10-11 18:49:10.073944+03	e004e639-8c86-40ae-933d-7bba3eef2e5f	Valtec 16M 30407260 - 30407260	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
1242	2023-10-11 18:49:31.467459+03	41eccbff-9e1b-4e34-b49e-96ea42d1be6e	Valtec 16M 30407257 - 30407257	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
1243	2023-10-11 18:49:43.750703+03	aba01ebd-3a90-46ac-b480-0a309567c0cf	Valtec 16M 30407259 - 30407259	2	[{"changed": {"fields": ["\\u0421\\u0435\\u0442\\u0435\\u0432\\u043e\\u0439 \\u0430\\u0434\\u0440\\u0435\\u0441"]}}]	12	3
1244	2023-12-19 12:24:40.904208+03	bd997f67-c780-461b-9211-519cec32eda4	ул. Мосфильмовская, 98	3		25	3
1245	2023-12-19 12:24:57.784264+03	954e3b7a-c06e-43ff-b495-711785eed3d2	Корпус 1 Вода	3		25	3
1246	2023-12-19 12:24:57.793871+03	83e87bff-143f-40d4-955a-f88350766053	Корпус 2 Вода	3		25	3
1247	2023-12-19 12:25:15.107667+03	e004e639-8c86-40ae-933d-7bba3eef2e5f	Valtec 16M 30407260 - 30407260	3		12	3
1248	2023-12-19 12:25:15.109666+03	aba01ebd-3a90-46ac-b480-0a309567c0cf	Valtec 16M 30407259 - 30407259	3		12	3
1249	2023-12-19 12:25:15.110667+03	74a6700b-6dc1-4ffb-b3b4-3cb99a944798	Valtec 16M 30407258 - 30407258	3		12	3
1250	2023-12-19 12:25:15.110667+03	41eccbff-9e1b-4e34-b49e-96ea42d1be6e	Valtec 16M 30407257 - 30407257	3		12	3
1251	2023-12-19 12:25:15.110667+03	3746334a-647a-472f-8bdd-5de6414e65d6	Valtec 16M 30407256 - 30407256	3		12	3
1252	2024-01-19 14:10:15.148794+03	52316886-124d-40ea-ac91-8d14a316f969	Наименование дома	3		25	3
1253	2024-01-19 14:11:12.797185+03	f3bc4a53-e508-406d-94a6-fa9479963b0d	10.10.152.7:4002	3		20	3
1254	2024-01-19 14:11:12.801184+03	efc15026-664a-4086-8da2-68bfdc7aad7f	10.10.152.5:4001	3		20	3
1255	2024-01-19 14:11:12.802185+03	ee9b6804-758a-4695-9fb7-53781c3a77d4	10.222.109.21:4000	3		20	3
1256	2024-01-19 14:11:12.803185+03	ed5c3fd9-b3db-44a3-a792-e0673680d07a	10.222.109.11:4005	3		20	3
1257	2024-01-19 14:11:12.805184+03	eb737836-8c5c-4b9f-90cf-c2890a8053cf	10.10.152.9:4005	3		20	3
1258	2024-01-19 14:11:12.806185+03	e123a611-d016-4a03-b0b1-c7f0f7c63b10	10.10.152.9:4004	3		20	3
1259	2024-01-19 14:11:12.807186+03	dccc9464-f113-41e7-aace-e9df91633f0d	10.10.152.9:4003	3		20	3
1260	2024-01-19 14:11:12.808185+03	d8240d11-5c82-40b0-8531-2dd714fb0b99	10.10.152.7:4001	3		20	3
1261	2024-01-19 14:11:12.810186+03	d4683d8c-c17e-49d6-80b4-8ffc044edbc2	10.222.109.11:4000	3		20	3
1262	2024-01-19 14:11:12.811185+03	d3f2bdeb-4ebd-4be3-ac21-b791ef44f41b	10.222.109.21:4006	3		20	3
1263	2024-01-19 14:11:12.812185+03	d0c8f2c9-2a0b-49a8-b048-cb0a53047763	10.222.109.21:4003	3		20	3
1264	2024-01-19 14:11:12.813186+03	c4d0b33b-a145-47ef-9a73-a3ae7f90d0d7	10.10.152.9:4000	3		20	3
1265	2024-01-19 14:11:12.814185+03	c4cdac5d-6ef1-42b1-87c8-34262a198d2b	10.10.152.6:4002	3		20	3
1266	2024-01-19 14:11:12.816187+03	c410b11e-d672-408a-ae7d-77efa42f31fe	10.222.109.11:4002	3		20	3
1267	2024-01-19 14:11:12.817188+03	c3397444-450c-4c68-a203-c2769a1f5583	10.10.152.10:4001	3		20	3
1268	2024-01-19 14:11:12.818186+03	b926a1a7-07a4-4ae7-afd4-6a8a40c97292	10.10.152.10:4003	3		20	3
1269	2024-01-19 14:11:12.820186+03	a138e4cf-abe3-4689-9f9b-34a8de7d2cdd	10.10.152.4:4001	3		20	3
1270	2024-01-19 14:11:12.821185+03	9f89a1fb-25f1-448b-b800-cc418fc88a64	10.10.152.9:4001	3		20	3
1271	2024-01-19 14:11:12.822187+03	9dc262e6-122b-410e-b3de-f1b165e63a5e	10.10.152.8:4003	3		20	3
1272	2024-01-19 14:11:12.823187+03	945aaeba-e257-45da-8530-4eeb711e8caf	10.10.152.11:4001	3		20	3
1273	2024-01-19 14:11:12.824188+03	8782e700-c1bf-494c-93dc-31026ec1acaa	10.10.152.12:4002	3		20	3
1274	2024-01-19 14:11:12.825188+03	7f56611c-2cfa-49f9-9650-fb2e09de787f	10.10.152.8:4002	3		20	3
1275	2024-01-19 14:11:12.826188+03	7e506f43-c495-4e98-911a-4134e699adf5	10.10.152.10:4005	3		20	3
1276	2024-01-19 14:11:12.827188+03	7e262084-9790-478a-9ba7-5ef77221d146	10.10.152.9:4007	3		20	3
1277	2024-01-19 14:11:12.828187+03	7733ac51-9f23-49b6-95bd-2444a9439800	10.10.152.10:4000	3		20	3
1278	2024-01-19 14:11:12.829188+03	720376cd-e6d1-485c-b885-c66c5b4b788f	10.10.152.11:4003	3		20	3
1279	2024-01-19 14:11:12.830188+03	6f8c21a8-90a2-4f47-9f86-565193064644	10.10.152.6:4001	3		20	3
1280	2024-01-19 14:11:12.831188+03	6e945803-4209-4b4e-ac98-df008b883c65	10.222.109.21:4002	3		20	3
1281	2024-01-19 14:11:12.832188+03	6b486cba-574e-44b1-bc3c-091dbbd2eb8e	10.222.109.11:4003	3		20	3
1282	2024-01-19 14:11:12.833188+03	685d957b-8ffa-4781-ad47-a9111d33a9a7	10.222.109.21:4005	3		20	3
1283	2024-01-19 14:11:12.834188+03	61d0a915-c3d3-4aff-b87d-ef424c2da024	10.222.109.21:4004	3		20	3
1284	2024-01-19 14:11:12.835188+03	5f67e0b0-1be8-4175-919f-cb44d8d87d01	10.10.152.8:4001	3		20	3
1285	2024-01-19 14:11:12.836188+03	5f0c346a-3adc-4251-8a7e-a343029eff4d	10.10.152.8:4000	3		20	3
1286	2024-01-19 14:11:12.837188+03	5ee17b2c-2f52-48ff-9cb6-2ca231b5670b	10.10.152.9:4002	3		20	3
1287	2024-01-19 14:11:12.838188+03	58125c16-2714-4722-86c4-baa9abcd764e	10.10.152.12:4000	3		20	3
1288	2024-01-19 14:11:12.839188+03	55bcc31a-37e7-4918-8298-251fb224245c	10.222.109.11:4001	3		20	3
1289	2024-01-19 14:11:12.840188+03	4e62e635-cc8f-4b56-ae46-b17c020eeac6	10.222.109.21:4007	3		20	3
1290	2024-01-19 14:11:12.841188+03	452caf88-bec4-4f14-9101-08b541d0cc47	10.10.152.5:4002	3		20	3
1291	2024-01-19 14:11:12.842188+03	41507458-45e9-42d7-824f-e4db46027248	10.10.152.4:4002	3		20	3
1292	2024-01-19 14:11:12.843188+03	3c9f6d61-6b8a-470a-974e-3dd5a6f8cd55	10.10.152.12:4001	3		20	3
1293	2024-01-19 14:11:12.844189+03	38d24c10-46df-4fa5-81a8-57bd34ea8615	10.222.109.11:4004	3		20	3
1294	2024-01-19 14:11:12.845189+03	346eb37d-6247-4e4d-a9d8-31e31fbff13f	10.10.152.10:4002	3		20	3
1295	2024-01-19 14:11:12.847189+03	2c987e90-04bb-4a05-be5b-3047c6838ef1	10.222.109.11:4006	3		20	3
1296	2024-01-19 14:11:12.848188+03	2c355699-30dc-4caa-82ed-108f420a16ce	10.10.152.10:4004	3		20	3
1297	2024-01-19 14:11:12.849188+03	1fe87690-9ecc-4403-b677-537ace9c576e	10.10.152.11:4002	3		20	3
1298	2024-01-19 14:11:12.850721+03	15b315c0-052e-4eec-b2d6-e09a0de38ec7	10.10.152.11:4000	3		20	3
1299	2024-01-19 14:11:12.852041+03	0cbb80d5-5fc2-41ae-a9f8-3f7ca2c59a8e	10.10.152.11:4007	3		20	3
1300	2024-01-19 14:11:12.853042+03	00dec37f-7568-44f5-b150-5e4be83ef4bc	10.222.109.21:4001	3		20	3
1301	2024-02-23 09:41:28.150439+03	94c47228-ec33-486a-a16b-22c37271aa28	172.17.21.5:4005 - М-230 43714277	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1302	2024-02-23 11:31:44.384463+03	2bbf5f07-f153-467f-9f55-f5d5d7e6dbb0	172.17.21.8:4002 - Пульсар Теплосчётчик 5738089	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1303	2024-02-23 11:32:07.163494+03	45e5647f-b16d-4c72-a80c-b6785b46a5e7	172.17.21.7:4002 - Пульсар Теплосчётчик 5738620	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1304	2024-02-23 11:32:26.458287+03	882c477c-d31d-4576-a608-9a20324bd414	172.17.21.8:4002 - Пульсар Теплосчётчик 5738344	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1305	2024-02-23 11:32:45.38031+03	10f4e205-5afe-4c29-8f8d-d887e16b09f5	172.17.21.7:4002 - Пульсар Теплосчётчик 5737601	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1306	2024-02-23 11:33:30.765246+03	9a62dd8b-1ddf-44a8-8319-c645ff58de63	172.17.21.8:4002 - Пульсар Теплосчётчик 5738263	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1307	2024-02-23 11:33:47.814196+03	aa154baa-d73b-4aa7-bdae-e0e551e7894e	172.17.21.7:4002 - Пульсар Теплосчётчик 5738780	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1308	2024-02-23 11:34:06.183175+03	2353a92e-ef9c-4ffc-a6bb-9298d51ac19e	172.17.21.8:4002 - Пульсар Теплосчётчик 5737669	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1309	2024-02-23 11:34:22.503658+03	dac58dfb-bd02-4369-a58f-ac39c34236b1	172.17.21.7:4002 - Пульсар Теплосчётчик 5737350	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1310	2024-02-23 11:34:37.820313+03	c091a767-d422-470f-989d-99295a53bdb0	172.17.21.8:4002 - Пульсар Теплосчётчик 5737670	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1311	2024-02-23 11:34:55.515295+03	7221a8f9-3a2a-4924-beb8-43cd0da2678b	172.17.21.7:4002 - Пульсар Теплосчётчик 5738395	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1312	2024-02-23 11:35:10.337807+03	15a0d195-8c7f-4650-ba25-6743da5da900	172.17.21.8:4002 - Пульсар Теплосчётчик 5738622	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1313	2024-02-23 11:36:04.383564+03	a5110259-b717-4f15-bcdf-975ef5cf89ba	172.17.21.7:4002 - Пульсар Теплосчётчик 5737562	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1314	2024-02-23 11:36:20.731639+03	446e1bf5-7adc-4c9c-b4c6-3a182ef3df1f	172.17.21.7:4002 - Пульсар Теплосчётчик 5738626	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1315	2024-02-23 11:37:27.381009+03	6a230580-3ac7-4ef4-af9f-50e219dfa99d	172.17.21.8:4002 - Пульсар Теплосчётчик 5737679	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1316	2024-02-23 11:37:46.626043+03	ca0d6a1b-4e10-4085-b082-2e409fcf1be8	172.17.21.7:4002 - Пульсар Теплосчётчик 5738172	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1317	2024-02-23 11:38:05.515186+03	21cb0f14-7836-4b99-b9f9-c611e821ba3a	172.17.21.8:4002 - Пульсар Теплосчётчик 5737768	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1318	2024-02-23 11:38:20.820816+03	e8c9341b-38e8-43d0-9b98-39db8c5320ec	172.17.21.7:4002 - Пульсар Теплосчётчик 5738586	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1319	2024-02-23 11:38:36.986283+03	290be3eb-0e1f-494a-b51d-7ecef19ac873	172.17.21.8:4002 - Пульсар Теплосчётчик 5737897	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1320	2024-02-23 11:38:53.631475+03	349d9faf-0630-4eb6-a8e6-eb94b81ca87f	172.17.21.7:4002 - Пульсар Теплосчётчик 5737895	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1321	2024-02-23 11:39:10.495313+03	1d770dc8-1446-4fc4-87c4-01b163730c9c	172.17.21.8:4002 - Пульсар Теплосчётчик 5737781	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1322	2024-02-23 11:39:31.006017+03	8606a321-b36a-471c-87ff-baf936c36489	172.17.21.7:4002 - Пульсар Теплосчётчик 5737675	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1323	2024-02-23 11:39:49.607469+03	0d63d31b-27e9-45d5-90a5-b4c1ed74f514	172.17.21.7:4002 - Пульсар Теплосчётчик 5737850	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1324	2024-02-23 11:40:07.29719+03	c42784de-43b7-4534-9fc1-d728e801814b	172.17.21.8:4002 - Пульсар Теплосчётчик 5737877	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1325	2024-02-23 11:40:24.107437+03	7f064de0-755f-4b94-b31a-16d44951002c	172.17.21.8:4002 - Пульсар Теплосчётчик 5737715	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1326	2024-02-23 11:40:43.315604+03	73bf85e0-1d60-4c82-9fbe-f1d583de38d3	172.17.21.7:4002 - Пульсар Теплосчётчик 5737718	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1327	2024-02-23 11:41:01.045578+03	99e522ce-6eaf-4584-8171-6e844383cf2b	172.17.21.8:4002 - Пульсар Теплосчётчик 5737646	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1328	2024-02-23 11:41:18.459124+03	dc8a91cb-e6d2-4429-9216-1ccda191fe27	172.17.21.7:4002 - Пульсар Теплосчётчик 5737825	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1329	2024-02-23 11:41:33.709413+03	3cf96126-ee17-4779-8487-babc14756462	172.17.21.8:4002 - Пульсар Теплосчётчик 5737654	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1330	2024-02-23 11:41:52.504122+03	a7f39fe5-3b03-45bb-b4c5-228fab7b3925	172.17.21.7:4002 - Пульсар Теплосчётчик 5734150	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1331	2024-02-23 11:43:21.832331+03	818cd294-a8ff-453f-bb56-52ced37386cd	172.17.21.8:4003 - Пульсар Теплосчётчик 5738792	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1332	2024-02-23 11:43:57.809832+03	690b0fb4-208f-409f-8210-b54ab57a734c	172.17.21.7:4003 - Пульсар Теплосчётчик 5737888	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1333	2024-02-23 11:44:29.457654+03	44823c87-53a7-4ae0-bcdb-18c36cccb35c	172.17.21.8:4003 - Пульсар Теплосчётчик 5737851	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1334	2024-02-23 11:44:45.366998+03	723131fd-706d-47d0-8dc5-fb8fa0239e0e	172.17.21.7:4003 - Пульсар Теплосчётчик 5737856	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1335	2024-02-23 11:45:00.014388+03	84e3fc4d-25eb-4d1b-bbab-7fa94159c80d	172.17.21.8:4003 - Пульсар Теплосчётчик 5738082	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1336	2024-02-23 11:45:16.918975+03	a48d554c-5f4a-4a6f-b89b-dff375553e18	172.17.21.7:4003 - Пульсар Теплосчётчик 5738083	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1337	2024-02-23 11:45:32.81616+03	01d73cae-5550-481d-8459-75ec15896df1	172.17.21.8:4003 - Пульсар Теплосчётчик 5737754	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1338	2024-02-23 11:45:50.135436+03	cec54f79-767c-4754-93fa-8d650cdcfbe6	172.17.21.7:4003 - Пульсар Теплосчётчик 5737762	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1339	2024-02-23 11:46:09.361151+03	648cc6d5-3e9c-473e-a0da-aaccd7436206	172.17.21.8:4003 - Пульсар Теплосчётчик 5734130	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1340	2024-02-23 11:46:28.969106+03	4c09cde3-8e4a-4ee9-b018-335ac6cf7222	172.17.21.7:4003 - Пульсар Теплосчётчик 5737870	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1341	2024-02-23 11:46:43.035967+03	ce49d26f-fbca-483b-bdf8-52d033572479	172.17.21.8:4003 - Пульсар Теплосчётчик 5737865	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1342	2024-02-23 11:46:58.48407+03	853e3312-6df3-416d-9aa1-e5965ab870de	172.17.21.7:4003 - Пульсар Теплосчётчик 5737721	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1343	2024-02-23 11:47:27.43055+03	510325fe-c727-4259-ab49-d8b8c37dd98d	172.17.21.8:4003 - Пульсар Теплосчётчик 5738816	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1344	2024-02-23 11:47:44.23732+03	cc177690-f463-4957-a91d-caf23816360f	172.17.21.7:4003 - Пульсар Теплосчётчик 5737925	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1345	2024-02-23 11:48:00.45356+03	deebb83c-5d71-468f-bb1e-61b790763ce0	172.17.21.8:4003 - Пульсар Теплосчётчик 5737966	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1346	2024-02-23 11:48:15.769739+03	cf6a5a3d-a82d-405e-976c-9d0bc5513f0f	172.17.21.7:4003 - Пульсар Теплосчётчик 5737970	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1347	2024-02-23 11:48:31.418243+03	030b07bf-99c7-4b97-aac3-9d0c704af3b5	172.17.21.8:4003 - Пульсар Теплосчётчик 5737904	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1348	2024-02-23 11:48:48.030338+03	9966a72a-8889-415e-9e4e-6eeea92a6983	172.17.21.7:4003 - Пульсар Теплосчётчик 5738637	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1349	2024-02-23 11:49:05.018199+03	7bb0888b-9d15-403a-950a-66838d4211bf	172.17.21.8:4003 - Пульсар Теплосчётчик 5738112	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1350	2024-02-23 11:49:23.618872+03	a254ad50-34ee-4929-bd57-86f0abea79ca	172.17.21.7:4003 - Пульсар Теплосчётчик 5737690	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1351	2024-02-23 11:49:39.398948+03	b44ba90e-533f-4e6c-a7b2-2137bdf18114	172.17.21.8:4003 - Пульсар Теплосчётчик 5738237	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1352	2024-02-23 11:49:59.232037+03	0e89033b-e528-4e44-8146-988248297d62	172.17.21.7:4003 - Пульсар Теплосчётчик 5738680	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1353	2024-02-23 11:50:16.774227+03	5a384993-92aa-485d-9552-7699984298e8	172.17.21.8:4003 - Пульсар Теплосчётчик 5737740	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1354	2024-02-23 11:50:34.621166+03	ba4d7e96-8c8b-4498-bc16-b42b313fe432	172.17.21.7:4003 - Пульсар Теплосчётчик 5737695	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1355	2024-02-23 11:50:50.910039+03	0e4636de-7797-43b5-b6d7-46fc16f8c7b1	172.17.21.8:4003 - Пульсар Теплосчётчик 5737915	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1356	2024-02-23 11:51:47.925708+03	bad4ea03-19fd-4e29-85ae-d5ec253e65c2	172.17.21.7:4003 - Пульсар Теплосчётчик 5737910	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1357	2024-02-23 11:52:32.805261+03	f784c5a4-8955-486a-8319-984996a6f501	172.17.21.8:4003 - Пульсар Теплосчётчик 5737789	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1358	2024-02-23 11:52:50.704198+03	8b675f3a-3950-405e-96b6-882a06ba56bb	172.17.21.7:4003 - Пульсар Теплосчётчик 5737790	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1359	2024-02-23 11:53:06.16944+03	e5fe001d-252c-4f06-8508-0504effd4d28	172.17.21.8:4003 - Пульсар Теплосчётчик 5737357	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1360	2024-02-23 11:53:23.499613+03	8655e214-0121-453a-8b9f-ea4bbb9d6d27	172.17.21.7:4003 - Пульсар Теплосчётчик 5737229	2	[{"changed": {"fields": ["Guid tcpip settings"]}}]	27	3
1361	2024-02-27 16:54:16.048087+03	0166c378-5696-489e-92fb-a1d360fc2921	Danfoss SonoSelect Канал 1 Суточный -- adress: 31  channel: 0	1	[{"added": {}}]	14	1
1362	2024-02-27 16:54:56.784602+03	b18bc638-eb07-429e-9c59-d859604be48f	Danfoss SonoSelect Канал 2 Суточный -- adress: 32  channel: 0	1	[{"added": {}}]	14	1
1363	2024-02-27 16:56:12.154768+03	af842772-2e25-45d0-9c40-3b21f30fe808	Пульсар Теплосчётчик Канал 1 Суточный -- adress: 31  channel: 0	1	[{"added": {}}]	14	1
1364	2024-02-27 16:56:39.856828+03	318bd700-815c-46fe-aa7c-1e5265bab53e	Пульсар Теплосчётчик Канал 2 Суточный -- adress: 32  channel: 0	1	[{"added": {}}]	14	1
1365	2024-06-16 20:00:22.862061+03	ee70db95-2573-44d0-99d9-370810d41d93	Дом 24, к.4	3		25	1
1366	2024-06-16 20:00:22.890889+03	8f2e9be5-6cd8-412f-94c6-5dbd74b512d4	Дом 24, к.4, щитовые	3		25	1
1367	2024-06-16 20:00:22.89479+03	8222e9a7-6a21-4283-b501-c30616235d60	Дом 24, к.2	3		25	1
1368	2024-06-16 20:00:22.896741+03	71926354-99ec-4338-9587-7fd4c1a6a73b	Дом 24, к.2, щитовые	3		25	1
1369	2024-06-16 20:00:22.901174+03	6359216b-ac8e-476e-9d07-f31a4b4b7e39	Ореховый бульвар	3		25	1
1370	2024-06-16 20:00:22.90605+03	4cc8befc-a274-4a50-ae8d-03f152c05aef	Дом 24, к.1	3		25	1
1371	2024-06-16 20:00:22.907998+03	396294d3-6034-4939-940e-b2c857b011cc	Дом 24, к.1, щитовые	3		25	1
1372	2024-06-16 20:00:22.910935+03	38704721-f466-4c56-b487-7948bfac6ebd	Дом 24, к.3, щитовые	3		25	1
1373	2024-06-16 20:00:22.913853+03	2dd16211-468f-4518-b038-61b551a6105c	Дом 24, к.3	3		25	1
1374	2024-06-16 20:01:01.003757+03	e65b0b81-a8dc-4a19-86f9-ca89342ae37d	172.17.21.5:4005	3		20	1
1375	2024-06-16 20:01:01.009148+03	dfecbab7-9d9b-4368-8df8-13981a231a3d	172.17.21.11:4007	3		20	1
1376	2024-06-16 20:01:01.011099+03	d8c6be8e-6469-47c6-a776-449e434afd31	172.17.21.8:4006	3		20	1
1377	2024-06-16 20:01:01.014024+03	d73517aa-d506-4176-aeed-d10bcf7a08de	172.17.21.7:4002	3		20	1
1378	2024-06-16 20:01:01.016952+03	c3f88550-8812-4616-ad76-09026d1c9a43	172.17.21.11:4004	3		20	1
1379	2024-06-16 20:01:01.019415+03	c2ff25d3-420f-4c6d-be21-821fd5ed5747	172.17.21.5:4002	3		20	1
1380	2024-06-16 20:01:01.021366+03	be49d91d-0390-49f3-830b-f8351e82f9ec	172.17.21.2:4000	3		20	1
1381	2024-06-16 20:01:01.023317+03	a2eca6cc-2823-4b78-9b90-1899be903472	172.17.21.6:4002	3		20	1
1382	2024-06-16 20:01:01.026244+03	9f6527b9-29a1-43e1-b320-b04609db1b38	172.17.21.7:4004	3		20	1
1383	2024-06-16 20:01:01.027266+03	9b8f79fc-30eb-40b5-bd0e-9bd5be52a7b8	172.17.21.20:4002	3		20	1
1384	2024-06-16 20:01:01.029168+03	9899333f-2443-424c-8a7f-c80469300e5c	172.17.21.18:4002	3		20	1
1385	2024-06-16 20:01:01.03112+03	9405e7fb-12f2-4496-ac52-770c1b1713e9	172.17.21.7:4003	3		20	1
1386	2024-06-16 20:01:01.03307+03	91d327b1-9f99-49ae-b29a-72fc50efdee3	172.17.21.8:4007	3		20	1
1387	2024-06-16 20:01:01.035021+03	907f0248-6d0e-47f3-a16f-df5715ffc7c9	172.17.21.18:4001	3		20	1
1388	2024-06-16 20:01:01.036973+03	8e438f1b-5bca-4e16-ba68-d1d04a854a52	172.17.21.2:4001	3		20	1
1389	2024-06-16 20:01:01.038614+03	7f0a33d9-1973-4c44-9f7a-fa1e5039e21f	172.17.21.5:4006	3		20	1
1390	2024-06-16 20:01:01.040566+03	7ac6d7ba-304d-4b35-acc5-3a2718b215b6	172.17.21.5:4007	3		20	1
1391	2024-06-16 20:01:01.042517+03	78c808b5-2e4f-48a6-bf12-3f99a2f607b4	172.17.21.20:4001	3		20	1
1392	2024-06-16 20:01:01.044469+03	76493e31-6b65-4b5b-92b6-0f8433cbab7c	172.17.21.2:4007	3		20	1
1393	2024-06-16 20:01:01.046421+03	6b3fa99c-6aa1-4cf4-aab2-0173ab6dc094	172.17.21.4:4002	3		20	1
1394	2024-06-16 20:01:01.047394+03	6acf033c-fd5c-401f-bb16-b410579747b7	172.17.21.2:4006	3		20	1
1395	2024-06-16 20:01:01.049345+03	5f313fe9-5306-4170-bf2e-ede5bcc496a4	172.17.21.11:4003	3		20	1
1396	2024-06-16 20:01:01.051294+03	5e05b0f9-3e7d-43fe-827d-6e59f5344776	172.17.21.11:4001	3		20	1
1397	2024-06-16 20:01:01.053245+03	54717b42-979c-4695-8ea2-b9cdbb6b1feb	172.17.21.6:4001	3		20	1
1398	2024-06-16 20:01:01.055196+03	52d33e8d-3bfc-4f0f-9be5-f0069ab340ac	172.17.21.8:4005	3		20	1
1399	2024-06-16 20:01:01.057147+03	4486bf09-c09c-482a-924c-a02050b17a0a	172.17.21.4:4003	3		20	1
1400	2024-06-16 20:01:01.058098+03	3cadb242-1a79-429a-80b5-7e52a193124d	172.17.21.6:4003	3		20	1
1401	2024-06-16 20:01:01.060022+03	37858a0d-0c80-4a1a-bca0-b3798d826b6a	172.17.21.11:4002	3		20	1
1402	2024-06-16 20:01:01.061973+03	28684cbd-7f2b-4b8d-a1e2-f9dde0fccb42	172.17.21.5:4001	3		20	1
1403	2024-06-16 20:01:01.063926+03	23842df4-4478-4242-b62c-0ce5a82b3959	172.17.21.8:4002	3		20	1
1404	2024-06-16 20:01:01.065875+03	20fd5893-a72f-442b-b745-00c17ab777e6	172.17.21.8:4003	3		20	1
1405	2024-06-16 20:01:01.066851+03	1f15412d-217f-4e93-b42f-4a86f03e9fdc	172.17.21.2:4005	3		20	1
1406	2024-06-16 20:01:01.068489+03	13582f98-eb4c-41dc-8f4a-098c87ef42f8	172.17.21.6:4004	3		20	1
1407	2024-06-16 20:01:01.071402+03	12b49d34-29d0-48f8-985c-34c89c224ad0	172.17.21.11:4006	3		20	1
1408	2024-06-16 20:01:01.073352+03	0a090e65-a4da-4c39-a119-30949b30614b	172.17.21.11:4005	3		20	1
1409	2024-08-05 01:11:05.150496+03	b95134db-af0c-4eea-bc8e-32b2bcfc7e1d	Декаст Теплосчётчик	1	[{"added": {}}]	22	1
1410	2024-08-05 01:13:32.156842+03	7b109795-7076-444c-ba75-0f6494e523c5	Декаст Теплосчётчик Энергия Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1411	2024-08-05 01:24:23.798724+03	99fd51ba-2b1a-4cd3-adde-e0e744250d96	Декаст Теплосчётчик Объем Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1412	2024-08-05 01:26:00.023+03	47c98a3e-0db8-4c51-8f2e-a4eed31039f9	Декаст Теплосчётчик Ti Суточный -- adress: 3  channel: 1	1	[{"added": {}}]	14	1
1413	2024-08-05 01:29:36.890803+03	9a0c606e-6986-4a36-93a4-0769a2f851e9	Декаст Теплосчётчик To Суточный -- adress: 4  channel: 1	1	[{"added": {}}]	14	1
1414	2024-08-12 15:14:05.795971+03	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	МЗТА	1	[{"added": {}}]	22	1
1415	2024-08-12 15:17:21.971391+03	82ce9adf-0a2e-4ceb-8d95-89fc4d9df289	МЗТА Канал 1 Суточный -- adress: 1  channel: 0	1	[{"added": {}}]	14	1
1416	2024-08-12 18:27:43.598757+03	82ce9adf-0a2e-4ceb-8d95-89fc4d9df289	МЗТА Канал 1 Суточный -- adress: 2  channel: 0	2	[{"changed": {"fields": ["Param address"]}}]	14	1
1417	2024-08-12 18:27:56.642121+03	82ce9adf-0a2e-4ceb-8d95-89fc4d9df289	МЗТА Канал 1 Суточный -- adress: 2  channel: 0	2	[{"changed": {"fields": ["Name"]}}]	14	1
1418	2024-08-12 18:28:14.372101+03	82ce9adf-0a2e-4ceb-8d95-89fc4d9df289	МЗТА Канал 2 Суточный -- adress: 2  channel: 0	2	[{"changed": {"fields": ["Guid names params"]}}]	14	1
1419	2024-08-12 18:38:38.085958+03	4fd62d3d-880f-4f00-81bd-41b380c012da	МЗТА Канал 3 Суточный -- adress: 3  channel: 0	1	[{"added": {}}]	14	1
1420	2024-08-12 18:39:00.333606+03	ec10fc08-9e1b-416b-ab8e-b6f2233c8196	МЗТА Канал 4 Суточный -- adress: 4  channel: 0	1	[{"added": {}}]	14	1
1421	2024-08-12 18:39:23.386261+03	12ea6b3b-4dcf-40e3-bdf1-9edb80b9585a	МЗТА Канал 5 Суточный -- adress: 5  channel: 0	1	[{"added": {}}]	14	1
1422	2024-08-12 18:39:39.19513+03	6352996a-dc82-4939-8e0d-8679af9a3cb4	МЗТА Канал 6 Суточный -- adress: 6  channel: 0	1	[{"added": {}}]	14	1
1423	2024-08-12 18:39:59.147079+03	99c31bc4-0764-472a-91f9-774c7eacfaed	МЗТА Канал 7 Суточный -- adress: 7  channel: 0	1	[{"added": {}}]	14	1
1424	2024-08-12 18:40:13.402347+03	f394d963-c94f-42ac-9a15-d83dd0a97e78	МЗТА Канал 8 Суточный -- adress: 8  channel: 0	1	[{"added": {}}]	14	1
1425	2024-08-12 18:40:35.430079+03	8f16a338-23db-4fe0-99e1-3aad34897fda	МЗТА Канал 9 Суточный -- adress: 9  channel: 0	1	[{"added": {}}]	14	1
1426	2024-08-12 18:40:55.522084+03	11136ad3-a88e-40e5-8d19-cbf43032d17c	МЗТА Канал 10 Суточный -- adress: 10  channel: 0	1	[{"added": {}}]	14	1
1427	2024-08-12 18:41:07.699083+03	41f7302d-4fe7-4b55-8cc4-5d12269671e1	МЗТА Канал 11 Суточный -- adress: 11  channel: 0	1	[{"added": {}}]	14	1
1428	2024-08-12 18:41:26.43147+03	6472c355-66cd-4f99-8c17-a01ad155449e	МЗТА Канал 12 Суточный -- adress: 12  channel: 0	1	[{"added": {}}]	14	1
1429	2024-08-12 18:41:42.322609+03	5a4f437f-8b6d-4a59-9ec3-ad5f47cefccf	МЗТА Канал 13 Суточный -- adress: 13  channel: 0	1	[{"added": {}}]	14	1
1430	2024-08-12 18:42:00.285723+03	447cf2bb-bc43-4a50-8cd0-b1cc0407d973	МЗТА Канал 14 Суточный -- adress: 14  channel: 0	1	[{"added": {}}]	14	1
1431	2024-08-12 18:42:33.920885+03	98bcdfdd-8965-42f3-84fe-978d367be9eb	МЗТА Канал 15 Суточный -- adress: 15  channel: 0	1	[{"added": {}}]	14	1
1432	2024-08-12 18:42:50.046206+03	8663465e-64d1-49d9-915b-b0cd7d71a503	МЗТА Канал 16 Суточный -- adress: 16  channel: 0	1	[{"added": {}}]	14	1
1433	2024-08-12 19:31:29.707532+03	f7af4d4f-e542-406d-9ad2-44a5b8e9d506	МЗТА Канал 17 Суточный -- adress: 17  channel: 0	1	[{"added": {}}]	14	1
1434	2024-08-12 19:32:34.822971+03	ccd0c7f4-babd-4953-99c8-b6adf0cf1b12	МЗТА Канал 18 Суточный -- adress: 18  channel: 0	1	[{"added": {}}]	14	1
1435	2024-08-12 19:32:48.667202+03	7633d6a2-9cba-49d4-b456-a51e137b45f1	МЗТА Канал 19 Суточный -- adress: 19  channel: 0	1	[{"added": {}}]	14	1
1436	2024-08-12 19:33:06.218229+03	a556773c-888a-4bb7-8ac4-e083630f0f28	МЗТА Канал 20 Суточный -- adress: 20  channel: 0	1	[{"added": {}}]	14	1
1437	2024-08-12 21:48:09.12191+03	a1aee492-2bff-4dde-92e0-4b0ff416407c	МЗТА 20M 12121212 - 12121212	3		12	1
1438	2024-08-12 21:51:18.205329+03	8269fcee-40de-425f-a57e-fe56aa92846d	МЗТА 20M 12121212 - 12121212	3		12	1
1439	2024-08-12 21:53:19.662741+03	c32eed96-61d9-4b30-b80f-e519a863a731	МЗТА 20M 12121212 - 12121212	3		12	1
1440	2024-08-12 21:54:05.490683+03	7887e5a3-7781-42ae-a89d-3ac60e3a6e38	МЗТА 20M 12121212 - 12121212	3		12	1
1441	2024-08-12 22:04:21.503527+03	33952218-d00e-4fc2-9a3b-02f727c8e4a6	МЗТА 20M 12121212 - 12121212	3		12	1
1442	2024-08-13 11:18:19.921507+03	2c74e0f7-190a-4d25-a390-5eb03caf4193	МЗТА 12121212 - 12121212	3		12	1
1443	2024-08-13 11:18:44.459528+03	ad878607-10e9-45c2-9567-712f7fc20458	Корпус 6 Вода	3		25	1
1444	2024-09-10 00:37:29.053593+03	657d8ad0-bdba-4459-a07e-4d4eb72950d6	Декаст ХВС	1	[{"added": {}}]	22	1
1445	2024-09-10 00:38:00.551511+03	36b6ea95-beb1-490d-a39f-06163bfcaae5	Декаст ГВС	1	[{"added": {}}]	22	1
1446	2024-09-10 00:40:30.438274+03	2c129d66-9551-43af-b841-3beeb31974e1	Декаст ХВС Объем ХВС Суточный -- adress: 1  channel: 1	1	[{"added": {}}]	14	1
1447	2024-09-10 00:40:47.7143+03	a2df1925-fa6a-4e41-9ded-01f17f8db55d	Декаст ГВС Объем ГВС Суточный -- adress: 1  channel: 1	1	[{"added": {}}]	14	1
1448	2025-04-24 01:24:50.936065+03	5e1dbf09-6c37-4982-aa1e-a693d2b4f079	Danfoss SonoMeter-500	1	[{"added": {}}]	22	1
1449	2025-04-24 01:29:26.860114+03	bad0b995-04ac-4650-ada1-9ddec3574606	Danfoss SonoMeter-500 Объем Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1450	2025-04-24 01:34:42.741092+03	751b8d48-b7f9-4b68-85a1-b1cb00e08dc2	Danfoss SonoMeter-500 Энергия Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1451	2025-04-24 01:35:58.838897+03	bc847426-44cf-4788-8abf-8ec84e81fb5f	Danfoss SonoMeter-500 Ti Суточный -- adress: 3  channel: 1	1	[{"added": {}}]	14	1
1452	2025-04-24 01:36:35.524238+03	230e16d7-d4d1-4a31-86a9-c962791dd0e0	Danfoss SonoMeter-500 To Суточный -- adress: 4  channel: 1	1	[{"added": {}}]	14	1
1453	2025-08-01 15:45:36.186788+03	b29f02ba-a5bf-4236-acae-6de1185536cf	Пульсар 3Ф4Т A+ Профиль Получасовой -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
1454	2025-08-01 15:46:09.58959+03	16087cc4-9360-4568-b15f-14a5e09dbd56	Пульсар 3Ф4Т R+ Профиль Получасовой -- adress: 2  channel: 0	1	[{"added": {}}]	14	1
1455	2025-08-07 11:14:44.085078+03	bc61d16e-4059-4f9b-b7df-55915a7a844b	Пульсар IoT ВС	1	[{"added": {}}]	22	1
1456	2025-08-07 11:55:40.931403+03	dc619965-fe10-4ef8-b41f-9506cd579297	Пульсар IoT ВС Объем Суточный -- adress: 1  channel: 1	1	[{"added": {}}]	14	1
1457	2025-08-07 12:01:01.593641+03	84bf3b54-d51d-48d7-902d-4826cdef7101	Пульсар IoT Тепло-объем	1	[{"added": {}}]	22	1
1458	2025-08-07 12:01:18.323456+03	a3aa2833-4104-4ac4-a0fb-c34e4402d1d6	Пульсар IoT Тепло-энергия	1	[{"added": {}}]	22	1
1459	2025-08-07 12:02:06.762992+03	ae250bd8-db9b-49ef-8153-adf2cee5b80e	Пульсар IoT Тепло-энергия Энергия Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1460	2025-08-07 12:16:01.329354+03	ae250bd8-db9b-49ef-8153-adf2cee5b80e	Пульсар IoT Тепло-энергия Энергия Суточный -- adress: 7  channel: 1	2	[]	14	1
1461	2025-08-07 12:18:32.188717+03	af6b27af-03dd-4128-86b9-d58849950220	Пульсар IoT Тепло-объем Объем Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1462	2025-08-08 14:34:12.789201+03	dc619965-fe10-4ef8-b41f-9506cd579297	Пульсар IoT ВС Объем ВС Суточный -- adress: 1  channel: 1	2	[{"changed": {"fields": ["Guid names params"]}}]	14	1
1463	2025-08-11 16:46:56.71112+03	59963730-468e-441c-86d9-d08a3ed062fc	ВКТ9	1	[{"added": {}}]	22	1
1464	2025-08-11 19:53:50.232506+03	26f1708f-a6d7-4755-a8de-5773f5d78d1e	ВКТ9 Энергия Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1465	2025-08-11 19:55:07.023524+03	09372faf-0a0f-4e01-8922-e0e0727d5908	ВКТ9 Энергия ГВС Суточный -- adress: 7  channel: 2	1	[{"added": {}}]	14	1
1466	2025-08-11 19:55:40.307585+03	27ef159a-156b-485f-9a78-93516fdb1f49	ВКТ9 Объем_1 Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1467	2025-08-11 19:56:10.37466+03	54bda39f-0a0b-4d18-b3bd-383340bcf483	ВКТ9 Объем_2 Суточный -- adress: 8  channel: 2	1	[{"added": {}}]	14	1
1468	2025-08-11 19:57:30.636317+03	9798a726-739d-419f-8ed6-41a3651c90ba	ВКТ9 Температура_1 Суточный -- adress: 2  channel: 1	1	[{"added": {}}]	14	1
1469	2025-08-11 19:57:47.804035+03	232bd7a4-497b-4dde-94d0-7dde4a78e8f1	ВКТ9 Температура_2 Суточный -- adress: 2  channel: 2	1	[{"added": {}}]	14	1
1470	2025-08-11 19:58:20.300391+03	71b0014f-87b8-400f-a589-c9f73baca185	ВКТ9 THW Суточный -- adress: 2  channel: 3	1	[{"added": {}}]	14	1
1471	2025-08-11 19:58:43.793539+03	1d105023-cd5d-4df8-a020-705f44ce7311	ВКТ9 dt_1 Суточный -- adress: 2  channel: 5	1	[{"added": {}}]	14	1
1472	2025-08-11 19:59:09.608544+03	9cf42823-594a-41ba-9273-9b36c5a04e59	ВКТ9 dt_2 Суточный -- adress: 2  channel: 6	1	[{"added": {}}]	14	1
1473	2025-08-15 00:50:56.948748+03	4d714a5e-3af5-40fe-ab72-199ed8760ac3	Теплосчётчик Ридан РУТ-01	1	[{"added": {}}]	22	1
1474	2025-08-15 00:53:35.642776+03	0a5753cf-debd-45cb-8dd0-3905f36293fc	Водосчётчик Ридан СГВ-15	1	[{"added": {}}]	22	1
1475	2025-08-15 13:39:16.519353+03	da5b2c6e-d222-437c-8222-201b67ebfef6	Теплосчётчик Ридан РУТ-01 Энергия_тепло Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1476	2025-08-15 13:43:12.183427+03	7072151e-6e29-41e4-bc55-0665942c4b6d	Теплосчётчик Ридан РУТ-01 Энергия_холод Суточный -- adress: 20  channel: 0	1	[{"added": {}}]	14	1
1477	2025-08-15 13:45:06.420729+03	21ec90c8-4722-4933-9d93-f3d531ac4086	Теплосчётчик Ридан РУТ-01 Объем Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1478	2025-08-15 13:46:47.794485+03	aaca1772-5c13-4ab5-b983-b3bb3cd6f9b0	Теплосчётчик Ридан РУТ-01 Ti Суточный -- adress: 3  channel: 1	1	[{"added": {}}]	14	1
1479	2025-08-15 13:47:33.714945+03	a9a6a79b-e490-4efd-a85a-e7a19b68a700	Теплосчётчик Ридан РУТ-01 To Суточный -- adress: 4  channel: 1	1	[{"added": {}}]	14	1
1480	2025-08-15 13:49:51.462562+03	7a82197a-aee7-400c-8d63-8d9b9f3be475	Теплосчётчик Ридан РУТ-01 Канал 1 Суточный -- adress: 31  channel: 0	1	[{"added": {}}]	14	1
1481	2025-08-15 13:50:38.344431+03	89a38afd-9b1c-4c57-b851-95e3a49205be	Теплосчётчик Ридан РУТ-01 Канал 2 Суточный -- adress: 32  channel: 0	1	[{"added": {}}]	14	1
1482	2025-08-15 13:51:13.296098+03	63f8d3c1-15f7-4fdc-954a-f4c080e36b3b	Теплосчётчик Ридан РУТ-01 Канал 3 Суточный -- adress: 33  channel: 0	1	[{"added": {}}]	14	1
1483	2025-08-15 13:51:50.116648+03	626464e3-25f7-46e2-9b7c-c7400858b783	Теплосчётчик Ридан РУТ-01 Канал 4 Суточный -- adress: 34  channel: 0	1	[{"added": {}}]	14	1
1484	2025-08-15 13:53:52.878558+03	de41dc3f-d837-4772-a142-99f49b8dd5f7	Теплосчётчик Ридан РУТ-01 Error_code Суточный -- adress: 24  channel: 0	1	[{"added": {}}]	14	1
1485	2025-08-15 14:26:57.434129+03	2dedf3cf-05f1-4c30-ab6e-e51315136d17	Водосчётчик Ридан СГВ-15 Объем_входящий Суточный -- adress: 0  channel: 3	1	[{"added": {}}]	14	1
1486	2025-08-15 14:27:31.211351+03	e676cd88-ef85-4d3c-852e-14627b7c056b	Водосчётчик Ридан СГВ-15 Объем_выходящий Суточный -- adress: 0  channel: 4	1	[{"added": {}}]	14	1
1487	2025-08-15 14:28:07.850029+03	bf418620-56a2-4490-a5c2-856b62a2b1a0	Водосчётчик Ридан СГВ-15 magnet_time Суточный -- adress: 0  channel: 5	1	[{"added": {}}]	14	1
1488	2025-08-15 14:28:34.873604+03	3fc2ea8f-237a-42ec-8f2f-d1b69e170ae4	Водосчётчик Ридан СГВ-15 magnet_flag Суточный -- adress: 0  channel: 6	1	[{"added": {}}]	14	1
1489	2025-08-19 15:16:17.366147+03	3a32cec9-d03a-4e46-a065-f81f92e5ead0	Взлёт	1	[{"added": {}}]	22	1
1490	2025-08-19 16:47:45.618209+03	0df5bd35-8a69-47da-9e28-2d7f3b492926	Взлёт Объем_1 Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1491	2025-08-19 16:48:11.667122+03	50c593c1-ab75-47c8-9c5c-da13713fcaf0	Взлёт Объем_2 Суточный -- adress: 8  channel: 2	1	[{"added": {}}]	14	1
1492	2025-08-19 16:49:03.783673+03	554ecd96-18c4-4f9f-9cee-305764cbcbc5	Взлёт Объем_3 Суточный -- adress: 8  channel: 3	1	[{"added": {}}]	14	1
1493	2025-08-19 16:49:40.076899+03	3702fc3a-7a0a-4cad-8d1c-a702d950b4af	Взлёт Объем_4 Суточный -- adress: 8  channel: 4	1	[{"added": {}}]	14	1
1494	2025-08-19 16:50:08.929223+03	9656b53b-49a7-4ff9-8694-dc8a5d95a3dd	Взлёт Объем_5 Суточный -- adress: 8  channel: 5	1	[{"added": {}}]	14	1
1495	2025-08-19 16:51:04.141364+03	d1216f4e-35ad-4aa3-92dd-d5b8d576e9b7	Взлёт Объем_6 Суточный -- adress: 8  channel: 6	1	[{"added": {}}]	14	1
1496	2025-08-19 16:52:34.594349+03	75a548d8-04bf-48a0-a18a-f70c8d2aefbe	Взлёт Энергия_1 Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1497	2025-08-19 16:53:08.231384+03	39b248ca-4928-4a69-958b-88c1b0aefa0f	Взлёт Энергия_2 Суточный -- adress: 7  channel: 2	1	[{"added": {}}]	14	1
1498	2025-08-19 16:53:40.689498+03	fcbc58c0-631d-47b7-b200-a3a7036908f0	Взлёт Энергия_3 Суточный -- adress: 7  channel: 3	1	[{"added": {}}]	14	1
1499	2025-08-19 16:54:11.748831+03	06fa9df2-c671-484d-a48a-18251f0a010f	Взлёт Энергия_4 Суточный -- adress: 7  channel: 4	1	[{"added": {}}]	14	1
1500	2025-08-19 16:55:00.161627+03	f6f28d56-84bd-4cbc-8173-3ed85460093c	Взлёт Температура_1 Суточный -- adress: 2  channel: 1	1	[{"added": {}}]	14	1
1501	2025-08-19 16:55:41.217491+03	14645b7c-087d-4281-9bb8-8f7570311fb9	Взлёт Температура_2 Суточный -- adress: 2  channel: 2	1	[{"added": {}}]	14	1
1502	2025-08-19 16:56:05.119658+03	8495f818-7c32-48fb-8c20-4283c20a4700	Взлёт Температура_3 Суточный -- adress: 2  channel: 3	1	[{"added": {}}]	14	1
1503	2025-08-19 16:56:25.638059+03	9fb2b75e-904a-488a-9f83-7d79233c0bc9	Взлёт Температура_4 Суточный -- adress: 2  channel: 4	1	[{"added": {}}]	14	1
1504	2025-08-19 16:56:46.951226+03	60001591-c938-4053-b3cc-91ae789dd715	Взлёт Температура_5 Суточный -- adress: 2  channel: 5	1	[{"added": {}}]	14	1
1505	2025-08-19 16:57:10.958805+03	f54bb4f3-cae9-4d4e-af2f-769f13a1b200	Взлёт Температура_6 Суточный -- adress: 2  channel: 6	1	[{"added": {}}]	14	1
1506	2025-08-22 11:55:54.648137+03	3a32cec9-d03a-4e46-a065-f81f92e5ead0	ВЗЛЕТ ТСР-М ТСРВ-043	2	[{"changed": {"fields": ["Name"]}}]	22	1
1507	2025-08-22 11:59:09.625347+03	30936305-66a6-4459-b7d0-9c3ea8e2ba12	ВЗЛЕТ ТСР-М ТСРВ-024М	1	[{"added": {}}]	22	1
1508	2025-08-22 12:13:40.557986+03	fcbc58c0-631d-47b7-b200-a3a7036908f0	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_3 Суточный -- adress: 7  channel: 3	2	[]	14	1
1509	2025-08-22 12:17:53.789755+03	ec6fc0ca-5f75-4ad7-96b2-e66aee490d7e	ВЗЛЕТ ТСР-М ТСРВ-024М Энергия_1 Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1510	2025-08-22 12:19:44.086387+03	f6f28d56-84bd-4cbc-8173-3ed85460093c	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_1 Суточный -- adress: 2  channel: 1	2	[]	14	1
1511	2025-08-22 12:19:51.57013+03	f54bb4f3-cae9-4d4e-af2f-769f13a1b200	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_6 Суточный -- adress: 2  channel: 6	2	[]	14	1
1512	2025-08-22 12:20:00.034644+03	d1216f4e-35ad-4aa3-92dd-d5b8d576e9b7	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_6 Суточный -- adress: 8  channel: 6	2	[]	14	1
1513	2025-08-22 12:20:03.038467+03	9656b53b-49a7-4ff9-8694-dc8a5d95a3dd	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_5 Суточный -- adress: 8  channel: 5	2	[]	14	1
1514	2025-08-22 12:20:05.744583+03	75a548d8-04bf-48a0-a18a-f70c8d2aefbe	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_1 Суточный -- adress: 7  channel: 1	2	[]	14	1
1515	2025-08-22 12:20:08.233339+03	554ecd96-18c4-4f9f-9cee-305764cbcbc5	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_3 Суточный -- adress: 8  channel: 3	2	[]	14	1
1516	2025-08-22 12:20:11.604992+03	39b248ca-4928-4a69-958b-88c1b0aefa0f	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_2 Суточный -- adress: 7  channel: 2	2	[]	14	1
1517	2025-08-22 12:20:14.10108+03	3702fc3a-7a0a-4cad-8d1c-a702d950b4af	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_4 Суточный -- adress: 8  channel: 4	2	[]	14	1
1518	2025-08-22 12:20:16.886655+03	0df5bd35-8a69-47da-9e28-2d7f3b492926	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_1 Суточный -- adress: 8  channel: 1	2	[]	14	1
1519	2025-08-22 12:20:19.698488+03	14645b7c-087d-4281-9bb8-8f7570311fb9	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_2 Суточный -- adress: 2  channel: 2	2	[]	14	1
1520	2025-08-22 12:20:26.020135+03	9fb2b75e-904a-488a-9f83-7d79233c0bc9	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_4 Суточный -- adress: 2  channel: 4	2	[]	14	1
1521	2025-08-22 12:20:28.613042+03	8495f818-7c32-48fb-8c20-4283c20a4700	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_3 Суточный -- adress: 2  channel: 3	2	[]	14	1
1522	2025-08-22 12:20:31.429212+03	60001591-c938-4053-b3cc-91ae789dd715	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_5 Суточный -- adress: 2  channel: 5	2	[]	14	1
1523	2025-08-22 12:20:33.694643+03	50c593c1-ab75-47c8-9c5c-da13713fcaf0	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_2 Суточный -- adress: 8  channel: 2	2	[]	14	1
1524	2025-08-22 12:20:36.147402+03	06fa9df2-c671-484d-a48a-18251f0a010f	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_4 Суточный -- adress: 7  channel: 4	2	[]	14	1
1525	2025-08-22 12:35:12.394655+03	cae77cb0-740f-4f0f-973b-4699f5a353b6	ВЗЛЕТ ТСР-М ТСРВ-024М Масса_1 Суточный -- adress: 9  channel: 1	1	[{"added": {}}]	14	1
1526	2025-08-22 12:48:35.763601+03	c7d5aa55-10da-4075-bfa3-1b79ae924b1b	ВЗЛЕТ ТСР-М ТСРВ-024М Энергия_2 Суточный -- adress: 7  channel: 2	1	[{"added": {}}]	14	1
1527	2025-08-22 12:48:59.117256+03	39d45f5f-f758-48cc-b55f-97a534114ffc	ВЗЛЕТ ТСР-М ТСРВ-024М Энергия_3 Суточный -- adress: 7  channel: 3	1	[{"added": {}}]	14	1
1528	2025-08-22 12:49:22.385825+03	3044cce6-0653-4fd4-9384-159d570abd27	ВЗЛЕТ ТСР-М ТСРВ-024М Масса_2 Суточный -- adress: 9  channel: 2	1	[{"added": {}}]	14	1
1529	2025-08-22 12:49:41.802499+03	ba655bde-5621-4da9-a642-7542e73550fa	ВЗЛЕТ ТСР-М ТСРВ-024М Масса_3 Суточный -- adress: 9  channel: 3	1	[{"added": {}}]	14	1
1530	2025-08-22 13:37:40.144567+03	4d85e9a5-513e-419c-a02e-3e6ba79eafa7	ВЗЛЕТ МР УРСВ-311	1	[{"added": {}}]	22	3
1531	2025-08-22 13:54:26.846517+03	56aefad0-0058-4ee2-95fe-aaf02e54c4ca	ВЗЛЕТ МР УРСВ-311 Объем_входящий Суточный -- adress: 0  channel: 3	1	[{"added": {}}]	14	3
1532	2025-09-08 12:55:38.555977+03	0a5753cf-debd-45cb-8dd0-3905f36293fc	Водосчётчик Ридан СГВ-15 ГВС	2	[{"changed": {"fields": ["Name"]}}]	22	3
1533	2025-09-08 12:56:10.779572+03	e676cd88-ef85-4d3c-852e-14627b7c056b	Водосчётчик Ридан СГВ-15 ГВС Объем_выходящий Суточный -- adress: 0  channel: 4	2	[]	14	3
1534	2025-09-08 12:56:17.283005+03	bf418620-56a2-4490-a5c2-856b62a2b1a0	Водосчётчик Ридан СГВ-15 ГВС magnet_time Суточный -- adress: 0  channel: 5	2	[]	14	3
1535	2025-09-08 12:56:24.363415+03	3fc2ea8f-237a-42ec-8f2f-d1b69e170ae4	Водосчётчик Ридан СГВ-15 ГВС magnet_flag Суточный -- adress: 0  channel: 6	2	[]	14	3
1536	2025-09-08 12:56:35.965615+03	2dedf3cf-05f1-4c30-ab6e-e51315136d17	Водосчётчик Ридан СГВ-15 ГВС Объем_входящий Суточный -- adress: 0  channel: 3	2	[]	14	3
1537	2025-09-08 13:03:39.582709+03	b060fcdd-f52d-4914-9dca-2fbcc2a205d5	Водосчётчик Ридан СГВ-15 ХВС	1	[{"added": {}}]	22	3
1538	2025-09-08 15:59:44.74603+03	df15cfb8-8baa-4755-8f98-b0467efd18cf	Водосчётчик Ридан СГВ-15 ХВС Объем_входящий Суточный -- adress: 0  channel: 3	1	[{"added": {}}]	14	3
1539	2025-09-08 16:01:30.454483+03	89070715-65ca-42f2-90df-347039eee95d	Водосчётчик Ридан СГВ-15 ХВС Объем_выходящий Суточный -- adress: 0  channel: 4	1	[{"added": {}}]	14	3
1540	2025-09-08 16:02:46.357199+03	0918da1d-27b8-43bf-ad9e-8a78645d9440	Водосчётчик Ридан СГВ-15 ХВС magnet_time Суточный -- adress: 0  channel: 5	1	[{"added": {}}]	14	3
1541	2025-09-08 16:03:44.71574+03	0db11f70-373f-4bae-beb9-5d1e7afdda81	Водосчётчик Ридан СГВ-15 ХВС magnet_flag Суточный -- adress: 0  channel: 6	1	[{"added": {}}]	14	3
1542	2025-09-09 09:21:11.367473+03	4d85e9a5-513e-419c-a02e-3e6ba79eafa7	ВЗЛЕТ МР УРСВ-311 ГВС	2	[{"changed": {"fields": ["Name"]}}]	22	3
1543	2025-09-09 09:21:33.765428+03	56aefad0-0058-4ee2-95fe-aaf02e54c4ca	ВЗЛЕТ МР УРСВ-311 ГВС Объем_входящий Суточный -- adress: 0  channel: 3	2	[]	14	3
1544	2025-09-09 09:30:01.604795+03	af871462-2104-491d-9a83-e7dcd77364b1	ВЗЛЕТ МР УРСВ-311 ХВС	1	[{"added": {}}]	22	3
1545	2025-09-09 09:38:56.994871+03	9e16351b-6725-4887-bbba-cb28418e25c0	ВЗЛЕТ МР УРСВ-311 ХВС Объем_входящий Суточный -- adress: 0  channel: 3	1	[{"added": {}}]	14	3
1546	2025-09-09 10:09:09.886789+03	ee75f601-4915-4a7f-9634-af8b04dd9110	Водосчётчик Ридан СГВ-15 ГВС 58211776 - 58211776	3		12	3
1547	2025-09-09 10:09:09.890782+03	06bcd239-05f0-4515-984d-3bf2ad890f80	Водосчётчик Ридан СГВ-15 ХВС 58211781 - 58211781	3		12	3
1548	2025-09-09 10:09:26.553084+03	bcaa389c-47b7-4814-b7dd-536552417039	Стенд	3		25	3
1549	2025-09-09 10:09:26.555084+03	36d900ea-5b20-4bda-a3bf-71adb407f6aa	Ридан	3		25	3
1550	2025-10-03 14:00:58.130074+03	ca55f589-3fed-48a2-b835-8bf5263f892e	Толстопальцево	3		25	3
1551	2025-10-03 14:00:58.134039+03	30f9ca1e-4865-45df-99c9-e1e81d063ab7	Экспериментальный завод	3		25	3
1552	2025-12-08 14:47:14.167639+03	d5417782-4ea5-4bfb-bc3f-21e8e7868aa9	Пульсар ГВС ГВС_current_error Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
1553	2025-12-08 14:47:58.732885+03	649603aa-93a8-44df-ba55-e15e3bf44c0e	Пульсар ГВС ГВС_accumulated_error Суточный -- adress: 1  channel: 0	1	[{"added": {}}]	14	1
1554	2025-12-08 14:48:35.440207+03	6ca83dce-dcc9-4e2d-94ca-e22ec855a65d	Пульсар ХВС ХВС_current_error Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
1555	2025-12-08 14:49:02.145379+03	3c066109-31bf-4256-83de-40ccd02e20fd	Пульсар ХВС ХВС_accumulated_error Суточный -- adress: 1  channel: 0	1	[{"added": {}}]	14	1
1556	2025-12-08 14:50:42.7944+03	e5a3a4d1-4cc4-4d4e-b7c3-51e370007bfc	ВЗЛЕТ МР УРСВ-311 ХВС 55555 - 55555	3		12	1
1557	2025-12-08 14:50:42.798552+03	cb1576c8-0446-4124-9f59-89a6bf0f8cb8	ВЗЛЕТ МР УРСВ-311 ГВС 55556 - 55556	3		12	1
1558	2025-12-08 14:50:42.800782+03	b9e5061c-6f9a-48d3-ab8b-3fc293fa3d8c	Теплосчётчик Ридан РУТ-01 23230759 - 23230759	3		12	1
1559	2025-12-08 14:50:42.802706+03	b2bedc5d-52b4-4ad8-8bb7-63c474230458	Теплосчётчик Ридан РУТ-01 21215005 - 21215005	3		12	1
1560	2025-12-08 14:50:42.80471+03	a6f34445-5db1-4906-83c4-ddfc6ece4dfa	Теплосчётчик Ридан РУТ-01 21215008 - 21215008	3		12	1
1561	2025-12-08 14:50:42.807218+03	6ab3b828-f3e9-422c-aa0c-611e5e200930	Теплосчётчик Ридан РУТ-01 23230764 - 23230764	3		12	1
1562	2025-12-08 14:50:42.808999+03	5d1bd70c-62ee-4a9a-8fc2-798b6e7e7da8	Теплосчётчик Ридан РУТ-01 21216672 - 21216672	3		12	1
1563	2025-12-08 14:50:42.810364+03	48c73657-7466-45e9-996b-42cb4a6d3d53	Теплосчётчик Ридан РУТ-01 21216733 - 21216733	3		12	1
1564	2025-12-08 14:50:42.812663+03	35e4464b-9c4e-4559-921e-72056b1183d3	Водосчётчик Ридан СГВ-15 ХВС 58211781 - 58211781	3		12	1
1565	2025-12-08 14:50:42.813889+03	049dd1a6-f96e-4477-962d-28d09cb583ca	Водосчётчик Ридан СГВ-15 ГВС 58211776 - 58211776	3		12	1
1566	2025-12-08 14:57:51.940783+03	b0874ed1-0596-42df-9100-f0cd54ba08a6	Ридан	3		25	1
1567	2025-12-08 14:57:51.945342+03	9149eb0e-17d7-4191-9dc6-0ed76e9f5f81	Стенд	3		25	1
1568	2026-01-27 22:26:09.013904+03	84244574-8fee-47a6-a546-15b01c82f778	CE308 СПОДЭС	1	[{"added": {}}]	22	1
1569	2026-01-27 22:27:25.08985+03	634d9f9a-a7f2-479e-9904-147cfa800ccc	Нартис СПОДЭС T1 A+ Суточный -- adress: 0  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1570	2026-01-27 22:27:36.38064+03	949b3f73-a0bb-4037-8f13-cb30c815c226	Нартис СПОДЭС T2 A+ Суточный -- adress: 0  channel: 2	2	[{"changed": {"fields": ["Name"]}}]	14	1
1571	2026-01-27 22:27:50.114887+03	14ba0cf1-d4c6-40d6-a70c-9ecdd2c73050	Нартис СПОДЭС T3 A+ Суточный -- adress: 0  channel: 3	2	[{"changed": {"fields": ["Name"]}}]	14	1
1572	2026-01-27 22:28:07.738552+03	eac09f54-2365-4cc9-a4cc-cd375d3b5039	Нартис СПОДЭС T4 A+ Суточный -- adress: 0  channel: 4	2	[{"changed": {"fields": ["Name"]}}]	14	1
1573	2026-01-27 22:29:32.108863+03	58d49e69-c779-4e5a-98bf-f598c833ce3e	CE308 СПОДЭС T0 A+ Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
1574	2026-01-27 22:30:05.078228+03	f27e1847-ff1c-417c-8e3e-4c653f3dc72e	CE308 СПОДЭС T1 A+ Суточный -- adress: 0  channel: 1	1	[{"added": {}}]	14	1
1575	2026-01-27 22:30:54.387748+03	22e995cc-a170-43b7-9cd4-e3da4ea28ace	CE308 СПОДЭС T2 A+ Суточный -- adress: 0  channel: 2	1	[{"added": {}}]	14	1
1576	2026-01-27 22:31:36.050853+03	dfbc97bc-1d20-491e-97ad-8dced70f1ac7	CE308 СПОДЭС T3 A+ Суточный -- adress: 0  channel: 3	1	[{"added": {}}]	14	1
1577	2026-01-27 22:31:46.685803+03	dfbc97bc-1d20-491e-97ad-8dced70f1ac7	CE308 СПОДЭС T3 A+ Суточный -- adress: 0  channel: 3	2	[]	14	1
1578	2026-01-29 01:05:24.150248+03	2d99741f-b22e-4926-af61-056e956b24b0	МИРТЕК-32-РУ-D37	1	[{"added": {}}]	22	1
1579	2026-05-06 19:45:11.880161+03	a91aa386-0de1-4dd3-a702-db980e788fcd	Пульсар 405 Теплосчётчик	1	[{"added": {}}]	22	1
1580	2026-05-06 19:49:37.456603+03	0688928a-bf26-4aa8-8e50-e3fe31f8ae8c	Пульсар 405 Теплосчётчик Ti Суточный -- adress: 3  channel: 1	1	[{"added": {}}]	14	1
1581	2026-05-06 19:50:39.794677+03	0ee60478-1024-4281-a9f7-0e93f118d8d9	Пульсар 405 Теплосчётчик To Суточный -- adress: 4  channel: 1	1	[{"added": {}}]	14	1
1582	2026-05-06 19:51:25.819465+03	ab892f72-f26c-40c4-bf4f-c5f81fb16ecb	Пульсар 405 Теплосчётчик Объем Суточный -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1583	2026-05-06 19:51:50.854513+03	9036e603-7b32-4759-8653-4eb48535bd6c	Пульсар 405 Теплосчётчик Энергия Суточный -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1584	2026-05-18 14:26:33.120085+03	c19d784b-119c-4bee-a0cb-92bddc4b1d55	Gi	1	[{"added": {}}]	13	1
1585	2026-05-18 14:34:42.17063+03	f1dc85e8-5d13-4517-96e1-3c748a209c0d	Go	1	[{"added": {}}]	13	1
1586	2026-05-18 15:26:43.50954+03	f8f102ff-1374-4180-8709-2b97a5161b22	ат	1	[{"added": {}}]	11	1
1587	2026-05-18 15:29:16.560381+03	679fed74-2097-47b7-a928-cdd1577b509f	Pi	1	[{"added": {}}]	13	1
1588	2026-05-18 15:29:37.681485+03	067fb77b-d21c-4f28-ae05-4063514c6192	Po	1	[{"added": {}}]	13	1
1589	2026-06-16 14:12:40.21846+03	72f7e34e-a6e7-4ab7-a72f-eb391220662a	Пульсар 405 Теплосчётчик Gi Суточный -- adress: 9  channel: 1	1	[{"added": {}}]	14	1
1590	2026-06-16 14:14:17.437614+03	fb9c55b4-cb27-4f20-aa2c-b25b7d18c73d	Пульсар 405 Теплосчётчик Go Суточный -- adress: 10  channel: 1	1	[{"added": {}}]	14	1
1591	2026-06-16 14:15:50.334859+03	6766e7ad-dd9c-445e-b163-e2a06b408313	Пульсар 405 Теплосчётчик Pi Суточный -- adress: 11  channel: 1	1	[{"added": {}}]	14	1
1592	2026-06-16 14:16:58.081407+03	0d534194-dc81-4500-b7b5-0ea8162777e4	Пульсар 405 Теплосчётчик Po Суточный -- adress: 12  channel: 0	1	[{"added": {}}]	14	1
1593	2026-06-16 14:17:22.266965+03	0d534194-dc81-4500-b7b5-0ea8162777e4	Пульсар 405 Теплосчётчик Po Суточный -- adress: 12  channel: 1	2	[{"changed": {"fields": ["Channel"]}}]	14	1
1594	2026-06-16 14:26:22.710738+03	330217e8-78e2-4a3d-b257-ea2e6c617213	operating_hours	1	[{"added": {}}]	13	1
1595	2026-06-16 14:29:01.754569+03	bd26a158-e8cf-4038-b7c9-e0b6b6d3dc93	Пульсар 405 Теплосчётчик operating_hours Суточный -- adress: 13  channel: 1	1	[{"added": {}}]	14	1
1596	2026-06-29 15:12:01.914615+03	ce1acf72-1660-4fee-bedf-a36777a41702	Вис.Т	1	[{"added": {}}]	22	1
1597	2026-06-29 15:43:12.589035+03	a2966e59-3ba9-48d8-a886-d27b9003bfa1	Часовой	1	[{"added": {}}]	23	1
1598	2026-06-29 15:44:31.090604+03	4f50e1c1-f7f7-43f3-befd-748e78fba47e	Вис.Т Энергия Часовой -- adress: 7  channel: 1	1	[{"added": {}}]	14	1
1599	2026-06-29 15:48:11.569034+03	a01b2e7c-84ec-42c5-b872-fe6e4ebc8684	Вис.Т Объем Часовой -- adress: 8  channel: 1	1	[{"added": {}}]	14	1
1600	2026-06-29 15:49:36.480072+03	fbe43c67-122a-4155-a3de-ffe6cee4e60a	Вис.Т Ti Часовой -- adress: 3  channel: 1	1	[{"added": {}}]	14	1
1601	2026-06-29 15:50:19.225053+03	db5aa6d6-84fe-4294-8765-8ae334bff927	Вис.Т To Часовой -- adress: 4  channel: 1	1	[{"added": {}}]	14	1
1602	2026-06-29 15:51:33.752735+03	970096c6-0923-402e-92de-b75494a32ffa	Вис.Т Gi Часовой -- adress: 9  channel: 1	1	[{"added": {}}]	14	1
1603	2026-06-29 15:58:02.180782+03	e2618b23-8db2-4d6b-8ea1-adb413aa43b7	Вис.Т Go Часовой -- adress: 10  channel: 1	1	[{"added": {}}]	14	1
1604	2026-06-29 15:59:06.290852+03	20bf2a30-421f-4e3b-bd70-2028a0ccbc52	Вис.Т Pi Часовой -- adress: 11  channel: 1	1	[{"added": {}}]	14	1
1605	2026-06-29 15:59:54.830304+03	1a8dcaa6-a726-4b3b-aaed-3222d58f4887	Вис.Т Po Часовой -- adress: 12  channel: 1	1	[{"added": {}}]	14	1
1606	2026-06-29 16:00:51.909992+03	a2962079-6df5-4e8f-bcec-a9cf2905afff	Вис.Т operating_hours Часовой -- adress: 13  channel: 1	1	[{"added": {}}]	14	1
1607	2026-06-30 15:12:23.718308+03	ce1acf72-1660-4fee-bedf-a36777a41702	Вис.Т-ТС	2	[{"changed": {"fields": ["Name"]}}]	22	1
1608	2026-06-30 15:12:39.322265+03	fbe43c67-122a-4155-a3de-ffe6cee4e60a	Вис.Т-ТС Ti Часовой -- adress: 3  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1609	2026-06-30 15:12:46.487735+03	e2618b23-8db2-4d6b-8ea1-adb413aa43b7	Вис.Т-ТС Go Часовой -- adress: 10  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1610	2026-06-30 15:12:53.082215+03	db5aa6d6-84fe-4294-8765-8ae334bff927	Вис.Т-ТС To Часовой -- adress: 4  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1611	2026-06-30 15:13:14.978064+03	a2962079-6df5-4e8f-bcec-a9cf2905afff	Вис.Т-ТС operating_hours Часовой -- adress: 13  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1612	2026-06-30 15:13:26.038714+03	a01b2e7c-84ec-42c5-b872-fe6e4ebc8684	Вис.Т-ТС Объем Часовой -- adress: 8  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1613	2026-06-30 15:13:36.90198+03	970096c6-0923-402e-92de-b75494a32ffa	Вис.Т-ТС Gi Часовой -- adress: 9  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1614	2026-06-30 15:13:45.622767+03	4f50e1c1-f7f7-43f3-befd-748e78fba47e	Вис.Т-ТС Энергия Часовой -- adress: 7  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1615	2026-06-30 15:13:53.002454+03	20bf2a30-421f-4e3b-bd70-2028a0ccbc52	Вис.Т-ТС Pi Часовой -- adress: 11  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1616	2026-06-30 15:14:02.771952+03	1a8dcaa6-a726-4b3b-aaed-3222d58f4887	Вис.Т-ТС Po Часовой -- adress: 12  channel: 1	2	[{"changed": {"fields": ["Name"]}}]	14	1
1617	2026-09-15 23:49:18.271574+03	bf98a5cd-963b-403d-80e5-d0577bf45741	Энергомера СЕ102 R51	1	[{"added": {}}]	22	1
1618	2026-09-15 23:59:07.586396+03	41280140-8377-4be1-a242-e520d193ee5b	Энергомера СЕ102 R51 T0 A+ Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
1619	2026-09-16 00:05:42.716984+03	539d0465-23b5-4474-b519-1a0549d31183	Энергомера СЕ102 R51 T1 A+ Суточный -- adress: 0  channel: 1	1	[{"added": {}}]	14	1
1620	2026-09-16 00:07:02.804345+03	eca9377e-8e12-4e69-af38-5e0f5179521d	Энергомера СЕ102 R51 T2 A+ Суточный -- adress: 0  channel: 2	1	[{"added": {}}]	14	1
1621	2026-09-16 00:09:00.264031+03	a00d116f-6497-4f18-97e4-d432d7812693	Энергомера СЕ102 R51 T3 A+ Суточный -- adress: 0  channel: 3	1	[{"added": {}}]	14	1
1622	2026-09-30 00:39:02.635437+03	91d05ae9-925e-45ab-9c4e-fc9b1ad96499	CE207 СПОДЭС	1	[{"added": {}}]	22	1
1623	2026-09-30 00:41:53.712414+03	b788cff3-da11-4f60-8d55-2441d183637e	CE207 СПОДЭС T0 A+ Суточный -- adress: 0  channel: 0	1	[{"added": {}}]	14	1
1624	2026-09-30 00:43:10.768027+03	bb4ce9e8-2586-4d12-9c5a-3d3e834b26f3	CE207 СПОДЭС T1 A+ Суточный -- adress: 0  channel: 1	1	[{"added": {}}]	14	1
1625	2026-09-30 00:44:29.443339+03	3a62764f-1da9-4ce1-a05d-7c4ff6c26271	CE207 СПОДЭС T2 A+ Суточный -- adress: 0  channel: 2	1	[{"added": {}}]	14	1
1626	2026-09-30 00:45:29.246314+03	32c9f65b-43f9-4593-9b0d-652e490d004b	CE207 СПОДЭС T3 A+ Суточный -- adress: 0  channel: 3	1	[{"added": {}}]	14	1
\.


--
-- TOC entry 3806 (class 0 OID 156038)
-- Dependencies: 246
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	general	abonents
8	general	balancegroups
9	general	comportsettings
10	general	groups80020
11	general	measurement
12	general	meters
13	general	namesparams
14	general	params
15	general	productcoefficientskilns
16	general	productinfokilns
17	general	producttypekilns
18	general	resources
19	general	takenparams
20	general	tcpipsettings
21	general	typesabonents
22	general	typesmeters
23	general	typesparams
24	general	variousvalues
25	general	objects
26	general	monthlyvalues
27	general	linkmeterstcpipsettings
28	general	linkmeterscomportsettings
29	general	linkgroups80020meters
30	general	linkbalancegroupsmeters
31	general	linkabonentstakenparams
32	general	linkabonentsauthuser
33	general	dailyvalues
34	general	currentvaluesarchive
35	general	currentvalues
36	general	comments
37	general	reportconfig
\.


--
-- TOC entry 3808 (class 0 OID 156042)
-- Dependencies: 248
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2020-09-16 15:52:52.257202+03
2	auth	0001_initial	2020-09-16 15:52:52.364208+03
3	admin	0001_initial	2020-09-16 15:52:52.485215+03
4	admin	0002_logentry_remove_auto_add	2020-09-16 15:52:52.534218+03
5	admin	0003_logentry_add_action_flag_choices	2020-09-16 15:52:52.546218+03
6	contenttypes	0002_remove_content_type_name	2020-09-16 15:52:52.629223+03
7	auth	0002_alter_permission_name_max_length	2020-09-16 15:52:52.641224+03
8	auth	0003_alter_user_email_max_length	2020-09-16 15:52:52.653224+03
9	auth	0004_alter_user_username_opts	2020-09-16 15:52:52.664225+03
10	auth	0005_alter_user_last_login_null	2020-09-16 15:52:52.676226+03
11	auth	0006_require_contenttypes_0002	2020-09-16 15:52:52.679226+03
12	auth	0007_alter_validators_add_error_messages	2020-09-16 15:52:52.690227+03
13	auth	0008_alter_user_username_max_length	2020-09-16 15:52:52.719228+03
14	auth	0009_alter_user_last_name_max_length	2020-09-16 15:52:52.731229+03
15	auth	0010_alter_group_name_max_length	2020-09-16 15:52:52.74523+03
16	auth	0011_update_proxy_permissions	2020-09-16 15:52:52.75623+03
17	general	0001_initial	2020-09-16 15:52:53.412268+03
18	sessions	0001_initial	2020-09-16 15:52:53.80429+03
19	auth	0012_alter_user_first_name_max_length	2020-10-08 15:12:49.340384+03
20	general	0002_auto_20201008_1512	2020-10-08 15:12:49.456706+03
21	general	0002_auto_20210115_1355	2021-02-08 16:05:24.407105+03
22	general	0003_auto_20260727_1513	2026-07-27 15:35:18.501214+03
23	general	0004_auto_20260727_1542	2026-07-27 15:42:12.672861+03
\.


--
-- TOC entry 3810 (class 0 OID 156048)
-- Dependencies: 250
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
ktfnmteknsne29h8dwpxtzcwf18o1cxa	MzRlMDIyOTJhYThjYjZkOTIwMzcyOGJiNmQ1Y2QyNDZhYjM3NjY4MTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJhMDNlZTIzODNjYjJhZDBjZjA5NGI4NTNmYmFlZmU5Yzk1ZGZmOWFiIiwiY2hvaWNlX2ZpbGUiOiJlbGVjdHJpY190ZW1wbGF0ZV9mb3JfbG9hZCAoMSkueGxzeCIsImNob2ljZV9zaGVldCI6IkVsZWN0cl9rMSIsInRjcF9pcF9zdGF0dXMiOiIiLCJvYmplY3Rfc3RhdHVzIjoiIiwiY291bnRlcl9zdGF0dXMiOiIiLCJvYmpfdGl0bGUiOiIzODEzNjI0MyIsIm9ial9rZXkiOiJtZXRlci0wIiwib2JqX3BhcmVudF90aXRsZSI6Ilx1MDQxYVx1MDQzMlx1MDQzMFx1MDQ0MFx1MDQ0Mlx1MDQzOFx1MDQ0MFx1MDQzMCAwMDAyIiwiaXNfZWxlY3RyaWNfbW9udGhseSI6IjAiLCJpc19lbGVjdHJpY19kYWlseSI6IjEiLCJlbGVjdHJpY19kYXRhX3N0YXJ0IjoiMTcuMDkuMjAyMCIsImVsZWN0cmljX2RhdGFfZW5kIjoiMTcuMDkuMjAyMCIsImlzX2VsZWN0cmljX3BlcmlvZCI6IjAifQ==	2020-10-01 16:48:16.864984+03
965ax4jeiyufn1ecfp1287avdm0wghhh	.eJxtjUEKAjEMRe-StQ5tOop4FqHUmYDV2g6dKIh4d010UdTNX7y8196h7I-eIyeCLewuprcoi0bXwUKFE91e50RXSri0HziFSpn_xE7jXte9yUY3KJc-zp4SDVzj4M8l8yHJB-brMoaoXIoGcvAzh8pSrDprOzRofhTKowjrRmjfnqjGogY8ntZ5UbM:1kaxFe:Awe_HyDnlzD3LBmn7ZQ-4ii-5QHkzANK_3YTdCqXktU	2020-11-20 11:37:42.900314+03
cgfavosrucqeiq19aldkcb7ddyhrdv8a	.eJxVjMEOwiAQRP-FsyG7UErr0Xu_gSwsSNXQpLQn479Lkx40c5v3Zt7C0b5lt9e4upnFVaC4_HaewjOWA_CDyn2RYSnbOnt5KPKkVU4Lx9ftdP8OMtXc1t3IwfcGwLBCbf2gDKMF0hQpBJ0aahmV7lAR6AF7CxyQE0LyGo34fAHD8Dbj:1kaylU:XZDQ5HnwehxwSb_afcRTg_d2riJ6yJ3Dd_QYI9l_WzU	2020-11-20 13:14:40.955486+03
fh9njblfy39d6jynxlt0g8wayur4oo1z	.eJytVNuOmzAQ_ZWK59SdGY9vfex7v2AbIQNOwy4NESFVq6r_3jGhSrJdaVUWIQ1mLofjczC_ijKex315PqWhbJviY4HF5jZXxfopHXKheYyHr72q-8M4tJXKLWquntTnvkndp7n3DmAfT3uZ5tDUlTUApiHUrvJkGnQQdUyxrvVOSnIF0owUQXu0Dpoamx3CrtJoBLSvHsuxHbskcF_OwKhzJJhimBue0k8pd-l76ug9zMljHNJhvB9OOWrMkeO0NlOc1kxZhvZUpi7Vst26_Cbb3ncZG55VmthO-ecT9XnIb31pInVjnPM3MGMsT2Mc8gSRQlAE9G_LxQzAm4Zb7GMa2r6ZwaeBMVZdKtOPY5-hHx7uZyfxdtOe3Y0K4aqFhneYO8USAqRgiw2SUxzAhXABwObDdOPiv59Bidm03bxAi1-lRZkWaJRLu2Jjg_YKgL0nvwIxQlhKTF-JoejF2mkFhOyZ1yAGziwkNiUvdoITcsZzphecAo9g2L2ZHnplnXwcgAsp-qt2JDqKCQJAhmEVU5Fflu7VM0DXM2AzFJmgDBkjZ2GVQ7DUUjITL0Rvghe9yFnFsgSv1-BlOCzk5a4-gvydA1utnIHgrF3DR9C8kFj4-_UDG8Ey1nqFBnSANYiJk7zd_v4DVivoIg:1kVYXv:JKpZQoE57WU5fVA_lRv3-u8bBEwNaG3M6cyaLD70j9o	2020-11-05 14:14:15.840257+03
scimqa5xskwqrhxphbqepqp92gzkxiqs	.eJylUc1uwyAMfpUp5wnZkDTtjrvvDSYhg8lCmyYVIYep6rsPaDR1XW8V0ofl70fYnCtNS-z1MrugPVdvFVavtz1D9uDGTPCexq9J2GmMwRuRJWJlZ_ExsRveV-2fgJ7mPrnrHVuzaQAalqhas5UNYwukyJG1qktUOjupapQEaoubFtgidwidUdik0MnsdfRxcCnuc4EaOaNqXsolM9am1FhqKPUVefUf3PcT7hMFN8anHuEGZ9P-rGaKpK-bRRQIQoKEf4I5UohJIuWNxM_6V3VM39EPeah7hsmXPt717RLyFI8cboj0wHFywU9cDJcfUJGuhQ:1kVcEU:OheC33fvqX4KCSIAIzZpOxt-LClpJEZdMBToS4lAH-g	2020-11-05 18:10:26.604052+03
4s4mgolapiipnn0qjse4e7zq9hzhgz59	.eJxtUMluxCAM_ZecW2Qg2_TYe_-gEjLgNMwwYRRIparqvxeYHNJFlt7hbZb92Sjc0qy2SKtytnlqePNw5DSaCy1FsGdc3gIzYUmr06xY2K5G9hIs-efd-6NgxjjndHuyRvcdQGcFl4MeRWf5ACiR0Bg5ZSnPSciWCwQ58n4Aa7idOExa8i6XBn1WySVPue51g2wsKKCi3A0X-siyp3fy4pHv5A1XWtI_YVnDbUV5Z8aKWPmSd1GRJ5NvNuqab599WQC_FIuu8iVxIBOqmHBNWRE948AECPhjuf9XDAfDsftGqwu2Lv36BsIuh80:1kXM69:CfOPWj1WdPe-g-cn2164Oxlr_Ev_E6vHfhsoGWymHto	2020-11-10 13:21:01.39724+03
7tgo4zvvo32m9mltaio9fmna87pr6urb	.eJxVjMEOwiAQRP-FsyG7UErr0Xu_gSwsSNXQpLQn479Lkx40c5v3Zt7C0b5lt9e4upnFVaC4_HaewjOWA_CDyn2RYSnbOnt5KPKkVU4Lx9ftdP8OMtXc1t3IwfcGwLBCbf2gDKMF0hQpBJ0aahmV7lAR6AF7CxyQE0LyGo34fAHD8Dbj:1kVdZC:Ug3D_mcNdOlmjAPBE5paVhOyzkazEkIoqyVIXD2lRwU	2020-11-05 19:35:54.485205+03
lnuyxqd5ih485xwactoafbhvspx7xfad	.eJxVjMEOwiAQRP-FsyG7UErr0Xu_gSwsSNXQpLQn479Lkx40c5v3Zt7C0b5lt9e4upnFVaC4_HaewjOWA_CDyn2RYSnbOnt5KPKkVU4Lx9ftdP8OMtXc1t3IwfcGwLBCbf2gDKMF0hQpBJ0aahmV7lAR6AF7CxyQE0LyGo34fAHD8Dbj:1kVdZm:58fkGkz1MPqwknSfGxST6MX52RvD4J9eWIyIzD_I4Ow	2020-11-05 19:36:30.872456+03
y40mc0mu8waio5fdhlcq24nkgai9ptpl	.eJxVjMEOwiAQRP-FsyG7UErr0Xu_gSwsSNXQpLQn479Lkx40c5v3Zt7C0b5lt9e4upnFVaC4_HaewjOWA_CDyn2RYSnbOnt5KPKkVU4Lx9ftdP8OMtXc1t3IwfcGwLBCbf2gDKMF0hQpBJ0aahmV7lAR6AF7CxyQE0LyGo34fAHD8Dbj:1kVdcY:VKYnlK8T3XsciMxD8nEsCIFmPpfV3zPC32HYU5N_s6k	2020-11-05 19:39:22.189417+03
zx27co36o87dvq1hcwwmtcnxrj3f72lm	.eJxlUctugzAQ_JXI5xbt2rzSY-_9AyRrsZdC4kAEplJV9d9rGw6kkaXRemZ2dmX_CE2r7_W68KwHK94Eipcj15K58hgFe6Hxc8rMNPp5aLNoyXZ1yT4my-599z4E9LT0oTs_W9OWBUBhJaqqrWVhsQJSxGSM6oIUzlmqHCWBqrGswBq0HULXKixC6NRetB-84xDXrJAjRVQcMYdUd6lWCfGEe9OVv0OL4y928hV28k4zj_4xsNxiT812NYd8TPVhopJPfJ3w3IgwYlg0OzbhqYy-hSfrXdwB_imWhsTHTQ-kJ714mn1QZJkhZBIkPFm2bwE8GI7Zd56HKTnE7x-m_Jea:1kX3u7:QZR5AWr8sgrZsu3HKwP_YtpeGM4JcVi_C8vh0_G4Hqk	2020-11-09 17:55:23.115683+03
p58r5yvofymiq3u0u1l9329eou3wxyjo	.eJxVjMEOwiAQRP-FsyG7UErr0Xu_gSwsSNXQpLQn479Lkx40c5v3Zt7C0b5lt9e4upnFVaC4_HaewjOWA_CDyn2RYSnbOnt5KPKkVU4Lx9ftdP8OMtXc1t3IwfcGwLBCbf2gDKMF0hQpBJ0aahmV7lAR6AF7CxyQE0LyGo34fAHD8Dbj:1kVdei:oV9eP3YGmAqCI_Cca8fBB1wuiwVCRdQzf6pr_0K_lSY	2020-11-05 19:41:36.024308+03
qt0vd0t12u1cdhxu1iqwy23kotuf07z4	.eJx9jstqxDAMRX8leF2M5Mck02X3_YOCkWynyTQkkDirMv8-tjOLtIViuHrcI8nfwtGeBrdvcXVjEK8Cxcu5x-S_4lyMcKP5c5F-mdM6siyIfLqbfF9CnN6e7I8FA21DnjbX4PliAWxQqFvulA3YAmmK5L3us5XfVWmDikB3eGkheAw9Qs8abV4ap-jzae8CJXLHp6CTCFKBgj_AlmhNv5GFby6NaYrZ-NjBYDxrkwMQ1wKKalXUVNUV0r5qdQ3WnI9OU0PX_Ddt7AGdNtXc9OUys7g_AJvfeTc:1kQaMg:XyP_yKAH6TJqSOh_lAsSoQqlEMOsF1Ut-j-6kO9dV0g	2020-10-22 21:10:06.440631+03
xg9u3ez7ieamndi0enreisfwaos37af6	.eJyVUEtOxDAMvUvXENlJO51hyZ4bIEVO7NLMhHbUpEgIcXfSUhCUFbL0ZPl9bPmtsjTn3s5JJhu4uquwuvk5c-QvMiwEn2l4GpUfhzwFpxaJ2tikHkaWeL9pfwX0lPrirk_s3aEBaFijad1RN4wtkCEh701XqFInbWrUBOaIhxbYI3cInTPYlFCJ4stqb5ky2c-jtFYISoOGP4KUacp7yejONoccpRCPM9QoCxpcsKa1b1Zc-1rj5rnIa3FEeZGob7-CrjTJkP-dF5L9vvS5fLOPSzbsGKawzveOq0xh5NXw_gG8fIxU:1kVdgq:ovI9Exszd7r7Zhx9nkuSv1p8X6jLFPvXizXtUhS1iQk	2020-11-05 19:43:48.552932+03
sn0duse4nhoaog0vj9x56zl9vusvda40	.eJztkctuwyAQRX8l8rqlA_iRZNl9vyCN0ADj2olrLBtLrar-e8H2wnks2n2FNDAz954R8JUoHH2lxoF6Vdtkn_DkYV3TaM7UxoY9YfvmmHGt72vNooQt3YG9OEvN86K9AFQ4VMGd7qzReQaQWcFlobcis7wAlEhojCxDK6ydkCkXCHLL8wKs4bbkUGrJswB1-qR87RsKuNcRUgEx8lJspl3EKOdIU0w3fLGd6TOYULuWWv8IS7XDPqQXzJkyk4UMunpQ1JAJVzbqPVy9aiIJrjoW66nOr-pm7OOIew5qPC6OFcajGjz20SEE48AECLiRzB9yIVizO-prZ5ehk8GjbkjRR-ci-nD4y_vJtICskHk4Tjr7NG3pf36TC2DwC1k-y_gd8fH4_QOtmwZ0:1kVeLk:xTSbzUHT_LOB37v2eVTc8cc-nGSs4X4YjeZUz4liOPM	2020-11-05 20:26:04.879944+03
03oi51t42i9765h5c4tdo5ybektxwkos	.eJxlUM1KxDAQfpeeNcwk7Xbr0btvIIRJMrXZjc3SpoKI724Se-gqAx_D9wczX42mLU16W3nR3jVPDTYPR86QvfJcBHeh-S0KG-e0eCOKRezqKl6i4_C8e-8KJlqnnG4HZ82pA-icRNWbs-wc9kCKmKxVY5byDFK1KAnUGU89OItuRBiNwi6XRnPRyafAue51gxZVQQkVh91w5c8sB_7gIB9hJ2-08Jzuw1xQYcGW6t5VrHsryxv8qjmwzeda_Z7PnkLphj-KI1_5kjiQifSaaElZkVIgCAkS_ll-Xwt4MBy7b7z4WB3N9w-ARobB:1kVfgH:_i9aOOMzCKKIs3buKHBpOKPz6jIsPJhpsaby5DdJUF4	2020-11-05 21:51:21.257524+03
35ov02cglcnunzfjxyg0x4j5wfirhp4m	.eJxVjDsOwjAQBe_iGlk2G3-gpOcM0e56jQPIluKkQtwdIqWA9s3Me6kR16WMa5d5nJI6K1CH342QH1I3kO5Yb01zq8s8kd4UvdOury3J87K7fwcFe_nWmQAgGhOSeDYnQkuIMQziUdhb78QYQLZHl0N2NrELMThiO0gAgqjeH-4oN_U:1kVfgi:KA7Fq-1mL3EV7Quo54oobz7DK59hZligvW1NGk1YmjM	2020-11-05 21:51:48.838995+03
b4dyemfc50uijxnof3z7os23r5crm53k	.eJxlUM1KxDAQfpeeNcwkzXbXo3ffQAiTZGqzG9ulTQUR390k9tAqAx_D9wczX42hNQ1mXXg2wTdPDTYPe86Su_FYBH-l8W0SbhrTHKwoFrGpi3iZPMfnzXsoGGgZcrq9eGdPGkB7iaqzZ6k9dkCKmJxTfZbyXKRqURKoM5468A59j9BbhTqXTvZqUkiRc93rCi2qghIqXjbDjT-zHPmDo3yEjbzTzGM6hrmgwoIt1V1XrHsryxvCYjiyy-c6857PHmLphj-Kp1D5ktiRicySaE4loQWikCDhn-X3tQfDvvvOc5iqo_n-AYF8hsg:1kaf9O:K30lPZ_HIMW_n7_QLD7BnqciLzQp23p7dlfkTwukZig	2020-11-19 16:18:02.183953+03
7oht5ku52gqpp8rsusimgww4gp2h0wb2	.eJx9TtEOgjAM_BWzZyXrmBj9FpNlQNEpMjLKgzH-u6wYHT74crm7Xtt7CF9eDDlqURzEcZQaIGIuGcuE1xE1fPns62bFImcxW8zzJkHJIcVC79jaMu4Z7SekAAolxZp7XfE-tToFP_YbeHu9DdjRsvLf37qcNt1gsMWKgqvMzXd0buNl-TOprWM__kpMsmYgGyhuQAaQKckVlxHs6hgokkB6u8fgPCfE8wUlQXEv:1kaymG:e1t4gzvDc6gSBsZ62I-T7NNW5czwmUpZrRUmcdG6lKU	2020-11-20 13:15:28.246605+03
cy015f0heo2sy30j0xeuq1t74i15m3wm	.eJxVjMEOwiAQRP-FsyG7UErr0Xu_gSwsSNXQpLQn479Lkx40c5v3Zt7C0b5lt9e4upnFVaC4_HaewjOWA_CDyn2RYSnbOnt5KPKkVU4Lx9ftdP8OMtXc1t3IwfcGwLBCbf2gDKMF0hQpBJ0aahmV7lAR6AF7CxyQE0LyGo34fAHD8Dbj:1kazad:f5MTlShaMA-F5ePYgZtAQLlW0NskLfOaxHB-29-Zjac	2020-11-20 14:07:31.718944+03
v316w38cwpyh5y4uiyh6cbjva0b7yz2u	.eJx9kMtugzAQRX-lYt1YnrExpsvu-weVLD-GQIIgArOIqv57jUlSokrdXM3cOfPQfBXGLrE1y0yT6ULxVsjide856880rIVwssNxZH4c4tQ5tiLsVp3Zxxiof7-xTwNaO7epG3WjbckrVE4jUkkeURLXPkghAJyoveKNU5UXQXFSoKHC2oWmEsqS5mno6E4mdrGnNO5z4RJgVcGzul0cVpXwG2--bF5yInKyWTkWzU55hjAnsspWmbXOah8QAii433Wma7rqOI3L5XD3LnaiIT6f_O9u6VIn9eTTg70JNlqzvR4EA2DIkf8B5minmBCOD-T7BzJDjfY:1kdT1r:s21maL2i87--stBS_ItK1lGVXCnweAU6fBc24o2lsOk	2020-11-27 09:57:51.726231+03
fhrnpgqiq035u5beuax70rgjr6h8c8xh	.eJylUEFqwzAQ_ErRuYhdyYqTHnvvDwpipV3XSowVbPkQSv9e2fEh7TUIRsPOzLLMt_K0lN4vs0w-sXpTqF4fZ4HiRcZV4DONX1nHPJYpBb1a9K7O-iOzDO-798-Cnua-ppsTx3BwAI4N2jYcjWNsgSwJxWi7KtV3MrZBQ2CPeGiBI3KH0AWLri7N4exLKoPUdZ8LNMgrWveyfWbFJmwcNw4bvyPv-YvcnkhfaZKxPHVEmr0MEmuF0TOl4bZX_jAs5O-No9WI2oCBf8GrTCmvDlA_v-2oicI:1kdU5Q:01U5o1v0nWpPJ2kdRfNuQFskzz7GaHrgwCXV5yw5VGA	2020-11-27 11:05:36.698314+03
knkre785fj7pr2i057i2ehr3zzg9idov	.eJx9UstOwzAQ_BWUM0Re23FSjtz5AkCWH5smbYgjx5FAiH_HdlNIC-Iy2p2dmV1Z_iikWkInlxm97G1xX_DidstpZY44poE9qHHvSuPG4HtdJkm5Tufy0VkcHlbtRUCn5i66adM2qiI1FbqhFCs0lHIkjbGcMQDNdkaQVovaMCsICmigpjtt25oJhQ2JoU4fZOjDgDHueSEcICEjGfWmtgk5_NQnnrc3uWG5OVG5Zu0GSRbR3PA6U1XGXUb1LaIAAs53HfE9XrX3bpnuztykPI7h8uR_d3Mdnf0scUAT39jI1_jW3ZCSydXEqj7zcMWbxaelfzlwCGrlNzFByTkonx1QApSU0N-S0w8AuhFssyf0vbNreDYEpQeU-Da5FP308vkFT-_BFg:1kd59O:138Qm2oc9HKO6nrX7UJ8tDy70jOF6JGIzow4tE2o3Ig	2020-11-26 08:28:02.851837+03
4g8sql3n1x3p62ml6lsb3uoh0tr8pqht	.eJx9UttqwzAM_ZWR5zVYdtI0e9z7_mBgfEvjLouD7UDH2L9PUUqbdjAMB-noSDoIfxdSzbmXc3JRelu8FFA8bzmtzIcbl4I9qfEYShPGHL0uF0l5qabyLVg3vF60dwN6lXrsrlpr9L5mrLYcRKMPvLbQMCWUU8aIDkv4Wi4q4IqJA-wbZg3YDlinBdQ41PTBGyc7Pzgc6AZn0IiR0R19yi7ueFsCKznjrDwP6XzrSL1zGVveZ1aBXlAcFqyAkHOUZjNJP8mUVZ4TapEK-oQr7igT5hFXPcpk9plM0QaaKhih3sT2tnONV77qnigRlKwUxaLbICMRp6RqiKoJW0J1FXGAPWcXXx_uC10dY5inHVy4SUU35nvL_-6uNHZez21VVnL9EXht1tLB_wjwQHE5OYONxCd5VX3iN-qHxd1jxSpPPDzwk4s-WGr4-QU32dg0:1kb0Fj:0TwUWJTRkfw1I-X43Umslfr1ZDwRZCpBIafVHR7_t24	2020-11-20 14:49:59.260078+03
086kkuod3dkcyosvw3glef4esljegls6	.eJy1V9tu2zAM_ZUhz50miqIue9z7vqArDNlWlrReEiTOsGHYv49SUsReC2RrWQSQZFE65jmiSOfXoknHcdUcD3nfrPvFxwUsbqZzbeoe8qYY-vu0-bpV3XYz7tetKkvU2XpQn7d9Hj6d184AVumw4t029l3rSGvqDaBvg6EevE6Ycuo6XLKJf9GgBZM0BnBe9x30S9DLFoEYdNveN-N6HDLDfTlqC1hao2sbzwse8k82D_l7Hsx7fZ7cpX3ejPPNubQIpbWpjqm2dWxNkWF9aPKQO6bbNd-Y9moo2PovS5_Wdb7smEyOqTmMaT-WHU4BKKONfrLkJK0OkwVT7F3er7f9My_tjvtC6Tl38jCmszv1FWNqh9zkH7ttceb2ttI3y0rTT4jHC33U76Dg8ikYDSY6HoMjhYA8qvL1H2pnX_AMzikeCiBp5Y0XweGIm_e68EceFIdRRwU0tbizpbZzuLubk8T2qsSmSKxZVEAsNFzEwPgkwEgQ6pHy63FMDapLf8I1JykfH0UVxovCUILYokeljUTsCUIJKqzDrH97hevkKVlozypTqOKQcSq4l5B4ojNhSRdRAIovcZC4ERCU8zQdPEpqT5IawxlWRRel1Q6XeDYltoFLhjJGhJQclFw8g6VZ_9p4vlr2zKXsueoDEqloJYoMsn9RRBerIkkU4lLu4ryflr0QgZTV9H8SXw3iGmIBgO9iDIWGiaRcTc-vJcRfKsoFicNihl4otRPN-1miIA8Kq8eiEvtLntDlZKN1qDxJMBKEEswTGmf9m9e9-n-jVjxtqfhAHkkRSlxLhorKiIRxOSmJInzlA5mLoGcL_KPId7__AKzKhf4:1kbquu:Kjpu3vrvh3_zfH61ljLJrN13xDc2hFm99PYUB4NeVcE	2020-11-22 23:04:00.227167+03
5cm2jjfpcobtw40q8vlaa65bug0o7bdn	.eJx9UctOxDAM_BXUM0R2kj6WI3f-AClyHt1mt7RVmx4Q4t9J0gJdkFCkkT0ejy3nvVC0hk6ti5uVt8VjgcX9kdNkrm5IBXuh4TwyMw5h9polCdurC3sereufdu2NQUdLF7vlyRpdlQCl5Shq3fDSYg0kyJExoo2l-E5cSOQEosGqBmvQtgitFlhG01FfVPChd9HuZQWJmFBARn2IbUKJP_HGy_YuJyInG5Vj0R4QsojnRNaZKjOeMtK3iCNWCPteV_cWtzrP4zo9fHETzW4Ityv_O1vq2OkX5Xpn4o2Neo237vrkDL8qlnzm028dyEBqCTSH1NEwRMaBwx_J9p_ID4Kj9-RmP9o89OMTut6nRw:1kdJUe:xUZ4vTQWfmpgcLGGAVWMaryrdpydLjfldWjrLVdEJXc	2020-11-26 23:46:56.96808+03
ngpuwm91wx9xnkpaqi4eaufn3esoj9ft	.eJx9UctOwzAQ_BWUM1i7tpO0HLnzB0jW-pEmbYgjxzkgxL_jOKGkRUKWRrszs-uR_VkommOr5skF1dniucDicc9pMhc3LII903DyzPghhk6zxcI2dWKv3rr-ZfPeLGhpatO0PFqjqxKgtBxFrQ-8tFgDCXJkjGiSlM6RC4mcQBywqsEatA1CowWWaanXZxW72Lu07m0GibiggIx6V9sFJf7WKy-bh9yI3KxUrkWzQ8gmnhtZZ6rMeMxIVxNHrBC2XBf3kVKdgp_Hpx9upOCGeBv537ulTpOudyY9sFGWIqn16VEwRMaBwx_DFCnEZAHcWbpJXV3v6b_afkl3r1jqMo93_OhC520e-PoGFtOnQQ:1kdUzP:n54gRWyGdL8sVuLlMqM46y56GK_WuryoKrlZFFOXvEM	2020-11-27 12:03:27.857682+03
q0qb9fgp6xacyz72pgn5itzl4cgj3qsk	NjIyOGZiMGIzM2VhMjJlZGE3ZWNiOWJkOTZmYjI0MTQzMDExYzA2Zjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjMjYzZTNjYWYzZGIwODNhZjdiNTJhN2JiMzk4ZGFlMDE3OWQ2YjgxIiwib2JqX3RpdGxlIjoiXHUwNDExXHUwNDMwXHUwNDNiXHUwNDMwXHUwNDNkXHUwNDQxXHUwNDNkXHUwNDMwXHUwNDRmIFx1MDQzM1x1MDQ0MFx1MDQ0M1x1MDQzZlx1MDQzZlx1MDQzMCBcdTA0MmZcdTA0NDdcdTA0MzVcdTA0MzlcdTA0M2FcdTA0MzAgXHUyMTE2MTAiLCJvYmpfa2V5IjoiZ3JvdXAtMCIsIm9ial9wYXJlbnRfdGl0bGUiOiJcdTA0MTNcdTA0NDBcdTA0NDNcdTA0M2ZcdTA0M2ZcdTA0NGIiLCJlbGVjdHJpY19kYXRhX2VuZCI6IjEzLjExLjIwMjAiLCJlbGVjdHJpY19kYXRhX3N0YXJ0IjoiMDYuMTEuMjAyMCJ9	2020-11-27 12:45:22.72317+03
z546j5p72hxommepxco2ggwgk2m5ie8g	.eJxVjEsOwjAMBe-SNYpaO60bluw5Q2UnNi2gVOpnhbg7VOoCtm9m3sv1vK1Dvy0692N2Z1e70-8mnB5adpDvXG6TT1NZ51H8rviDLv46ZX1eDvfvYOBl-NYYEDszZUkRNGK0ZCoJpAZDi2AtEXRCgTBEJGqrhuoKLDBDQ1Hd-wPxqTeO:1l7xvm:P-PsIo23unPggDr7PBRqoDcUa80J0RjQZJBcBaLSIvU	2021-02-06 13:01:38.755432+03
w9n0d4ewrcy9svggdu3p4o7q3g9xjqsn	YzQ2MjhiNGI1YTdiOTIyNTlhZTU0YjQ0NmQ0NGMzNjRmZDg2ZDkwNTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJlODExYjFjYTcwYmQ3NmQ4NzU3ZDM0MWE1ZGRhZTlhMjU2NDFhZmM3Iiwib2JqX3RpdGxlIjoiNjU1MzQiLCJvYmpfa2V5IjoibWV0ZXItMCIsIm9ial9wYXJlbnRfdGl0bGUiOiJcdTA0MjFcdTA0NDdcdTA0MzVcdTA0NDJcdTA0NDdcdTA0MzhcdTA0M2EifQ==	2021-02-06 14:58:01.521351+03
l63hp75fxtm7h0sz70ec3osq2x32hsuw	.eJxlkMFuwyAMht8l5w45BhSy4-57g0nIgFnSoqRKyKRp2rs30KhatcsvZH98YP80lrY82G3lxY6heW3a5vS35shfeCqNcKbpcxZ-nvIyOlEQcXRX8T4HTm8H-yQYaB2KVnLXsZYQTe8Qehl7T1EBoI4cALzze-ogtdHsnTaAnQJnuAXZRVV-NbuzzWNOvOs-NlDYllRYUuqaoaY64At_72jiL074AkfxSgtP-UnUchWpetnUc3mPE_t9VG8DZbL3JYARgAIB_wNrpiUXRD-Q3xvvP21H:1l96Rk:lzmD9yFxoxdLuyJpB8nJRUKZXMA1EpT-c6KpR95K5t8	2021-02-09 16:19:20.993674+03
w7y9axcih6l5cbpt8dv7an8r7cfy0456	.eJxdjt1OhDAQRl_FcK1kSmkAL73yxjcwafoztV1YSuiQYIzvbrtLXNebL-mZM1_nq5JqIy-3hKsMtnquWPX4l2llRpzLwJ7U_BFrE2dag66LUh_TVL9Fi9PL4d4VeJV8qeXYdSg4uH7QDQzcDUa5FqARDi2A0SansFz0Ao0WPTRdC7pHBrxzbbnK-BgMShcmzIUeFUncz8skE42yPOt9SvtNTB6RsvlazFJAZpFhybqiLeVBRlGf0NAdMnGbKR_-T5MU6PIxG4BDB-zAI35meMa88gQHW9SKM_1uvG_QMlWSN5eEku01r6S_EQ4PwBpRff8AYmOEOw:1lHo5a:H-tIDnGSxXBDpRWldbzcKj1HB5vWfvKw6SM1kmTTtBM	2021-03-05 16:32:26.353416+03
0x3bakqebvo5dc2g9cto0ugqlk2stdf3	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1lWHql:kQcoXIylWPKFDGiKU9KaMaW8G-dsLyV_nCAzbRvfJQs	2021-04-14 15:08:59.124148+03
o8kcphjrjg514n87ercx67dedfruzfoc	NDNhNjFkZWY1YmZhNzk5MGY0NzU2MjhjZTAyZjQ4ZWMxZDcwNGJjNzp7Im9ial90aXRsZSI6Ilx1MDQxMlx1MDQyMFx1MDQyMyBcdTA0MjVcdTA0M2VcdTA0NDBcdTA0M2VcdTA0NDhcdTA0MzVcdTA0MzJcdTA0NDFcdTA0M2FcdTA0M2VcdTA0MzUgXHUwNDQ4LiwgMiIsIm9ial9rZXkiOiJsZXZlbDItMCIsIm9ial9wYXJlbnRfdGl0bGUiOiJcdTA0MTZcdTA0MWEgXCJcdTA0MWJcdTA0MzBcdTA0MzlcdTA0M2RcdTA0MzVcdTA0NDBcIiIsImlzX2VsZWN0cmljX21vbnRobHkiOiIwIiwiaXNfZWxlY3RyaWNfZGFpbHkiOiIxIiwiZWxlY3RyaWNfZGF0YV9zdGFydCI6IjAxLjA0LjIwMjEiLCJlbGVjdHJpY19kYXRhX2VuZCI6IjMwLjA0LjIwMjEiLCJpc19lbGVjdHJpY19wZXJpb2QiOiIwIiwiaXNfZWxlY3RyaWNfY3VycmVudCI6IjAiLCJpc19lbGVjdHJpY19kZWx0YSI6IjEiLCJkYXRhX3RhYmxlX2V4cG9ydCI6W10sIl9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2Y2EyZWM0MDE3MjNkZDNmMjNjODhjNmRmYmRlN2Y5MWFkYTg4NWYzIiwiZmlsZTMwIjoiIn0=	2021-05-01 14:06:44.535203+03
n0fu9e4jcgkcu4rstk2jl9impi5fm06o	MDJkZmMyZDdkMjBiM2I1N2VmZWMwNmUxMzNjZjdiZjMyMWNmMTNhZjp7Il9hdXRoX3VzZXJfaWQiOiIzIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2Y2EyZWM0MDE3MjNkZDNmMjNjODhjNmRmYmRlN2Y5MWFkYTg4NWYzIiwiY2hvaWNlX2ZpbGUiOiJcdTA0MWJcdTA0MzBcdTA0MzlcdTA0M2RcdTA0MzVcdTA0NDAgLSBcdTA0NGRcdTA0M2JcdTA0MzVcdTA0M2FcdTA0NDJcdTA0NDBcdTA0MzhcdTA0M2FcdTA0MzAueGxzeCIsImNob2ljZV9zaGVldCI6IjgwMDIwXzIiLCJ0Y3BfaXBfc3RhdHVzIjoiIiwib2JqZWN0X3N0YXR1cyI6IiIsImNvdW50ZXJfc3RhdHVzIjoiIiwib2JqX3RpdGxlIjoiXHUwNDFkXHUwNDM1IFx1MDQzMlx1MDQ0Ylx1MDQzMVx1MDQ0MFx1MDQzMFx1MDQzZCIsIm9ial9rZXkiOiJcdTA0MWRcdTA0MzUgXHUwNDMyXHUwNDRiXHUwNDMxXHUwNDQwXHUwNDMwXHUwNDNkIiwib2JqX3BhcmVudF90aXRsZSI6Ilx1MDQxZFx1MDQzNSBcdTA0MzJcdTA0NGJcdTA0MzFcdTA0NDBcdTA0MzBcdTA0M2QiLCJpc19lbGVjdHJpY19tb250aGx5IjoiMCIsImlzX2VsZWN0cmljX2RhaWx5IjoiMSIsImVsZWN0cmljX2RhdGFfc3RhcnQiOiIyNi4wNC4yMDIxIiwiZWxlY3RyaWNfZGF0YV9lbmQiOiIyNy4wNC4yMDIxIiwiaXNfZWxlY3RyaWNfcGVyaW9kIjoiMCIsImlzX2VsZWN0cmljX2N1cnJlbnQiOiIwIiwiaXNfZWxlY3RyaWNfZGVsdGEiOiIxIiwiZGF0YV90YWJsZV9leHBvcnQiOltbIlx1MDQxMlx1MDQyMFx1MDQyMy0wMSIsIjI3MzgzNDAwIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTAyIiwiMjczODMzMjIiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI4MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMDMiLCIyNzM4MzIwNyIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjMwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0wNCIsIjI3MzgzMzQwIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNDAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTA1IiwiMjczODMyNTMiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI2MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMDYiLCIyNzM4MzI1NSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjgwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0wNyIsIjI3MzgzMjI4IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNDAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTA4IiwiMjczODMyNDEiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI1MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMDkiLCIyNzM3ODgxNSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjUwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0xMCIsIjI3Mzc5NDIzIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTExIiwiMjczNzg3NzQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIzMC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMTIiLCIyNzM3OTAwNyIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjMwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0xMyIsIjI3MzgyODEyIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTE0IiwiMjczODI4NzMiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI4MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMTUiLCIyNzM4MzUxMSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjQwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0xNiIsIjI3MzgzNTEzIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNDAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTE3IiwiMjczODI5MDQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxMDAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTE4IiwiMjczODI5MDgiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI4MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMTkiLCIyNzM4Mjk2NSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjMwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0yMCIsIjI3MzgyOTYzIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNDAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTIxIiwiMjczNzg4MTIiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI2MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMjIiLCIyNzM3ODgxMyIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjgwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0yMyIsIjI3MzgzMzgzIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMzAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTI0IiwiMjczODI5ODAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI0MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMjUiLCIyNzM4MzIyMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjgwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0yNiIsIjI3MzgzMjE5IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMTAwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0yNyIsIjI3MzgzMjEzIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMzAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTI4IiwiMjczODMyMTUiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI0MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMjkiLCIyNzM4MzQyMSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjYwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0zMCIsIjI3MzgzNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiODAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTMxIiwiMjczODMxOTUiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI0MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMzIiLCIyNzM4MjgxNSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjQwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0zMyIsIjI3MzgzNTQyIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTM0IiwiMjczODI5MTMiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI2MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMzUiLCIyNzM4MzU2NyIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjYwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0zNiIsIjI3MzgyODE2IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTM3IiwiMjczODI5MTIiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI2MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtMzgiLCIyNjYxNjkzNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjYwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy0zOSIsIjI3MzgzMzg4IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTQwIiwiMjczODMyMDQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCI2MC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNDEiLCIyNzM4MzAxOSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjQwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy00MiIsIjI3MzgyOTcwIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiNDAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTQzIiwiMjczODMwMjQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIzMC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNDQiLCIyNzM4MzAxNSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjMwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy00NSIsIjE5MDk1MjExIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNDYiLCIyNzM4MzYzMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTQ3IiwiMTkwOTUzMDciLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy00OCIsIjE5MDk1MjEyIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNDkiLCIyNzM4MzIxMiIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjIwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy01MCIsIjI3MzgzMzE2IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTUxIiwiMjczODI5MzkiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIyMC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNTIiLCIyNzM4MzU0MSIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjIwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy01MyIsIjI3MzgzMjA1IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTU0IiwiMjczODMwMjkiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxNS4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNTUiLCIyNzM4MjkwNyIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjE1LjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy01NiIsIjI3MzgyOTAzIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMTUuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTU3IiwiMjczODI5MDkiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIyMC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNTgiLCIyNzM4MzAzMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjIwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy01OSIsIjI3MzgzMjE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMTUuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdLFsiXHUwNDEyXHUwNDIwXHUwNDIzLTYwIiwiMjczODI5NDEiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIzMC4wIiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCIxLjAiLCIxLjAiLCJcdTA0MWQvXHUwNDE0Il0sWyJcdTA0MTJcdTA0MjBcdTA0MjMtNjEiLCIyNjYxNjkzNyIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjMwLjAiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIjEuMCIsIjEuMCIsIlx1MDQxZC9cdTA0MTQiXSxbIlx1MDQxMlx1MDQyMFx1MDQyMy02MiIsIjI3MzgzMTk0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiXHUwNDFkL1x1MDQxNCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMjAuMCIsIlx1MDQxZC9cdTA0MTQiLCJcdTA0MWQvXHUwNDE0IiwiMS4wIiwiMS4wIiwiXHUwNDFkL1x1MDQxNCJdXX0=	2021-04-28 11:04:23.196648+03
9h6j1nf8cka21zsugbeatb9uxrny42bt	.eJxlUctugzAQ_BXEObEWPwr02Hv_IJLlx1KcuBCBiVRV_ffaBinQXsbrnfHsaP1dSrWEXi4zTtLZ8rWsytO-p5W54ZAIe1XDx0jMOITJaZIkZGNn8j5a9G-b9mDQq7lPtgzrGgWDrmk1hZZ1rVEdB6CiQwtgtIkoLBONQKNFA7TmoBusgNUdT6lGfZXBBY_R7rIAr2hCChlZkQ-RkGFCDru6yfXK5me8yrV6apgoVik5FXQbd8OvOMzjAz09w9a8qwmHcIzyklEVl_Wqs-EaoM1onwFisDJauVmiRxOXaeRnXGrv0yz4w1jlcj8tYNcMSs5BTSEyDAhwQoH-l6wfdxDsve84udHmoT-_tHGgYQ:1lcRS1:A7WUvt6aPWe7hrRvmk9dx0DD8ZK1zEoxfJXU9XoJy0o	2021-05-01 14:36:53.899844+03
unhvxl7mvrfess4o2dtfi81pd6i8bhy2	.eJxlUMtOwzAQ_BWUM1jrV5NwROLIH1SybGeDTdM4ih2pFeLfsdMAqbjMYWZ2dnc-K6WX5NQScVa-q54rWj3uOaPtCccidB96fA_EhjHN3pBiIZsayVvocHjZvHcBTkdXYjnWNUoOfdMaBi3vW6t7AcBkjx2ANTaj7LhsJFojG2C1ANMgBV73olwVzIdKPg2Y4wRvRdsc2Eaf8JrJMyacn2DjJj3jmH4njgsIygryG-KK4uG4MEoPZYGPCge0-T2rzvlNN1y3QvZKp_3Klz07MmkVk55TVhgQkIQBo_8styqBEhA_hn32hLMP3RZuXfAWVe_X-x0OnpHLEC9_UnSIZeHrOq9OJS7ZSfmp3JKWmLVbG1m_o2xYxlzWjvv6BvvDqDc:1ljf9T:fRCj-70F919JvS4ZU3FIpzPEfWwvE1mC_0pSi-tTmPo	2021-05-21 12:39:35.496977+03
4hszrsn8gzjapuqc1xaytf2oemloveoe	.eJxdjs1uwyAQhF-l8rmxMD_F7rFSj3mDSAjWSyF2jWVASlX13Qup-5Ne5jDfzOy-N0rn5FSOuCk_No9N19z_9YyGCZcKxrNeXkILYUmbN22NtDuN7TGMOD_t2ZsBp6OrswylRMGI7QdDycDsANpyQqiwOBICBoqKkYleIBjREyo5MT12hEnL61fgggdU1s9YBh3OnraXOV5-UXSIqbDnGSFtaqqtBKvyq4pJpxwLK1Yw58JvLAh5SeXbfzGVfLpe42zgg5Rktyd8K-Yrlsrh21v1hkv6aZwy4R2tyr4Ur8rvTpl23QNtPj4Bb296Ng:1lj0BV:4rycDBpWxPNtR8SKgYcMFJ5TVbYZP7_9xamBUCNtAKI	2021-05-19 16:54:57.29046+03
nu8q16iik8vkr1trgj1g60ypgea8n6ct	.eJy1UstOwzAQ_BWUM1jrR5SUI3cuSHBCsvxYk7RRUsUOKkL8O7aTqm45c5k4u7Oz40m-K6mW0MnF4yx7Wz1WtLova1qZA46pYfdq_JiImcYw95okCtm6njxPFoenjXsl0CnfJVmOTYM1B9fuNIMddzujnABgtUMLYLSJWFtetzUaXbfAGgG6RQq8cSK5Mt3UG5SuHzAK4oAmGjFKvi8gOM0IGZv1fJce1OYXzMiKs8hoMrYJRe4KuOWLVVpdFgh3lztU5RYFchr86eLQd4ghWnx7eZXFLBb6mwI_K8ThYI6yP0ofVFh8nI6lSe_jJa9KZlrGEGO9ocnQhxxL3sGztib_mMC29oBfcemAnzjQB74Vj2rGMVxZ4pxkL6ZIolRdfaUYzt9VWhVUuuacomSCQE0YMPqHsv6dBeHnFwj33I0:1llD9y:p5InEXo5cJLXH6AZjHQwErxD2qc-V0sEJ5kxwq8GJ1U	2021-05-25 19:10:30.495591+03
57sm4x3dnes4z1m4reh529v9lih0n9aj	.eJy1Uk1vhCAU_C97ruapGN099uPYY28kBOFZWalYwM02Tf97gTXdj1566WWCM8O8x8TPDeOLH9ji0DIlN7tNsbm75DouRpyiIPd8ejW5MJO3qsujJV9Vlz8bifp-9V4FDNwNMbbCpsG6gr7ddiVsq34reE8AyrpHCSA6EbCWVd3WKLq6hbIh0LVYQNX0JG4lBqMEsl5pDIGDOVg1mczhAW3WhiDIj9odz0Y3IPrgfNIovGVjzPBiZmpmznO_uKAFynT7oF9RwiyTD7tfcphSlGCSe85OlVSQA8lLKItfhnDVxuFQXFjCKOaVT_vTBUhZR6wwYRmRQDq3CeVJzZK1SB_12Xo6Ewi5sZIKQujDjtKX0Lqj1L1rSh_Rjd7MlCbrn6ata474EfJ0KFeXGVnJmVuc_L88QTn2U-Bb-MUGHeffKpKrxBc3_IxWGZkufH0DzYXjTQ:1loiOi:69eOMqxpi3BEkjytM0fhdeT3e1cO0DZX1WXfKjCQwU0	2021-06-04 11:08:12.27072+03
yxx2lqrxsq2kr12lxtqed27p7isprt3n	.eJxdUctuwyAQ_JXI5xjxjJ0ce--p10qIxxKTWHZkcJuq6r8Xtpba9DIMw-zsAp-NNmse9Jpg0dE3p4Y1-7-aNe4KUz3wFzOdZ-LmKS_Rkmoh22kiz7OH8WnzPgQMJg01VkDXgRI09EfL6VGEozNBUspVAE-ps66g8kL1CpxVPeWdpLYHRkUXZJ3KDXN0oEMcoQS-m1zSFzjHVEjL-pYeWk452zGpxYHcx3T_LUoDQC5VL7jum-xuOt50yiavqehFmu0FXH6Q3LxOtcs_m84x4wyvK5WMIZqKXCL3O7YZr_BRbCO8wchbuok3s8CUH0P6isIhhopSILfIUZfYSHjkqAu1w2KOG0DECURtBWO5zhKd9iYb_fOHrCf0QOorNV_fz2OfBg:1luCol:7zpGawoX_0oy_YiFwEs-X5_uVc55pbz9q7KQps10rgY	2021-06-19 14:37:47.113652+03
ket3mxeawsup6r89zftfkfcq0zbpssz9	.eJxtUsmO3CAQ_ZWWzxOrbGzZ3ccsxxxzChFiKcZM08YBrHQU5d8D2JmJJ3N5h1dvgYJfFeNrnNga0DOjqkvVVA__coLLK855oJ74_Ohq6ebojaizpN6nof7sFNr3u_YQMPEw5ViCw4A9AT2eRQtnos-S6w6g7TUqAClkwl6RfuxRin6EduhAjNgAGXSXT-WsYjeM6KvLvFr7UM3440jIyRmJTBuLqVIHx26-Y2Mqgfpuw716loQJMSbNJ4syenbN-VEuzCwsRB7XkGa5Ujyl-YGSbp1T5YHDkmIkUzxytq0LmhrGuoW2-U-QrD7ukuGvJFWxaGI5OV2hazBj1xYcMvbNxpzKhU5FJDO20KWAfGsCyf3hQumXtPpAafhuKf2I4RrdQum-EEqneLMn7fyWRGkOIVCw9BFSmjbcW_cjXvFnqnj0bl2K-R3sg4V7nOPxClsAvIQR_YKd2OqT3wT2vKFb-l-TzSWvJ4qbwjeveLn6XP2WA23kbzgW9Map3VCeJHJhkeF9cfllvn77_QcXuf31:1mLNiK:jzxZqd3SaWKxcXDA8Zpr-EorZr9SR1fjqgHZDTCfkgc	2021-09-02 13:43:28.624711+03
gpk1308dsx1radrtl0eceqxjhu8lhbna	.eJxljztPxDAQhP9KlBpFGz-U5EqgpaRbyfJjTXKXO0PsqxD_Hdu5IojmK2bHM-PvVul7mtU90qYW157avn06akbbC93KwZ317SN0NtzStpiuWLrHNXZvwdH6_PD-CZh1nEssp2EgycGPk2EwcT9Z7QUAk54cgDU2UzouR0nWyBHYIMCM1AMfvCiraCWbq61yOmm1j-LQwdQxYP8NMektZQv0B0swZ5WWtFI-4B1ET4WCVQ6Fst-VZszboKkmW8hA5AC_rMQhv345Ib7nD0bE-LUivlK8pPCJ6GNQ100gzum6Nj5sexJiza3pXFa6Q7evyt4Nlbb9-QXuW3_G:1mWFXz:uy-Te7BeJJSIexxEuSOxez92x0rh2mo7yHo0u7MK5w0	2021-10-02 13:13:43.853618+03
jv4bkb5tjvpet7nz6x73d3gnqgu1hzdp	.eJxlj71uhDAQhF8FUUdo8Y-AK5O0KdOtZNlmHbjz4QSbKsq7x4YriNJ8xex4ZvxdK72lSW2RVjWP9aVu66ezZrS90VIO41UvH6GxYUnrbJpiaR7X2LyFkfzzw_snYNJxKrGcuo4kB9cPhsHA3WC1EwBMOhoBrLGZcuSyl2SN7IF1AkxPLfDOibKKPNlcbdWok1bHKN42LTQM2H9DTHpN2QJnSzBXlebkKR9wA9FSoWA7u0LZHkrV521Q7SZbyEDkADd74pBfv1wQ3_MHI2L88oivFG8pfCK6GNR9FYhTuvvKhfVIQiwhfO_j-tTqduVohZ22_vkF8oZ-Sg:1mhSDm:ytNYA9W7qclYVpbBPrVsEcTyvhp-3v282tXafUd7o5c	2021-11-02 10:59:10.184724+03
k3oklb01zfibmkwpytx0u05e8yiblbn8	.eJxljjsOwjAQRK-CXCNr_ZMdSnpugGTZ6zUJRImUOBXi7thAAaJ5xc7T7NyZD1vp_bbS4ofEDkyw_fctBrzR1IJ0DdNl5jhPZRkibwr_pCs_zYnG48f9KejD2rdaRdaSUZBdFyV0KncYsgaQJlMCwIiVJinjDGE0DqTVEB0JUDbrtopGwvoafQol-PcoJbgALkH-C2sJS6kKfCtzvPoylJFqcN5AC2rU8kXbaMT7snN1G-xeEjZK0OzxBAI5XWI:1mjzII:w-GqOjI917VtgSI8lq8kbi1V7gaiv71i5mDvXejkT3Y	2021-11-09 10:42:18.884956+03
e0o7awa9f8iet53y5hzcdiixc7z2kp4l	.eJxljztPxDAQhP_KKTWK1i8luRJoKelWsvxYk9zlYoidCvHfsZMrDtF8snbGM7vfjTZbHvWWaNWTb84Na54eZ9a4Ky1V8BezfMTWxSWvk22rpb2rqX2Lnubnu_dPwGjSWGMFdR0pAaEfLIdBhMGZIAG4CuQBnHWFygvVK3JW9cA7CbYnBqILsm5FM7lS7bQ32ehjKQEtYy0H_t-QsllzsQB7sER70XnKMxUBN5CMKiXf2VUqdkxOfdkNTrvJVXKQJSBMMwkov1_OiO_lwISYvmbEV0rXHD8RQ4r6tkrEMd_mU4jrkYRYQ4TfebSG_X30wU7X_PwCA6R8sw:1msL6y:BfTE4wYnU9kLNEvJXr_6N5tf-nOCHbO17F20S2mDYEU	2021-12-02 11:37:08.901664+03
hvw9bjhdxo6lpcya712d4hqek7mnmhhe	.eJyrVkrNSU0uKcpMjk9JLEmMT81LUbJSMjbQMzTUMzIwMlTSQVNQXJJYVAJUYmCIpCQ_KSu-JLMkJxUoEVNqYGKYCiJNjMCkOYg0NYSIKFgYGBgZKIAVJYNIIwMTpVoA0IYm0g:1mt4Fo:KqK_X9k6H3GbFj4MXMaCyOVzTBsZxkYPHZmbBWOiAos	2021-12-04 11:49:16.447685+03
pxwdv455cl0xpggki62tis95rdp3677v	.eJyrVkrNSU0uKcpMjk9JLEmMT81LUbJSMjbQMzTUMzIwMlTSQVNQXJJYVAJUYmCIpCQ_KSu-JLMkJxUoEVNqYGJkBCIN05RqAb1OHS0:1mt4Fo:ioyLQfAa8o86qwZwiwEP8kBp3YW2-7y8ofhhckSHc3w	2021-12-04 11:49:16.547477+03
j10jt74r7f21g020ylbdfjj7xftxeedv	.eJxdjtEKwjAMRX9l9FlH0tUXv0UodY1YrdvoMkHEf7cNQ2ZfLsk9N7d9K4rUcwq99Y6dpcGro-qgRWw1aFS7KjCzS5wjgJvIeL5ZDhwpg9MCRuuieFnRnV4ZRHpS1HtYzcklGvjvDPuiHRU1KLMTlboOGukGWQ4bDI3JpWG2v68-xoGvsbwKFfEuiI-VP1EKo5eDzxc7XFYX:1mt4Ft:HEbbAxbfMBA77723Xc4YwIfNXlgrwEuKL5IybYrDtFY	2021-12-04 11:49:21.337207+03
ydtmeh4bhejcb3veb6pgxfqfh2lbrsbg	.eJxlj7tuxCAQRX9l5Tqyhpdsb5mkTZluJAR4iL3rNYnBVZR_D-AtNkpzhLhHd2a-G232NOk90qbnsTk3rHl6_LPGXWktwXgx60doXVjTNtu2KO09je1bGGl5vrt_CiYTp1IrqOtICfD9YDkMwg_OeAnAlacRwFmXqUahekXOqh54J8H2xEB0Xpat_LyQgNz1ckZ8z90RMX4tiK8Uryl8IvoY9G2TiFO6LScftlOfBwAi7iCFrFSVphIqWaGsb-nyHFrI5ROdHk0y-jhesJbxlgNn_4SYzJayAo9KsBed5rRQDkoxo1rPK7tCdYzlx4qnKrlCDrL5-QVZKn3o:1n4N4K:q8Gg-Ei9Z_WMZ7zIUoQd4MR3y38Bb9SzxRFlIdTLv-I	2022-01-04 16:08:08.540205+03
mhp6ofriuw8j1e5ow8kkosdzr3hm93kw	.eJxlUstugzAQ_JWIc4sWA4Lk2Mexp6o3S5axl-LgYIpNmqrqv9c2NErSy0qeGY9nFr4TxmfXsdnixJRMdkmW3F1iDRc9DoGQez68m1SYwU2qSYMkXVmbvhiJ-mHVXhl03HbBNseqwjKHtt42BLZ5uxW8LQBI2aIEEI3ws5R5WZcomrIGUhXQ1JhBXrVFSNUqjTl4r8cdpW_e21JqPzSlT2h7Z0ZKX80RHaWdO-hNa6ZN7e2BUjpDUbRh5jJOEidEfJnC-6NG4asJJrnjbCkNWQokJUDIP4F1fHKrJPuTmGbPnHIaPRGMM4z28cGiCrPMFmQJF65oyQ7ocEp2w6z1XTLg5zUgOqMEstDf28Z7zIaq6UnbU3IW2A4xJHqOOVkflubEyNQYwrrZem7J6PkrSJh58A_eyliPX_6g8Yia3MMKjnzCwV3VJLFUjhfbLZea_o6y7Ly5g_97Oh1M4YaRXEU8u8FHnJSJnyL5-QUk19ws:1nErc8:W74FDUlkkdaHgXrsAjhXWSZUUw_6NgIK77JxnpBOpVE	2022-02-02 14:46:24.149321+03
e31uc5u1vj4kxf087lxp4ls6qki57mpe	.eJxljjsOwjAQRK-CXCNr_ZMdSnpugGT5syYJUSIlToW4OzZJEUTzip2n2XkR69bc2nXB2XaRXAgj5-PNu_DEsQaxd-NjomEa89x5WhW6pwu9TRGH6-7-FLRuaWutQK1RCUim8RwakZrgkgTgKmEECD4UqiiUURi8MsC1BG-QgdBJ1lU4YCivg40uO7uNEowCoxw4_xOW7OZcFDgqk-9t7vKAJbivIBlWSv6lrlRsu5xM2Qbk_QH_NVmw:1nEsix:0YICYH4uRnkUmqrYA7DahzqtiGCSY292id7gmH9MEHI	2022-02-02 15:57:31.939315+03
d9epc386v918578m5zwgrl25n9a7oc9c	.eJxljztPxDAQhP_KKTWyNn4ovis5WipEt1Lkx5rkLsQQOzSI_46dXHGI5pM1M7s7_m56s-ahXxMt_eibU9M2D_eaNe5KczX8xcxvkbk452W0rEbYzU3sOXqaHm_ZPwsGk4a6VlDXkRIQ9NFyOIpwdCZIAK4CeQBnXaHyQmlFzioNvJNgNbUguiBrK5rIldOu9yabfi_FNQPOOHD-L5CyWXKJQHsXifbS5zFPVAxcQbZUKfnGrlK1u3LQpRuUkTBOJKDkzyfE1_KlhJg-J8QnStccPxBf4hdlxCG_T4cQl30ScdsjK4XauF-B7b3Tboprfn4Ba6p5lA:1nP264:H05Zm1I9wk1WUyP_BhB0oGMM4vFd5breQYQYZyIhoe8	2022-03-02 15:59:20.018907+03
y9zvq61f892reve8xf8q322tjvsftebb	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1nTj07:wMHf0wz9C0qlHxZo6sAX1yz-lmAcETVihqon4pBpEEE	2022-03-15 14:36:35.62583+03
3c5j3qjwpkh1oi8505zhhzvyeeklk9xe	.eJx9UMtOwzAQ_BWUczEbP0jCkRMX_gDJWtsb4tZNqsRBQoh_JzYGtRXiMivNYzWaj0rjGge9LjRr76qHqq5255xBe6AxCW6P4-vE7DTG2RuWLKyoC3ueHIXH4r14MOAypLeCmoaUgL7tDIdO9J3FXgJw1ZMDsMZuqJxQrSJrVAu8kWBaqkE0vUytJrPX0cdA27uXFSTnGSHjfTEc6H2TA71R4LdQyBPONMaLsBQJhWE36dYycyZzdUaV0WXEjLTLXsF_ks1dqkWB7LaI1Q4j6u-toGUgGQfON4Nf9K_nuK03hFQRrhSHPvP1FW_XOZX_K0EhYuEvSywR5_hfjRPNfnIla4fJW9K9z-OcMctAlN48EUYNrQZZfX4BDmawrA:1ncojQ:UDFJBt-AZgI7-K64anJVU7ecFM684HxP9BdHR79epc0	2022-04-09 16:32:56.010637+03
ckm8hvlj3jemu5j37uf7pho38hbn1bip	.eJylUctOwzAQ_BWUM4o2cUxSjnDhwgWQuCCt_NgQtyGObKcUIf4d262AVogLl_VqdmY8Xr8XKJYw4OLJodHFZVEV5z8xKdSGpjTQazE921LZKTgjy0QpD1Nf3lpN49WBe2QwCD8kW0ZtS5xB361kDSvWr5ToG4Ca96QBlFSxcs14x0lJ3kHdNiA7qoC1fZNSqcEaRdibkaLhPW3xxm6dmSw-3F3jqwjxtoojMKyhrsvd6HffKj8QhSh7zLRN8gtqRjOjDyIsPo4iZOWaVDiClF2mJDmhYTAh53haoKl0qoyf5aNOtZG5r3IPud9XfdBv6O0f6lk4msK_QtAYn-qMQi2CwP0fVxclsDKtLxKMxy_OS_z1YUyJ4WSihcl4dYKrxaWIvyloDOKAH4eIO3bhrxgzOWN11n58ApKA3eQ:1nUOje:XadtKSCyBWsMA_PYVhIcqfAoZAAMTt7Ht7yDqAP3Oxk	2022-03-17 11:10:22.841935+03
3o59gkjojsg2so2fod0wk7pvvjkirchm	.eJxtUdlKxDAU_RXp8xhvs9jWR9_9AyFkubWdybRDmgoi_rvJtUJnFMIJnI1D8llps6ZBrwtGPfrqqaqrw56zxp1wKoI_multZm6eUhwtKxa2qQt7mT2G5817VTCYZSi1ApsGlYC-7SyHTvSdM70E4KpHD-Csy6i8UK1CZ1ULvJFgW6xBNL0sq2Z71GlMAXPd6wqSc0IgfNwMJ_zIcsB3DPweNvJiIk7pKixFQWHZXblrSZwlriZUhJ7QEOKBvIL_JpuHMmtcNAZ0-VGcPufHGUJZADeKNyPxtwm3xrLtvwSGZDZ-V5OMXpKJlJAsHw6c_7H8fNmVYd99wTjO5Ki-vgE5YqI_:1nbHxk:nk77pFE8pzcSoBCQeWh_KfahBq3rut3iCkBoCuHzuuA	2022-04-05 11:21:24.985684+03
iz72b90xtbkio16ibgiv7ho5mkgtxmug	.eJx9UU1PxCAQ_S89Kxmgta1HT178ByaEwlTYZUsD1Kwx_nehW3fdjfEywHtv3nzwWQm5JCOWiEFYXT1WtLr7jQ1S7XEqhN7J6c0T5acU7ECKhGxsJC9eo3vatFcGRkZTbDm2LTYcxq4fGPR87JUcawDWjKgB1KBybDRvugbV0HTA2hqGDinwdqxLV37YiWSTw2z3ukDNOSkHVesDS6zpepdrZGuELXOPHznP4Ts6uP8BZxlwSmfX4H3KDDpUeUYltExSnKZnDQFOGDCWBTaKs-aQ92Fc8YYbRku74vQGV0soVf_KQJfkhl83EZMM6b82ZgzW6y1XGW8VitGuUxmUSTxQWrd9S44uHi-KaBCL7XORlD6TmoWdS7m0xEyc9pRrXEHKL1PKf3vBvr4BIEW9Ww:1nXlzC:05beK_kt6fimlwSmaAZF-NbfQ-k_N_RgDF8D4PE4PCg	2022-03-26 18:36:22.451668+03
0orwkila6pqhh17ntbrqp8yqg279kqhf	.eJxtkc1uwyAQhF-l8rlB_Dp2j733DSKhBdY1iWsijA9V1XcvEKty0l4GMzvzIfBXo2FNo14XjNq75qURzfPeM2AvOJeBO8P8HogNc4rekBIh23Qhb8Hh9Lpl7wAjLGNuo8FesUGA6ySDVrl-6NWAR0exZ0dpWlCCgVS8U9B2UghuW-mAuU6YTiqZocGcdfJpwoxjp5VK6apy8lRWLoqKoXq0ft-Uk618wc9cBRNmnNOBbu4VYt7-kiuKV6113uacXzROaPPFrf7IDzBOhUQfJg589dmDb9dYjvivgVOCzd9hEuglQSwNxgiVhFPO_0Ruv-UusGdfMfrgKvz7BzAgmv0:1ndu9q:NG2zQVgalO5J7JchcPZx_RKg_zQrSe0w2_nEZTK_a7w	2022-04-12 16:32:42.594454+03
g3zp3ptehjoxzgmlnrcvoirpey1n1sl6	.eJylUstOwzAQ_BWUM4o2dtIkHOHChQsgcUGy_NgQNyGObKcUIf4d241EW7j1sl7NzozHj6-M8cX3bHFomVbZTVZk18eY4HLAKQ7Ulk9vJpdm8laLPFLyderyB6NwvF25JwY9d320pVjXWFHomlYQaGnXSt6VAKTqUAFIIUOtFK2aCqWoGiB1CaLBAmjdlTGV7I2WyDo9YjB8wh27NzurJ8OeH-_YB_dht2LDgDIChDDa1htoSL4f3f5X7XpEH-QviT5EXy9npmfmPPeLC6MAGbFF6U8gaZYpSs5ozGuf8rwuUBYqVlpdpYXEWorUF6mH1B-qWvUDfl6gnrnFyV8UQjuGYzit1ZK9h8ftxxgIziaK64QXZ7hcbEzwnwJHz1f8yMbzeIU2KopNDjSPj_WHcvhyJ4Rj7xmtNiqZf_8A7H3ftw:1nURat:-nenvzd0nCvejnqsFPxgAbW_L235uUC8-a7yr2VEJkA	2022-03-17 14:13:31.640013+03
8lcvog5s9ao3w7n7zzzst5m7h5uyqy04	.eJxtUMtOwzAQ_BXkc4nWL5L22Dt_gGT5sSFp3bhyHBBC_Dt2CKWJuIzsmZ3xjj-J0lPq1DRiVL0jB0LJ7p4z2p5xKII76eE1VDYMKfamKiPVoo7Vc3Doj8vsKqDTY1diOdY1Sg5tszcM9rzdW90KACZbdADW2IzScdlItEY2wGoBpkEKvG5F2SqYk0p98pjjXiYQlBcUMON85u0fCvPQ5HRYjGf8yDaPb-jh8TftqiMO6RYaQ0hZQY82V7TK6aTVT3mgFYiKAWPF6p26YMJIDsPk_Y4M-L4m5gvNPiZyV1lMM8UyJeqayqeyVz-q21uX_K2dLztuFaf7macb3k6xbP-fA33SC78uMyYd07bOvfWKsQ9zYfL1DUVMq9I:1naDiz:F4nxkzSveLK_oKvMukBzsF7_TBw4AcGTE8X7KM7-3yA	2022-04-02 12:37:45.296142+03
wpn5a7beg0kkfvibxyqwx2ee3otbhewx	.eJxtUctKxDAU_RXpeow3L9O6dO8fCCGPW5uZTDukqSDiv9vECp3RzQmcF4ebz0abJQ96mTHp4JunhjaHPWeNO-FYBH8049tE3DTmFCwpFrKpM3mZPMbnzXtVMJh5KLUclULJoW87y6DjfedMLwCY7NEDOOtWlJ7LVqKzsgWmBNgWKXDVi7JqskedQ4641r0uIBirCBUfN8MJP1Y54jtGdg8beTEJx3wVFrwgt-SuvFRUzlaOVpQVfUVTEQ_Vy9lvUj2UWWHWGNGtR3H6vB5niGUB3CjehMrfJtySyrb_Ehiz2fhdTTZ6ziaVBFUEOGHA2B_Lz5fRdmfYd18whcnX8q9vOsmiRg:1nV5w7:qwIax8F_BXti1L3k2YPWWATIqjpK43s2d_9Is4xLpKQ	2022-03-19 09:18:07.268282+03
boqdolvckic77rzqul6su8gybuuz7d75	.eJxtUctKxDAU_RXpeoy3edjWpXv_QAh53NrMZNohTQUR_93mWqEzujmB8-Jw81lps-RBLzMmHXz1VNXVYc9Z4044FsEfzfg2MTeNOQXLioVt6sxeJo_xefNeFQxmHkqtwKZBJaBvO8uhE33nTC8BuOrRAzjrVlReqFahs6oF3kiwLdYgml6WVZM96hxyxLXudQHJOSEQPm6GE36scsR3jPweNvJiEo75KixFQWHZXXlrSZwlriZUhJ7QEOKBvIL_JpuHMivMGiO69ShOn9fjDLEsgBvFm0D8bcItqWz7L4Exm43f1WSj52xSppsykIwD538sP192Zdh3XzCFyVP51zc5ZKI_:1nel5C:WeJJH0SjEUwraIHssD4KfXiQNyBfVLYTzyQBo2cOCgY	2022-04-15 01:03:26.097913+03
g879g5i2s4ijt5blij9sdnwxcyyh3xb5	.eJxtkM1OwzAQhF8F5VyMf_PDkTtvgGSt7Q1J6yaV4yAhxLtjm4Bo6GUszXyz1u5HpWGNg14XDHp01WMlqsNfz4A94ZQDd4TpdSZ2nmIYDckI2dKFPM8O_dPGXg0YYBlSGw12ivUCXCsZ1Mp1fad6bBzFjjXS1KAEA6l4q6BupRDc1tIBc60wrVQyDZ3NUccxekzjXlYqOS9Ki9YbcML3FHt8Q8_v6WZeIOAUr8pSZBWG3OWXyeKZ4rGiqqgrCkXxUFjBf5rNA0sfoEebLmK1gwj6-1a8I1QSTjn_BywRQtwj46J_qXM68ODzFnSXOBiLz3a-XUPe71YDfYQb_gXDOLsSfH4BVo-icA:1nkPva:FEy_AQGxO0rQogFh2hEXEnkcR_fuDroYpORgWGA69R4	2022-04-30 15:40:54.822061+03
2adfprp81yiwn6so40p5uj1rm9zn5aqv	.eJx9kU1OwzAQha-CsgYrTuw06ZI9N0AaTewJMbhxZDttEeLu2GlUKEJsvPjee_PnjwJwiSMsgTwYXeyLurj_yXpUbzRlQb_i9OKYclP0pmfZwjY1sCenyT5u3psCI4YxpamnTvKhRt0Kjo3U3dDJgXa6pI7vRN-grDkKWbUSm1bUdaUaoZHrtu5bIUUq6vpXiCZaylM2O1G23Ubf6D2xA0XyD-XGZvQ0xWvgeSlFPawvra9idxXjPLnJkkorKdAYES7LcslKwaqyqpLBBLh6Dmn90eZ25S9Fo1k5_8XV4vMkfyXIRtz47RAhoo__jTGTN05vWTU6owgGs246uiMEOkL0Ck6YTgJcQikgV2FnG87fiTAS5TaTA09hTkJUM5g5949LSMrlmKnpDVJumXLhG5vVsP5AsZ8Wa--LiU4_wecX34PLEg:1nfOm3:ZobtVg8Xc6Ig7N3m50qbE3rq8TzYqtsmx98EtQN4ykw	2022-04-16 19:26:19.438419+03
zrbcazznamo7qfiutgiqjrjayexx0hvk	.eJylUMtqxDAM_JXiczF-SFmnx977BwUjW0qT3ZCUxDmU0n-vk82hPS-I0aDRDELfKtJW-ritssSB1Yvy6vnvLFG-ybQLfKXpY9Z5nsoyJL2v6FNd9dvMMr6eu_8Celr76pYkLdrOEwew1CC3XYudXNhIay-QGkJvCdAFpCaA9y43wGQ5-BQAoYbO6RrLUEapce-bAcs7enw6mtsR0sHtwc3B78in_yZfD7g_aZGpPHSEjJLr_3JkKhTvnzWoaznjnPr5Ba3Geck:1nmaNM:rVuaanSqz-CxXPgrwN1ZhBB7SuzgPPMGUg8VZzLG0QQ	2022-05-06 15:14:32.310178+03
5nnsk9cgz0emwq8c1jgap5ddbfq93x1b	.eJxVkM1qxCAQx1-leN616qhJ9tj7vkFBRp002ZWkJKZQSt-9xqbQvfyE_5cwX8zhlge3rbS4MbILA3b6r3kMd5p2I95wept5mKe8jJ7vEX64K7_OkdLLkX0YGHAdSps8dUb2gLHVEq2JXd-ZnpooqJON9hYNSNRGtQZtqwFUsDqijC34VhtdRmd_c3nMicrc6ya0UpWi0h6BO30WO9EHJXUWh_iOC035oaxhJ3j-tL9SV81XTVaayliJlXSqWVB_zeZZlg8oUSgXCS5iRvd7KwlcGK6EUuz7B4ozbPw:1npTCa:Sc_8PNkmNjmTU2VBWrrQVXAGp6_6vCS-d7tNZsS4ZsE	2022-05-14 14:11:20.272663+03
8z7s5glkd4eeo0e93yucmx6rtk3r5ix4	.eJxVkNtqxCAQhl-leL1rPYwm2cve7xsUZNRJk11JSmIKpfTda2wK3ZtP-E_CfDGHWx7cttLixsguTLPTf81juNO0G_GG09vMwzzlZfR8j_DDXfl1jpRejuzDwIDrUNrkqTOy1xhbkGhN7PrO9NREQZ1swFs0WiIY1Rq0LWitgoWIMrbat2CgjM7-5vKYE5W5102AUpWi0h6BO30WO9EHJXUWh_iOC035oQx6p_b8aX8lVM1XTVaayliJlXSqWa3-ms2zLB9QolAuElzEjO73Vgq4MFwJpdj3D4pKbP4:1ntmqT:KVNRKbdI0YVuFhiqZRpat_EuTDI8Ll_t-hEaFVdn2DI	2022-05-26 11:58:21.735378+03
z34hdu86mt1pppd998hqeltl8ggx64kx	.eJylUclOxDAM_RXUM4qyduHInT9AipzYpZkp7ShNDwjx7zSZCkGZ21wc622ync_KwpoGuy4UbcDqqVLV42_MgT_TlAk8wfQ2Mz9PKQbHsoTt7MJeZqTxedf-CRhgGTY3OeqM6BVgqwXUBru-Mz01yKkTjXY1GCVAG9kaqFutlPS1RhDYKtdqo7fQ2Z1sCmmkLe515Vpgrso8lEfmql3pRel56a8Vd_-ZPu5wXyDSlO4agkby2_28RUhgr5eVDeOaSS7lP8GSIKajJCz2R_W-fccw5qX4gUEIBRcH3K8xb3HLQWOCG_iFYpixEF_fd6qvOA:1njfNt:ajF0EUPXmFlO5qPDeyXIuI3y1aaoPWyoa2exJV1EiX0	2022-04-28 13:59:01.676021+03
yapcg4j1v5ks44jkeg46sjmp08k7pssb	.eJylUEGOgzAM_MqK8yqKE4eGHve-P1gpcmJTaBGsIByqav--QDm06rGX8cieGVlzKwLNuQnzJGNouTgWtvh83EVKF-nXA5-pPw0qDX0e26hWidqvk_oeWLqvXfsU0NDULG6JUjmoLbFHoNJxVVeulgNrqeCAsSRngdAZ76j0aK1JJTIBexs9OlxCh3gOuc2dLHE_s0bgFa372IZZEePGYeN643fk3X-R6xvuXxqlz289IZ2kpb8UmDKFe7MASjtltDEvginTmJ8lf_8moYRu:1nogsM:eU3WjW67js6PnQjI1ea--A9-sX1PsaiXYX42u6ZL6xM	2022-05-12 10:35:14.42013+03
ntsgw4cbe434sqblgjm964ljqdmy5nuv	.eJxVjcEKwjAQRH9F9lzjZpNW8FuEkDR7qIYqJRVE_HfTQQ9e3sLbGeZFt3QJdapF6UTnlb0IyOBAHQJXfbZ30YcW2fNX3uOic_0re7fRJbPbrvVwCc6CPZjBCGqHrJNf83iwbUCLjnWZxpBjjUHn3BbsYLg3wiL0_gBKKDZL:1nqYIY:gnj1I9rvhqgdjnDQSRrcnz1H2ip60tkAeBx9mefuStY	2022-05-17 13:49:58.59016+03
2gx8wsntd7ysn6v0tzmgnvyvkwgru0du	.eJzlXc1y4jgQfhWK025VRmP92Nhz3Ps-wWRKJcticcaDKWwy2drad19J7QkikMsSKh_kIkCWrK9brW6pu43_mWuzG1d6N7itbpv5l7mc36V1tbHf3TpcaB7M-q-e2X49btuahSZsujqwP_vGdX9MbQ9usDLDyvd2tatyvpSmKRU3Rd5UyypfukWTuYovVF2YXHKjclHmpiiVlMIWqjG8KWVdqlz5m_b1gx7bsXP-dve7TAkRyyyWxdTgu_vbX-7co-vEp2yq3JitW48HnZUMpazZLHxyFevqWMdjmceyiaWJpbuLbaX41XPxmfsBXOes54jVjRmNJl4JwTLFRCaEb9AO-rnND8-9VRcgZi-uNKaN9ce3HEazHcNN-Ss33bht2zcn7ml320D4qdFcN5qpPg4ymrpz2j1t-jDW169zXiWj3RPDiTMu5QnxIvku7uehQ2Bq85l4e_Hf3-5e4OVxplScPSVojgXN-DLWRaGRVAqGBjgBVwBguzJeild5SWudL_AxWhY_6EoZS5WoJff-FChgiY04SFnVCQeLWDZJTZVof-5IskHgTxLCE_6mynYyUtRIzvbLcWpl2UwyqRi_JXLy2yKnwCGH8O7Xh1f08QdZ-exTrJsU_ezAICBRoExCxyKWChIt6fJsLzHK7nmPr5ssyTUtAXzZOFh5M84Uh1l4L5SCByaAsUlgbDim7hgbjqI_xlYCY6twsQEvU5EBYwNGxrjGRgdpT5_RoWxOjtEhr1Vcrl0eyf9GBjyfOEfUY2zA2xABvA0RwNsQ4B25zGCRAZ__JLCxksjSBmwUZM5gt26yAMa2AMZWAmMDNljAy1QBn5uRXZYK2CyokqHEI09hK4GxVajY_BELFtsCdykAn7Bg7BXHhfaSa_6cAA0N1ZdK4ED3bgQO1CfoweHOKfJi4KhHBQEcbhbA4WYBHG4WwOFmwgZsGQpo0wC7uSRss9_ib8q7yo4T5NKMeupa_Q5LD-xuWQCnRQjg3AMRotQifYLjIN2RLkzpjtRn3-g5uy0OmImY8saXN0-pnQgNyaqzo5VMw9Y0-MdjRZ4MVSffL0_6-7JCLCXxAjWX5xKU6o9C6hJ2-_NmlKoPI77q44ivugLxVedRepWUsesmDdg9IiTjuIyTwM7CAA5XT0jUqKBgCteRCZt3KXBDSDJEG3JUd9yEDlTiJnSgoZqIDjTxIShfhss3j00nl9JtSurApHpyb9KDkLiCKlhJvllOWy-ihrZkKmndJFfrSJPdt1Ec1FkrQ6AINCFEAgeKPDZYoymBg1gSOBAjgQMXEjhwIYEDFzI-XgeLDfaELOM5DxYbsF3AfYjNYwPWvbgPsUncB8U8tOxcHzDuEfYNaIM9V7wBbbDHwDeg7fK0vB9tOTBtZ0ZZoHXJubQh65L8huftXNpued6QbcC5tOHaAOBjm8QNbBI4aM7hqorgcAQGp4AtSECHPLEKWIsHdLh6OKDDXhWwYcSIDuC_vF9FhzuvwE40YL8osFsUOFoGLGslo_cuCI4cxqhQs64itF8MBNmx09FLEdI0ucFOD6Sd_DN2SmK9Zgr2wizLw4l5F8n-djfvu0b_cKPbzr-EN8Ks3c_0p131rXV62cY38qz6Rz24Rz1urf5pfCPNK535Pa9nC3vqhqd9j2HlXHijzammuutNeP3QaDe63YQX54y7gcbr6wdnx4Mq2-_Wof--7t__ADPoWts:1nho5f:IVZXyG7BKfEVc3d3y1UiPAxdK7dV03HIWU_TNwUASa8	2022-04-23 10:52:31.966063+03
sbntbalp9ygnp39xhnaghhqsjxgi1i7i	.eJxVjjsOwyAQRO9CbaE1GIFdps8ZEJ8ldkJAAqMUUe6eILlwminmjZ7mTbRp-6pbxaI3TxYykuHcWeMemDrwd5Numbqc9rJZ2if0oJVes8d4ObZ_gtXUtWs5SomCQ1CzZTDzMDsTJgAmAnoAZ90vhedCCXRWKGByAqtwBC7D1F_l6PUTdyxkSS3GgSR8nYvPF_98Q6k:1ntpbB:M2QBbD48QEuPIhC2IJmdADRXk7nytJvgIhTevq8cASg	2022-05-26 14:54:45.133422+03
b1ivr0eihty8j9u5hfdsdjr47nk66sia	.eJylUMsOgjAQ_BXD2TTbVwCP3v0Dk2bbbgUlYKAcjPHfpcAB45HL7GR3ZrKZd2ZwjJUZB-pN7bNTxrPjdmfRPahNB3_H9tYx17Wxry1LErZeB3bpPDXnVfsTUOFQpVhJeU5aQihKK6CUoXQYFIDQgTyAs25C7aUuNDmrCxC5AlsQB5kHlb7q7N3EOjY0xV1HUNwnlPowD5FQ2ZnzmcPMF_Sr_0GvHe4n9tTGXU9QQ27qzxmPEc0QsY9TkpCMcyZAiD_JUv5G8PkC-VCESw:1oxtZ9:bq2ThLum4cCTT_Rr6hEjx2RHGzHm3EUgaoFE09pQhdA	2022-11-24 20:29:43.864805+03
mreo7a4ds9cuqhy59kp03j0akslff7qo	.eJylUstuwyAQ_JXK58oCA3702Hv_oBJaw7omdowFOE1U9d8LjpU2aW65LKuZ2YFl9yuTsIReLh6dNDp7yVj2_BdrQQ04JULvYPqwubJTcKbNkyTfWJ-_WY3j66a9MujB97EaW2wE7RjomlMohW66RnRYaYINrXhbgmAUuChqAWXNGStUyTVQXbO25oJHU9Vbo1B2ZsRoOMMBRwx-gBPImKng5CDy4-iPv1rfI4Z0-ygH62Z5cEskg5qlmaUPEBYf2QjZdhcdriBllynEBm5kMpiwPuB9IZzqFJl4Wo8iRd6uOV1zsubnqLf6AU8PVM_gcAoPPeL8WUZJDQFSey59EaM5YXlBCvZPcp7_lcB4edHs40b0Y2qK3DAazIrTG3xGZ6y-U6AWl9q7Z4VjgA23o5Z7jLNJ1lSQkqb1mPDzglZ1VTNCsu8fEcbp3A:1piB9D:vkyusO_YdyZAmzoTrI4y0TGlnFlQ04WT2SFMktX5vY0	2023-04-01 12:34:15.574967+03
3a7ueavn5hoeybf14qdh5b6xb6lokxbi	.eJxlUMtOwzAQ_JUo52L5HZsjd_4AyVrHG9LWTVDigBDi33GcCNpyGY1mZmdX-1U7WFLvlhkndwz1Yy3qw7XmoT3jsBrhBMPrSNpxSNPRkzVCdncmz2PA-LRnbwp6mPs8jR6tYp2AYCQDrYLtrOqwCRQta6TXoAQDqbhRoI0UgrdaBmDBCG-kkrl09CeXjilirntZaK5ZUeCKkhbeFS4KskrtQ2f8zCMR3zHyB7qLbzDhkG4Kt0HhC5qi6MJpVfbJqxD7C4lwz-XmbveVy2R3qJTNqzFim__XugAJ3PZZKgiVhFMu_gXmBFO6j4wxuAsmnLLBmKKasawO-PGrNqYx3Nr6-weprZDd:1pjE6E:jECEDKy5tvLL1LovYVmqYUqO7Vo6ifF9uWZwa7v_hrc	2023-04-04 09:55:30.312741+03
u8oadr85jcs3f9it7bnwgax7xgzmkfw4	.eJylUMtqwzAQ_JXicxF6OnKPvfcPCmLlXddKHCvI8qGE_HtlJRTqHnMZDbMzw66uTfRHl0OeqHlrPleuBW6ozEt95IbaVy4q55XfEZvXmj_R9xPpCySa81NL0ER9TqF3CBkczVh6RMe4ZpJL9c-wZEh5b3Gw5tGtCyUXtvxO89Cf7sV4hPkrsj7OpdGzzcIe04V9RKTp_eH9UzDCMpY0eeqMGBSg1QJag93QmYEOyKkTB-1bMEqANtIaaK1WSvatRhBolbfa6FIaFvd7z7lsMU7b9_PdBCFUXez0C6UQsQZuP1ainik:1pp2Ln:OhCBHtx3xi30NPKmIwZCjHrMaOp3DPg-nFNmnuwz8OE	2023-04-20 10:35:35.717652+03
gna9lvc9py7ttpeqtg2falpp8u7zp1wz	.eJyrVspPyoovySzJSVWyUoopNTAxTAGRxqYKYMoIRJokgdmGYLYBmA0hU5R0wPqzUysp0F2QWJSaV0KRI1JzUpNLijKT41MSSxLji0sSi0qAJhla6hmY6BkZGBljKEnNSwEqMDKAK6gFAKQ_TcI:1ppSsk:4gJk7BK9AUxcSeQUZ9SBemqlaRVrRsTMPdrfZ14-NI4	2023-04-21 14:55:22.230996+03
6lnse3txt0imx63r0y7dzk6pidkj7m0l	.eJylUcFOxCAQ_RXD2RAo0KUevfsHJmRgppbd2m4KPRjjv0vZxmg97uXx8ubNGxg-mYM1D25NtLiI7Ikp9vhb8xAuNG0FPMP0NvMwT3mJnm8WvlcTf5mRxufd-ydggDSUbvLUGdkrQKsltAa7vjM9nVBQJ0_at2CUBG0aa6C1WqkmtBpBolXeaqNL6OzPLsc8Uol7XYWWuKEyD_VoNtS-clm5qPyGuPdf6OOO7issNOW7LkEjhbK_4BAyuNtmheJC80Y06p8hZVjy0RKT-3G9l-8Yxu1R4lBBiFWXB_1KS5zrWPb1DdGUnhs:1pjF6d:rpfcudhpGeHGBXMBVSAXVOF6R8Vgv_EYVeYhXN7SuqU	2023-04-04 10:59:59.799923+03
41ta1o801e806trsjiq0gplbfi5dek83	.eJx9UNtOxCAQ_ZWmzyuBAr346Lt_YEIGmNrusu2mpSbG-O8CrbptjC-TyblxmI9cweI7tcw4qd7mjznPT_eYBnPBIRL2DMPrSMw4-KnXJErIxs7kebTonjbtLqCDuQtu1NhI1nKwtWBQStu0jWyxshQbVgldguQMhCxqCWUtOC9MKSwwW3NdCylC6KjPyvfeYYh7WWiIiZNjnIKmvU07T5Nl36YLvgeLwzd0xQPdwBtMOPhd4GrkOs06IWXaaZbeE3ci9ivi9riLlV37pWaiPWWyCU-jQxPuZ5QFD2q9LK0IFaSgRbx9P6sfzTXcunOxPD0wFvqEswNulil-6y8HOg8bvi8xe5j8fzVuOPVjKpp_fgGrUq9k:1pkhQ0:5TS_l_KdnhjmhYjkGFrtoTfQzm2soXnWWdnk9khbeD8	2023-04-08 11:26:00.154276+03
575sq8lam6tql7a5k1b6l1bcvrw0n8kr	.eJylUUtuwyAQvUrldYPAgD9ddt8bVEIDjGMS17YAS6mq3r3gWG2SZpfNePQ-M8zzV6Fgib1aAnrlbPFS8OL5EtNgjjhmwh5g3E_ETGP0TpMsIRsbyNtkcXjdtFcDegh9cqPGVrKOg20Eg0ratmtlh7Wl2LJa6AokZyBk2UioGsF5aSphgdmG60ZIkYZO-qCiiwOmce8LFczmyuXT-ilzFXrt2drTtT9Xu_mP-PmAewaPY3zoETigSfkZZSGCChF8TJNYTaggJS35P8k5_CuBC-pX85F-Rz_ko-gNY8GtOLvBzeLzFfccOES4g8_o3WQ3wvSTM6g6t0bQI0Tlce9CRL9j9Y6KXX7lE2OKVuQ0hNOfJ_SIee9RqNUnaE3zPdHMys05jLiExJ_TTsuvIDMtY1pygX3_AH-X3Os:1poJvu:obUUdu-vutnmeQQ1fIg70ZadomWtUSKVA-xQxgjg8Vo	2023-04-18 11:09:54.484909+03
l6r2lto0nw9mr02nqobjecypjx1xf782	.eJxtUc1ugzAMfhXEuUMJSWjYcfe9waTIwWbQZlCFMGma9u4LgW2l68Wyvj_byWduYA6dmSfypsf8MRf54Rqz0JxpWAg8wfA6Fs04BN_bYpEUGzsVzyOSe9q0u4AOpi66yVKteCsAteRQKazbWrV0REY1P0pbgRIcpCq1gkpLIcqmkggctbBaKhlDR3syoQ-OYtzLzGLMUgUtVbLUt6kXqfLsx3Smj2hx9E6ufGAbeAFPQ9gFrkZhU9UJqVLPsjRPXon4n0jgbS9Xdt0vbSbbQ6bqOJocNfH9GoMQwEwBfIjTOSuYLEpWin-S9fF3gn4yv5q3-B2dW-5jNwxCn3B-gzezXy6_5yAX4A5-Id-PmIivby6Fr1g:1pllqY:0P-h6hpmn5XEUZujrfwadoW2HVNmwD4YOQC-DT3Xhs4	2023-04-11 10:21:50.742338+03
fez30pyxslbig9f86uy55wwiw5j0pslh	.eJylUk1vhCAQ_SuN54aIgKs99t5zL03IAGNltWIE2900_e8FdtN27d72Mk7eF_rws3BqL4MNIxYPxctacmrSZOIuP6o0uco7zXuZ99M0xX32D3i8wT3DglO46SVwRB0Wq6WBANIHWEJMKgUpOanKiv2T4GS2Aglr6OXqcZE2kRtMgR5OLrOH6dUR7aaYp0iSkDPryZMzOD6etRcBPfg-ulFhK2jHwDScQi1M27Wiw50psaU7rmoQjAIXVSOgbjhjla65AWoaphoueAzVvbMaZWdzXzO8x28LfoAjyA8I8aiBk8PoD79S3yOmRp7PdGSCnqWdU1dh9ZE6XUbs6ALSbp2S5S9mvfwp8y2W0I_p9ssNY8BmnG7wGRfrzBWDXpf0H1yLwjFAxr--Aaof26w:1pjzzv:VB9HBE0lt7KyPX2kFPTCy0Ymj4KLhsVfrFRDkAigY5g	2023-04-06 13:04:11.251266+03
wp5vcke5fabf2mj784d0dqbzb9y07yue	.eJylUMsOgjAQ_BXD2TR9bLF49O4fmDTb7iIoAQPlYIz_LiAHjUcvs5PdmclmHpnHMVV-HLj3NWX7zGTbz13AeOV2PtAF23MnYtemvg5iloj1OohjR9wcVu1XQIVDNbk5cGFVaZAcKMwtFWVhS96R5ELtIORojUKw2lnMHRijYw6EipwJDixMoV24-FSnhqe40yhB0YzGbpahZ4SwcLVwufA30uq_8v0P9w17btNfT3DDceovesKE_t2sBiFBaKnNj2BI2KdvyfMFJ32Edg:1pqppb:iuDDjEZtEapNkwPvy-aOljcXT9MWmjt8tjbc1Wk9XnM	2023-04-25 09:37:47.170906+03
55mb69en5vvzz2ay6cvvxwmh15hecpxa	.eJyrVspPyoovySzJSVWyUjIxNzQ2NjE3V9IBC2enVgIFc1NLUot0DaBiBYlFqXklcB0xpQYmhokg0tgITBqASBMICRGxQIgYGyiYGhgZGCrVAgCw6CMP:1puZtU:c0oIPf-KDZWFysSx0yV3csgmKYBCzseDdHOQ60NyWso	2023-05-05 17:25:16.28573+03
rkfgmsmed1grwsqoh7kx7wluhsvql2we	.eJyrVspPyoovySzJSVWyUjIxNzQ2NjE3V9IBC2enVgIFc1NLUot0DaBiBYlFqXklcB0xpQYmhokg0tgITBqASBMICRGxQIgYGyiYGhgZGCrVAgCw6CMP:1puZtX:EjKMyRLwToUEo2_1vszZOx1HM482HPyprAzVVk_fUz0	2023-05-05 17:25:19.366138+03
t2o4rr19h35kjubj8parpxpk5c3dvf4p	.eJxtTtEOgjAQ-xWyZyQbm0T8FpNlwBGnE8g4TIzx32UHiTh9aZpe2-uT9dVFo0UH7MhOE1fCBJQQUHHiLXFJKBLBUgpd4TFHHNzB5Tu-ioPx0OFX4RKUFeGBlII4T-if2pjExySbmKvluuyjZapNk305v7ajBgc1elvrW9_h2YVtPLo0xpIuIr2efFj9LwEOzapvatDoEY2nRJnxIst5Ln8s0DWxYds9gLc9OdjrDQvweLU:1q8yO8:LTWIlbSd8TIhQYc0k3S8t816ZSHttwF46uvNud8N55w	2023-06-14 10:24:24.223393+03
3up88d3b770czem1bchcj539l2fu25m9	.eJztVMmOnDAQ_RXEuUO8suSYS3LJF8yMrMIuBqYJIGyiHkX599iGdNM9HWk-YC6l4tWrxbXwO1WwuFYtFmfVmfRLytPDHqtBH3EIBvMCw_OY6XFwc1dngZJtVpv9GA32XzfuVYAWbOu9scZK0oaDKQWFXJqqqWSDhSFY0ULUOUhOQUhWSshLwTnTuTBATcnrUkjhg471i3Kd69GHe1yIDxMkxyAFiXoTdR4lTf45HfHVu_T4C3v2iWzgBDMO7irg6sjrKMuI5FEnScwndiR6IXFzq4vVutYXKxPNIZGVT409at8_rQw4UNbB7Hx2SjIiMkYYf0NZm8_KHaGz6sz56cfR9uF95MZioIs4vcEnnLvR3HHQyxxaci8U9g42PBbloO5R4WkaQ_kPD_t5sN2rV8l2DSVbQyVhJFQmCsq5KAqvxhjm89rqj-833zQj72bd4z49HVLdjp1G1XTnpd82eZ1LsVv3bWzycljbZWBCk91-__f-slNvT-k5p20Rw3J9R3DqSNW3GSx6s9OT6qZwCm6x3r7ep9-8K0iPy-D87-SC_fkLINhfvA:1psJd9:g4N6VCZ1toIKFZcpmMum7ob14GJ_W5r71SORTTkFb0Q	2023-04-29 11:39:03.402309+03
z48f6pk4js76v37pylhjdezlq339j09u	.eJylUcFuwyAM_ZUp5yoKCaRJj7vvDyYhA85CS0MUQO007d8HNNqWatqlEjLWs9_zk_1RWHHkXnuDxaF4DRUlKsWGPeWvTpGKnJOcVzm_RVXsMv-E7w-wZ1hw8g-Z4BD8yIPDhWsVNZotJkCecEoFdYTpzZbSTn7Rokwt5Vp15YtVaJ7X3o3ACG6MbBTYMzI0oDpKoGWqH3o24F5V2JM9FS2whgBldceg7WjT1LKlCojqGtFRRqMoGpRxtOQKPPCbqYqV8dVVnWxrx797ztHmaNJuq7uKAp1xcofLsKRl_sVA42HFtyach8X_Z2PGRVu1cuVotUQ-6HysC_i4nhMrr8Zdf6puREySxkLapJcz13Ma5IOL8O3wUX0DSRumpLZpM4qfMaLFYQrG7IoJL7-Bzy_8A-Ew:1pur5F:VJ2JbglJZue21IyXtTSPwbCn3Xc5AMaR2S34yEipvsU	2023-05-06 11:46:33.125811+03
8eo67x44xz357u9osjvlyo5ps9qwef19	.eJylUbtuxCAQ_JXIdYSMAT9SXp86TSS0wDrmbBnLYOmiKP8eDFZ8V18zjHZ2Z1bLTyFhC4PcPK7SmuKtYMXrfU2BHnHeBXOF-csR7eawWkX2FnKonrw7g9Pl6H0wGMAPcRoVdoL2DEzLKdTCdH0nemxMiR1tuKpBMApcVK2AuuWMVbrmBqhpmWq54NHUqasMNkwY7T63klOzIxMv6al25CpxmniZeEZzzI_4_cT0AivO4aklcEId76elgQAyX7bqSMlJVVb77fXgrEbZ2_-I7HR4NJnfxTFMyA-BZglO6dihT5wlpOQ2-duZ5gfEEOM-IMQvG0VUgl6kXaQPEDYfpXyCuPxDSbtt3kfO2u8fqnG1hw:1psij1:J-Ax3Fdu-OKQXDbKZ4CVvXf1JDJ5YXZT8VhWsHYxrJs	2023-04-30 14:26:47.205053+03
wrnffa8njdpdf839m73ffgh67j12kajl	.eJyljr1uwzAMhF-l0FwI-iEduWP3vkEBgRLp2olhF7Y8BEHfvbaSpV2zHA_kfQfe1JzOsQxlFPWmPjcDlg_1-FKHOxRS9bZ6U_1dWb1W_iLXJ-hvWmQqTz0ho-SyDDkyFYoy8d5jvDaonXF-D0TaSh-3VZY4HMd_u0T5cqf4TNPXrPM87X1JHxH9uK76Y2YZ3x_ZPwU9rf1OS5IWbeeJA1hqkNuuxU5ObKS1J0gNobcE6AJSE8B7lxtgshx8CoCgfn4BitZ5yA:1pu6Vf:A-AQ3qyBuFPtRNhFhoVIHtXGHlrKc81lbe0islpE1Bg	2023-05-04 10:02:43.824784+03
lje6daudncwqq8b5jjjd6hzfx5co7cda	.eJyrVspPyoovySzJSVWyUjIxNzQ2NjE3V9IBC2enVgIFc1NLUot0DaBiBYlFqXklcB0xpQYmhokg0tgITBqASBMICRGxQIgYGyiYGhgZGCrVAgCw6CMP:1puZtU:c0oIPf-KDZWFysSx0yV3csgmKYBCzseDdHOQ60NyWso	2023-05-05 17:25:16.382346+03
rhst8brx00j3n1kem0mxegg3prma0ifg	.eJxtkMFOxCAQhl_F9KwECrTUo3ffwIQMMLXssu2G0oMxvrvQNqvWPfAfvv-fGWY-Kw1LGvQyY9TeVc8Vrx5_MwP2jGMx3AnG94nYaUzRG1IiZHdn8jo5DC979k-DAeYhV6PBTrKeg1OCQSNd13eyx9ZR7FgrTAOSMxCyVhIaJTivbSMcMKe4UUKK3HQyJ518CpjbtQ1j-e30jB-ZXTBhfKI7u0LEMd0K3haa5xbl9aq0qNh0I-qHcPogqKDlFhjQ5oWtdpBAb6dglFBJalr_D8wJYjpG_KxvqUu-3xDKf-nBceBXzg7cLrGscq8CQ4I7_IrRT241vr4BqRSYpg:1pwzuX:exaqpPBm2bjXXn05YNMkspzZgoFg0hGIcuK3mQdIOF0	2023-05-12 09:36:21.408849+03
eoyx345tnmvxx0fh0dy8694z1prelt9o	.eJxlkE1PhDAQhv-K4axNv7d49OTFf2DSDO0gdREILWaN8b87LMR19TKH533mZcpn5WEpnV8yzj7F6r5S1e1v1kA44rAG8RWGl5GFcShzatiqsD3N7GmM2D_s7lVBB7mjbWywNqJVEJ0WYE2s29q0eIgca3HQjQWjBGgjnQHrtFIyWB1BRKcap42m0tCNKaBvU49UOMG77xCKP0p26vPpIuQOsZDxuKUUlDD5NPlcoCyZEkJj84qhXKEwLkOhi_9ovqRy_uLBClFbu9MjfhB7Q9q44zubYMah_Cw8L5zeuk4lz5OvU29zI-5CFL-RXHJHXdjTbXMKPkIBv_1-qRk3jAz1T6CD53KtfH0Dd6uVqw:1q1kuV:FNjbH4-j5_TvsdvQACZFcV1VXlndTphkrLELRM4LSkU	2023-05-25 12:35:59.361746+03
pshmhjjd01a9zi69xiapxgb1nck3ozy5	.eJylUcFuwyAM_ZUp5wlBgDTZcff9wSRkwFlo0xAFonWa9u8DGqnt1lsvxnp-frYf35WCNQ5qDbgoZ6uXilfP15gGc8ApF-wepg9PjJ_i4jTJFLJVA3nzFsfXjXsjMEAYUjdq7CTrOdhWMGik7fpO9rizFDu2E7oByRkIWbcSmlZwXptGWGC25boVUiRRr_cqujhikntfqWA2Ry6fylPnKHTJWclpyc_Rbv0H_Hqge4YFp_jQEi4oHNEkC406JiuHMS9E_1QsuIKzhF-BEVSIsMTcURPakJrW_B_l_F03hGvtGRfn7Z2hZl3yeffWwTHChpvBO4Oqd8WCT4jpj8FaRVmZx8lpDKcLLwyIWXL0kM-PZlZuzlfENST4bGwacwMZv05Z94L9_AKQ-tdR:1q4zeL:CeEFh2QkFozWT9TtAYCiX1tDfTD4SnJgAuHlpW5sVdQ	2023-06-03 10:56:41.256277+03
cks91bl9glvibyj13lqxs77rvougtgr4	.eJxdUMtuhDAM_BXEeRsl2MmGPfbeP6gUOcQUdhFUECpVVf-9IVB1t5fRyPOw5a_S0Ro7ty48uz6UlxLK0_3MU3PjcRPClca3STTTGOfei80iDnURL1Pg4fnwPhR0tHQpzZ5rrVqgYFGR0aFua93yOUiu1Rm9IQ2KUFdWk7EIUDUGA6lgwVvUmEonf3WxjwOnutdVppoNgTdEmXmbOWRUxW_oxp8pMvAHD9WTPIbvNPMYHwr3IPiMNk9M5rLI-_DOpP5MEP5z3NX9vnwZtqdC12k1D9yk_zUuUCS3f1ZqIY2oZAXl9w9D7Hn5:1q64eb:vBaV2tXWu5kSyCbGKROwj7RhFAKAj05wlVq3izOY3Pg	2023-06-06 10:29:25.067541+03
8dawryucoqsemzzunfpyd33ailnryfzl	.eJylUctuwyAQ_JXI5woZA47dY-79g0pogXXtxDIWLFWqqv9e_JBSq8dcltXM7OyD70JDol6niEEPrngtRPHyFzNgbzgthLvC9OGZ9ROFwbBFwnY2sjfvcLzs2oNBD7HP1WiwVbwT4BrJoVau7VrV4dmV2PKzNDUowUGqqlFQN1KIytbSAXeNMI1UMpt6c9U00IjZ7j2VkrslCnVan2qJ0qw5X_Nyzbfo9vobfj1RPUPAiZ4aAke0-X5WOyDQkSBQduKKlYpVZSX-SbbjHwS294NF3Q3rFDjqG9efIbH7GO8POvaItPM-zCeuM0d21sO89KUUM7ktlvsdIOvTRPnvHtjPL_3grIs:1pyXvm:nZX7mqcUhTtcUc8jvE1zzvnaRS38SilI-0ZzMP5WJjM	2023-05-16 16:08:02.764552+03
5ug4e5299ca8k0fheud8tafdilxct6eh	.eJx1Uk1vgzAM_SsV5w4lJOGjx9133mVSZBIz0qaAIGydpv33JQG1tNoulvXs52e_5DuRMLtWzhOO0ujkkLBkv8VqUCfsQkEfoXvvU9V3bjR1GlrStTqlL71G-7z23g1oYWo9G2usBG0Y6JJTyIWumko0WGiCFS14nYNgFLjISgF5yRnLVM41UF2yuuSC-6F9fZTOOIt-3NtM_JgQGYbIScybmLMY6Y6upBN-eYrFD7TZE1nBAUbs3N3AhcjqGMuI5DEnu6jHN0301sT0Y86X6rJf3Iw3-52ovDRaVN4_JTU4kIuztEqJSDOSBe9V2xuFsjHXtVat5cJisxDLbgYwvhbobqP9rzeSFpIImbH0YqfLTXZqEZ3XfQXn3-4UHHRqkGaQkwM3T760-OevuINUP3eBssXMJK_nnv23aW14B_JQ0WAiTh9wNY_hhf5ioHWw4vd-evXRPTq6pQ44ml6v3N5qeUa_dXLoZmv3SYefW-DnFwqw-bc:1pzygf:EvT1dxoKOCMyUDjirdzApObRZ50yGVf8lBhqwpzS0qo	2023-05-20 14:54:21.118493+03
qdoep3jzecqd45t7nurau3uhy53b9bto	.eJylUMuKwzAM_JUl58X4IbtOj3vfP1gwsqU0aUOyJM6hlP33ddIcWnosiNEgzQxCtyrgktuwzDyFjqpjZarPx1nEdOFhXdAZh9Mo0jjkqYtilYh9O4vvkbj_2rVPAS3ObXFz5NqqxiB5UOgs1U1tGz6Q5FodIDq0RiFY7S06D8bo5IBQkTfRg4USOsZzyF3uucT9LBIUrWjsx9b0ihA3rjYuN35H2v0Xvr7h_sWJh_zWEdxzKv9LgTBjuH9WOlFKS21eBHPGKT9L_v4BJ9-Eeg:1q6QqD:APtvaubQwJI0t6MBk3A6Q8UzN4fmAs4UCmr_7YI0QxI	2023-06-07 10:10:53.984128+03
pzfud9uu61fk2d4ochkfwzvujlyk589n	.eJxtUctugzAQ_JWIc2r5SaDH3vsHlay1vRQnBCJjKlVV_73YIBVoL6vR7MzsWP4qBnPV0ccOi-fibaKSQZoC05Q04yZjkSc7qeKcTTf8nC0dfmDHn-hKPiBgH3eBi1GYPKvMlBnTU74nNyL2KxLuiOWyXfrlZrI5n1Q9n_ajxg5tDN7q-9DHtkvd6GHjwGeeHXg7hdT6Pwd2EVZ-ExNBjxFCcnBOqCKccvFHgr07CrbZDwx-cGu4him2ehoxaJ84secM2NsS567Qvw_Ezo8M3pAkIet2JK_DXPhl1e4CWhjb2Y0Ga8UaAa6aP7pUrm5q1eDFUazZRZoSlGAgFa8UlJUUgttSOmCuEqaSShbfP5q4r2E:1q127T:Z845SyM9i-rFxCC69poTHsLEQlhyjoCSwJC3fJqBb2o	2023-05-23 12:46:23.174034+03
6x23y7s7aukcmb5vzbfvcsm6sgyk4iju	.eJylUc1OwzAMfhXUM4ry27UcufMGSJETuzRb105pekCIdyfJJsTGbrs41vcn2_lqLGxptNtK0QZsXhrVPP_FHPgDzYXAPcwfC_PLnGJwrEjYhV3Z24I0vV60VwEjrGN2k6PeiEEBdlpAa7AfejPQDjn1YqddC0YJ0EZ2BtpOKyV9qxEEdsp12ugcuri9TSFNlOPeN64FlqrMU31kqdrVXtSe1_5c8eI_0OcD7hNEmtNDQ9BEPt_PW4QEdk0QU06SLeOGSS7VP8n5-FeCsNpfzTF_xziVpfgNgxAqLm5wv8WyxT0HTQnu4CeKYcFKfP8AhS6vOg:1q2S1N:dGH6TP1G03ovblI_7rhsQ2qh-xaMLruEm6OOaH64oNc	2023-05-27 10:37:57.090995+03
uoi1i4c4t8u3xhrxbpje6hqljjog045u	.eJx9UM1uhCAQfhXjeWtAwMUee-8bNCEDjNVdqhvEJk3Tdy-gaVfT9DKZfH98zGepYAm9Wmb0arDlY8nK0z2mwVxxTIS9wPg6VWYagx90lSTVxs7V82TRPW3aXUAPcx_dqLEVtGNgJafQCNt2rejwbAm29Mx1A4JR4KKWAhrJGatNwy1QK5mWXPAYOumLCkNwGONeFhJj0mSYJid57_LO8qQF20xX_IgWh-_o6geygTfwOIZd4GpkOk-ZkSbvpMjv8TsR_RUxe9z5yq79cjPenQrRxqfRoYn3M8pCALVetm4rIqqa1KnwMKsfzVu8de9SeXJgLAwZpwfcLD596y8HugAbvi8xB_Dhvxo39MNks_frG64Hr20:1q3WX2:8jZrcvV5OZzE6oFkYIDYzr5s_vw-xH3RpsV62h-_yzg	2023-05-30 09:39:04.908172+03
ss8bgjv8nnxa7orym6px9f4cql0yommd	.eJxlTu0KwjAMfJWR37OkTR3qswilayNMy5TRCSK-u10q-PUnuVwud7nDuT-6POTEsIP9jNbSUqmXuhGmE4zN0rT9EOm3iOIvtnXr67Ewh7ZZb6GVzBPfSmLiKye9whd58ROP-esfIiW5QQb-czbVvxhw4pCnIbjos3c8xuKgSWGnDBqCxxPSw0Sy:1qB7jh:o0sV6uCCW7KJG6V2JtN4acww1oMx6Ut0Dts5RAD6Sb8	2023-06-20 08:47:33.288752+03
9q9n8ra54a5lv07kmrq0on8b8fj18c93	.eJxlTu0KwjAMfJWR37OkTR3qswilayNMy5TRCSK-u10q-PUnuVwud7nDuT-6POTEsIP9jNbSUqmXuhGmE4zN0rT9EOm3iOIvtnXr67Ewh7ZZb6GVzBPfSmLiKye9whd58ROP-esfIiW5QQb-czbVvxhw4pCnIbjos3c8xuKgSWGnDBqCxxPSw0Sy:1qB7jh:o0sV6uCCW7KJG6V2JtN4acww1oMx6Ut0Dts5RAD6Sb8	2023-06-20 08:47:33.349977+03
1e80jexwqt6akf38mx68xdk45z22b0ar	.eJxtU9tuhCAQ_RXj89ZwdbWPfe8fNCEIY2WXilFstmn670U0Fbf7MpmcM3MGzsB3LuTsOzFPMAqj8-ec5qcUa6S6Qr8Q-iL7d1co1_vRNMVSUmzsVLw6DfZlqz0IdHLqQjc0UHPcUqkrhmXJdd3WvIWzRlDjM2tKySmWjJOKy7JilBJVMi2xrmhTMc6CqGsuwhtvIci9zSjILJHCEhmKeRtzGiPO8NZ0ha_QYuETLHlCGzjIEXp_EFwbaRNjFZEy5iiL81hShPciqu9ztrLr-eLJWHvKeB1GgwUV_FNCSy_F5OXow3RUF6gsCCL0X8lq_qHATOKv5iOso7PL_dAdo6WJOL7DBxiN0w8a1DwuljySAuvlhqvOGQWiNfse8H5Pek4MIzrxk--WMJKsrEqtWn1uEz2SNCdC22IODosEIgmB9pnbVlekSRsOr4gUNzvd9stOHcDiC1hxdeOQkUB5NQgzLBv08xS49VkFww6QcnPvwy_YsZ9fAuAPbA:1q7abn:5zUFmlGkGuj7zzIbsWIxJ-QIrQDRto9vbTuJ0DCEjMM	2023-06-10 14:48:47.964419+03
bco9pfm39ss0ejwd4fpzlniqbbbz5lih	.eJxtTtEOgjAQ-xWyZyRjm0T8FpNlwBGnE8g4TIzx32UHiTh9aZpe2-uT9dVFo0UH7MhOE1e5CSghoOLEW-KSME8ESyl0hccccXAHJ3Z8FQfjocOvwiUoK8IDKQVxntA_tTHlH5NsYq6W67KPlqk2Tfbl_NqOGhzU6G2tb32HZxe28ejSGEt6Hun15MPqfwlwaFZ9U4NGj2g8JcqMF5ngQv5YoGtiw7Z7AG97crDXGw1EeLY:1q8yOE:_5tgUkJbsdCwnpbCTuo9h_cniYYvM1y1Kx9INDjwz70	2023-06-14 10:24:30.256501+03
05aaav3acadwhronrp4xod0o4s9becv3	.eJxljE0KgzAQha8iWYs8k1CkZymEqKNoxch0XIh4d2OgLaWbj8f721WoRyeDTKTu6rHCluaiRWLSpvvS1lkFaKg8DZ-0xVnPYV1K4O0unmmWzyuHIDGhiRrhoXGtF-9e4lliaFDgVmho81ehuf0tHCdO1zU7:1qFyoa:Hmb_U11Epscn2G0rYPUhHDjc3zA8uOCridMaPeSNdxk	2023-07-03 18:16:40.302533+03
6ekdwawigftv4ddpnoc6ra0l09xt10kp	.eJxljE0KgzAQha8iWYs8k1CkZymEqKNoxch0XIh4d2OgLaWbj8f721WoRyeDTKTu6rHCluaiRWLSpvvS1lkFaKg8DZ-0xVnPYV1K4O0unmmWzyuHIDGhiRrhoXGtF-9e4lliaFDgVmho81ehuf0tHCdO1zU7:1qFyod:XwZl94lLFnxvnb1rwbnnpiYzrGa5x6vDRnq3qOSzuVc	2023-07-03 18:16:43.747699+03
upq6mac3n2etce2fkp5su05ee04lx9un	.eJx1kt1OhDAQhV9lw7WS_rLgpfe-gUkzbQepICW0mDXGd7cF4u7qenMC50y_oSd8FgqW2Kkl4KycLR4KXtxdehpMj2MO7CuML740foyz02UeKfc0lE_e4vC4z14BOghdOo0aG0lbDrYWFCppm7aRLR4twYYeha5AcgpCslpCVQvOmamEBWprrmshRYJ6_aqiiwMm3PNCEiYrZ6uSrGLTzanPDicHyjg57pAePxICtB9xjPeU7fYEc3q_tQIvUO36zFelB5rO4oAmVWKUhQhqK4vyklQlIyzX6YL6mXlL9XVD3k9-JRbc6v9FhghzzEn1D3TC2Xl7g2mWOd_p1jYcIuy-6bwzqFq33vt9XlTPy9MQTucsdIgZ03OV8uRHMyk35U-LS0jB1mGCX1nGL2NMP8HZ-_oG7njIaA:1qA9eb:WKYpoKGQe9R7L8r-M__bdU2r3Sfa4xfkkM9nbGzr4_Q	2023-06-17 16:38:17.73852+03
dmk8bcbguxlry7et73yp9nkj5tdvnhhr	.eJxFjMEKgCAQRP9lzxFrSoe-JRCtLSrRkPUQ0b9nEnV5DPOYOSHYVfPCjqCDPqES8qHCwpLl9FNZqMpkoyMP5hjSLhDxbXcTyfP3F0PgbMjRwHEZ9GjYaPJjVkLW2NYNNhKuG-TeKXc:1qB7jh:i_G7ts4MZ0hQfzhAiz54WZXDKisOCO1EQuAg2gUGLGI	2023-06-20 08:47:33.290753+03
iipmz3rgd00zeyoz1mvksd0cl3qoo8ls	.eJxFjMEKgCAQRP9lzxFrSoe-JRCtLSrRkPUQ0b9nEnV5DPOYOSHYVfPCjqCDPqES8qHCwpLl9FNZqMpkoyMP5hjSLhDxbXcTyfP3F0PgbMjRwHEZ9GjYaPJjVkLW2NYNNhKuG-TeKXc:1qB7jh:i_G7ts4MZ0hQfzhAiz54WZXDKisOCO1EQuAg2gUGLGI	2023-06-20 08:47:33.354977+03
lpzdtliz46sa4o46k8o9i4srpapx0na6	.eJxFjMEKgCAQRP9lzxFrSoe-JRCtLSrRkPUQ0b9nEnV5DPOYOSHYVfPCjqCDPqES8qHCwpLl9FNZqMpkoyMP5hjSLhDxbXcTyfP3F0PgbMjRwHEZ9GjYaPJjVkLW2NYNNhKuG-TeKXc:1qB7jh:i_G7ts4MZ0hQfzhAiz54WZXDKisOCO1EQuAg2gUGLGI	2023-06-20 08:47:33.418339+03
5t7ykjkmr7y18h43f3983wboxy8yfzfg	.eJxFjMEKgCAQRP9lzxFrSoe-JRCtLSrRkPUQ0b9nEnV5DPOYOSHYVfPCjqCDPqES8qHCwpLl9FNZqMpkoyMP5hjSLhDxbXcTyfP3F0PgbMjRwHEZ9GjYaPJjVkLW2NYNNhKuG-TeKXc:1qB7jh:i_G7ts4MZ0hQfzhAiz54WZXDKisOCO1EQuAg2gUGLGI	2023-06-20 08:47:33.479612+03
9ywuh198oc6vwhcdpjqexe99ag27touo	.eJxlTu0KwjAMfJWR37OkTR3qswilayNMy5TRCSK-u10q-PUnuVwud7nDuT-6POTEsIP9jNbSUqmXuhGmE4zN0rT9EOm3iOIvtnXr67Ewh7ZZb6GVzBPfSmLiKye9whd58ROP-esfIiW5QQb-czbVvxhw4pCnIbjos3c8xuKgSWGnDBqCxxPSw0Sy:1qB7jh:o0sV6uCCW7KJG6V2JtN4acww1oMx6Ut0Dts5RAD6Sb8	2023-06-20 08:47:33.518752+03
ry8yp5q91f8141tae8g7swr1nv5jtpq3	.eJxlTu0KwjAMfJWR37OkTR3qswilayNMy5TRCSK-u10q-PUnuVwud7nDuT-6POTEsIP9jNbSUqmXuhGmE4zN0rT9EOm3iOIvtnXr67Ewh7ZZb6GVzBPfSmLiKye9whd58ROP-esfIiW5QQb-czbVvxhw4pCnIbjos3c8xuKgSWGnDBqCxxPSw0Sy:1qB7jh:o0sV6uCCW7KJG6V2JtN4acww1oMx6Ut0Dts5RAD6Sb8	2023-06-20 08:47:33.576978+03
ufoav1lhzoqx0kearbiewak1hk9xa6bt	.eJxlTu0KwjAMfJWR37OkTR3qswilayNMy5TRCSK-u10q-PUnuVwud7nDuT-6POTEsIP9jNbSUqmXuhGmE4zN0rT9EOm3iOIvtnXr67Ewh7ZZb6GVzBPfSmLiKye9whd58ROP-esfIiW5QQb-czbVvxhw4pCnIbjos3c8xuKgSWGnDBqCxxPSw0Sy:1qB7jh:o0sV6uCCW7KJG6V2JtN4acww1oMx6Ut0Dts5RAD6Sb8	2023-06-20 08:47:33.750787+03
c3of1r7hrand8x21gdtdohhby270op3n	.eJxlTu0KwjAMfJWR37OkTR3qswilayNMy5TRCSK-u10q-PUnuVwud7nDuT-6POTEsIP9jNbSUqmXuhGmE4zN0rT9EOm3iOIvtnXr67Ewh7ZZb6GVzBPfSmLiKye9whd58ROP-esfIiW5QQb-czbVvxhw4pCnIbjos3c8xuKgSWGnDBqCxxPSw0Sy:1qB7jh:o0sV6uCCW7KJG6V2JtN4acww1oMx6Ut0Dts5RAD6Sb8	2023-06-20 08:47:33.923535+03
cq0j8tnntt303sb78dq5f4gnsuqp6r0x	.eJx9UNtOhDAQ_ZUNz2vTKws--u4fmDTTdhB2u7CBYmKM_25bUBdifJlMzq2n81FomEOr5wlH3bnisRDF8R4zYC_YJ8KdoX8diB36MHaGJAlZ2Yk8Dw7906rdBLQwtdGNBmvFGgGukgxK5eqmVg2eHMWanaQpQQkGUvFKQVlJIbgtpQPmKmEqqWQMHcxZhy54jHEvM40xaQpMU9K8N3kXebLDt-mC79Hi8Q09f6AreIMR-7AJXIzC5FllpMw7PeT35J2I_YqE2-9yYZd-uZlsjgdVx6fRo433s9pBAL1clgtCS8IpT7fvJv2jucZbtz6VpzvGQZdxtsPtPKZv_eVAH2DFtyWmAGP4r8YNx25w2fv5BatKr2Q:1qCk11:nPyXPu0S9McQlc78BrH5KfuWJ-WzwzDD9T1TLVEyiek	2023-06-24 19:52:07.61978+03
cb6xtb6o9aqlqm1i0ylpnbfx6e9rpgx8	.eJxtjt0OwiAMhV_FcD0X_lzUZzEhDGpEcVsYMzHGd3d0S5zMm9J-PT2HF2nrq4oueiBHchqolCJVUWPdI6mwp5v0MLkQsa9I2LyX01ZPx0jOxWZ3IAVm3uA5Jnp4gGdbOsNOB2jiz3-EKDHX4AArZz75jwauV-DBxOCMurdNvPiUkG-sdshZxs0QUva_C_BRz3xhE7Xqow7pgouSViWnXKwk0NhcsPTuILjWovn7A5cWeh4:1qDeth:cCWqGNqWpn1s1-IadA36SOBWpa_4ixcFyLlFGP5XqqU	2023-06-27 08:36:21.550779+03
up31ir33g2y7i8bcra4t3v1rlrtg65lb	.eJxtjt0OwiAMhV_FcD0X_lzUZzEhDGpEcVsYMzHGd3d0S5zMm9J-PT2HF2nrq4oueiBHchqolCJVUWPdI6mwp5v0MLkQsa9I2LyX01ZPx0jOxWZ3IAVm3uA5Jnp4gGdbOsNOB2jiz3-EKDHX4AArZz75jwauV-DBxOCMurdNvPiUkG-sdshZxs0QUva_C_BRz3xhE7Xqow7pgouSViWnXKwk0NhcsPTuILjWovn7A5cWeh4:1qDeti:wpXEzpCuz0W8WWgEs-eqZWeJq_zY4SDcdNBCttS9dEU	2023-06-27 08:36:22.596184+03
c1qk8ebqgi7ty57v0yc28be12t2kgq3o	.eJxtTtEOgjAQ-xWyZyVjm0T9FpNlsCNOJ5BxmBjjv8sOEnH60jS9ttcn66qLRoce2JGdRq4KE1FCRMWJN8QlYZFJtqHQFR5TxMMdvNjyRexNgBa_CuegrAj3pJTEeUb_1MpUfEzSplzN13kfLVPNJtsdptdu0OChxuBqfetaPPu4jScXaxzpRaLXY4ir_yXAo1n0VQ0aPaAJMSFkzstccCF_LNDa1LDu7iG4zlL56w0M-Hiv:1qDeti:dX-nh-MMhee7dvFdA888ot0GjHNIs-3A6_lxEikAMwo	2023-06-27 08:36:22.782988+03
5az323lcb1t9mg559gbh416nj339trf1	.eJxtjt0OwiAMhV_FcD0X_lzUZzEhDGpEcVsYMzHGd3d0S5zMm9J-PT2HF2nrq4oueiBHchqolCJVUWPdI6mwp5v0MLkQsa9I2LyX01ZPx0jOxWZ3IAVm3uA5Jnp4gGdbOsNOB2jiz3-EKDHX4AArZz75jwauV-DBxOCMurdNvPiUkG-sdshZxs0QUva_C_BRz3xhE7Xqow7pgouSViWnXKwk0NhcsPTuILjWovn7A5cWeh4:1qDetj:bVNnWvIdbJJKDGslH7LE4HyamKDU_RLSpSKdVU_elvM	2023-06-27 08:36:23.969133+03
vzjnqhzntbwine4glwal2x0vekzer5h7	.eJxtTtEOgjAQ-xWyZyVjm0T9FpNlsCNOJ5BxmBjjv8sOEnH60jS9ttcn66qLRoce2JGdRq4KE1FCRMWJN8QlYZFJtqHQFR5TxMMdvNjyRexNgBa_CuegrAj3pJTEeUb_1MpUfEzSplzN13kfLVPNJtsdptdu0OChxuBqfetaPPu4jScXaxzpRaLXY4ir_yXAo1n0VQ0aPaAJMSFkzstccCF_LNDa1LDu7iG4zlL56w0M-Hiv:1qDetk:vb0uTycNsxnrV8XK0wYKLvkgsHwJ_DLQPZo-PheHvC8	2023-06-27 08:36:24.1083+03
awy3ib0yg8q7busm5w80esum2yzbai6k	.eJylUktugzAQvUrFukL-B7rsvjeoZA32UNw4gMAoqarevYMTpQrNLpth_H5GT_4uhubTppAiFi_F-8IU9-uU-il_xDpVk3eed5b38_TFc_bv8esB9wgT9umhn8CILk3BWQ8JLPaecoQomSkFE5IEFpbU2WXGyYaV3GANuP3Z5T-h_xhKN_SU15SrpLywc_k2eIyvF-1NQAdzR25ssNa8leArxcFoX7e1bnHnGdZ8pxoDWnJQWlQaTKWkFM4oD9xXsqmUVhTquiE4tG3IZRwhUfpeWrrYxgG8FcwyY4UsT3E-_ennDjGRgaTHLCQqudGG0c4J0jITd-6bmrqB3LD06yU3sujtAQml485wLpUhtMfjFa0FY7UR_7qnlClt2w-zvaoO1GwX1_fCNoyHkHG-wd0yrQ_kngNjgjv4iFMYfCZ-fgFKH-jI:1qCHD1:UKCmNlOCGruBD35MhMAOTnQw8ToJhk1YJzOSYBUUf4g	2023-06-23 13:06:35.400905+03
uawdp27r4c5i3zw8jnzbt98e4qulqve5	.eJxtjt0OwiAMhV_FcD0X_lzUZzEhDGpEcVsYMzHGd3d0S5zMm9J-PT2HF2nrq4oueiBHchqolCJVUWPdI6mwp5v0MLkQsa9I2LyX01ZPx0jOxWZ3IAVm3uA5Jnp4gGdbOsNOB2jiz3-EKDHX4AArZz75jwauV-DBxOCMurdNvPiUkG-sdshZxs0QUva_C_BRz3xhE7Xqow7pgouSViWnXKwk0NhcsPTuILjWovn7A5cWeh4:1qDetl:lsLEFtbFvxnzdiqpEFfcAbe5ZotGF7dbeUHaiwd1MZM	2023-06-27 08:36:25.241963+03
qo5fjs5l447qygqxl2w0ew9es9889q3f	.eJxtjt0OwiAMhV_FcD0X_lzUZzEhDGpEcVsYMzHGd3d0S5zMm9J-PT2HF2nrq4oueiBHchqolCJVUWPdI6mwp5v0MLkQsa9I2LyX01ZPx0jOxWZ3IAVm3uA5Jnp4gGdbOsNOB2jiz3-EKDHX4AArZz75jwauV-DBxOCMurdNvPiUkG-sdshZxs0QUva_C_BRz3xhE7Xqow7pgouSViWnXKwk0NhcsPTuILjWovn7A5cWeh4:1qDetm:wnU8ftfPhYrElPNSuGOuObvBNXl_HTANBrPuWksHpg8	2023-06-27 08:36:26.45711+03
noxeviehl33kiozyyph1zg7gw9wpxb20	.eJylULtuwzAM_JVCcyHoQdlyxuz9gwICJdKxE8MObHkIgv57_Rra2cvxwOMdiHuLgHNuwjzxGFoSF2HF599dxPTgfhXojv1tkGno89hGuZ7IQ53k10DcXY_bfwENTs3i5siV07VF8qCxcFTVlau5JMWVLiEW6KxGcMY7LDxYa1IBhJq8jR4cLKFDvIfc5o6XuO9ZgaYVrfvYhlkR4sb1xtXGd6TD_-DXCfcTR-7zqSe447T0lwJhxrA3q5VUpTTKWPHzC62uecg:1qIl1s:yjlqNWjTwyPMs7SF23jdm1SQkAfwB_11Z-vJpb6yJgc	2023-07-11 10:09:52.951219+03
ehdfy1qz68t91qedh8x09dtv98qpykmc	.eJylkctqxDAMRX-lZF2MHT8m6bL7_kHByLbSeCbEIVZgSum_18kEOmmXs5Ev0rl64K_KwkK9XTLONobqpZLV833Ogb_guBbCGcaPxHwaaY6OrQjbq5m9pYDD684eGvSQ--JGh60WnYTQKAFGh7ZrdYenwLEVJ-UMaClA6brRYBolZe2NCiBCI12jtCpNfZ-iR9vFAUvDi7Q9AlnJuakluw75-svkHpHuoCFBsMKaQpCfbJxsJqAlF6Skkjujp0PKp2Wksv0fzFKkbfr7wpUIa5T6aXvqNSq3abFpvulbDLv_gp8PuCeYcaSHlsChnDpHbwMQ2NvPSs64YTWv5T-g3D_TEfn-Ae7Ur1I:1qFAy2:rRjeftHHxKgvyGoiGLtvUqLtJv5eLcpLeJAXGrb7evI	2023-07-01 13:03:06.032567+03
tt20exjaei4lup97bu1ul3lhndots7e9	.eJxljMsKgCAQRf_FdcSk0qJvCURrih5kTNMion_PJIpoc7jc1y686w13PKIoRLmCztRFDZFRq-aldiKJkwG3MGjJr3MGALc7W8KJnz_ynkOCI1ZMXWVqy9YsbIlDqCCFPJUg1a-CU_0tHCduwjQh:1qFyoa:YxTHAwY8EmUVGuPFMGHjCz3xiebWM7ZQxMuXOl4hfRA	2023-07-03 18:16:40.304532+03
y1fklb1t2b1xivr7u4c32o2xt9zl0tqp	.eJxljMsKgCAQRf_FdcSk0qJvCURrih5kTNMion_PJIpoc7jc1y686w13PKIoRLmCztRFDZFRq-aldiKJkwG3MGjJr3MGALc7W8KJnz_ynkOCI1ZMXWVqy9YsbIlDqCCFPJUg1a-CU_0tHCduwjQh:1qFyod:whCMuvdg2Mo7QQBlYHMeXxv1mWlPjwohHytl4F6G7UQ	2023-07-03 18:16:43.747699+03
8ufm2rjpokmrtp99hqs3l0xmyyj0dpxu	.eJxlTtEKwjAM_JXR51napg71W4TStRGmZUqNgoj_bpcKOveSXC6XuzzFuT86Giih2In9TVkLU4We64aZjrFqpqbtj0h_RRD_sa1bX4-ZObTNeitazjzhoyQmvGPSK_UhLz7jSLN_ACTnBh5w4WyqfzHAhIHyEFz05N2VfKbiAUqqThplYCHBMc4FrzcV9E9c:1qFyoe:Nz2hQ6l0HEH_XiNJiHBMvHGk-ZV5dkO2K3z4li-PIJE	2023-07-03 18:16:44.962221+03
bxq7eat3m9tlq4h5lycr2pgb1zu5qjv5	.eJyrVspPyoovySzJSVWyUoopNTAxNtYDUYbJYE4qiDQxBLMTwaQRmDRQ0gHrzE6tBOrLSS1LzTHQhQkWJBal5pXATS3Kzy8ByqTmpCaXFGUmx6ckliTGF5ckFpUAJY0N9AzM9IwMjIwxlKTmpaAqqAUAfLU1lw:1qFyoj:RhR7XqqPNuxj2fJn-phPg9Tg1ZkBrZDrmgwCmW_NuMY	2023-07-03 18:16:49.330614+03
d3afqztp5wbhdr3qceehbnokl6a7zuis	.eJxlTtEKwjAM_JXR51napg71W4TStRGmZUqNgoj_bpcKOveSXC6XuzzFuT86Giih2In9TVkLU4We64aZjrFqpqbtj0h_RRD_sa1bX4-ZObTNeitazjzhoyQmvGPSK_UhLz7jSLN_ACTnBh5w4WyqfzHAhIHyEFz05N2VfKbiAUqqThplYCHBMc4FrzcV9E9c:1qFyor:J8q7VMTTXJDJVI8CvmqJnTSX0-K8C_7LHh7wBjwZxqQ	2023-07-03 18:16:57.602105+03
sbll2i12s6iiqjwbk0eden8r25xdnszp	.eJxtkN1OxCAQhV9l02tt-G2pl977BiZkgKllt5YNpRfG-O5C2-i6NiEncObMx2Q-Kw1LGvQyY9TeVU8Vrx5uPQP2glMpuDNMb6G2YUrRm7pE6r061y_B4fi8Z_8ABpiH3I0GO0l7Dk4JCo10Xd_JHltHsKOtMA1ITkFIpiQ0SnDObCMcUKe4UUKKDA3mrJNPI2bc60Iypihnq5KiYtPNUb8OJydGOsJ2yAU_MgJMmHBKj5Tu9hVifh99gTeofr3zVempIHFEm1ditYMEelsWaet8GGH8X2BOENN9xM_6J_WeNzyMZURyV3HgV5_e-XaJZfSjDhwTHPhXjD6sg1Zf35jdoso:1qHl3e:siofUe5CQszjf28QrZtNzHNLo25lVJ9y5H5kiT2MfcI	2023-07-08 15:59:34.5479+03
umzvge2hcp6lymzuqdqnc2vqx3ejg9a3	.eJztXVuPXLmN_itBPw8UXahbHvd9f0E2aJS7a9ad6bgNu42dRZD_Hoq6nHJbXkw0Dg6hpR_sOsfFqlP8JIofSVF_v3t599f716fX5-vdn-7-64sG81j-dv4P9I8tf8M7em3otabX9e_Hu59I_pfr__4O6Y-XT9cPr7_rIZ4-31-frw-vn54e7v_28uH1_XN5IP3mfx4vT3TfvLn_8OVTeYKZxPX59dLu33zM6-X-8-vlU5FwWumgrLbum7dcPzy-fcPtZ3-8fnp6eWwffn_58vr-_svn66f7J5L6-t67y8Mv9eMe_3r58N8v6gF_5Kend6q8RbX__az-8wUf-D_ae7_6gPeXz-9R-vrumr352V0eE5hL8I_55-x_vsZHfc0mwrtw8c5cwNvkLyGBc_YhwOPFPCb3LoGHgtjz4_3frq_XT3d_-vDl-fmnuw_X__n6xsP7l6eH6_3PTwTnL-7-_fXyeu-0DtapX58__3o33vP5_fX6evOm55fL432B5_Xh4_3Tx6Ll1y-f8Q11qKDmvrr18PLlA37xV_foUQy-jsGY6HO_ZcethLcIoNfLu-fr_fXXjy8Fyj__uQ69yzHm6girow3qnXQ7_v7gtNXlcSFqsNaUl3X4_pH-Abn-5too_ZvfNXvvX35axMk2nIx3mYEeuF-fhlMxfRCyxj-OgR64X5-GE_T55NxveYL_79en4eQHTuAZ6IH79Wk4BbJ7KeccZH1ijFNs8wktIAc9cL8-Dac07F4Uv5wtTm7wJ-OCrE-Mcar8Cb29ZC0DPXC_Pg0n1-ZTjORSnK0H7ten4VQ-lvy9mIXnMsap86cYvcwnxjiFw-4lBnrgfn0aTnHgFMSPYIxT509ea_HL2eIElT9RvNzIfGKM08g_Vcp7th64X5-GU-dPxnrBiTFOMOyelng5Y5xu8k8ynxjj1PmTNSYy0AP369Nw6vzJOBZ64H59Gk7Enyif62V9YouTv-VPghNjnAZ_kng5a5wGf4IocSPGOEHHKRuZT4xxOvhT4qAH7ten4dT5E9o9mU-McRr8KTuJlzPGaeSfXJR8LlucwlG_l6zgxBinm_1P4pczxmnwp5QEJ8Y4lY-t9XuBgx64X5-G0-BPyXPQA_fr03Aa-5-ik_wTY5wGf0pZ1ifGOI39Tz7L_ly2OMWDP2UrcSPGOA3-FDIHPXC_Pg2nzp-slToWzjjBsHtG_AjGOA3-5EH8CMY4HfwJJK_BGKfBn4Lsf-KM0-BPKUhegy1O6eBP1kr9HmOcOn-yOolfzhinkX_yQfw9xjhBx4mHHrhfn4bT4E9Z8hqccRr1e96L3WOM05F_kr4EnHHq_An9PeG5bHHKN_wpCn9ijNNN_kn8CMY4Df4Uk8SNGOMEAyfpx8IZp8GfQPotc8Zp8KeYxe4xxmnwpyh9sTnjNPJPMQlOXHEyuvWPKHl36b_HGSfbcQpZeC5jnNyYT0HsHmOcYOBkOeiB-_VpOPmBk5P6csY4HfV7UrfMGad4zCc5D4AxToM_BcdBD9yvT8LJNP7kQwgs9MD9-jSc7MAJhD8xxsl1nHKWeARjnOCYT1JvxBinwZ9k3ydrnEKbT1HO-2SNU-VPOkOW-cQZp9Tnk8nCc9niZFv9XjmXFQQnxjiN83ODFZwY4-T6-iR-OWuc4K7G90KQ-j3OOPlu96Ls--SMU-g4eSs4McYpDpwkn8sZpzTsnvBcvji5zp-SNuJHcMap8yebpL6cM051_5OJOTrBiTFOcNf4k5f6Pc44-b4-WTlPjTNOods96R_BGqfYcXKyr4YzTqnbPROk3ogtTtD5E7LcIHkNxjjZMZ8kT8gZp8Gfgpc4LGOcoOOUpW8OZ5wO_iR5d844Df4ERvgTY5x6_slmwYkzTqnPJ5eF57LFyY_9T8nLOSiccer7nxIk8SMY49T774W6pfpsPXC_Pg0nuBvnHHPQA_fr03Dyd30_ocT3OOPU9z8lLfs-OeMU-3yS-gjWOB3nP1nhT2xxCqN_eZDzCVnjdOSfrODEGKe6_6nknyRPyBknuOv7PiUOyxmnln_C-ZQlvscYp5F_En-PNU6jfi9FsXuMcRr1e1biRnxxikf9Xj2y62w9cL8-DSd7N_bViN1jjNOo33NO_AjGOEHHSc69Y43TqN-LSeweY5wGf3Igdo8xToM_BTnfnTNO6cBJ9gGwxSmN_JMHyWtwxqmfn-uN9M3hjNM4P9eBxCMY4wQdJy99CTjjNPiTZqEH7ten4TT4k5yfyxqnwZ-i-HuccTr6R3iJR7DFKR_5J-ckDssYp5F_8k7iEYxxGvufvOQJOeMEd61-z0lfbM44-TafvJN9NZxxCg0nE73gxBin2OeTNcJzGeM09j956V_OFierj_OfjNg9zjgN_gRyvjtnnFyfTzrK-sQYJ-g4Wc9BD9yvT8NpnP9kpL8RZ5zG-U_4FgZ64H59Gk6dPwUv8XLOOI36PS_1e3xxMqN-z3jpQ8UZp16_Z9DyMdAD9-vTcBr1eyFKnSVjnKDjFIPgxBinnn8yKYofwRinm_yT1BsxxikOnCS-xxmnkX8KEjfii5Md_CmGwEEP3K9Pw6n2L89a6mF54zTq92KS9YkxTtDtnpX9Gpxxqv3LrY9O-lBxxqnzp2iy5DUY49T5UwQjcSPGOHX-FIITu8cWJ3fsf8qyr4YzTj3_FCRuxBqnzp-i8FzWOEHHKch5apxxOs7P1Rz0wP36NJwO_gTCnxjjNPiTtuLvMcbp6B8h-5_44gSdPyWtk9QtM8Zp7H_KXvoSMMZp9C-P0n-PM07Q7Z71Uh_BGKeDP0l9BGecwsAJJK_BGKfj_CdZnzjjNPY_JfH3-OLkj_4RMUnciDFOx_m5kYMeuF-fhtPgT0HyuZxxgm73IMv6xBincX5ulLwGZ5yO83Ol7yhnnGL3I7Scc8wZpyP_JPEIvjiFgz856WfJGSfbcbJecGKM0-i_B3K-O2ecYOAkfgRnnEb_PamPYI3T6L8Xvfh7jHGKHackfQk445QGTtInkS9O8aZ-z5T1yTujHHV4s8krTb0T8T9VPTggeOXyzN1YFNNKa_1__PtjtPq9T_s3aHNU2UUa9cYYZWk9CVY5aiDlvKrNv4xTMc5cgiWh7TTpxrh0ZVhFVEEy5fPBW-Vpz4oFHGq2GBqXlMmzbSyLYttpE-5GVoyGqEkq0X5866zSlIExLiuTqhuk_DQpsyi2nTaPnIgNZOhiUrXDS44aTV2Z-ilHFXN5pylPNot5rMptp89R-2UymT2PQ4q-GxKoTH6eCUYB7dgwVsVpCGlRbDttHhVaoU5Q_OWWFBRUPXwdnLJtGitnZ270ktB2mhw1VJmWY4OvlDE0SzW-ogNonce1mUp3DLSl5psnW5TbTJ_pZq99NaHoIHrKKju0ddaTLcVJbE3VttJpugqtiW2nzaMiiTpMeFDIter8zJSzMgHdx1BHmJ5WP6_IbKfHY8cFedaQAacoUZmMyqDTGIyPKrny_ejt5GkhxKLYdtqEY1TSWo7z0VFFAjJAXEmKCUCfW9VuG7asKTM6syi2nTbH7gU0cGW-6oC_vNx0ziGJoeUjuLZ-ZHR1ZmxmTWo7XR47DKgzesDhFB3RQEgqUHTeOqNCW-uDqpuxvhmai3Lb6fPwM8mvtjEqR73MjQakMOVe1qpuh09WgZmNsjWp7XR5eJrUddKZqDJFfqxGZ4d2mOWk2tfn7_DCNanNdHlzon2GxrJViLmOK0-HCAeL9tDRDFbJTh96RWg7TY5oZvohz7_79Ukx_Hx4sJlWNghe2eoooYOfyaYaj8OXVi2fVD219O2DLYptN-rhbsRKyZ13uN6TVTW43icKHOOiVY9pQwJaSzrfPtea1Ha6HJHSQNVEEHEUEVu1OJ48DTYTAA1reeXL-Ju59Yti22lz1HhHKIr11qtArL349bGGP9BnqocsZBx1Mz90TWo7XQ7vNcdi1QLOyVwJJy70gc4isxp9JgqPlBzH9JieRbHttDn810AxFLRuyhKrtOhIuZoLjValWN-IDzYLhiyK7aVNp8eZDlYHGpsBB1ld2UuOjXRgjVPwmzoa_D7pf5dOT9fx0Q-Hpm-IytQ5q5WlSnIkTInIGLIqPT37aUVmu7E6fM9EaQ1kRioBLcvoAWlaXWzUCiw5PoWNzpbqRbHttNl8z9LtscaoEq4g9egQo4A6oaGBVLly-7Z6fzMul6S202U_uQ3XY_K-QwkfV61oVeOp1pu2fPsy_mZqWRTbTptHjp6ixjHiyCIVAC7V9Z4FdHwoFuj8dwL0i2LbaXN4nxFIBVFlqqGJuH4YmqQmNaaYp_74vy6xnQ57h32rKfIO6NMY-uVIC9FlpG_FxcTRIEs4YadpuyWpzXR5cwqzJVc74vCyVLFZSmlSpd5gFdAK8r3nWpPaTpe9U71tZbAaAto8WpgtflEgS-dsCwplq7ybVoctym2nz3GisSVDZ3TKrcQDbypPN5ErqkAuIuDISzPPe1VuO31C16ersR8HpeKw6CAFwMlKE9iiXmwtCEd_cWYDV-U20-dxAqOpYZCIQyoRb4dQ7CGt1iXvTpER_E_Is-K5RbHttFk97ZTRM6plm1B2FpCn45FmkxIA7aGnBwpZ-TjLSqzKbadP1_WZaarGiIOLEpuQtap75m2pBaGhZ12roP1mdK6JbafNYTstlSTlpFWsSYgMrY6hLNGtWgeUhdmkXRTbTJvuJs5JabGAgyxRfBIMLi1Euq31fQ8MqDh9sEWx7bTZ_U5c16l4BpmNrRszPK4eNTURg4pUMIs6Q_9y8mCLYttps3udtlbBotuEIwooHO96facrU5WcRnwRpxHKVbnt9HlYTqIvaECT0rZu7cpta0ZZn03IbZxNz3VdldtMn3BjO8nxdsm0zZa2RMvb7sOgTGqpMzstil8U206bB2enARV1Kf8iI-jwKShgaW1UjtzI4k9ODzdbFNtOm4Ox131CoSTKTE2IO_S76VvxVaVO6Au5aSBjUWw7bZLlLCfH1_RQKBWJhqY_4FPY6u4kVc_BtuhFTrdaL4ptpk0_7GbwlV_q1KqHPLIZqGXdKpAHZXB9CdPdcStC22lydPSqi4XBhVdFGldRe-QytVYWBxZFLr1RMK0fXJXbTp_dagZPRQXoKCFLpD3BEUB52swJxqMDXguWcMbOPaQ1ue302T3OUAO80XsV04_olfXjPulH6ZY5FuHG6lKS0uNilHyl5yW1QYnLbHCwEilC62pnQ3RRbLORfdtLkfYhGFMKPsjbjK64RZUQAL4iRl9qvabL2KLcdvocPQ8NGctY9hfWkkOkmJ6-1TqvPGU04XvDbFFsO23C0GatuzFOBVrRABlQpCCyRX_TkkOPvmiYNqxeFNtMm_Hob1trQWNQqXKiqCDVYiQVakgFFTZvgrMgs50eh82sR4LhMFWhFh0l08hl2TVn6v4526Iibx9sUWw7bR4Ws9aLmLIwk4pLap3qPSxaPCC1lF3wdj7Hl8S20-bwVD3tWITCxolMWnD4itwcJESe3uiC8tMNxotim2kz3XS0IxJknGn7ikePJSh731uZtp868ktC22nyYPihxvFQKbY6ia6l1AvZzBTyxOkK06PGFsW20-boaGcpg-Z92dhSuzLEVjRjqCkQtUzEBwvTZg5rYttps3mZMQf64bEUZ1MtbWkPZKjWoWwWrE1ErFFhejzAothm2syHzTRk2VCnKtZtbeBxolYqg4t1pdxl2Z6eyr4qt50-j95M1MjCx6QC-e-uhDhr48SsG5lBq2jyzG1cFNtOm2OPka9B99ExrXQPqU0ZjEfHnF4ltI9p9tiLYttpc_Bzneq0T8qH3rhKkwk0oWwvoGpbUJC_tyd7QWwvbYK-qf6kNpPJeQVk7dCXb-nLMtxMzTZB6_f59sEWxbbT5qj-DDVlToE0SlCWeveaAo4WPfKioFg447wb9ZLYdtocefhUA-ShNFWrJNuh60jfmqAlhtAgqDA982VVbjt9Dp_T0-8NGblL7Wuhy950KoU1pi3ZaB_TtOHSothm2rzZc5SoSgTdcBUpBFRWFlsjGsoRV6J91dMUxorQdprs1UtBUwoHSjc6iiSVwk2dakAjotWr3apVHclvH2xRbDttHjy9tpB2-NNru56EK3KuFYc4uIyvdXO4rEwrPxflttMn3I3oZmWBpQyWdrfj2CLu7XwPZCClmcfjVoQ206Q9ckG1f49xuk3OUDqf0w4X07Zk4DibN-NfEtpOkyOyWesRTLCtlUdObccV4JStR24EdL6nGwpXhLbT5MgE1bijsbm1RkB_25s2vKxtvaXN3FSuCG2nycHLgbx1nJIq-ZUnf3v94z7pR-mWORbusLS19XTpEqCpPtaGsu-68p7SgC61yT6PkayJbTayj51JofKmUj5bt3CEEhAut0ohcuOVKpt5meiC0HaaHNY2pKoKpywx85JAh8HMLTFIAyrMW1iviW2nzWFxI42eaEFFiuKVVqg9lW5af3QcZGZ6hOei2GbahJsaT5qd6KSqWr5ki4LqkUa2EEsKaZZs-qw9wKLYdto8ajxrh6CiAnoVc7N6oTBy2pSZvnOAzJLQdprsNtPWNaIMq1YZUnqi5d6ZlwyqKe1Apn3ql6S20-VhMWmOB_zlrcmvie3QwnrsI0WLjapNHL5Zf9bENtOmv8m61yN3cGQlKpTBkRUpWIIuTqSRZXXrE_DNY60IbafJYS1r-Vf2TmVfhxq0SeqMwZUYqn7sNDC8KLadNoeX6WlchlhsH93UXkFtsGC0CrULNa4oU-O3KLadNpvNjNlNY2tyPUPgt73rB-IUDs5vqeoYbQFAq2UIvh_UF-uRAN-p816R2Wy83-xOqtU6ZRd3PVUCnyG1ZanW0OPSVVPy35qOf12GrR7_8o9_Ah-1E5g:1qF8jE:vPv8-9ECtUjnk3J1Hp22f6CPMoyXX4DKvfkbQwEmnyw	2023-07-01 10:39:40.301738+03
hvqlk9qdn9hbkzjiv1wz9a4yroer1qns	.eJztXdtyXLtx_RUXn50OgG7c_JinvOQLHBeLEqkc2fLRKYlKnErl39MXbGxQcapcsTqzx8GDxJk9Q84M1gB9Xav_4-Hzu98_vn58_fTy8JuHf_4WKD7L_5h_pT-S_E_v9HbU20Fv2__PD7_W3__Dy7__Fb_9y9OXl59f_6o38fLp5f3rl4_vH5-fXp8ev74-fXnlvxQKhAopJPxvT3n5-VmeUJcnPD59e_3p8dvXly-PH-XB7669e3r_B_ut598__fwvn-H955_5770DeQqMR7_CP31-fvn0D-O5b_7AT09ff-Lffnn30nP8gE_PjeJTyc_9Q88fXupzeOmx0rvylDE-UU4tP5VGiOl9oeen-NzwXaNM_Ec_fn2cn-aP_C5--iTLH7575Pnpo16P311__-2LrPef-42XT69Pf-b6Ly9fPn5-Hg_o8r0-vfv08vjyp18-y0L_9rcG2tOJlmFjOJFdaStyv-JFD_LOqPIvUm9804D_e_1BP-B-jBFaTnyrEhDJSyBBDfIpEv_8Ea_xw98zhL_4WX_uub_79f8SizSxqNHhcyWGAvVNI8QiUBQg_QIkSMXjFe8WCTyQKNljXTA1aD0rJhFilpeLfArWVPUWhJgvsPyXgYMOODp6HFKpFeikILQGfNrzrR7BDvrK-NQLLP5lwMgTjOTxJeVvfwpdD6VQ5QUyYC9mLlzQv1sgygFEzS67IhMfUroregf-Jy_XocWkoLSWLrD4lwGjzl1RXT5Xz2yzuxpv9pZJXo7xiSiXEGrDCyz-ZcBoAwy-5fG5coeiWw4b9CxnVGR0xr7IfXtSEwo844tGHlY0UgFMsvJsuZOhwwakmOVudIW1vwwWM74oLpYbBQK1Cnw-sdGWHRJTh1TlGju6JW6TscAxg4yMLqcUh3lZPSbeIGw8ihoPhgNlT2a-RPukWuCgCUfwWJfGlsHc2KguNBvtMrIguHFYcND4ouRSioYBP_xzscWI6hbUDtU2YQZqYp1SgN6vsPiXAeOMMcgjxsiIHFnoNqiZjYdcS4kgq63iB2lnCFc4jigjBZd1SQXB0pAcxkBQ9DNCR_Vxd5bwOzSOMCOW6hKAE7tMTc02ERTNF1beG5q6ZZNOaQd9Ew2akUZKycPNjAWK-lAZqp5YBEGj7sL3NxALEDPMsDDsR3-uzmGdps6hkJonsFRYYtu9cVhwmPFFq8XjcwU-iqx6hFrhY482GyCUNxALEDSBcPH0Y-NQzpJPtvAZuu4MPploA7EAYaWLiJiDSzKK36xW8BBCMRNhMR8CulR07xaIcgDRosuOYNugXpJkxtVL45BP6xfsRm0gFiDqAUR1WZcaQoJa1CMg6QDRUmqizlfVKGGGnDzC_LtFpM0zyiU9h1SBuqJQ-H1HsQ8tc5whGAVoYadoJxiWCKTSeq8uX9LIO0IXvrLrpF7CrH3nuHfFAkQ6gCguhhTraC6IHF3owcTebaOg0ASXePJuocBzT3hUkVLJvOJaoojs1xooBZLG2rGyR_WXfO7_N2jQgUZ3yQalNMqrt17guwXoaJcq2SX4S5GDPOsLAWtWzJCy5UMaXRG5myFxBB2p-yTPOQ5vap0iFij6coUjP60s6WO7e21BY0YexeVbmpFkI2iqvJQChKg3OQhBspCQ6u7rXAA5A4_uYtc7dkZB33bJBMH8LQYHkmar2PWK5JGovFNEyog-QqfeXLgZBbLG4xyDN3kthKYthhWiS37sboGw6COXmtHD-YxHvpCtBR2tzgJIgb4bO1cgcADRsLkA0aFW86HMnSbeCQIIX9--1AoEPRxNOtGltpTYOltrsyVI8Oh5hpp3_LcAYd1SEo27HU3Z2tU6WQY9VittdNzGegGizKPJp7ZE7M3qrmNbYcW9OGpLHPpfYOEvA0Q9d4TL55KEoAFRdMtlKN0AKS4U2rsFYrZHNZc-kJiH18Q_1VsiaMFshE8H0J0CUUccwca6o8e6EIdwWf9yagGKFlojcRChdT9sfGnXXBc4ZjSBxcOC5tzYi1WbrQ2EGmZXNhN2agn3e8cUCxxHTFFD94AjBSDtSxM60iAA6HEl_VMuzvPdIkETieLhy-bUIWg2FpPYCE06VY4oojagN4guZP-7hWN2S2F1gaMlyMoqxnocSuwqHD0iCXrdJfAFjoOKUcyz-uFw1MghnlrsHNiAWOGVzyi7xoZ9O1UrHLN-QS7s-1zZb9IjCvmIMuZk7AiktzqU3aizojGLFy14ODcxCm1PblU5l9SG1NGjwz6Wy4a8UyzaIGJIIcnFv8XEkV9Xc5ESEZtvWf1eOttvDUIgbB7AiscRb7SMLi0itULRlY_SUahp2pZHkgTjqC3devUvg4aFG1LUc-lki4lGf2eLUPtQqTAjTlvK6C0W9HAkRpLH50oJJU2ub5t6BFQ2RkUOQzQ1SZA3UWbF46B-V3TxqYhtdqzW-xyg67kUSU4oPapoC1S8haPMo6p7RGKMRleBFiEwWeNUhKSJRDmxttVYoKjHzjBRuh--M_Kh3FJHOYkdXqO1Hubk1kt_GSjasSuKEyeAVzxdMS94Jwj1MwDx-eZGalDVeNQATc8r3j-xmtTO6CC59eJfBox0gFEveYxc7f7NcMIDJ3Qx9qKsWrVpq7OfpWEIR4uoraayadJOoSxg0AFGdumIjZEx0HaeLMwa7f3kSEW934RA-Yrm52ZgzDpIc-ENcDyYOTTU5qoWEvSi6ha5iRNsJOa2W61WQE72uEuQEEODZOzkwpG6vhpHKEqVTQQxXdGO3QyMWQfJLvWhhPz1V5GAKFQn9b4bjQYHjlZwG44VjZPEgR7f0irtI9ZsFfrIZ2GIozbCdry4CO7eJxwxTE2qUnyaQkMYyavcoethiDjkkCqQy1fgbrGYgUhzWRcKQHpO8TEVyhDMi9U6f-znrZf-MlDgCYXH5yrs3nZznTrvC5PQ6-xOaX9PLAOoWy__ZeCgaTRc8t9UO2RVxRduf7WUL4bB8m9s312EXu8WjhFv1E4uQsRpcvoVBN0ThQa_JrVRuL316l8GjRFstBB9mE7lnPpjkumifqvnFLTt265I1GNf-JD_iIO8ZgrE1CF1K9tGQCMZcEzoYqzuFo52bIzkIi8ptXNTAJeJJ3Q0XxnRSiSiXdKUd4pGnByPSi5ds8Tff5vjlzqHgDq_L-YwZPaEirMDvxWO2XMVXfo0c5TMh7xf5IDPFPRilR5d_SQ46um3Xv7LwHFwPEp3Oatqkz4fzacHId-Y1AjDkW2fbKLHWzjoOKwSukiNsAMF1k0U2XoPmeIY2fFtJiPW2KrvDbIgctQ4UnORV8tsuZMaDaw01Iljp5FdR0hxe7oLGjPmCC6qrKkMoWgOPkIy7rLl2BF89BzuFol6IJGyh1vVJD9l8YUkSXTtMdDg2rDhaJt0s8IxYo7ac_YwHEK6SToACPkWGXW2NwgKTByDH269-hdBI82Yo5HLulCLIxXCru5IoUeJQ9SdS-z27iHJCxqTVp6Sh9HIvUJUUSQkcZ_UkIQEQSXDSNQv9uZY4JhSVT5j9ioK78zqizjkwoQNZcOyRQzUhXx1t3DQhMOFckFYwHohkkgtkFELZNyAfp42hmDeevkvA8dkepCLKm7J0jSlzps0JdjuYBSMnYYQXby5u0WjTDSiSzzOIZ8dSwHSJac9XBaZyftAFwnQGqT8ZOM52hhek4TZrMYjRbb4V4TrZnC0hyOPGFziD9HFVcxRJjGaBkNjYJRDyAfZrnmcaOBZ8_AZliHTMC11HDNH4hoDChiakxG1Yhe9oLtFY8Yf5CJ0Tk1mPyhdIEpDlZY8GCFSHWn2vra8-orGWfFwESXMRcYvaouVFMtV6S22PlAQDsHWxFjhoGNzBJekBfYI3WSsRHjPDEcSCT4tgohB372gCxxH-NGyS-sZ5jKo_eJMNQ02YmSIFHx2ucq24wsaM_zILgQbzINnznGIkdukeK6e9S48vUVihhvBZTZGiXGIgWJjLLT0lIK0WGngwTi5RDl3C8cRbrTgkj0S5R5KZiFw6O51mVij1lyoBdvBnWjQSSt3EgrNIrmgraDSs6CnYmO_NtvQcXRplbhbMBZauVc-17oPU4tDOlc0jW2IUxlK07de_cugcYwab5U81iUXGqJuWApEm3fGh5clxRLvls1YXuGgh4N25qIWg0IX0G6eJAwCy4dwkDEkdcvosrr18l8GjmMEYA2XnF1ytfs3w2kq7GaXpl1hk1t6pIGJ_x2DtngThSt-M26GxCSVo0v2qsY0TIYUz6nhcZSpj9XHbLpbr_5l0DgGedSELtkS7NA0Lk8SAhrxhhEKxhSEVrbnO9HIk1PO7qjL56I09Hk4-KgaARLHhFEDE9k2V1j8y4CRjq1RXDp1KaVxGKUsXdJajOLtErW3IfUx3uPWy38ZOI44JPr0BuYQoFqjdBLKk7m7yC5wG7tja8OscNABRyefqkcYGiQpRzbjxn2SHhM9vqBs2aQVjckrR5czXJpBiw27VpUkwUWG-yoxkPdGcmHt3i0a5UDDp2-WYwyM5kkBFnNrrZ2oQt3u7YrE5JU7nVKhsgtrdJsGZAxN3itIY4yETzr5buGYHA90UcGNJD0jOtQXwQbiER9Xxcb-mjm59dpfBIsyY43so5iTWge0kkePQ_VYbPqYQr5n3LwBwxqsOFLuTur4NFTXk-Z3NavLsQbZLMGw4_C3cMxYA13GmxaR2jPMI4NQrNLRwDT-IkG9pEj4zeCgeVS5lOZKbFDLFc-ju0FojirvLs0lVdIh2ijNb-HoYKcITeMOUWjfEiUrHEe1I_u0amYp1GrJtkMeYeGY1SXcnB2BLFDUA4roktKlxiuvMT_KGHlr1s2iAmdN1Hsi8Fs45uDy5KK-XhrHfHoEUqwcgqgnLMJ7emTxieXTfHencNSj74rjc595gsihR7dWRJnyqEldPqtQ9yIjFLYkxgpHOuCoLtTNhhWqaRqLQU9WMM9jClGS4tRunl7gwAOOkjwOcSF6JE0kSsnDhkILJW2EJg3IZeDq3cJBD4dcqMsMczmimo7jjmoxBISSoSgdqm-65lswZsWju0RuJVWgpi8S81j7FNjdtaOKfa6NxoLGrHj4tOwK50apzMhbxFpE2WpoqqzxEbZzVwsUs-Th0-KPncRWaIeoDqS1xtAqGXcbo1K3AN9bRGbVo7p0AlKKYNqXqcr0bA0BKXAIKPuCDUjbR9VEo509VlhdSoJVwnCT7OEzisyeh3GtQXbxHe4WDSt89BACudCgMo1ZKcLzT-pdCbnAJK7i0Bu79epfBo2j7pGxeaQpsHY233pSlQhZE4UxHvJiEcpmbK5o0HFSVRelSCRia2GCFyLcah0lhwK4iF65iM3dLRwH1SM6UQgkBjdieZCoz4iabdQ9YmR_d8OxwGHMci05-bAEIWYz49CUTxAD4yOoVMi7lWSFYtY40Cf6ow7GChVFfNMGii0P4QsMbEmusPyXgeOocWQfyTcMBYJZ8SA6-LY3ZM6vbhcoWwHjRGOZWO5To8YoaXOz4h1CsXlDGdpotKo7O7KiMbnlsV9xXa52_2Y4zTGCwYUFI9xAE97gFwDqVjY_1HvqkMy_9epfBg2au8YlXpYREkgWdbDDa1SoztfUsxDXN-2kyQLHEYmU7MKCIVErMQEf9rKsFBxpTtusEPZQxxWOk1vu0-LDZt3GDjEEo3V3sM3ZEetXWPrLQDHJ5T59NlkIgcorELGSPgTAI2Sj4xDkPdZxhWOOLC8uqiEyry5pkVasRVC70UWezwTgtut7gpHOgeXs57hQ_Usd_YdC9U8WFkpPj4uwwN8MKgfLPFb02CJSjgp4lKO6voagUvXsyoAusox3iwaeaLikTkoc0roJ8-BsagEkWo_PHgn1Bg060Gguc1YwSw5RQ79eoWYrR0kSxWQsoe407wrHSTLvLs5VDkBamEXiA0obgiXNG5sZlT1p8y0cs-cKfTiDEWwoQmrQqunAQVIaNX-Mvg-qBYoZdpBLabDUNrxbSnV0-IiT1dT3FUWGPRBqheMcJejSG0oSiHcbBIxHP-JZL0zjwVsv_0XgiGfgUV36AkXNOJg3G1WEUSYU2DHV6Yqxx82AmLEGuUgopTqqTjqkXDZhBVRE-KeLB3e3SJxiVi7fUCRI1lNVxwxa3iRRk-hlUD5uvfSXgYLm6eTClY3SkpvHHlDDxPeNKVv26bQCMfurmkvJjw-lNqg0pN0L0hkq-3ArtH4HxFHPiD5iUsiOq454jgRovbkBmmYJ-YbRnW699pfB4mititmFcJTwyHskaKqEX9h50qm_ewbzWyQmc9ynZzxFKGlE2SUac6NplM3h3SVW_iJIpBlPpOAidlhzOSZfV_ZojcOPnVHRdsO229TfwnFWMFxIAzVHiBpQU4-Q0FIe9WhYl7rfhmOB4wgtSvXRruoNYhtD1th-KzE2NsjZeGcceFxh-S8DB83d4WJOS0oDBOwdLNfCLwrdhmg2SJuovMJxBBl8bLnwzQKvOJmUt7i5KpRbIWqgIVXxrf4ywcBpyEt1aeBv7DlpvSKzl2tdO7xD9MCqu_D9FopT7N6lDaFKj5S9BmSbQVfZ37WRmegycPtuocATCpe5A-w6WUU1ACptPCIU42LiyE3deu0vg8VhvUt1SUsUgmYSrOxAmcXuYxREhbAnba1QzElbySU9mPiIIo0kOI5hl0reeatQNSmSwUcI9k7BoGm5a3FRqi1ZRBRIN4ZMv9bjKpZRRZL4fPMzVjgO612qi9YHGwVIOts3ywzZMaAmDvZ4S2xQ9lG1wDFDcPo_6efjvaJOGwFeclbmZXA5rHlr6NKmEzi-0NQtvxSQVTRk62juGMNQ-r718l8Gjkljqi4atQnrVFSXsVqyNaqQl_TjRKgbjRONY_acSPK4DCSXpnPrYRMRGNWzRBpDsTka3x1TKxbpwCK6ZCmijK1RNrpMreljBoTlSjj-oCus_WWwwImFy4wM0fqs6luxQ1W1RQfZobLCL8Q9knHFgg4sgouWgnRL1SH1crQSmvYSI7HzhSsSee4Kl05wDsFN7oh4d1QL_yDo7mhbJXqFoiwa6tWjjSlzuG1sPswBcjrUdzqZ6Migkt16-S8Dx7TdwUVfMsbKgYSmwKpKdCtXSYiw2vAp1sSFnXO3eEwlkVo81kUW3LrZIvQ05ME0O9UBN51vRYIOJJpLmiIJ80IrrjG3sR1K5IjcDHnOO8RYwMgHGDl7WA1sCbIaBuHIoA2KjWy7dROGraC3olFPkTCfVEhhh7Yrx5hCAasrRmnk0dOxjIaeW6_-ZdCYImHZZX5vluSTbkCUUM_yhLkzCjYuc5QCb738l4FjptNzdaGBt8GflC62MMI_1LCmQ9pJwhWKacJ9yDKigUujcw2hWWc6n1jZJIllEMeu-y1wTCMeXHJTKGIImpviDXKIHIUEpEaKo8Ho8i24UzjaacXJRWGnNF5xjfGJHdyuIGhVPFmy0KZh3nr1L4PGtOLNpfMWe4GKNom0sBW3Bqo0SPkMi41DufXyXwaOOcysukxelH5C3XVlNLOJ_bDiks_kzbsFgiYQLhPFcgqj-xwJIRnBrxxpXD63XLKUd4vGNOHFZTAMtQikup0oXD8jhWdR9bTP4zM97U7RWMS6berCj_5cLY25ftKRnsfQy1QtCA8uTSl3C8U03-jSXCZjYC3SrxmadjEih-XaP5fZ69059AWLmUPPPplb9mFNyihAofpgUi6yF8OYL37rlb8MEqfxdvEuRV7qkBjuaPSMQKaJ3uNGYkFiVsCTz3DeDJTMiwIy1TXeFNpwm0f_1K2X_hpQYDhb14LLKKDaytAzIo7Am405yYlhUWORRpfhrZf_MnCc3WsuX9MYRChSU8GF44qu1VcZZpa1C1oGl-129BWPs4PNpcwjypwaTbTB0y_jnBKi-I71FiBoAuEiISKnkyWCMRC0MfaSo3Gl5ifiSOOK9ICbwbGMEHeBQ_RSNTUrJXBLCcfUR5o2Vmh1m40JRzz72KrLEIUYGg0x-iKzZbqpuSBvlKyHFYXt3y5wnFbcJUUUozTZdiVlBLbnakFQxjIpg4ateKWNx4LHzJ83l-1Boj-lh5UcTNpFJfhYJt0n7L9bKKYdDz46qmEU9xiBpJXvCsmOKzYjG4kFiTMIdzHh0lfblBSeMg4sIm-QYr6VEF93P8KEI50mvLmM3uktHxY8Ckdfwz3EITmFxLZjp9AXOKYJTy61pZgkMaLV3MbRhQXiqlBvmhYMzJ7YsOIxA3GfqW1EEK2sx6eW2ouZxZUuEZfRBHeLBc2jysW3aaUPtS_hz3QN-RKHHdHEE4RtuVMjCxynIXeRApOTyl4k8i0bmCL9O6ruguCTqLxTME5dtphc_FuREzE_tojYrem8sAGxaR2YIO29scIxBVZT94j8Ck3bHTnQUM9N2gqTOlOM0B5q-QaOObshZRcJyTr6_xsYGaSN8cfalb79qQUJGkiMGTM_fGMc4ugUjwlYbWSlcNvvt1BMXdXk8rkoC-FYyxidRu42ckiOY4fYjLhbr_5F0KCzjS24cF4bu05dh5nkWsGuYZBbIy0Sd6vICsfZyuZCCa-iHDLMEg7JkFQSoDL-hL7v0sx4t3DMbjZ0qWyIZGEjk6nnrWBDwoWbrA3QMu110_tWOMyKy7Q-F71bthK5DYmjbDzkxBAoFuxRufTA3y0Wsxs9uswUlTHtPVsWPY-ou1RoyUjhew7TAkY-s-nkwnrMmUNuNRaIIrej71_m7ZqHK30j24ovcEwr7iOQViQDoiuObM9tCpfMpY7Wmy40v03SX-A4WeGXpLBc7f7NcKK5bS55ul_t_s1wmqY_XXIs5dXu3winspDMXbrOS4lASmuWZqyqDnOSepUmO9lZy5fcxjeDY3oFwcUMZVGw0sbE1GiwNWVAQVI1K3YPmov-4t3CcXoF2cNbogytWBkREAdRyoYRRJmYucuICxbT8mN3SXtlyJpmIcZC5cSUiWDDS4tLP9jdQnHG9S6MDBmeEi6Zgr8ThBYFOB-STu9yTmnrHOHIDCNWvqZxZoLioqh8t3CcZr27lBY7r7gpS0uBvZmMzJGFwTQu3Xr5LwPHadZdehEwjOm-Uaj_qq0LeHDYtgLcisQ06j6NWsKUsj3QoDXLgQ0hUdrSMW-hmEa9BZ_Z8DhmK8v8lFBVTEm0Qk0OoLp0v9wpGO2cZZpd1Ol7EllQLbm3OMJyKbknTeCTCOruvbHAMe03-Yx66mwxlE0rY5eTTcFOvF8U_MIByeZ2rnCcne8ute8oggBjBJr2OqSxHxCKC9X6boEY5rt2cpH9LrwtNCGF5aAgVI7JNXUIPhytu4Vi0s9r8qizYgrQ1DrExl4smZYujjFPYk7K5q5NOIb0W2m9V_JYl9Yy1G5eQh_Z9MRWpJtcKAceZc96WvE4LbhLKMxelCVwxbc1KT4xHkPqCnepfYHiHKHi0n8utIOgLKyEGdAaUTBB1YZfEqnjKyz_ZeCgA47iQumjOHSNYzvmZ6YR9bGfZfzbW6_9ZbA45Vtd5sPxl9_msyBBMRU4DjI03GfrvtkgEwoKS2HcJWXbcoNm4pQy86lYTTZDM6BkYPmGY4FjicBd9L452u4q7F1pzIXnmCObtpIE4jvWWMCY8XdymUxAouCqAXeqM_ATIb48zAftAUMrHHTAEV3azyV3bm-9jaA7xjEbnkMPl2L83UJxzkFzaaSR6TWmEqQS-JoxFNaB6ST2tE3GxCIuFtxn0JO4TqPKR-rGdsha_25sL3Y1Y0FiGu_okgzJhW22hhaYE5RgE58yBO2sZ2NSXLq37haOqf3mU81gDLCaqjGQVjCizNwaER_tDPqKBR1bo0SPDHpuQxURMySV042Ho8vh-GarrVDMDHq-5Ol9tfs3wimtc9F8dBpEMsZa1gnIxtR1dn2VbZ13peM7OE46uovCag8QNcrMEaqCkcSaqOMVhxj1rdf-MlicqXUX6UIUUQY0g151O0yDLuKiu8yxYjEtO7n0U5GU-LRRRBpwra8KrCIvNfLNtV2gOORkSq4uGkvStGPbgcPyfJed6zfCBtcZaS7YiEKGnVnYRhuPCMYFC9jLrgWuYJyjyl1seU0Bgm4UYofKAE8pAinfZis2fIfGtObkotT3t3b_ZjhNS48uo2FLHdom0luiTQyxjUHae8t8B8WZf48eWyZxRJg1qxir9KwrpyMfxj-Cz6veKRqLcFxDFz39GgftKWVRpNb3HzOgXtt74zs0TuPu0k0uOjP2l1PFw-eKFboynDca36Fxysa5UCVFzdJafcLQzefwkLLpW5Y9Z2KFYtpvcpkOW_hIqtptha1B0-xhCgh9qGFA3zvjhCOfViO7uL29SAOJcgikz8Rmy0c-n9JILoY973GFY5oNnzGxuSfI2mKHjY0FHar6Q-lSSMxXzKfcDI5zeLaLKm5O7Nai2Q2bwyntDboRZcDBthsLFNNu-Aipl8Irrjl1UiOuLaJsxasV1-MeabfCsUpZNZfYL0FQDArbcE0jDpWLNtiCt174ywBxWgwXxyZViNmGbI5euMESlM5Q3AH4gsSZQXTpJucFN50ePNhPENWFlukrV1j4Hw7E73798PnT8-MfX15fvjz85qHFUozl9fPLvy1X27j6_qfPH9-_PH74-OmFr-sfiSd4WAdU-oBeSvHEOaH-_2wPf1h-z-DO-v-78zYVvf20fD0-POov6y8kewV8XJ71snxlPqT_8RF8_Dt73_1X9k3TH1SX17Zn0vIun-BPn77-6VyFrz-9vLzyMvzjy9Pr4x_w8V-_fOMHX9__8vjxl8evr0-v377yo3zp87vfv7x_fXPp_edvP_PiLtf-878Ar0RBVA:1qHhTb:GOnxAZ0DyK09iL8E_NR8CmzsssTa8bp7TwpoVVxpjKE	2023-07-08 12:10:07.01637+03
cr3qw1rmbipc4dgod616ghzi4hw4tc7m	.eJylkc9OwzAMxl8F9Yyq_G1Tjtx5A6TITTyarWuqJtWGEO9O0hbGxm5cHOvnz3by5aPQMMdOzwEn7WzxVPDi8TdrwRxwyAW7h-HNl8YPcXJtmSXlVg3li7fYP2_aqwEdhC51Y4uNpDsOVgkKlbTNrpE7rC3BhtairUByCkIyJaFSgnNmKmGBWsVbJaRIQ32719HFHtO415kIanPk8mE5WI6iXXK65GTJ12i3_gO-_6N7hAmH-K9LYI8m-We0hQh6dZbKktQlIyx773urjxhxSgVFVVWROtEBTxfaSNkIluhC6CYkXH0jtqJaEPVnZYgwxdulLugf1TF9cNdnm8hNxYJbOL3hZp6yL_c6sI9wh484OW-3gum8M6h3bjH1wHRygBJSM16e-3C-KEKHGFfJCdIzde_B6iYJohm1G_Pb4hySYv2vtOwKGT8Pue3CPr8A_pnu4Q:1qKZ0g:Wqp-37JVJ9d7RdSK-y9NuZvLzRljPeAvsmx0hKIFWH0	2023-07-16 09:44:06.921523+03
3nrd5qcg7x9ea4uzrd1l1b2b8flf9n51	.eJylULtuwzAM_JXCcyHoQdlSx-75gwACJdK1E8MubHkoiv57ZcdDgoxZjgfy7kDcbxVwzV1YF55DT9VHZar3-13EdOVxO9AFx69JpGnMcx_FJhHHdRGniXj4PLQPAR0uXXFzZG9Va5AcKKwt-dbblhuS7FUDsUZrFILVzmLtwBidaiBU5Ex0YKGETvEScp8HLnHnVYKiDY1924feEOLO1c7lzm9Ih__KPy-4v3HmMb_0BA-cSn8pEGYMS8Y5lyTlhWyElto8SW7l3wn-_gE1V4SE:1qM11V:L8Je3ztIKi6EUzeNKnBupOl9HQhkj5vc7lWMzlczDqY	2023-07-20 09:50:57.213304+03
uik9qbbjpcjukznjj41isptex83z5599	.eJztUstu3DAM_JVA562rpx859t4vSAOBlujaWcUybBndIMi_R5KNZt3soei5gEFLw-FIHPGVaFhDr9cFZz1Yck8EOV1jLZgzjilhn2D86QvjxzAPbZEoxZ5diu_eovu2cw8CPSx9rMYWG8U6AbaWDEplm65RHVaWYsMq2ZagBAOpeK2grKUQ3JTSArO1aGupZBT17ZMOQ3AY5X6sNMqkKHiONEW5xQ2pPxBB7ziTVO0iZ3yJEtD6EcfwhbEdnmCO-1tH4JVUl9ciR3bHYy06NNESoy0E0EuAOcRyzgpaFZxy8Ymy-XkgeGf1Mwacyf24OnciI_46AsOif6s8xzfoXWqCkmPGwpBx9gc-4Tx4uxeY3g8GdTfkPtHpswOrnY-BNbRKVyoubrl8UJceMVxxk5PBTHqYUr9hXWJuczGed4CMX8fYxQG7vphZ5-T6rVbQBdhbybYFaB1qvEw-Gfzw8O9DICsaP5VOzBr2a_7J__tP-zikf826xX18PJE8xyw-Zc3qiomG7BDfoLKUjLy9A5ZHVE4:1qMrpa:WH9T9ZFkIZrpRNHn-az2BBoOg9S6JAJUgRsbygeHpZU	2023-07-22 18:14:10.141107+03
r3oqrckm8w58mc0a0pxjmd42xtn1mhah	.eJylUMuOgzAM_JUV51WUhwNhj3vvH1SKnNgstAhWEA5V1X8vUA5FPXIZj-yZkTX3zOOUaj-NPPiGsp_MZN_vu4Dxyt1yoAt2f72IfZeGJohFIrbrKE49cfu7aXcBNY717ObApVWVQXKgMLdUVqWtuCDJpSog5GiNQrDaWcwdGKNjDoSKnAkOLMyhfbj41KSW57jzJEHRgsZ-rUMvCGHlauVy5S-kzX_l2wH3Pw7cpUNPcMtx7i96woT-1awGIQuhpTYfgjHhkPaSxxMoFoR8:1qNqBp:VmK7RHFsgyL-gJEtdN0X6jDi8pMdnlLNLt7axOWqJN4	2023-07-25 10:41:09.969872+03
9vanxlarn7va3t7ofxzsv1ea568a5ekk	.eJzdfduuHMdy5a8YfBZqKu-Z53He5ws8BkGR-1i0eURBojDHMObfHStWZHXv3dEHcqm6aDQgaF-4s7N7VWbcY8V_vnv_4fdvP73__beXX99__vTuL-_Sux-uf_fjh4___vIz_uHTv334-V-_Lh-__vzt188_LviTxf71t-X_fP308uV_29--eoGfPvz2k6x--fFllPDX9OFTz-FDLZ_GX0f560v7tL6M0PKP9UNJ4UMusZcPteeU4seaP30In3r6seeS5UW__vhv7799_vblRV7u__6-5vAJ_0_ln_RLxP_zj_p90O9X_Z7__2Tr__3lP_7E6l8-_Pry87c_9SY-__b-5cvLR4Hw4_u_CZQ_fcEbWt_8y6cPn_X34c3vP_7-K96Bt-Lly7cPtuLqZb59eP_btw-_YkUcy9qWuMZ08yd8wK_-4Pq1f3n59fPXT7bp1y-f3v_t5dvLr-_-8vPvX7788O7nl__3-hf6Q5A_76HXNfV39qvIX7W84lcff_r6-ePL-79-Vihfvrz_8vXDp_exv1_be7yH5e9ffvv75e9---nlBZ8CfyW__fbxl_eff8Fn-_b7b_JrPiB5v69-9fHr7z_Lxq9-px_424cfv7y8f_n7L18BzT__Mx_lh8sz5BPj08v8Tb9-nv8U1rgC69xCSjk0-TamuoQEjEZfxsCvWljiwNmtZelpyDc8M_9Lv-AfkvxLKHilkPIiP-G7sC4t419DXJc1R2ddwNOKWJeKLAOiaSy5YPuS5SkmZ9F_9-ewrK-2uvPv-v_X__YvP-zENE5M117xUWpc2gpQYq5LjwpPHcvoun8WWEd13lmpSZCvtm6E8WZdXdLwEFqXMoJ-XQd_XtdVv2Z9oMcgOnc5Ac808ewqQ2OVQxaCHa2qV73J4x3YUv6tjO68L6zKcd1WjTer2up9mnUJ6zAM6yssw4Gnc-5yApZ5Yln60PseBQvFMsQlKwa1L6XioJSw1OJ9ypj70nrUVW0JEd-1bMeryG-qtyqIaKkqb5amW5ZlqKgpSwm3H3H3VZ_bnIBmmWgGVRECr4HQkkCHAyN3f0T8W21yhV0w9yy6nEP_61Hn0n-1ByBZiWQbSWVmEvmfuu6CE6q3I4hmF-NKTx0kgKuKZF1uydY1FcV_ZB1kZXr99TF4uhL7AXg2xXPNtTR8K-p9KYl4pmWo9TKGKKNqADVXBaVal5UXXV7AhO7a7b4GuWrRvWpRpLAiLsirnOxLVa3Vl6zmwTF4btucAGjfDmhVwVnkYdLSEeMlK45NJGhWkRCXMLy3HYvc7EFLqS5iX_PWj1y5qrofFtKg8vOoxJFHuVLBU6EdBKbt8nAs08XopB4Qcb2saln2aBIwCyidB1esHO9tRVh0ifc7Ln01C7UpIlWsk9WzAiBQ9QqKDRCyyuywtKS_Eb0RvMO0D85tpxPwjNtl72pEy9lqGejB7B28q6uY8ZXfib5tniGYxPruicJzlUOZ3qxrS03eeUsLDV08xWvhGZfVNR_2ATp3OQHPzeDMehhj7EvSwxLktPBmi5EU1UhKfendQzOKKup6sfEUQlENX5eqtlGGO-IeaxELar_K8amUnDz_4k8F1_vaedvnPifAudmclP1iVrbVtEQo_KydumksLXioiEGU1MGUt131jAscuetvxPfsrg4QK18vQTTNB9lCszNXb5N9QG7bnABkmTooEy7RGKuaM6ULCHoaxVFsKg7E06yu7SYeZFMLSXR7VKUswrY0NcSHuZk3p1IMhEL9vaqpWs3LCnIry4Gncu5zApibxRmH-oKwF1UsRmgh_ecIiNSUCl0UUvXema7TI3l3XfMsHhGSIbxzLfjgmVT7AL33ag_As008i96u1JoIbMY6ogV1oEy6-jPwNnv0rm0Rs5QyMoruz0llX5UTqucuyiv4SihGuedNpUkQ20HdKBE0tDpFRrvmwM5Tum11Aqyb3Zl5oOSOBtXogknXKEaG3lXo8hJdUQTUohojooCiahH526F3vskR6d5nhRHb9VnJ46MNIWeZzwORwONCSdtOD4czm-m54j-czQEJapInpfmNgp7km-ad0JFMSMWptyLcHLxcgmvkR3IYDIVdOj1BfZxihR4H5NzlBBynydmb6p085JPQdKzwZxiIEZOlUec0U1Q3h2znuieLf2QzOcWEzxmfN8HJTio9xUpizHiIyanbd7FgfHc9wlinoYqTSDMIZriuF0tluIczmguUxLjS3cVwpaV0bAzetjkBzjyveVHZloZ8lErRlczwDbjpjGgEUTTF9YhEGZm_rtY81w0xIBlOKgKYp14R4aSnngpNT8uPLDHuAfCO3LRdTsBzszwT1beYOlFFX0tLUgiKXFUVlzDvXfdSztJ088V4VxVfswEiBmxyIznip3eN_jULRDWBEl_FAnXtqn1QbtucgKUZnuKlq3BJWdCgry0qh7lGUfxLV99TDmDJbqRz37KnE5yXQKf62nFsEUu51fSxe7Pcn0iBNXmHRuybpQ_GOccSqXxkfacBK87UHcmFv1H7IYmAYTxJjAJ1FJA9cT3sndJz2-oEUC9GZ2beMotNPtO6vZolGdQGlotfXaEWxbRkwimEbn_cIbPUo4eZ5V74IoqPFz4FbCmKTJ-suAWuzb3zws9tHo5muYQ7aS3mgCASbR6RYgydiQBKqpyh76PrrJSAoJyqETnIld_Bdm66TiRxcDPcIgsaj-YwSwAxT02u5H4nv7QP1G2nE0DdkuyNhQvi7KXGIxrmyUkWjxeYa_DuvRzBhTUQQXy6qib5aPIhVGwISsX7NCJ5LXEiO1l2ZGFUWyyCkI8DdNvpBEC3oGdT40ZMIzF4aIFWy1sNEUGq2sWU7K72FfNAxGeyVSXbqqGOqtj63c2yhyVrunO1OIGoD9Xx652UxE4JarucgOU0P2vRAHiEGVkYxRVJ2lQXxen4iNIOru2T5I-Lnm7E7Omui_NZarJXGr7jLn9hxiYlymLhQvFWj8tvzF1OQPNifOoxSq33ZVVHN-Yk9qdmbUJMQyQA7XmUE3lvTpcWlZK6tPXxR5fK2dSjf_n6GMMpu7bzA1CdZmjsfd73MlYToMyNjWrKHme0NNcM3bfsyczQcmWGMseQm0V6opyoOBgHFW1b-J1IyeK9s73rng7PvuEZmW4vFnIV06fpBW1iqKuhLd5kcfOMKYm-Whlu7kulgoYkZZhJzKlYPYGIV1bHWmyCni1bVhvdi6W5fuI-QLedHo5ovVihLGBIK6xJFX8J9xVAjGyVHXXcSxGvMLPurEIoefVWraaBbk9ndmP5u2Wn-2oPwPKScI9HGHtvf85y42nCiiewrIFOaBRBS29KLNT1CLvo6J89jE95HpvtWtVyLwlpDgaq5CTT8mqr5ZBCQ4jgnvTlPRf_bFnNrxLbXl3WIIKGtu3NJwoWihF1F_m1RdUI5ugdA-y2zQmITgu2MK-M8q-uQhaVOUHzI90y8AU12-67ztECyFmA0ODg9aJyR5Ml8wFieaPZ3Jj3XlmR3N0fgGThhR6ja2lSEa-0qB2O2tvA4HJDxoPnVYyo6nr_PS-RqSpUROqzeL0uud7AamGT1YLWFzyjW2qxF08_OPMAPKudzMijhagyi3MEgqFHBmVgLGAuS433QtFJ_wSLFO9Xi1w_abVcFL6-tbmOi0SvdzJehyPZriwCjUHFJLdCpZ8Iv6SmZ0XR1SxSdE0_LOqaRZFFWStOLovkxDb_jmcNw84SyguSyf37vUhmN9j7ACS3YBSDfS3A31dFIOer6rGKscltV40icnx1S8ZaEcWhDn8aSLBo0C5hHWOEgqebJ4cnq6awmLSF0QVr3gnJFh8D6bbRCZhuOr0oakmj-MOkHiuYYdY3PTmjLdkNfu5c9mT-VJv6PGaGJ-FJBpX_yNsVnt_ZetXv1CHvWvR0SJapf4KqIlEjM76GKiVG3tD8pvd_TMRuzuW-ZU-HpmpzWkdMUYh7zl6NFCz-MbKF-OQCp-xGnWFosuAZmSr6S6vIQHXVRQI0103LdUZYRN-xNaxsPoKoouOyTdtOD0e0X7Q6TZ-AahGN8CFnr8meIv5PpEAQ2Ly3FdHtoRVeo4tG0eYGBHxVvXdLmbxdJIZTtzCVGFe0SsXUVdNitfj3MXBuO50A56baq0aCihzLpGGTKNBUdrg2NBRqUUIUze4dNSyj_X1nma-lxbwPXjvS_P1R191_tQegeXHU1dDLUfxBNrZqXE_3Q4OSqnwg5dYw54IzyPhIXjrDz3Lzs0WduxwPN7c8ltaZS2aTM6rIp-EUxnHJkW2jEyCdnnplWKqI3CuBtfIiQdVVDwUJUL3OwQIcNwcUCGi1g7ss3vGX4ff5eom_P-qA-q_2ADSndq8lsJJbzpLKShGjTU-qeoyzNSa4je37Vj2Zbu-XQidW6aQheoFaWpRJCLMILzDtXqyd6-0bwzKSE9xZFtw6Evmc7Q6ah_qY_qsdjua46HWezNzqrD6GO8PipYIef56ythRXtRf5mxpYXz9mBqAVi2mgmbG6N70hW6rLgjUzofuSqdQuz-C4CMi20wmgXhx3tSeKwJaYWRYLMG8Vo9a0kKoFLG5ARRlOnG5-YlCvTosJjyW4Ujdl-6jyJFgwus7OPRz14_pAto1OwPRSSKLFGzUPQYQp5moVyNqQkKeZn4v3QStawNWUT3LAWdMXtdVTn4pYCdmN7aHaRJ_Wkti-IE-Bn3S4z2AfoHOXE_CcCr5Y94JcW4aB0IcSO7uJ0S6oZjq6Yr2PuXPZkymlcRWO1_BaK3I6WYeLVFFkv2eaAXZx3Pyiur3rng7PLRwfWFo4kKRqdrOrBmD7sHwl0hVu4jKirGmTB11TGgNVYKoP5HX8rsRlHQwfM1S6muyWG3-gdzR3eTSWYd2akwLZP8CrVBNpf9BGOGOXDHWgutF92wmMTdZ5V6w5OSAizarGYmQYNzpsYfI0WNgkTFltxeXHoDl3OQHNmaQPNIT6GswxyrFaLwcaNRNrwMRpjK6TIfpG3FB9MfSBM1WC7n6LJa9GXXWL5-z5KCzOt9awaLRMR-EZXO35ADzTlJwsqhUzVHSg3sOSZpM6qJlYFCIutttlXQvqa1kVCVuTXZ2im7SFMZR4x3cPqIVVABHsI48QylHV50Xj0oGFottWJ6C6aXf6M02bVkmFJmeMHnlB0T1rm-My3NvYRrYW8LyiOZunVM4a659Q7t69dSla3Tni9wxCLyQzCvGOJ7AP1G2jEzAtG6YMXaLlXTWR2PlWToMzG7RzHalzv5QV69hie29ddaOQt8RrlxKGI4Mi_qs9AM-p44sVIIjqWTd-kVAtsBSHxTLvnTQ5u3XeL3JZoIiZ5adNDrtPLjisRQHdD40mwqw4LcYKcdAJHXeaIQ5HNFw0PX2TjPBQZ-ioTBe-iHxVSFFg416dgjijRpBjgxGqb7OB96oT0uyekCwSmFccHVLsKjfijQDWmuNc-W2nEyC9qHsWgYDUyo5rWWinBlBe8XNGAO4yBIkhwMyJv04OsRvrkNMZvLrw-fujLr3_ag_Ac3Ykh6FXHW58VcNc7pxd5CgmAAWBljn46h4-v17kgmo4th91a5fp-JWrzqxjD1UQhV_Zcm-1U8eg2U7iBBU09d6p2xmYwYLnrVFRsX1WGt4iVoN-h1okt71G9JTRXyRUL5M9S0DkgRVjtrlUOMkYNUS1s0XKivDCnXrdnfLTdjkBzYuC1y64JIqa_HJRjJ_OYHHMSzYHfcnVLWbet-y5XPgQrnLwbHCHs9j1YFQBgT3mqW10IEiv3eEREEO1qRNVwf6iFr3IYzltDKR2u8U3C0E3Ntm0knqfWVyK1Ziykmtl7YP1stXDgY0XLd_1frY1GqkD-o2r2pxaBLqalm8u3wiqySLLiaGnSVaXisXu671AvwZb9YWtMR-sDvo2jP_pIEDnNifguan4qhH2KniSzhNJdVbmoOA7WH8HqEC9N15jsnRHWnE49d2ii4Fl3vhXP0oFAg0tixQElUTHam77oVpp2-YERDcln9MRnsmz__x9GhxCvEQJjCkXXgI59BDBYqNCmb3MyjLuGv77lj2ZwotX5gPlCPzRSLE6ucPUIrACc9RCuXIEHLBtUpWxWRqhrFZJBl2sIPrtOhQHM7LcCyOCQ6M7Ygwf2O48dzkBzy0-wPcf4CBoNqmuxsAmZ4uNfKjP8xNnexY92clMF4vBaELXJKpfra4RreUeMZeuv0Pjo9s9mFELNSYj-WBcL4O2TEOzYG_zWVCWaFtYNhCMbyyeFlV3IEf7ttMJkF7iAlo6MlK07q8Sk1VpJfDmkG0cZOzuGx-1Wsq3JPlrjWokEECZsdGMa-LtOpUMFr9ajYV8q3QTmA_N8fdT2sOCWeZ1yL1wP_Sf_XkgwqjcGyVNsrMU55wABGFWN0nwvX_-TvZB2uyDSB8taz6VrNbVGFpBw7lq6y-sAJcOpYjKYsNa1A5guhHVmPjhLfu5JrwwPYwSqMhIrJaX6BYV7IN12-YEPDcLgTGW1Ous6hH_ovI-yz1maKznO7wmWW44M1RhNFlGnoogDp91sgeXAhV0kmygmoWwNtECuUY3YLUP0G2fEwDdYgxNQ_dJyydYZNoml7C4klkTXr3caYvfuezJzIQLi2loKdhtHeQvQVxR9VwHRQ-VlEX9bo9ZtOpFRGZYkN1Xs0VFS_rdc0hfswuyGUcPe9kmTfxBR9N2OQHLzT7IbZLnW-dEHVYYr7x6ethqWqrfz7Nv2dOdzC2gYE4QOvF5TZHj12BNnVVSNdngjJszhuEYVpZxtaprdc_dVat1U181Sbz6-Sgswylzr8KFxDSQZBQ6XT9IRe82s352gatV7N-8qTXabCGkZYORwFkb6mokcG8XzcFvcaHYRmmremFLcdXvPhznLifgWDYcOVlhWEsT6kc4Q0C-KfTMSXx7i-NqZ1a81GBFqXLf1Vm6O9hJPkQjWT6LWxA21KyXBWQPEpVzmxOQnI5-YF8Ucs1s_ha1Q_FfolGWoQvcjZpEwZKUsRUMZisPJ9vjwGHoh16bjShoNuEFwXKbA3EomHOfE8CclFFlsquDOk8D9tVK0fKc8JPqPcL5PYueTulMsqhitXywEtXxQD4q2TyhRJ1T7nDkY9H0guRQ5z-0CIevv_76GCRPIdcQJMe84OyYjXm1IZNwWzhDAXeear7cSTfvW_Vsp1IvNV0ehn3Qf6veOfQ3Bx8mo2uo3Xp0b96W-JaW51utChVE5Cpzxc7MbkdDtFoMEGDoznJ6-dnHgfVn8U7Fx-FIlqtqKU5mAG04iYXBzLwxvNHkRCrQJWvGMLvAVhDQFrDzKaBTb07Dc0k5ZrHLarSwIC3hJwxuMnsfmnOXE9DcHJ7uct7_2Z9bQuGVmkjoJKWDKmY848cY6RAOaQ09-ufvFLsrVzlYPb-oDaB5j7l4dZ0zB2zuVQBls9vgAxYD6zyTu5nY4LNuWe31TjAuTQLphVOzRfsx9m-cCMfgOnc5Ac_NbermeMJAViM1WkuY2O6GSjOJcPO2tIM7U-4y2Z-DNUOjw88tHYwiedQTuJrZtlo75qGDH7aNTkBzozuhmT2aFUeAIaIYHCzwk2-Gz8rQoYEs8sxCfczBVCGtR9X1QjHMiDbIkowD1GYXJXAoH1cStO10ApqbA0Uid8wDVBWd0OKuLn1cZgzEeO9v5OuONU9mW13odkO0itJqROkdDFV6sLpRmGLut9scEnWChur-YIPbYKWqCG2goXEn2ybj7GiWbEOuQz9kOHa07dznBDCn-yRaR2_7KMaUrv1jrHvGBEaqIp3c4L3xveue7nBOJ6oEjg8VP9L6bUHo3m0QKHtTtrjc7encs-rZsLw4UXQjwYebNWbUUY9qxdLMWcJD6m6f6J5FT4Zk3ZyoyoLeqCOXyDkA0aWBSfHWWalaxMnxh9qCsKffXRVcXQ6XyacxWt2K8d1YnlN_fuF_bmzPTSmaugil2MAwMZTYkNPETc8eKvtWPd25TBuWambHOCPsIMEb02oMlsSIblowwkhUax9kcRSR1ebBIN3kBu-ShWOQH2XnDse9BOOTPQbJdIez8wFIbo7PCFuKnIF2MdHZGyq3d84M9a0VdJpzlmsFv75V4FPZ5GxEB28XYew6XUYmVuRT2RzB1W2s3Ifk3OUEJLeMkQ1BL9XiRW2jwRb_UO_uVvl587ZAndfNlSlpJjyNpEvOpDsPE1NhrASvsiItWdUNhq669tM-NLedToBz83pyn3nxqP4PDluYRQqa3e3mbd-8q5SsgAZ0ECv70IxfB7PM_eEkYuCzz8wIEVDcZ22O7UBpue1zApZ6jbXyLkyWoaZKCNk03sZgo2xx2_1GAlAsBfOS2CGOFv5innly45p9GY1ik5c72nS9ZFXMx0A5dzkByen2BJN3GF1F7idRIiuL30BHytIrcciiO_mjNQxlYVxijkWHa9nKpN8c7rXFmFv2lCNnSj5OeZbD7Hu_BWQfqJetToD1kkJy6yT-7M9gxiagQaesM85WbCAUEk71kLD80T9_p_BypQfF-qZouoyiQ7zJRId_TssAp5Y7SQdWgfXpdxt-jd4HUpWXO0xlbemNPby0OZJFVPGEjrOv5i4PR7JdZocz_hR7WwZrOkFLpjd4BJMcECHuLO59q57M6jfGfBEWOZLqKKPia5bVMlaOopvOiTcJtDKPKDT_n_bzd5IS7TJ_vGUSpYCBXGuPwXRkkf9mphhmlPmE2pgFW-2JdXohSTxZkn1grET1jTuxkMkRWi27JQ4K4xTgenbzzPugvWx1AqjTIRO_8ohLevOOwRDCWcPVyCrFgmCLNcqBXEnyvX_-bid8Y_Zt9FEbUlDqV_bZgY0SC-wupvSdtCDmyM-ognFPdZsk09IdCsUYjbYerA5UWbxv3V7iGEi3bU7AcnPoGon50dnPAANUWbD5mpNALt0ZJgcORU4-xTLrwLwsy-bGvF02ybBAW_56olFzjZd9cM5dTkBzJrMiz0_aJkAHjU5TF2YbLIzaNrdpAwPhEzks4Aoy_792q5fECGS_XKfK6Wd5L2vcsj2tZj7zQXJ3bnMCnptj12z67tZEuQYrogKhOXmrUA7t-hlybIPlX4YcyfV6lTbx-EPP0Xar_RfiHl-XBIJw6MBhh9s-J-A5PbpIh78MeZY8XiNPDwzFbUoDEYOg5dZfYZ3FtLDOSNS2dXG1OvPb-16yzd0qr7MI-dCJcMWNyB2P58UjI99HlFtuOdIUrbO0i_qOZgf5ehw9P9mml4gHppFaDDdmpLZYCevbVcNIAqO5fhP9fKfseR-Wc5eHY9mvsloc1JpEmVNiguRz2OSSyHq0Zu36N1gq9YG-t4hCNfxNa3LIFZrVEglvV3U55-yPID19NG4uBNCP7JOorlXxACy3qaaNdAR5TMI-OVjmu2d5PywyC9Ha7t6-s73rnszH7Vc-1WA5ZDROVNBxZuNaQqY1v_tHkSusi_zrO-vaPeruHn083Vrj3Xj6lcvH45k3PNVQiZhG1yYJL4t3W7CJQwiCu8VoEfSx7HoEkSTLsKKNcBSvqblqHZF0ldX2jDA3xhiAXI92713P51ApXeacNFJl66gXNU862CW0WlLs6WrjnPygFMxTlrSN1WoABfaeJ5Gka2_Cb2IZNWm-gw2LFPPIrXfah-Tc5QQkN1_IqilE0iVNrFVw7irO3QrvcWAPGYP1P_3n7-Tk90tdYLLGvjgHumG-kVoBOv3ZQiTJJZ-ED2ozI1C4q11sl1WYmeaLW_LKrRY4u4jbfmA5wWnsdf2qq4rJa1HczAFgOhzZqhHSi8xONxFePkvSznVPZw5siTFWjyc5UiVxGkq12VtgnyS3j1jwxeWG2bns2dDcnKhC1ydjQjFbzsUgyomsxiJvGbvuRuT99o3psrEtq39wmXzOtL7--hg03YjB4WiO69SWwgLlP2Y8rtFVz6DXUDaDYEN43r6xggQ2adCAK5vPQL4et0YM1_IXacChn2nOM8dsKbKwDrHWjrOwtp1OwPTiTmnwCOXRnaEgTC8jJCi7YMIEDFt-vf-KhCEDWXWJpFIdqw2YRtikufUFUeQuQ4YgpCgUOZOjYgV1-nFa6bLXCbhuBYOMU6pWsZJUkKKqjgfvuMb20ejnu_x7Vj2ZFL3MlmqVXNIRLflbu2l4Z6z4ROwOM1pow3jSUZ-uqwvoWBv10eryxpVs0RKM3OVd6FPkrDa_4hg0t51OgPOSY-LgDkwsJjsOiDjUJMX8nWjjeEk9e3M022oU1FyV3q5yK4NQjjGjo2-8_gPnyM1dTsDSpke2wRZpxDs79TMoh7OBQUp6Qaz4E1-RlSMxMGr-9KBdVsk3ruhMcwSK6Kt6heVRtHPTRw3nzEYY5haFFIc1Sycjh1K6DtW8RUxzEsaZCr55W0jhqPUOpWWRqTn1sN5xbCdBszhBdipH4mktblX0TvVju5yA5JZbIt1JQtaCJaV5nTX82Uq-wQvnTnrdt-rplA8dIgSeSTmGBmZOgQLpO7UDiHe6UWgl1xZPbSafURDYzSFK1qPbu1F9v12GHCln9TVx9ukBWFGwaLp6YOpz2-nxkF5SSywxi2I70s9W1qzCdxMY0Rh3iNuxiEy0WNT-2KLVhvVdfX3M4TyF0zjOWXyifqgiUkeFOiezih_E-UMRPfJUSSjx997Z3nXPddnjeuUNkfsaAec2Y2xsDMXhajbIpA7XateinWjIdd7wYlNTtHnXVajiNqmzk60ho1j0vtoU-WPA3LY5Ac00Tyc5PERsWlu-Mj5w13U17jeYkf5Upxxn5wJa0GxUZBxWCYLEcnSjjUqHyi7CJdFhR10wNaIRUh0D6rbTCaDmDVR2_bRiWWGoZD1ZyA-pYE2YtufeHASKo51LkiNfL4ouvdxq9T6riYrr_sgjbXfucgKSZSLJAc7g1uqzA4qTjTKseTUAps_oIVlmkwqpzcoVfUS5U6huJSbZRqYVm-sjx8it6Nt91av_-I_H0vwg2O6PoLyuMEVVtsY5aK8ZEwysVJd47Hv__H3SS3G9-FH0nnQgvNadyLkuhSN6RIxqL4UYrr5uBVNsMvOK-u6yKBhVza2EKMZlGuJrcyC7f79XQpRTuE0FSfpRKOAhwTYGHHMYxjo70VB3l1TZF4wLcJMhvVkaOYLOlBklOb9MZevcRNfCTRbTaqZcupHUdpupdgyc2zYn4DkuUqIZCBxVnLu1N6eZwURpv0uTzUX9_qJ709DuVJkcWAV179WOR9JcKCDJorHRLeGL8e4czI0wKZufymqu0ts3lnuZhLvgk2QICqTaHMS3YqChJx3kQEerCpSTrezyS85W0TLcCsV9iG4bPRzScF2kx6x8tWHD4rpvxDvsKkXDpUtvFjFLVFMlsog58MuiavTlt5-FOX_M6H5NDd0O5e4LpzRXxnDlRbmxkD_7cxaQ51TJZsN3oK9mVCXaXMCj9z3mOfzRp3Xg89hyURzhGcVCLcPuMaMxGMerpuLIdxqB4QpzIEzvxu9zWXSv6T9YKaEY9fU6RL3KJsfFB8KdIe4PQDIbkmIIsfujWLwPk0i0nkruPWeajBnUukFSh51oaL9YqF78R0YHdNS0XxG4WtFfMerqZgQD7U56YB-W2zYngHmp7iNppI41oxSWo2YmZyJdtNxpl2gGnXJsGcndZj0oZ4R-k-5R_1rkdLXR9ZNTZbWe14OgvBOffQCS5n2JnarHUi-xBj6G8caCDZLefbMh8zfvCqTiHKIq6o51Dt2SLKizcO-rmAqVsQfrEUaJK5su5ri4Y7DcNjoBTHOf2iBvBzx8xpcqWMzVnsrGy4W2OvcZgz6eLDNN3ptW1qF_om2FDn7Rr42VbUbBX4wsGF7DgY0P2z4ngHnxoHTHFLqFH2FchmrGVLOI83qHOSklTPMlDZgcyrAlq1mVEkES5icJxMnSJyY3Wx-C9Sl0k8CHCU1ucwKgYzud6j3KyRTM9CMVo8LtYcnmmq7G03WrgvaserJof5hOVF85WhSEkLGYwOucCw3GLjWQ5G25xiwWDc7ZXa04_HpRvTOcm04C2hJeM_JXN9m-F8lzqKhivOShSOWF8Eirk-l0tTBHI83XeqdlE4uGahF30b1ap1C8mQbz90ch6b_aA5CME8muxqMScdDXWYP5g2Ji9sDhOO0OC1wSE8o6b0TisngPcpZ-PSj93GYxtDozq4CpHCyMFMlJ-9-q8o5BdNvpBEi3NBRraDFOe7UAh2gj3RXTduIWXfKnumnr02wOI-0DGiCZvIowUHz5sNC8zWK361G2weblDtHsPjy3bU7AM29iU08GOhe7MV4zQCxgFFaAzo7Ft--qFZMPGJxJ8n2UVbDWflnvOJPZGBBL5pVnFe9qvZQHAWm7nIBjmTiuYSZFyUGEeF02-3qycct99ElJdix6MkUeL1V45HpF5zbn7fR5mMRkp4lY0p3yOAwhZlQJzWWqoVBhOzvuhtuwIH-p2ahoM7qS2ZWoXDuwHtx2OQHJtt1tEvehIYmEesMI3WFss3073hkXsGvR053Jq9yRHs-4GgSwc9Y8I_QklASLrGur5RI2aoZoU4qgv4uRc4lWdiP0SOxp7GPMqJ21kYVJ43cMoNs-JyC6uT7JcnBwF81eJN6oB58X1h8aixkvLViJM4N4yIoOG-ke3X7MsfXOMyUarRpSzNQD-Q_nLo9H8uL4rPrBY-1mjOBANbUjWrWWoy1FdHPEtNaeIfdmdfjKR8Bm53FnmKg8GjLxYepWYzF40NgeyoPc0qh9eG4bPRzQdPF_GqUcDlef3TDB5r0V8wbxOV1TOisNZ_gHy1zqJJS7-z7Q6j643aLTn955PJpXPpAqU9TYkFg_Yn4txRjylSoGxp1qhJ3LnkwRpYv7k0jfOuB5sPgDrM3bLMJggdbkNrrqMvU6dRn9p1fL7s10CTPz8wbdcGji3ZU1D0DTnJ8Uu0YEQItTWA4uEo9MaVp-bOpouPVc-1Y93cncCvCYKQcf8SC9Zq5WsdAmKXZAiaU_7CFZeREK8lm73OOMWmC2m6tU0bOkD9BaybJdhXwn0bQPzG2bE9C8KsGjvYjGIIY5VhvNAj3PeUBxCW4AnKvKP1h1jxTnicpr0sUNMlMliV2TWSSKKat2X1eOFjMykdtLXiaTDkxMFVC9W3QJXSRumCmCks3Y4Mm2u8SZBPL54_eBue1zApr9cjK1RqgjqKgmDaiCrJIDdrklzLrfjNnnVDddxujmq2V3Bq6vxZgu8pvxLq7O2H02XX75B6A5i-gS4xipreZEohS85pklSyRbAwue61giCsr0GazOPo122p8gHHTlpsb46HqaUAggM6Jbuqxuldk-RLedHg_p9IeaKA3ejWqD_4JmeDVLGS0wiGJDf-rQrlVPptTzdIVEdJJOBROYkillJiJqkMOpggDFCC63jY5tqraIXvr1IrffYDVm2-seY_vs8dD5Tacw3cV8cYMs2tCQmoimTxqjOUhXaNQArAtu1dvOZU93Li9ZoER9BBIahWXM0kgRo0vmUNu8Wkf2jdwcKLjium7lCmDTYhYjIHPsFqzGKP6mJoUtXYHiXCbxrGP8GES3fU6ANM-rHlXrVIz4ZM0MmJOMTh2xSgUAHQVuaqWKe77SGwLzyZjfcbAgyDKbq1vB2Myj2oqVcSUaZEdSB85dTsBz84eMinGFTcMA22rUST1bNEgubnILufaterrrvnlDTMSgr5X51zTmcKxs88bgcPvTOfLs6wO9qpa1XxaButFPrvXOryT-vSDpz2Pei2R3k56HI1kusU0GzrQHk0z0oonpOwu2_E00kG_e1p5FT3Ym50x7Tfhq6KFjyvysKGAxHOz1YpQA3eWzxP22CeqhLow3D3HVq_EzBDeuFpDcVDPXGKSRIWUZAt3LY8DctjkBzTTR5ADbDB4AxVDZ-phgS0i1UTGjuNh7Z2JnLpx8gXWcunG9Ttyk5NJjWHbhyr8kF9jR9Cvn5DDKpbGYRacZg6dpFrVkpQXouqY_o-NVXEr6veue7rabNhc_3fqq-ySkRw0C7fA1WfAINqjLRp5XNAoyAjqM1xd5Yw7GVHZgP802lmIDyJbCCc_rUgOHl94hKdkH6bbTCZhuhR6cW_dnP8Cz__ydOo7qJQgQA8cmYLCGBgHAuGiDW2szWus7_a97Fj2ZFKlXudA-x94z04ahFEZZmZu4kNucTfdmFGTo1jngirk3pO9seHu_Fw3FqCurlZS_1c8YlswpBMXGYxyD6bbTCaBeTAdSKg7E8tXlwpkjZWUJ1hoPzlV_VsJAFSv7GtALZ-Sg2frTBVorcrz5RJh0WWh8yB9r9d6sKUGl86EcEHOrE2C9WBArx-UWm40NjpamcX6dylJ4p5NbAJwyIhg815PiSjuRSXaLl_S76qzkrlv2dAZcQziU2nrb5wQ8t3gA-VSTeAlxyxoXlnelWUE2rNjhBk90GWY-hb4kesMY3Jy2JnHXvq1x6TTjQHlJPmwRuop1PrSGbNvpBEg3A4IVlUnc-GJircwoIHrXyECYQLHui8WwTQrx11WXnnBd2F_mtCsc0rK8tSucMjwwtktwwLgWRSKytkkpntqsIY2DqaJuM4Bu8Oyo_WIVdDP2ReXCtCk5OLhuogCl_GyZY76ryRENpq7cM7Xz1s99ToB0654v5CAbGNWQDAZ2MwzUkmrWc9wZoQRZ0dNWLUp1lSdZAwa0uAcEhNYcQZ7U7cwWVyh3pmXtVEpzmxPQ3ML-2eYqdGMHSOJYsQYH2X0GRUCe4bc_NzE9V6PM8dblOxbhLCm9vfB-qeneC--_2gPwNB3f164HpCgHO3vh5Q5ymniZVMsBMyrcdFkBR14kG0Gc-gUFE4wSgA7Zr9KPxvCCI6zep5HuwCw9MJ-_7XMCpJuar3qYCqLOJA1HpThnAsqxbcZ7JUaRy89W0PNFi3WFVRDerJsMhLdHtEYrw31TRupf0r1HtLpZ2AfguXXDk8BJeWypUcR4Yxs85jdzmDW8qDvlzZiqUm6WsQIKy9zUNXTvaxIXTg5CFvpIBzS4pRaHo9kvrvxKpiFU4TCop5kUNSfBGhEmVNlNP-o6UtliXe1_cB1wHG--PsahP0W994tDz4SSWJ_GUqGEQ4zq9dlvhLB16H58L9tAgJjFLudt791qLUJpdr5vPtFqJpgcYI4YvnAQHpif2rY5AVFT8SnxTogUNUbACJLQNCVp5SxJFJK6iqIKZpVKJgVLZGN6DWeFY2IoRwC8XQfMOWGR81tnGVRa4oElznOXE_Dc3PiUOJkSIQnFUyslOPlkErIAoeJa2oiqcNpYWrtRaekU0cp5y_cmVpY-OV5hzHd-Q5YnMc96Pe7WbzudAOqm5IlvQYc8Kx2QmbKAWrHSpoAwidvyJz6-MbfqVBYTEm0hNVEYyK64Q-9n5ECsJA6ys-q9JR8y9Z1YzV1OwPMqE6BKHvlSjrYTq5w0rkHbj1Vvg9TWZ7DBOuuKl3U5_MF1UBj9zdfHqKX_ZvX4v_zw7m-ff_787i_v1h_wz3_78Pf5w___L9rinFg:1qPesJ:8e9RJ3dL7BGfDIVLC79pZiWVgUZTaahc2kY0yCakVgw	2023-07-30 11:00:31.078325+03
jiqkb8z1lo0r2bndu76tjbszjg0ltibt	.eJztVk2P2zgM_SuDue6UK5L63OPe9xe0haHYysatNwlip5ii2P--FO1ukhkXaIsB2kMvjkQ9UtLjI6NP94fNu2bqp6Hc_3GPd2_OxiLVLxn98p2_f1DQ-_JRIEP5UAZ6ZRbjMZ_Kfvo_QHWxXL-80W9Ui9exmaPbKxBeQNw9Hdt5Nc_Oatk-3LkkW_djU4bSTqe-bf457KfdUM9mnqx0uVc7iv3KOOVmnPJpqh4WTAQyxM8gZd89BVzHPpZTf-iWTZt8nnbNeSynpq82vrVtcvt-Dte9y_u_D9DKkU_9BioEltUR_jp0Zfhzwd4E2OVxJ95lU5LDLecuWszedWmb3LaEzpSEwW58dozZOoou-2iZqfW2y9hF3kTr7JMrtOdTTd4acWWY8mJvd4e-Lc221wR3zdCMRzlo2xjbmNhUauBxGB8v0HFXSo0qURasrE3tsemPlfjpPMrirB_Z78bUHs77SS58bdNsTHkzlKY8Hg81b69fq9LQXMuVfrvIFrf21XOEBLORKSZXE6Qr3e-zJn_Nn80jmK9AoaJwBfv2YckSzRmZE1IuPQC7JSHJYJSh8xbY1BE7Am9qoWN0IHUvI_LgnVs5gYsEzrC6RUCu_QqTgWDVxuBp9eCCTTWeA0dBf32qW3pIPr0Af-iNskIJUToIfhd5ZK-6H17GbK96pnLK7u4yWaA0L6glXcY3rbZSYANGNMrCj1bdzz5fS9Z3JVbZJ0a4rpEqEusdUtA68D4CR-1bbMHbKm3CAFHljg4Sr50mGA8mVA1b6xb5EyWgqMWFgH4t1RyWCkADKVSoCNdGO29F_BLy-FwT5FHKLL4gdfSZOh_1DiFJYYegt7AJRN91ezLL5UmIMWvkYRKmvNEhJuEq1MjeJWCq_IcEaPyao6TIUL2SRWBfvViw-l5xLC3qBfmLMgUf1iJ-PX_0MD_Ibv4j8dKTVW1JZBOctrMI0mplJMQKQvstEK5xyPJsclG5D0I4VwpSqM-oWWZk1wh0wEh6dufUFwJWTwLDa_hvnfPMHdZU-tXUf5m6t__-BxaC0gc:1qRzCI:pxiM1PhP0RsIYVdtdOisyNn-mpygScN_M_x5gfSwy-Y	2023-08-05 21:06:46.731263+03
cqpu5nserfgaaa5aiaa1o4rt830yw70h	.eJylUc1qwzAMfpWR8zD-TZwdd98bDIxsqUvaNC6Owxhj7z4nDaPteutFlr8_LPm7cjDnzs0TJddj9VKp6vkS8xAONC4E7mH8iCzEMafes0XCNnZibxFpeN20VwEdTF1xk6fWiJ0CtFpAbbDdtWZHDXJqRaN9DUYJ0EZaA7XVSslQawSBVnmrjS6h0e9d7vNAJe595lrgUpV5Wg-5VO3XXqw9X_tzxc1_oK8H3CdINOaHHkEDhbK_4BAyuClDyiVJCMYtk1yqf5Lz8q8E_eT-NMfyHd2wDMVvGIR-xcUNfqLUR7xjCHNaxrsXRUOGDY8DuiNlSuXe1LqxsinoSJ8XqJFayurnF7sDu3Y:1qUUSw:M2pQPJa64ElHooviuOdjkS2qBYLBlldQcGsGvz6hKJg	2023-08-12 18:54:18.798983+03
n5hxkot7yvh0n7axgs7aegn3ocjypsob	.eJyrVspPyoovySzJSVWyUoopNTAxTAGRxqYKYMoIRJokgdmGYLYBmA0hU5R0wPqzUysp0F2QWJSaV0KRI1JzUpNLijKT41MSSxLji0sSi0qAJhka6RlY6BkZGBljKEnNS0FVUAsAo9lNxA:1qVQjG:qjGMVWnD0Fq6JMlqjvHVGxXcA0lUpn2VwRYNjcYllWk	2023-08-15 09:07:02.569067+03
k53l4ld2iacyx2pn9bjxc36m6nalhzaq	.eJylUc1uhCAQfpXGszEioNjj3vsEbUMGZ6zs4k8Uk22avnuF3Tat3dtehuH7yzB8JKM5am-9o-QxeVlzwTBULh_iUYQqTOxZ7PPYXyomafSf6P0O9wQzDf6uIchR42fbaAQPevEw-y2JVVmusiIv-D8JDRgE6pdAw-o7vS40axvIHWagOV1ceIThbcyacdjyTBYk2ZVdsqcRyR2u2j8BHSzd5iZDtWQtB1SCQSmxbmvZUoU51awSpgTJGQhZKAmlEpwXTSkQGCpulJBiC7WL_nlNv03RubD-fMcg2IizHT7RbEe8YWjWOXzErShyHq54XJ8H40jTeRrDop9f06S3gw2KNGh6OH9fPr8AJpC99Q:1qX0dh:ln6-w1iyZAvo-VfCNV1KUVu1WQi_teu0wFKHXuh1b4Q	2023-08-19 17:39:49.761559+03
83t71614ffxkcejia9xdeko0irhvb40x	.eJyljr1uwzAMhF-l0FwIon5sOWP3vkEBgRLp2IlhF7Y8BEHfvbaSIWnHLMcD-d2BVzHFU8h9HlgcxNeqLNCuxr2VoXe1sXgoXhV_UxLvJX_mywvpb5x5zC89wQOnPPcpEGYMS8Y5b01QS-WlVtr8Q3ikDdDwAARccxfWhefQ78c_u4jpfEvRCcfjJNM0bn1R7oi8Xxf5OREPH3f2qaDDpdvSHLlx0BokbwErR03buJZrUtxAbWOFzgBap73DyltjdKosIZA30Vtnxc8vs46EfQ:1qXzDg:HAEbUGrDN1V6teSHuCxR4iKAZdqXf7g-EyVwioYyGDI	2023-08-22 10:21:00.529539+03
8sez3662mi3bv9y9meaz4co818x7v3ta	.eJztVs2O2yAQfpUo1yYUBmxDj733CbYrhM249sZrWzZuU1V99wLOZjc_h62UVD7UBzw_3wwwH6D5te7yJ-1q1-D60_rrRAUzYeQYRkGjXEaZx5Gt2HoTg3b404c0-B0b2NKDsTcDtu4k4RzI8zjKaEmjTFdxPvEGxF5B3J7LYvbO64srE-VmlSg_NTZYuKEutDXO6NGZwfnZQRAqCVDgFxBs7TlAm8lVehpx0HVwntlyU-zmKPtk2m8dKbrW58tJgJCDdyRfOovN5wP2JEFlxspHY44qYSU3Vvpap4lVpUpKzCxFxTKRpybhzIgEZGJSKTiHIhXWMCt5LkUifNJ61MfdPPtVVE1ggp55rKmjnZ3Zexzqzl4JKKYhkHctFTbOHOyxfM7kDWrc910o9MPDfHIiJwzCCDRMKyQHqUQQo8t-nBn_r1_oKSX0HTAWUewK9nFzjQX4MP-jrRTbS8SRJgULKMPSdZbciiaYKdnGe5JxJgXcY8GcAfH8xqVnBJj0kqJEQRIOnSBcvGc__1oXN7sNL2WGlzJzuMdzBJQTiJkZkyTL1HylE0iDkxPF0gWU9f5ljj-cvTP08L4oyrMF7HjpOtyKEVBxnEnAePhF-NQCNrl0_Vpd_4qDR98MN1Y_o8PBt01Zypjv4zyuxR9HqwJKZRpe5qLq6gJ1WceeOd-VrQauqdShMyX7Zty_gsYKMbRoFRqn2947XNHrug9Nr5tG71nHTtx3biemoptaP-8b2-8_YSghoQ:1qZBiL:Qld4EV8VX0GkaIUCwjPBADbcH7p720fwc71Y3bZJ8LM	2023-08-25 17:53:37.850745+03
f7tlfus53lxnz0tuv4ms9w42asbj3hq8	.eJylUMtqwzAQ_JXicxBrycJOjr33DwpCj3WsRJWCtaYppf9eyQk0psdcRstoZpjd70bphSa1ZJyVd82haZvdI2e0PWOsH-6k4zExmyLN3rAqYfffzN6Sw_B6124CJp2nGiuw71EKGIe94bAX497qsQPgckQHYI0tKJ2Qg0Rr5AC878AM2ILox662SuakyFPAEve-QNe6ikK-rA-v2Jl1btcZ1vmG7u4_49cT7oueMdJTJTCgLfezymnSKpOeqSTxjsHAOHDxT3I7_kZgp-QtqtGvLdIxetWqrCNeiV1Dvv5J8oRY8yfUpELS6yLBqQ8knJtDXELYNRE_twTZi_KXWo6WXNy37UupDWXTEovpgfv5BQXxumU:1qZXeM:ZWWdHYFvL2yedIKNIfWNUAjD_Mg2t7SQH53b4aP_dss	2023-08-26 17:18:58.236514+03
s11y65iho2r8ryr0re1l55hptcagqbaa	.eJxdUcluwyAU_JXI5xRhwDLusff-QSXE8ohJiIkMrlJV_fcCdpvlMkLzZuYtfDdCLmkUS4RZONO8Nm2zv-eU1CeYSsEc5XQISIcpzU6hIkFbNaL3YMC_bdqHgFHGscRS6HvoKLZ8UAQP1A5aWoYx6SwYjLXSGTtDO96BVh3HpGdYcWgx7S0rUwV1FMklDznuY8GslQUpFGS4vm1904rtjmymE3xli4dP8OTlL-kiZ5jSQ-BqpArtary-i28rssrwVVWZVXOnpOSmp-uAdTRm97uB597gQecDamFkkmI9LRkQ5ohgQrPARfGvOedjj75Mj58qRrrKt0-8Xuay1-bQY3AahHV1x3CYnGhFlBNcE7r6eL1J4ghQXCPIJHyQ5ReTvgh3ETHJtMRcWy-XGz1QOixTyh99435-Aeq1vq8:1qb0dd:bE7EVNXwyW5qJpFEvfdCNAZTAgjAN7EEt32qUw2261Q	2023-08-30 18:28:17.682057+03
y575pqg71dsmfasaoqovtu3ng1pfpziw	.eJxVjstuwyAQRf_F6wrhBzLusvt-wwiGwZAQsAyokar8e0CK1HQzi3PvXJ3fAVQtDmqmE7wZPodx-HhnWuGVYg_MRcU9MUyxnF6zXmGvNLPvZCh8vbr_BpzKrs_OtK4kZm7lpie-zXZDZRfOJ2HJcI4a2xVmFlIQaiH5tC5cSxr5vNqlW6FLHgmsD9QGf1TpyrejhkxwnSDt0cMIt5rTCansFGJi95Dvf6_ZEZUuIxsreIA_IBdVam6woaQvhOUNPZ7obWDK:1qb3C3:xsA-WgPJrp3Pi5SsrtYyiOBcNbRedUNTIlNzNr-rSOc	2023-08-30 21:11:59.253424+03
21yv5sqysqxjyn600keg922y0gw8giml	.eJxlkdFuhCAQRX_F-LwlwICLfex7_6AJGWCs7lptFJs0Tf-9iKZrty9DuHPuHTJ8lRaX2Nplpsl2oXwsoTwdNYf-SsPaCBccXkfmxyFOnWMrwvbuzJ7HQP3Tzv4JaHFuk5sc1Vo0gMEogZUOdVPrhs6BUy3OylWoQaDS0misjAKQvlIBRTDgjNIqhY7uYt9xoiHa2MWeUurLwpWCtYJjxXoKn2-UOyJXlRWzUVnZmAMJ8sYD5sqz0pyK2uyzj0MFHsZkFJrbY5QoZDJRTz7tytuAEe22RRCMGya5hD31Sp9J7umDevnA_7nmiFO893Wz_aXe0n-0_ZrB7zoBu6yLO90v07rE7Pj-ARqyn7k:1qbhOH:KSIQ8-oZa7JzYWFGT82S8dPbQMk0PpR3HZ2sumqt02A	2023-09-01 16:07:17.204782+03
72ilo6pqisaj01tqkgor1hmg0x1vj0lw	.eJylUMtOxDAM_BXUM4ry7KYcufMHSJETuzS73Ra16QEh_p0kWyG6173Y1oxnbM1342BLg9tWWlzE5qVRzfN_zEO40FQIPMP0MbMwT2mJnpUVtrMre5uRxtd992AwwDpkNXnqjOgVoNUCWoNd35meTsipEyftWzBKgDbSGmitVkqGViMItMpbbXQ2nf3ZpZhGynbvG9cCS1XmqTZZqvZ1FnXmdb5V3PUX-npA_QkLTemhJ2ikkPMLDiGBuyWrOOOWSS5L9nF1fzvXnPUwlo_5HYMQKy7u8LAt5cVdcTy2JljS8dzPL927nqM:1qbEJK:YAPVd_ON38ZZFhPQnz9tKS5Ggsbf0Ca-pSpwoAy-mTw	2023-08-31 09:04:14.135445+03
t7y16s6dyye1alrvz4ju140yqrysswgu	.eJxdUMlOxDAM_ZVRzxBl7aQcufMHSJGTuLQzoUVdkBDi30ncskwv1tPzWyx_Vg7WpXPrjJPrY_VQqeruP-chXHEoi3iB4WVkYRyWqfesSNi-ndnTGDE97tqbgA7mLrvRY2NEqyBaLaA2sWkb0-I5cmzEWfsajBKgjbQGaquVkqHWEUS0ylttdA4d_cUt_ZIwxz2vPMeUqbBMzQm3hBVNcZInksk_mdI0-Z52xY-clfAdk7j_Id9gwmG5bbJkC8cO5QmHrY-YSJh4ZbZ-MsjyV0wY8vOCi7CA296qOOOWSU6Cfna_mtf86C6VA_lhE6EnXhz4sE7ldHJ8fQP0j5QP:1qbByK:K2e7831mUJosvtW01V08bP-Glv_Sp0-unMHOQFO4sD0	2023-08-31 06:34:24.871827+03
timbkqpi1xqeekopwisxqat7whymdid1	.eJxlkM1OwzAQhF8F5QzW-rcOR-68AZK1trckbZogxzkgxLtjJ1Ep5TKHb2fG3v1qHC65c8tMyfWxeW5k83jLPIYzjXUQTzi-TyxMY069Z9XC9unMXqdIw8vu_VPQ4dyVNHlqNT9KjFZxNDq2x1Yf6RCBWn5Q3qCWHJUWVqOxSkoRjIrIo5XeKq1K6eRPLvd5oFLHAQS0Uu_4TJ8FXihTeoKdfWCiMV8TbwuUh6tKsSpUVZtuxP4SCQ_cmNJEA4Wyb3ARM7rtEpIzsEyAkP8Mc8aUqwVuLP3srq5LOV831N_C3SRiv3J-x8OS6iJr4vsHeFaH5w:1qbcr1:StIRUY9zGGg4RfUTO6zK1ze_2eqPc5MbDFMvg0mG5mI	2023-09-01 11:16:39.368237+03
rupxc931fxttq0w19qjw0qz9z16fxjcp	.eJylUs1uwyAMfpUp5w1BgDTZcfe9wSRkwGlo0xAFInWa9u4DGm1td-zFWN-PsQ1flYI1DmoNuChnq9eKV8_XmAZzxCkT9gDT3hPjp7g4TbKEbGwg797i-LZpbwoMEIbkRo2dZD0H2woGjbRd38ked5Zix3ZCNyA5AyHrVkLTCs5r0wgLzLZct0KKVNTrg4oujpjKfaxUMJsjl0_lqHMUuuSs5LTkl2g3_xE_H3DPsOAUH2oCRzRpf0ZZiKAum6UtoR2pac3_CUKEJd5LXFC_qlN6jmHMQ9E7xoIrOLvDzbrkKTaHGbwzqHpXJvL7yb0wdayTnJzHcP5ThAExm3DMNMt9RDMrN-ce4xoSddlSuuYGMn6dYvoI19h1PzMuzpc1VN8_oJfO6w:1qeYQc:P-mJRRHXA1cv8zeRutiL2edwwid6i8khRuPQczoQLFE	2023-09-09 13:09:30.871108+03
79f96rl6a9a639mw7lp3bmsunarjuz48	.eJyrVspPyoovySzJSVWyUoopNTAxTAGRxqYKYMoIRJokgdmGYLYBmA0hU5R0wPqzUysp0F2QWJSaV0KRI1JzUpNLijKT41MSSxLji0sSi0qAJhlY6BlY6hkZGBljKEnNS0FVUAsApRtN0A:1qfaZO:JJ54zHlMgdHOh8GDERPYVZi8B-xiVsWZLh20fC_n7Vo	2023-09-12 09:38:50.633187+03
qu5im9ytlgzawg8tl6f5w2khvs9ocam0	.eJylUktuwyAQvUrldWsZA47dZfe9QSU0wDgmcY3Fp0pV9e4FErWJu8xmPHqfYfzgq7LyIIIJM1bP1VtsGNG5Uv5QPm2uTJaelL4p_bnq6rH4j_h5h3sFh0u4awmcUQVnlNAQQPgALqRJpK2boW6blv6T4KK3AgExTCJ6dMJkcoNJUMezSx9g2dta2SXNk3WW1BfW169W4_xy0d4MmMBPyY0SB05GCrpnBDquh3HgI-50gwPZMdkBpwQYb3sOXc8obVXHNBDdU9kzztJQ48Xv37ynLaY5x99sGA2m4GSDr-iM1ReDmqxRKEZTorf7xTwRcWyTWnjx4WJ9mv3pT-cnxJxsopOI5IiCWoVZc-Yh-kSdLzWddQMpG5eQQrjGrpdS0eVHULb6_gEnLdFv:1qfxyP:mjOhLf4XuOpN4JTfGiCxLPglgsmM3y7EkPhHlsjvpmU	2023-09-13 10:38:13.404249+03
np84m3ud9br0ti0ivuw0w6j8uypczpym	.eJxtkk1uwyAQha8SeZ0g_uzYXXbfG1RCGMYxNTWWwVWqqncvYKuJ025G6M03b2aAr0LIJfRi8TALo4unghXHe62VaoAxJfSbHC8OKTeG2bQoIWjLevTiNNjnjd0Z9NL3sRpaaErSMalrTmRV6qZryg7OGkNDzrytZMmI5CWtS1nVnDGqKq4l0TVra17yaKp6ZxSIzliIhu4ymhMRAxFg0dX6643wPUBIPa0YqCBpo6AmYSbhgwyLj6koufYNVNhJyi1jiDM_YCKYkHu-LjgOnyKDFDnO5y6fWY7kQLeiAT5jiYUPsPSEN3GSM4xhZ7gWshYdsr26syc58qzUK5WVlbkjGb3xbB0wj8a746GpY2-wcdfZKKFlkGm_OV0Q4Qg3iGLK_iDrm-8A48Uv8x5_QW_Tgvgho6XJOnnQJ5iN0_8UqGVOd5Iz3z_-is_4:1qghz3:yZIzKAXxVCyWWFpr6f5UR08Rm6gVVPvTDk4POuMQWX8	2023-09-15 11:45:57.352525+03
xyp3hqxhz1tw3ju0osynu8rgnxgzcspa	.eJxlkEFOxDAMRa-Cuh6iOHHShiV7boAUOYlLZ6bTojZdIMTdSUOFBrH5sr6fvy1_Np62PPht5cWfU_PU6OZ07wWKV572RrrQ9DaLOE95OQexI-LoruJlTjw-H-yfgIHWoUxzYGeg15Q6BLImud6Zntsk2UGLwZLRQGhUZ8h2qLWKFhNB6nTo0GAJncPF53MeucRhi6ClO9wrfxTvxpmXR3l477TwlH8HXjeJ0O-Kelcdah2rQnVkreVDRSsEalcFp-IpAItS2nJZ2cAjx_KG6BNl8mumJZclYIR0Qkml_yE_P7wDvr4BDLhz2w:1qh6No:-qO_XLe0tb9ALzW1Bb78LupotJ7d7R7ekyPryJP0zhE	2023-09-16 13:49:08.844347+03
pq91rw4rweslegz6ael6yt8mkkmm19sh	.eJylULtuwzAM_JXCcyHo6dgdu_cPCgiUSNdKXCuQ5SEI-u-1lKBA3W5ZjgfeHUHy2kR3tDnkiZqX5n3lWmBBZZ5qkQW1q1xUziu_ITbPNX-iywPpMySa80NL0EQ-p-AtQgZLM25zpGC8Z5JLtRksrHm060LJhiLueg786ZbCI8wfkfk4b_McKxZ2Vxf2FpGm17v314ARlnFLk6PeiEEBdlpAa7AfejPQATn14qBdC0YJ0EZ2BtpOKyV9qxEEdsp12ug_pywZUt4fExb74_rcFh2n8n6-UxBC7Ytd36-p_PufxJlSiFiFr29GY6cr:1qjDRL:2PjBjGU_V2nLc617KuN7jZ7mTZUASjd01TFabc9YiMU	2023-09-22 09:45:31.678546+03
a9qo5744zimor6g2sthnpa0phdpsrnfz	.eJxVjcsOgjAQRX_FdK2kZaa1uHTvH5iQKR0ERTBQFsb47xYhPjZncebeOw-R0xiqfBy4z2svdgLE-tc5Ki7cTgd_pvbUJUXXhr52yRRJluuQHDrPzX7J_g1UNFSxzY4zrUogb1GR0T4rM13y1kvO1BadIQ2KUKdWk7EIkBYGPSlvwVnUGEc7d85DHRqOczEAgGAWfeF7lFcO3G_k4m7Ucxs-jeMo4-OJkL4pJ-LM2divAbmSUonnC1bgWVU:1qjcMh:7ZLJ1HtC8ZGccJMPDs8-YDJwRH8ILu1QRAB1yYDHyHI	2023-09-23 12:22:23.50438+03
gy2px1f3modc2d3ipcuw86nsdusg4fzr	.eJyrVspPyoovySzJSVWyUjIxBgITYzMlHbBwdmolUDA3tSS1SNcAKlaQWJSaVwLXEVNqYGKYCCKNjcCkAYg0gZAQEQuEiLGBgoGBoVItAGiiIqE:1qkfBb:vrjfDU8-Cntp1_3AGbkfU-KEpu50cLQUIv8SX_a6_qo	2023-09-26 09:35:15.687867+03
h40kx0xxeoofwuuo24g890p80yck8ojf	.eJxVj80OgjAQhF_F9KykpdtSPHr3DUzIli7yJxgoB2N8d8tPNOxhDt_MTnbfrLd15ivfEjszkGFAanZccEOvAB_kaTjxjT1xoM7_Nm4TB4GzynhRPiusuhLzJ5IfOBehKcPJl9k00pBVLtTIPbOYN9TNhquxu_dR3nd-qGw0R6LNHaNr76i9bNldQYljGbbJUqpEIdGZcKVWLi1SVVDiOKUiAatRSYGgYqNQm_B9nGtwKJyR1oAC9vkCzTdZVQ:1qkfHr:j-KDQwBpo0K12phansg9DlYYukGY7eq9V9cvpXMmMCo	2023-09-26 09:41:43.48698+03
eoseih9on2jxf20260ouulfebytkqqha	.eJxlkM1uwyAQhF-l8rlB_NqQY-99g0hoMeuaxLEjjA9V1Xcv2Faappc5fDs7LPNVWVhSb5cZow2-Olaien1kDtoLjmXgzzB-TKSdxhSDI8VC9ulM3iePw9vu_RPQw9znbXRoFOsEeC0Z1MqbzqgOG0_RsEa6GpRgIBXXCmotheBtLT0wr4XTUskcOrmzTSENmOOkYEbThu_4gp8ZXjFhPNCd3SDimO4bp4Xmh4sKviotKjfdiP4lgr5QWqrAAdv839Z6SGDnBDHlMK4INYRT_t-ylcXZgyHM9u655vr6oVxLnyYewsrZE79hDJNfF75_AATyh3A:1qkg5W:mk75LzPBd_C6hi2FBkqy-o-nksYjxrWgKuMk6l5mdHM	2023-09-26 10:33:02.220371+03
hsxeo10a0tnhiyu8vkdlyauqlpkw1p6n	.eJylULtuwzAM_JXCcyHoQSlSx-79gwICJdK1E8MubHkIgv57ZcdDio5Zjgfy7kDcrYm4li6uC8-xp-atMc3r4y5hvvC4HeiM49ck8jSWuU9ik4jjuoiPiXh4P7R_AjpcuurmxMGq1iB5UOgshTbYlk8kOagTJIfWKASrvUXnwRidHRAq8iZ5sFBDp3SOpS8D17jPVYKiDY192YfeENLO1c7lzu9Ih__C1yfc3zjzWJ56ggfOtb8cCQvGpeBcapJ2QgahpTb_JPfyHwQ_vzVNhIQ:1ql3fb:qtLb8oDPXo4wXlWBH9LVfdjalSB7SRX9Z_a4FTyk984	2023-09-27 11:43:51.358355+03
cson042wfjgzugtfr2rub69ikhnjtqgy	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1qlRIe:FCoJrWzc44_yXDdthAJOm66N-raOgmYVuNl__sDRm_c	2023-09-28 12:57:44.044232+03
3p40ugamqc29c5lczu684b4doxwlp3ww	.eJylkLtuwzAMRX-l8FwIelCO1LF7_iCAQIl0_YJd2PIQBPn32I6HZG2Xyws-DoF7KwIuuQ7LzFNoqPgqTPH52ouYOh62AbU4_IwijUOemii2FXFMZ3EeifvvY_cNUONcr9cc2VtVGSQHCktLvvK24hNJ9uoEsURrFILVzmLpwBidSiBU5Ex0YGGFjrENvzjxkENucs8r9bJIULSpsR970ZtC3L3avdz9U-nA_Oeee05rAikQZgzPbLQX0gsttTkedHz9E_7-AFboedQ:1qm94P:re5SppVwnHsDDM4mXP5L_Lzpin6s-RdLm0Ghqvgrd8o	2023-09-30 11:41:57.535159+03
zgoz4ma2fjckkru7vfg9c1li2gek8x40	.eJylUc1uwyAMfpUp5ykKAfKz4-57g0mWAadhTaEKROs07d0HabSuuVZCxvp-bIO_C8AljrAEmsGa4qXgxfN_TKE-ksuE-UB38KX2Ls5WlVlSbmwo37yh6XXT3hUYMYzJTYp6yQaOphMMG2n6oZcDtaainrVCNSg5QyHrTmLTCc5r3QiDzHRcdUKKVFSP3mqCwU6UCvqDs8AgoKNLhCMrL1O43FRhJIpJNhJGmDwaYFVioz6DPUOIGJeQ6AR59UE63kHaLy6m2XcyiDauvd-XSjCTI5dP61XnKNSaszWv1vwazeY_0tcD7jPO5OJDQ9CUnjpbDQYjwnWvdV9WfVlXdd68DfCnOaVNj1OeuNoxBu2Ksx2ulzmPuDnum6W_nOO-nZ8MnCh9dS7WtetJsKPPG8yTlPO2-PkFfQbWyw:1qmBBo:CGYJsuKXIaBcGnku-YykzO0bdkuirh1wfd_amXl8A9k	2023-09-30 13:57:44.890184+03
hyq7yzeokkyb0p6jfhbd8x9jf9s5eib0	.eJylUMtuwyAQ_JXK5wqBAQf32Hv_oBJa2HVN4tgVxoeq6r8XiBUpvuayjHYeWua3WdzZppAmat6az40rgWVK_VKftkzlKhYV84pvE5vX6r_QzxPub4g0p6eOoIl8isFbhASWZsw5vGOCs5a3MgssbGm020rRhkIedg785ebCM8xfC_PLnPMcKxK2syv7WJCm9137EDDCOmY3Oeq1GCSgUQI6jf3Q64FOyKkXJ-U60FKA0q3R0BklZes7hSDQSGeUVjk0rPb-m2u-YpxKt_zAIIS6F4e932Ipc3c81rImiJVR92L-_gG4MJ6Z:1qoeMG:7Vgs-McVIXJhrphpKDPeFjZC0IjyPplLQ-2lFv2aC1s	2023-10-07 09:30:44.849359+03
t9b2lx8fyu1xwnt8u0sueiivz6gbwjkd	.eJyljjtuxDAMRK8SqA4EfSivlDJ9bhBAoEQ69q5hB7ZcBEHuHku7RT7lNsMB-WbAT7GkcyxjmVg8idddgaaq1j20YapCal43r5q_KonHlr_wxx3pd1x5Lnc9wRPnso45EhaMPNPRo4LUShpl7D9gK7iWisAPJOJehrhvvMax5v_sEubLtZjOOL8tMi_z0ZhkReTtusmXhXh6vrG_CgbchiPNiYPTvUXyoLFzFPrgej6R4qBPkDp0ViM44x12Hqw1uQNCTd4mDw7E1zeeCIRx:1qplyG:ohkvwYgIcas2i6aKcVZ8ZlL43EGU21C1C8kz-h54jS8	2023-10-10 11:50:36.905362+03
gl4wblwc4ams50o00owj7x1alki1yxos	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1qqbRQ:wpfDlIM5TyU__judQubT7-SITu5LLGvdSMMwORlxR1E	2023-10-12 18:48:08.421516+03
9sl7mpdg85a1v67spfepiz1wcmmcpapc	.eJxtkc1qwzAQhF8l6JyIlWVjJ8fe-wYFoZ9VrFiVgiUnKaXvXtk1pC69DMvMt6MFfRIhp9yLKeEonCEnwsj-t6ekHjDMgbnIcI5Ux5BHp-iM0DVN9DUa9C8ruynoZernWo5tiw0H2x1VBUduj1raGqBqLBoArXTRxvCma1CrpoOqrUF1yIC3tp6v0n10GoV1HkthPAd3YMLdxcDow6fHk0g9Yi7IwMRN-oy6RNEb8Y4ZR3IKk_d7EvC-NbK-CncVKcs8pbI9L6kL6ryxdJxCWfqLiezyctbbBDWTs3KctYZltsvMF2U7tluw6onxelFY2wb8KF0eb-jZga3mVY4Y8val_yvQl7NHp4WRWYqf72OMMqAVVJx8fQNeE6CO:1qqcFT:Loceve8wNntpZ7LRTk4DryXStsQSgxL6QFyeIB5QZkk	2023-10-12 19:39:51.190681+03
0h79p4dckliik7enon5atufymrjpghtt	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1rFWKQ:3H55HdZeuFsDwlQOohIzvQt020OmCYFmCr_jilOF0-s	2023-12-20 12:23:54.320766+03
idm3srrb5dlbaowwa2pkgfmkqa00fmce	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1rQmku:lVLWmlkaTBQ-xjByb2oCHh2iLDwztgQZZgIqw0IajuM	2024-01-20 14:09:48.966613+03
dj5x5pjanm9stuczpxik4k1p5qliidef	.eJxtkU1uwyAQha8Sed1a5s-xu-y-N6iExjAuJNS2AEepqt69mFhNnGaDRu9984aB70LCHI2cA3ppdfFSsOLpVutAHXFYDH2A4WMs1ThEb7tyQcrVDeXbqNG9ruwmwEAwqRs7bAXpGeiGE6iFbvtW9LjXFbZkz7saBCPABW0E1A1njKqaayC6YV3DBU-hyoxWoeytwxTYewxGGoQo3Qi6PLtwvkLBIMZEHSWTx1PSo5qknWSIEOeQjCSN3QFV3EhqnIeYLn2HyWhjHvo-V5zw5WSYT7Wj_GmXSyjJSh_xK7EOT-joc7WKE3gc4jYpZ_Aqt4tci5tsmpUu1-1lBskSy3U2uLqirLrEpYHo0mbeKqkhwrKNXx6DsrKiJa0o_4dcvngD2CD_mM_06cYtW1V3jgabdXKnq9kv-z7qQBfhgT6ht6POxs8v3b7T6Q:1rdRVo:nTAs5nYLWiuSS1xJr_3aj6r625N3uP2bMn34iHSbxHs	2024-02-24 12:06:32.319793+03
wx0v1snipanthnsrghpkf0h3nodqs3v2	.eJxtkctugzAQRX8lYt0i4wePLrvvH1SyBnsoTghGtqlSVf332oCSkmYzi3Pv3PGMvzMJc-jl7NFJo7OXjGVPf1kL6oRjEvQRxg-bKzsGZ9o8WfJN9fmb1Ti8bt5dQA--j93YYiOKjoGueQGl0E3XiA4rTbApKt6WIFgBXNBaQFlzxqgquYZC16ytueAx1LZHGUwYMMaJilUVLzZ6wq_IzhjQPZONTeBwDNeG95nEuakyulSSKl_rSuobYeRwIITGKBxQxX2V1BBA-gAuxDRa5YTmlFD-z7Iea2dQvTUKZWeWl3QOfS97hCAHCzq_DP5yM_keMU04SSZPn5EHNUkzpclh9lFY14sTd0jZeYzb75jx8vq0c_y1fkhXIneKBrPw4o6r2aUDPurAIcADPqEzVi_Czy8UO8Gy:1revhI:4FzaKRWxCQR0JDFNB2GjEupM7kf2oWMf4bGEvlkHrCA	2024-02-28 14:32:32.261865+03
t5iqhyfiirge9k7el08jk58spsi2abw1	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1rex0u:-Iir0F6qSDoIourpgWEJAncFhs1j4uV3urTvib6sWCA	2024-02-28 15:56:52.00049+03
9hq3joi9ena9oe9aay37mfnmrpfejxgq	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1rexs1:UxCLCtM4BOwRTulGBhr9oVqL6wUQxukEvaKOos8DJ9M	2024-02-28 16:51:45.309987+03
lxs4b6l0w2iw1b25356xhrssimd9ksaf	.eJxVjskKwjAQhl9FcrZhmqWLR--efICQZWKipYUmhYL47jZSUC__wL98zJMoveSgloSzio6cSE2Ov57R9oFjCdxdj7eJ2mnMczS0VOieJnqZHA7nvfsHCDqFguXYtig5-K43DHrue6u9AGDSowOwxm4qHZedRGtkB6wVYDqsgbdelK9smKJF5eOAGzCgzmrGW0wZ56puKmgqBkwc6l7Jhq5DWr-bFBDzNrp-7usNmtNPUw:1sItBx:gBgbFLiB7acFPpm46qDWThXPg72sm-3CW7wDFzwwSus	2024-06-17 19:57:21.281296+03
nrffkmbxm32ig63fwqzdgmbbsej692yj	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1sajLD:OkPDu0fjhtsaFGi24t-EHgn-cgbOK_vwjT8RcwOd5nM	2024-08-06 01:04:39.451769+03
b0g38g8wtptydnalc4whdk6ddnq6n0xv	.eJxVjk1uwyAQhe_idYWIMbXdZfc9wwiGoZAQY5lBjVT17oUqUprNLL73M-97AFM5QC10QHTD23AaXv4za_BCWxfc2WyfWWDe-IhWdIu4q0V8ZEfp_e59KgimhF6raJ5JK-mX1Y5yVX5F4ycpR-3JSYkW29VO6UUTWr3IcZ6kXegk1eynvgpDjkjgY6JW-GW4T77uNRUCpuueGgGfD0jZOHFL5fYIlUDELXV5hb9gUxh3iDsUNlxLkxrK9kzITwhz3fqjB_v5BetaaFE:1sdaMb:lAdoi0hx56rL4nYz4lJ9OX6TDm_5K0oRfRMMWmOsQ7Y	2024-08-13 22:05:53.245379+03
jly0cf2b6qrafwxs6kkhirosd3hdgvhx	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1sg8be:UE6-XvSamZ9k3qX28hkPsuh4TBdAgfrpLkZk9HZfmfA	2024-08-20 23:03:58.183139+03
73upv7hml5rsmua63yjg62k9q6awvivb	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1snm3r:_u7OAo3ffC_niRPZh_ijCIEpENhNiJWUuoF6--QiFXU	2024-09-11 00:36:39.497212+03
dt0peqvt7l0hjg4u7yao2xv6z0mkvc4t	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1u7i52:WSjb19Es7oA6wgg0hHVDNYgCI33wrufNe7ZFqL5GF0E	2025-04-25 00:56:32.076746+03
83czlre5vkp1ekh9sz0er2q2sv6o400l	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1uhp6y:1z9Wdx7aAzhCsL6acccyQUTwgcODMor4x5GEbO1TkZo	2025-08-02 15:43:48.702111+03
ifsf3s96c86ztcso4jit5goskw7aea1e	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1ujvlD:XAL-X3UYNAvxqmC55xxXE2b--GTem_ePTPbHhT7RY8I	2025-08-08 11:14:03.20668+03
gd3h7a8qd0wgqehxdtyefz2mh3yq19cr	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1ukLHe:FKxAwwwPjJyhHi-nAEbTdTibk8YtYQPOuu4KWtjBPfY	2025-08-09 14:29:14.623305+03
2xfm9bvp43jywr591nu55ulyjaay2otf	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1ulSq6:vGUr3OOiu5wR46NEapGZe3TmjTvHIe1lLquesPIYvOs	2025-08-12 16:45:26.943603+03
fzwg388f20q1dy3u1rgx4qym6ptrikk3	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1umfiE:zyVYrowrKtZigpbykEzoLdrjLk4Z4ViKzDpEKt1TIOg	2025-08-16 00:42:18.813675+03
3uu2ji1jksud2e54opgp1tuwyxit199d	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1uoLDC:X0mEz7korjaz0V7QsbaAhTNe_7pL7AjsngkaVj_Moz8	2025-08-20 15:13:10.520049+03
7q8bch7rx42p3q32nf4vg0tq75lakbdp	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1upNYW:tkpO0kzsJu9Jm8tGVXf0ySATASSipbPNiP80E6IVjnc	2025-08-23 11:55:28.327646+03
6ahf0klb1eqfkadhmu0363jibho4h3qn	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1upP7r:B3jwH_QEpmBIfAXuA9hEabNwNQiwAnjAfn3RaN2G2FA	2025-08-23 13:36:03.528971+03
6it8y7w2f0eazinqvbwisnr4u8r3cnoj	.eJxdjsFuwyAMht8l5y0KAVKyY-97g0nIgDNo0xAFU7Wd9u4jVdSt42Chz59_-6vSkMnrnHDRwVVvFa9e_jID9ojT2nAHmD5jbeNESzD1qtRbN9Xv0eG439ynAA_Jl2k02Es2cHBKMOik64deDrhzDfZsJ0wHkjMQslUSOiU4b20nHDCnuFFCihJqfQwW9RBGLIHn24ikCRPpMYKrL2O6_ErJI9LDOs05LWfOWBHIzjrMOhFQTsUoKJoDWnpCNuaJyvX_NE2B7tvl-jZ2xGshJyz-a7OxGRac6KF_5Ea0cq2svf9Z9f0Df3V89g:1uvuzt:uAmQ9Akyt9CNyKB9k6RTutpFV0vMDHw1mARH7A0wk04	2025-09-10 12:50:45.217077+03
513dprqmoe80ciar9cixw8nhfeapll5j	.eJxlkL1OxDAQhN8lNVj-zSWU9NQ0SNbG3hDfRUlkb-AQ4t2xc5Eg0Ewx88145c_KwkqDXRNGG3z1UKnq7rfXgbvgVAJ_hul1Zm6eKIaOFYTtaWJPs8fxcWcPAwOkIbexw9aIXoFvtIDa-LZvTY8nz7EVJ93VYJQAbWRjoG60UtLV2oPwjeoabXQedcMcHNo-jJgHY_Aw2XcgjOw6pusPkAZEysRzyexF5ITcYsNiEwGtKUfZmrszOjpYbl6nUvmDWQq0Pfmyci1FUS2LKrOp31Tv8AU_MjriG47ynu_mAhEnOg7xrdbcypvenPJ_OObbYnDWA4G9_T9XTHAmuTT_gHxwpCPy9Q3MJJd7:1v4e9V:lSIQ-LRBOdSnN5DuihrHir58H8CHiupoiyRPzsZO7hU	2025-10-04 14:40:45.265489+03
i6nmiy9q180sixlc2827j9slu5wv67km	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1vSY3p:TQQLOx2z0X8FRlHy9olvcD6rQ2D73J3DdQlizUEGVPM	2025-12-09 13:01:41.902164+03
z3xipiqridgw0ghaqm882h82dtz9qbhh	.eJylUUFuwyAQ_Erlc4UWMLXdY-_9QSUE7Lomce0I8CGK-vcCsaomPeYyrGZmR7vLpdFmS5PeIgXtsXltePP8l7PGHWkpAh7M8rkyty4peMuKhe1qZO8r0vy2e28CJhOnEiup60hJGPvBChjkODgztgBCjYQAzrqMCqXqFTmrehBdC7YnDrIb2zLVag86-TRTjvvYoOVYUKqn-oiCra01rzXU-oq49x_p_ED3yQRa0kND0Ewu389pNMnomExIOUl0DDgTIF7-Wa7HvzH4qH89X_k7prksBXcKGl95fsefKPgVa8P3D56tngQ:1vkofW:RV2xRs3PwW-VxihNE9n11Hd0PjiPPZmMr0YMEJRsGdc	2026-01-28 22:24:06.192506+03
9mig0j7behl79loxh91ctxe66ye2od6t	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1vlDca:ajjp9812Q7AUDTyQiNl6gojeOMdQrGJvrezva0X1WTk	2026-01-30 01:02:44.562663+03
ghsvxvxccmzhvi1nyf5144ax6rlrpx1e	.eJylUbtuxCAQ_JWIOkJrHmc7Zfr8QSTEY4m5c8wJcBFF-fcYzoUvKa8ZVjOzo93lmyi9lkmtGZMKjryQjjwfOaPtBZcquLNePiK1cSkpGFotdFczfYsO59fdexcw6TzVWI59j5KDH0bDYOR-tNoLACY9OgBr7IbScTlItEYOwHoBZsAOeO9FnSqasyqhzLjFva8gOleRy6f2sIrCtLprNbT6hm7vv-DXA91XnXApDw0RssIZ7XZCqz63U05zHQj-KE6Hxte1D2TRKhedSu04UZCUATv9s9y-685wzL5iCrE5yM8vML-eBg:1wKfIj:E-NuwMluH9DoVR2m-8MN8vkC5Zlliudw_yzmR9vhsls	2026-05-07 19:40:45.05488+03
kmzp3r4our8xp5nqwtjskonmuo2kq4cy	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1wOvHV:n-WXARJ9Y4jAaCOzCnSMrpQ4_mOInjH1EkSgf8utET8	2026-05-19 13:33:05.116708+03
zpa0qt6bkhyyu0mlmkae4emuhrqbk77f	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1wRsmZ:0XJ3FcjerPe0YWMhaFedfOMKHcwD6MixJmr96MtIa4k	2026-05-27 17:29:23.872625+03
al82bgdtfaoidx997nujdo9wxx7akord	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1wZRaF:aW-HEcRbRARi9p8Ii9-OcU8sERuwV0STX-m8lThDss4	2026-06-17 14:03:55.517876+03
1ekavt8zoa4c3y2n6xz8oigxymlwu1xy	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1wZqSM:PPZIazh0R-hsDt0KHpuqgC95jVBrATGsqSdElyy6p7I	2026-06-18 16:37:26.039084+03
2sw12kwnuhsd2qz0k6j62nrtbrsb2x15	.eJylUUFuwyAQ_Erlc4XWYGK7x977g0pogXVN4poI8CGK-vca4oOT9pbLsJqdGY2Wa6VwSaNaIgXlbPVW1dXrntNoTjTnhT3i_OWZ8XMKTrMsYds2sg9vaXrftHcBI8YxxwpqW5IChq7XHHox9AaHBoDLgSyA0WZFaYXsJBktO-BtA7qjGkQ7NLmV10eVXJpojftcoKltRiFfysMzNrrMdZmhzDe0m_9ElyfcZww0p6dKuKhoIrOe0Kjv9ZTjlAvBw8aiK3z9wJsl5Ab_OWhKuPG7mIQqJgzZwXsGB8aBH_5Ibh98J9hnnyk4b0v4zy9bpq8l:1weAhr:aeQxMoPh5U9K7YDusA-AuTpUEC9Ge-btyst2wiD4wJw	2026-06-30 15:03:19.912739+03
itnokwzmyohjp5ya5bzksjdrcouicomu	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1weXJy:s5HfO4E8dbkqJVZVNA2hN1fZ7-odYJhNkVl4BUxu2js	2026-07-01 15:12:10.954684+03
isqhucuqut2w20wgau84vy2qkpcrihzb	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1whQBx:OYdmEQrAO511a6JIJpobWUOmM8gBpcpxf138zQlD5HY	2026-07-09 14:11:49.803193+03
r4vsebudfr27s8u4r6stopyf5xulhy8l	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1wmU9H:de1PCTlW0YHNHGPpRWaFY0oKhkkty4reTFdAZ8JpF0Y	2026-07-23 13:25:59.429732+03
yegvqdr94btw4066iccdmhbds3ez2h0z	.eJylUMsOgjAQ_BXD2TRLHxY8evcPTJptuxWUgIFyMMZ_lwIHiUcvs5PdmclmXpnBMVZmHKg3tc-OWZ7tv3cW3Z3adPA3bK8dc10b-9qyJGHrdWDnzlNzWrWbgAqHKsUK0pqUgFCUlkMpQukwSACuAnkAZ92EygtVKHJWFcC1BFtQDkIHmb7q7M3EOjY0xV1GkLlPKNRuHjyhtDPPZw4zX9Cv_js9_3A_sKc2_vUENeSm_pzxGNEszXLNQDMO_PAjGCL2cSt5fwDvYIRl:1woL7l:zQbEvgyVe1CoQaCsOMCyitchcQTdLksedH9B4AtNn2U	2026-07-28 16:12:05.55436+03
9yzdulv234z20hgl447ap71h4zf7ercf	.eJytkLtuwzAMRX-l8FwIelCy3DF7_yCAQIl07cSwC1segiD_Xr-GZk6Wyws-zgV4LwLOuQnzxGNoqfgqTPH5vxcxXblfB3TB_mcQaejz2EaxrohjOonvgbg7HbtPgAanZrnmyJVVtUHyoNBZqurK1lyS5EqVEB1aoxCs9hadB2N0ckCoyJvowcICHeIl_OLIfQ65zR0v1PMsQdGqxn5sRa8KcfNq83Lzu9KBeeWeO07LB1IgzBj23xgpZCm01O4IuPLtLfgp45ifAx5_zuKEfA:1wpRaw:GEF5GT94LfHfUNs6aM1YwnSCzEdvQBnZiPtjpMMHMiE	2026-07-31 17:18:46.605343+03
8a6zenw9m31ahpas4r2vgi7tk7n8h04c	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1wzWLJ:qeLGrP0Zpob9bS5gY8a6IkpAKdTSsOsQDwTcdE62zrc	2026-08-28 12:24:17.953961+03
zeo6brfpdss5copfwl0qqyewqwwpd4zg	.eJxVjEEOgjAQRe_StWksM1Nal-45QzNlpoIaSCisjHdXEha6_e-9_zKJt3VIW9UljWIuBszpd8vcP3Tagdx5us22n6d1GbPdFXvQartZ9Hk93L-DgevwrTVrJFeAJaBjTxJLpKKtnDW6FrNnAsdITSD2AQGa3qOwkwA5IKF5fwDtQTeB:1wzZQm:OSkmeItv69n_cgNJoelCT94B887fQTG07RMtn_fXdCk	2026-08-28 15:42:08.443852+03
zj30ioech5qnzbs8sjdewpa0za8m86ma	.eJylUctuwyAQ_JXK5wqtecR2j733DyohHktN4pgI8KGq-u8xxAcnOeYyrGZmh2X5a6Ra8iiXhFF623w0bfO-57QyJ5yLYI9q_gnEhDlHr0mxkE1N5CtYnD43713AqNJYYhl2HQoGrh80hYG5wSjHAahwaAGMNisKy0Qv0GjRA-046B5bYJ3jZaqgjzL7POEa970Ab21BJt7qQQtyXeu21lDrG9qt_4S_L3RfVMQ5vzSETxInNOsKjTyvqxynMhA8KFb5ypdn78isZMoq5qIIAgOhQA9Pltt33Rn22ReMPth66f8VMk2eDg:1x6Zxo:4-ozqW3LHsVmuj7QFlIWi723cw9hPwLFZU6Aor_2-7c	2026-09-16 23:41:12.335944+03
chk3bnhv5tnkx9lh6dxdjc3x4seb7b2m	.eJxVjLsOAiEQRf-F2pDhFcDS3m8gMAyyaiBZdivjvyvJFtrc4p6T82Ih7lsN-6A1LJmdmWCn3y9FfFCbIN9ju3WOvW3rkvhU-EEHv_ZMz8vh_gVqHHVmFVlLRkFxPknwqniMRQNIUygDYMLvmqyMM4TJOJBWQ3IkQNmiBXt_ANevN14:1xBTaf:93lVGFBExNcz3T676IKzjykRUPOAaBbEo5DNcWDwgZU	2026-09-30 11:53:33.15732+03
\.


--
-- TOC entry 3815 (class 0 OID 156080)
-- Dependencies: 257
-- Data for Name: groups_80020; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups_80020 (guid, name, name_sender, inn_sender, name_postavshik, inn_postavshik, dogovor_number) FROM stdin;
\.


--
-- TOC entry 3816 (class 0 OID 156089)
-- Dependencies: 259
-- Data for Name: link_abonents_auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_abonents_auth_user (guid, name, guid_abonents, id_auth_user) FROM stdin;
\.


--
-- TOC entry 3776 (class 0 OID 155956)
-- Dependencies: 215
-- Data for Name: link_abonents_taken_params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_abonents_taken_params (guid, name, coefficient, coefficient_2, coefficient_3, guid_abonents, guid_taken_params) FROM stdin;
\.


--
-- TOC entry 3814 (class 0 OID 156072)
-- Dependencies: 255
-- Data for Name: link_balance_groups_meters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_balance_groups_meters (guid, type, guid_balance_groups, guid_meters) FROM stdin;
\.


--
-- TOC entry 3817 (class 0 OID 156092)
-- Dependencies: 260
-- Data for Name: link_groups_80020_meters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_groups_80020_meters (guid, measuringpoint_code, measuringpoint_name, guid_groups_80020, guid_meters) FROM stdin;
\.


--
-- TOC entry 3818 (class 0 OID 156097)
-- Dependencies: 261
-- Data for Name: link_meters_comport_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_meters_comport_settings (guid, guid_comport_settings, guid_meters) FROM stdin;
\.


--
-- TOC entry 3811 (class 0 OID 156053)
-- Dependencies: 251
-- Data for Name: link_meters_tcpip_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link_meters_tcpip_settings (guid, guid_meters, guid_tcpip_settings) FROM stdin;
\.


--
-- TOC entry 3819 (class 0 OID 156100)
-- Dependencies: 262
-- Data for Name: measurement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.measurement (guid, name, comments) FROM stdin;
01bf0015-d0e9-4b10-93ca-89e5a616d31b	А	Ампер
06f68849-3e99-4f36-9650-a2687a82f465	В	Вольт
146f80c8-b857-4d58-8245-65fb9a8b048e	Гц	Герц
1c39318a-806e-461e-b412-38047f9cd265	Градус	Градус(угол)
23b35f9b-a699-4bed-be1a-a28e3fd6d55d	т	тонна
3006e346-85b4-40a3-ac2f-a63cd0fe5db5	м³/ч	метр кубический в час
45162f95-824e-4d88-90ac-6384973c52b8	т/ч	тонн в час
78493428-e5ab-49d0-815d-70aede4aa4c2	кВА	Киловольт-ампер
903419f1-177e-4881-bdd9-757965bf0757	°C	Градус Цельсия
959d5fe1-29fe-441f-988d-4a57543c5232	сек.	секунда
a3bf7d60-2b8e-43fc-aae0-c1c66106d660	кВт*ч	Киловатт-час
a9cf9822-3465-4de7-8ff8-10c0395ee29b	мин.	минута
abca323e-dc43-4ff3-a6cf-5bc4317dffc8	кВар*ч	Киловар-час
c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	м³	метр кубический
eff414fc-a0cb-4bf9-8ff6-1b0a1711e32d	Вт	Ватт
fac1bc47-3c2c-4276-bbae-14dccb5f643a	МПа	Мегапаскаль
75bb8d6c-1f15-4861-97dc-1a523342ee8c	кВт	Активная мощность (P)
8aac7617-2097-4b30-ba36-82eabc0c3df8	кВАр	Реактивная мощность (Q)
36f4e249-8173-4c78-ab13-75868f2dd57f	Гкал	Для учёта тепла
620b855b-e6b9-426c-9e34-e4b216bfaa41	Ч	Часы. Для учета времени
189b41f4-b792-4960-b222-4542153b55d3	кг	килограмм
01137f32-fe74-4b36-b2e9-4dd753e99309	Дж	Джоуль
82deb686-c22e-46d4-ad36-06b93cac46d8	Флаг	Для булевых переменных
123b9b71-92e2-4a30-83a9-4bc4b6432b53	Текст	Для кодов ошибок
f8f102ff-1374-4180-8709-2b97a5161b22	ат	Атмосферы
\.


--
-- TOC entry 3777 (class 0 OID 155959)
-- Dependencies: 216
-- Data for Name: meters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meters (guid, name, address, password, attr1, attr2, attr3, attr4, password_type_hex, factory_number_manual, factory_number_readed, is_factory_numbers_equal, dt_install, dt_last_read, time_delay_current, guid_meters, guid_types_meters) FROM stdin;
8ac58ece-45a6-49a1-a14f-96cf49dc3ee0	A	500	333333					t	00000000	\N	\N	2014-11-11 16:09:31+03	\N	10	\N	423b33a7-2d68-47b6-b4f6-5b470aedc4f4
\.


--
-- TOC entry 3820 (class 0 OID 156103)
-- Dependencies: 263
-- Data for Name: monthly_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monthly_values (id, date, value, status, id_taken_params) FROM stdin;
\.


--
-- TOC entry 3778 (class 0 OID 155962)
-- Dependencies: 217
-- Data for Name: names_params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.names_params (guid, name, guid_measurement, guid_resources) FROM stdin;
13e0918d-b288-4aeb-a034-4d2269c0d899	T Канал1	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
16462cac-a9cd-48df-b914-bff0cb9c5d94	R- Профиль	8aac7617-2097-4b30-ba36-82eabc0c3df8	ba710cff-e390-48ca-b442-70141c9864f7
21449962-b377-42bf-ac23-b1f4ae148df9	Канал 11	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
245c6491-d633-4689-94a6-7b3e737ce1e5	T0 A-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
2e91f015-633d-4e7c-ad10-3cfd88e77aa6	Канал 16	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
2fb7f1b6-dd14-4576-b66f-5bad98bea65d	Канал 5	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
338e8dec-c983-4044-bf11-3aa961c5d0a9	T0 R-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
35ff522d-0d31-41a1-a9fd-a388a5cbf266	Канал 8	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
37595211-23ea-49de-ba78-c529df6e577f	Канал 15	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
390b5791-fe51-4cf9-9103-a9cf446e238e	T4 A-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	T3 A+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
40e69bf7-fc3f-4a90-8264-988e819a2e9f	T0 R+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
41aef69c-477e-4659-afe2-f73c8ef445c4	Ia	01bf0015-d0e9-4b10-93ca-89e5a616d31b	ba710cff-e390-48ca-b442-70141c9864f7
44d47679-97a0-4444-8f30-bd30d4861789	Канал 6	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
4715571a-8fd3-41a9-862b-6deeabb40c26	ElfErr	620b855b-e6b9-426c-9e34-e4b216bfaa41	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
475ac5ee-3ddd-4311-a0fb-d4bf531cbafd	R+ Профиль	8aac7617-2097-4b30-ba36-82eabc0c3df8	ba710cff-e390-48ca-b442-70141c9864f7
5df2cb38-bfb5-4d96-9df4-815e48b52682	Канал 1	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
62bb153e-a48f-49c4-8628-39d0a3574aa4	To	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
64f9b17d-d599-428d-8849-5db3d37c7b0e	Энергия	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
6792f35c-8b9d-4b4a-ba0d-33a21e37517f	T4 R-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
6e822182-8dca-47f6-a25b-8599423f342e	T2 A+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
7257a7d2-a013-4849-88ad-d12a7d9553c5	T1 R-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
73209f55-c1b7-460d-b5f6-f376f31a11bf	T2 R-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
77c7effc-99b2-4e67-bad9-cef3f3ae47df	Канал 13	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
fed0877d-04e2-4da2-96e6-0403a08ee81d	Q	8aac7617-2097-4b30-ba36-82eabc0c3df8	ba710cff-e390-48ca-b442-70141c9864f7
00b7f1f2-c8c7-482d-88c1-7d6bc0335a78	Ub	06f68849-3e99-4f36-9650-a2687a82f465	ba710cff-e390-48ca-b442-70141c9864f7
0136afb0-813f-404d-8857-94226ef82cdb	T1 R+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
02ce4681-7be0-47c9-acd4-67a6c8d439e9	Канал 10	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
04241d8c-6687-477b-839e-4dacad0536c9	Ib	01bf0015-d0e9-4b10-93ca-89e5a616d31b	ba710cff-e390-48ca-b442-70141c9864f7
04ea0711-7a10-4350-8fc9-aec608703ffb	M Система2	189b41f4-b792-4960-b222-4542153b55d3	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
04edf057-d9ef-46af-b831-6d16d07fb73b	T3 R+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
070e5074-1c09-4826-bbb7-39607ee6b6c8	Канал 3	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
087475af-2791-48fe-87fb-f5e883c97528	A- Профиль	75bb8d6c-1f15-4861-97dc-1a523342ee8c	ba710cff-e390-48ca-b442-70141c9864f7
08c8bc27-59e1-4be3-9e16-5c0289aeea4d	Q Система2	01137f32-fe74-4b36-b2e9-4dd753e99309	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
092c67af-25ce-41ca-85ce-cb96953c930d	Объем	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
0a8ccd70-bc10-4d7a-a1fd-9226ea0e9db3	T2 R+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	T0 A+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
1068fe5c-6de1-455e-8700-abd5ce98039c	Объем ГВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
1d1d1038-2789-4fcf-a420-8be0ba20d99a	T4 A+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
7a72d894-11fe-45ea-9e51-52711c01adf2	M Система1	189b41f4-b792-4960-b222-4542153b55d3	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
7adc8719-8150-439d-992d-97b0d306af8d	ElfTon	620b855b-e6b9-426c-9e34-e4b216bfaa41	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
855aef13-ccb0-4478-ae1e-65d3681e89f6	Расход ХВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	47f0b64c-2bf6-45b4-972b-601f473a3752
885d1ffb-9ad3-4bbf-a3ba-710681c16499	T2 A-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
89591d35-2ea7-42f1-ba7d-d08be4d6be1d	T1 A-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
93896d3a-b7fb-48fe-8369-7debd6683865	T4 R+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
9ad9b931-fe2b-463d-b47f-f0a471279313	A+ Профиль	75bb8d6c-1f15-4861-97dc-1a523342ee8c	ba710cff-e390-48ca-b442-70141c9864f7
9b457f63-51f9-491e-8a6f-1a9aa5ac2e62	Канал 12	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
a30f5530-c027-4d8a-815b-6abfb1d81028	T1 A+	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
a44a841f-701f-413f-ae53-4a99e29cc52d	T3 R-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
a49db310-391f-4479-b57d-aa7ac84dc2d8	Объем ХВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	47f0b64c-2bf6-45b4-972b-601f473a3752
a6c58808-5211-4c4a-8be5-2709e1b1b303	T Канал2	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
a7e2ae97-718e-4667-b9bf-5313479438fd	Ic	01bf0015-d0e9-4b10-93ca-89e5a616d31b	ba710cff-e390-48ca-b442-70141c9864f7
aef66fe2-d8de-4697-874f-d91ef48386e4	Канал 4	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
af4b173b-8292-48c9-8f6a-e18061d75893	Канал 9	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
b33393b2-78aa-4921-a548-d603ec8ca4cc	Q Система1	01137f32-fe74-4b36-b2e9-4dd753e99309	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
bb56b908-a67d-48f3-95c5-4c8eec379056	Ti	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
c7a113bf-6efc-4403-89a0-655872c7e215	Ua	06f68849-3e99-4f36-9650-a2687a82f465	ba710cff-e390-48ca-b442-70141c9864f7
d6296a2d-93b7-4446-b71a-d1fff77e6a9f	Uc	06f68849-3e99-4f36-9650-a2687a82f465	ba710cff-e390-48ca-b442-70141c9864f7
d68113c9-0f5b-43bd-815c-2a66f304c8f6	Канал 2	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
e0f6b50f-127d-4189-a376-3494d2afbdba	Канал 14	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
e3cddacf-7e95-4865-b9ac-e7f2c0fc99b2	T Канал3	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
eb98b248-37e9-4674-8ba6-083b7a4fad2e	T Канал4	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
f001642c-d156-49df-b7bc-bfafcbca2e8b	P	75bb8d6c-1f15-4861-97dc-1a523342ee8c	ba710cff-e390-48ca-b442-70141c9864f7
fac8bc95-2c22-41a4-b0c6-ccb9b07dc31b	T3 A-	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	ba710cff-e390-48ca-b442-70141c9864f7
fb97edae-10f5-4772-9a4e-73e2b0ab488b	Канал 7	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
4d6bb331-7266-481d-9256-741850dd1518	Error_code	a3bf7d60-2b8e-43fc-aae0-c1c66106d660	c0534604-4cf3-4286-8428-8b846270e16f
06f68849-3e99-4f36-9650-a2687a82f468	battery_voltage	06f68849-3e99-4f36-9650-a2687a82f465	c0534604-4cf3-4286-8428-8b846270e16f
3c5923d1-8125-4af8-abf9-862e5b3b5439	Канал 17	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
76245cb6-f5c9-4fa8-8c24-a71f32cc3179	Канал 18	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
4ec1972e-65a7-42c7-ba41-982f79bf60bd	Канал 19	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
32e0ebca-2df4-45f8-807a-921f147210f0	Канал 20	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	12574d66-2034-4c8e-8c8c-249757736858
5a765ed4-ba16-4b09-bb91-9d099a491c32	Объем ВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
fbffd8b0-2ab5-4f21-95dd-c6227822ff9b	Объем_1	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
cdb9e994-b232-42f0-bba3-11d7714bb05b	Объем_2	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
5f7e51d1-d0a1-4a83-a3cd-ad8193cbce6b	Температура_1	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
77857b1e-62b2-436b-88aa-2a5681ae4eae	Температура_2	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
2f6586c6-3bc5-4250-b5aa-f87807483a68	dt_1	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
0f29f4c0-f182-4ca4-a7ab-d976c7ea65bf	dt_2	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
fe51df5a-959f-446f-8086-a4fd0e02a465	THW	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
03991c80-a277-43d4-8aff-716a301153bf	Энергия_ГВС	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
3baa31f7-cc69-43ac-b45d-e7669d60f232	Энергия_тепло	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
a38b5978-fefb-420b-8cac-23411dc46f68	Энергия_холод	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
5d7011b0-2739-4d86-a8b8-5e3302d584ca	Объем_6	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
47b4c408-0945-4e30-b59b-e05789338ef8	Объем_5	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
06c71b5a-d20f-4cb5-8019-37e132c7b18d	Объем_4	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
0d44a33e-9363-4ed2-8981-a7bc065c4f63	Объем_3	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
0ccfef01-cf17-48b6-825e-bbfd297b3673	Энергия_4	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
2f46ecbd-0089-4419-80bc-a92b8d207ebf	Энергия_3	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
5bb63f0e-4cf3-42d4-b62f-3fbcc1c9c20f	Энергия_2	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
009c284f-dffb-47a5-80ad-421f10569b8a	Энергия_1	36f4e249-8173-4c78-ab13-75868f2dd57f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
006e1a1d-d477-4552-a870-960ece95a7ce	Температура_6	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
572e0d91-09aa-4f27-9951-dcd29ba76735	Температура_5	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
a6ef4862-40d4-46bb-a5ab-d83365fa6c0d	Температура_4	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
5b563fd5-7aa1-47ce-9558-d8766c3a5a0a	Температура_3	903419f1-177e-4881-bdd9-757965bf0757	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
15c66fb6-70cd-4649-9861-e9382314f45d	Масса_1	23b35f9b-a699-4bed-be1a-a28e3fd6d55d	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
088d362f-689e-44bc-85c7-7a7b37ba87c7	Масса_2	23b35f9b-a699-4bed-be1a-a28e3fd6d55d	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
d8e48314-1d79-460b-b0ab-acfb20115507	Масса_3	23b35f9b-a699-4bed-be1a-a28e3fd6d55d	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
736723cc-6be0-4e0b-95ce-d1194b8455fd	Объем_входящий_ГВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
576f857f-9458-4667-8a76-71017cbce095	Объем_выходящий_ГВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	57ec8f42-69c6-4f79-81bb-8ea139407aa9
2175afa5-357d-41a1-9fe6-f2e8ce057ec5	magnet_time_ГВС	620b855b-e6b9-426c-9e34-e4b216bfaa41	57ec8f42-69c6-4f79-81bb-8ea139407aa9
cfbb6d8b-d2f4-4399-bd6a-2e95bd740a2b	magnet_flag_ГВС	82deb686-c22e-46d4-ad36-06b93cac46d8	57ec8f42-69c6-4f79-81bb-8ea139407aa9
ab6723cc-6be0-4e0b-95ce-d1194b8455fd	Объем_входящий_ХВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	47f0b64c-2bf6-45b4-972b-601f473a3752
cd6f857f-9458-4667-8a76-71017cbce095	Объем_выходящий_ХВС	c1ebaac1-5aca-4f3e-a560-5c2f67ab7c6e	47f0b64c-2bf6-45b4-972b-601f473a3752
ef75afa5-357d-41a1-9fe6-f2e8ce057ec5	magnet_time_ХВС	620b855b-e6b9-426c-9e34-e4b216bfaa41	47f0b64c-2bf6-45b4-972b-601f473a3752
11bb6d8b-d2f4-4399-bd6a-2e95bd740a2b	magnet_flag_ХВС	82deb686-c22e-46d4-ad36-06b93cac46d8	47f0b64c-2bf6-45b4-972b-601f473a3752
8a9cd773-36d8-46c4-b595-7544d69b67ba	ГВС_current_error	123b9b71-92e2-4a30-83a9-4bc4b6432b53	c0534604-4cf3-4286-8428-8b846270e16f
ab0d249b-2bbb-4f35-a534-d3a82108ecbc	ХВС_current_error	123b9b71-92e2-4a30-83a9-4bc4b6432b53	c0534604-4cf3-4286-8428-8b846270e16f
186b14a6-dfca-4edb-a4a6-548ba47b2b19	ГВС_accumulated_error	123b9b71-92e2-4a30-83a9-4bc4b6432b53	c0534604-4cf3-4286-8428-8b846270e16f
4dc55400-40c4-4720-a916-45ac920e6a45	ХВС_accumulated_error	123b9b71-92e2-4a30-83a9-4bc4b6432b53	c0534604-4cf3-4286-8428-8b846270e16f
c19d784b-119c-4bee-a0cb-92bddc4b1d55	Gi	23b35f9b-a699-4bed-be1a-a28e3fd6d55d	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
f1dc85e8-5d13-4517-96e1-3c748a209c0d	Go	23b35f9b-a699-4bed-be1a-a28e3fd6d55d	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
679fed74-2097-47b7-a928-cdd1577b509f	Pi	f8f102ff-1374-4180-8709-2b97a5161b22	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
067fb77b-d21c-4f28-ae05-4063514c6192	Po	f8f102ff-1374-4180-8709-2b97a5161b22	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
330217e8-78e2-4a3d-b257-ea2e6c617213	operating_hours	620b855b-e6b9-426c-9e34-e4b216bfaa41	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
\.


--
-- TOC entry 3779 (class 0 OID 155965)
-- Dependencies: 218
-- Data for Name: objects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.objects (guid, name, level, guid_parent) FROM stdin;
25568f96-af71-48d0-b087-c2fb740d80b9	г.Москва	0	\N
08c367ae-d97b-4667-95d2-3ca94dfdf45a	Вода	0	\N
\.


--
-- TOC entry 3780 (class 0 OID 155968)
-- Dependencies: 219
-- Data for Name: params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.params (guid, name, param_address, channel, guid_names_params, guid_types_meters, guid_types_params) FROM stdin;
e7617c95-7e42-4cfa-9acd-5bc119261c6d	Меркурий 230 Q Текущий -- adress: 6  channel: 0	6	0	fed0877d-04e2-4da2-96e6-0403a08ee81d	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
d262c71a-6da4-4ec0-a9c3-b9ea659c246d	Меркурий 230 T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	bb986590-63cb-4b9f-8f4b-1b96335c5441
cad09d8d-83fe-441c-8284-848670ca9ca2	Меркурий 230 T2 A+ Текущий -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
c3bb9033-ffcb-4a28-91e2-6b45924b8858	Меркурий 230 T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	bb986590-63cb-4b9f-8f4b-1b96335c5441
c31297be-220b-4971-8642-6b614aa7ecee	Меркурий 230 T2 A+ Месячный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
c06f7315-abc6-4889-97ad-201a936c8f2c	Меркурий 230 Ua Текущий -- adress: 8  channel: 1	8	1	c7a113bf-6efc-4403-89a0-655872c7e215	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
bdcd1268-37f3-4579-a9d9-5becb2ba8aa3	Меркурий 230 T0 A+ Месячный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
b4c188cb-d57f-44c0-9fe2-fc20deeb74ab	Пульсар16 Канал 1 Текущий -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	baf23191-8b7e-410d-8053-a654c11aaf58	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
b2c4b339-0256-4f28-bc5d-92ed78e6d9f7	Меркурий 230 T4 A+ Суточный -- adress: 0  channel: 4	0	4	1d1d1038-2789-4fcf-a420-8be0ba20d99a	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	bb986590-63cb-4b9f-8f4b-1b96335c5441
aee312b0-adb1-4be9-9879-b3a3598f9b29	Меркурий 230 Ia Текущий -- adress: 7  channel: 1	7	1	41aef69c-477e-4659-afe2-f73c8ef445c4	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
99cd6002-f81c-4ad6-9cb0-53a92a498519	Меркурий 230 T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	bb986590-63cb-4b9f-8f4b-1b96335c5441
7ed0d364-e790-4325-a927-9ef86a685f00	Меркурий 230 Ib Текущий -- adress: 7  channel: 2	7	2	04241d8c-6687-477b-839e-4dacad0536c9	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
6af9ddce-437a-4e07-bd70-6cf9dcc10b31	Меркурий 230 A+ Профиль Получасовой -- adress: 0  channel: 0	0	0	9ad9b931-fe2b-463d-b47f-f0a471279313	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
66e997c0-8128-40a7-ae65-7e8993fbea61	Меркурий 230 R+ Профиль Получасовой -- adress: 2  channel: 0	2	0	475ac5ee-3ddd-4311-a0fb-d4bf531cbafd	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
5a71b97f-6036-43b1-84df-cf77f9457f20	Пульсар16 Расход ХВС Суточный -- adress: 1  channel: 0	1	0	855aef13-ccb0-4478-ae1e-65d3681e89f6	baf23191-8b7e-410d-8053-a654c11aaf58	bb986590-63cb-4b9f-8f4b-1b96335c5441
56641ef5-9d6d-48a1-8c37-cab959b3c758	Меркурий 230 T1 A+ Текущий -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
474b0809-482a-4851-9a96-4587f8c59152	Меркурий 230 Ic Текущий -- adress: 7  channel: 3	7	3	a7e2ae97-718e-4667-b9bf-5313479438fd	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
37011b85-c8af-4f6c-857d-4b93a95d31e1	Меркурий 230 T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	bb986590-63cb-4b9f-8f4b-1b96335c5441
3077b3ac-fde2-4435-9e6f-17464310c090	Меркурий 230 P Текущий -- adress: 5  channel: 0	5	0	f001642c-d156-49df-b7bc-bfafcbca2e8b	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
2ebc02e6-65c6-40ab-b717-0d98d66b5701	Меркурий 230 T0 R+ Месячный -- adress: 2  channel: 0	2	0	40e69bf7-fc3f-4a90-8264-988e819a2e9f	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
1a3ca6ca-8866-4aad-8712-d9df003fe692	Меркурий 230 Uc Текущий -- adress: 8  channel: 3	8	3	d6296a2d-93b7-4446-b71a-d1fff77e6a9f	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
11e67353-3ba3-47c3-8667-386346c203a4	Пульсар16 Канал 1 Текущий -- adress: 2  channel: 0	2	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	baf23191-8b7e-410d-8053-a654c11aaf58	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
06e0a2f0-147f-4b00-9005-9e7941b0036a	Меркурий 230 T3 A+ Текущий -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
069898ea-9d74-4571-b719-e8e6f1513c12	Пульсар 10M Канал 6 Текущий -- adress: 6  channel: 0	6	0	44d47679-97a0-4444-8f30-bd30d4861789	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
1023b35b-3cbf-4519-aac3-3bf1ebae07c1	Пульсар 10M Канал 3 Текущий -- adress: 3  channel: 0	3	0	070e5074-1c09-4826-bbb7-39607ee6b6c8	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
1faeb517-bd1f-4ba0-96a5-67f00764822f	Пульсар 2M Канал 2 Текущий -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	6599be9a-1f4d-4a6e-a3d9-fb054b8d44e8	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
32dad392-ca1e-4110-8f2c-a86b02e26fb3	Пульсар 10M Канал 1 Текущий -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
3e13694b-7cb5-4417-a091-af8a7db34dc7	Пульсар 10M Канал 2 Текущий -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
eea27ade-44cd-4e66-8298-00a4a6ad915a	Пульсар 10M Канал 4 Текущий -- adress: 4  channel: 0	4	0	aef66fe2-d8de-4697-874f-d91ef48386e4	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
f897f0ca-4e35-4f0d-b345-3379668aa36f	Пульсар 10M Канал 3 Суточный -- adress: 3  channel: 0	3	0	070e5074-1c09-4826-bbb7-39607ee6b6c8	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
aa611d48-f1fe-462a-8b0a-0a7596792b69	Эльф 1.08 ElfTon Архивный -- adress: 3  channel: 0	3	0	7adc8719-8150-439d-992d-97b0d306af8d	1c5a8a80-1c51-4733-8332-4ed8d510a650	597eeb75-5d7e-4514-9255-12cc9e6cf97d
01a5419c-c701-4185-95b6-457b8c9ca2d0	Пульсар 16M Канал 4 Текущий -- adress: 4  channel: 0	4	0	aef66fe2-d8de-4697-874f-d91ef48386e4	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
1349b747-41ca-4ba8-a690-69c649129f44	Пульсар 16M Канал 10 Текущий -- adress: 10  channel: 0	10	0	02ce4681-7be0-47c9-acd4-67a6c8d439e9	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
169a79e0-da6f-4091-9fc7-ab81adc0d7e0	Пульсар 16M Канал 13 Суточный -- adress: 13  channel: 0	13	0	77c7effc-99b2-4e67-bad9-cef3f3ae47df	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
22dd3a17-a828-44e0-80d9-db075ba120ae	Пульсар 16M Канал 16 Текущий -- adress: 16  channel: 0	16	0	2e91f015-633d-4e7c-ad10-3cfd88e77aa6	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
253475ea-614d-4aad-93a8-e81e4c9028e9	Пульсар 10M Канал 10 Суточный -- adress: 10  channel: 0	10	0	02ce4681-7be0-47c9-acd4-67a6c8d439e9	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
325ec164-9428-4a57-867c-33d4eaf8cc2a	Пульсар 10M Канал 1 Суточный -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
4413bffb-1832-4900-9351-5ac3666dd8b0	Пульсар 16M Канал 13 Текущий -- adress: 13  channel: 0	13	0	77c7effc-99b2-4e67-bad9-cef3f3ae47df	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
4fd440c4-9ec5-4ab9-a073-6c4d3a174777	Пульсар 16M Канал 11 Суточный -- adress: 11  channel: 0	11	0	21449962-b377-42bf-ac23-b1f4ae148df9	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
5a6b0338-c15d-4224-a04f-a10fc73c5fc7	Пульсар 16M Канал 2 Текущий -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
6280490b-123d-4e27-bef9-19fd7dc2cf54	Пульсар 16M Канал 14 Текущий -- adress: 14  channel: 0	14	0	e0f6b50f-127d-4189-a376-3494d2afbdba	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
68270d0a-5043-4ea2-9b61-4adaa298abad	Пульсар 16M Канал 6 Текущий -- adress: 6  channel: 0	6	0	44d47679-97a0-4444-8f30-bd30d4861789	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
6ccc7efb-d9fe-4285-b343-8ed22d2d3625	Пульсар 16M Канал 6 Суточный -- adress: 6  channel: 0	6	0	44d47679-97a0-4444-8f30-bd30d4861789	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
72567365-9a40-4f97-ab25-0911585035bf	Пульсар 16M Канал 7 Суточный -- adress: 7  channel: 0	7	0	fb97edae-10f5-4772-9a4e-73e2b0ab488b	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
786ed8b8-aed1-478c-ae75-99caf1358cf0	Пульсар 10M Канал 8 Текущий -- adress: 8  channel: 0	8	0	35ff522d-0d31-41a1-a9fd-a388a5cbf266	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
8b2aa40a-cd91-4e22-b9d1-596e49e5f839	Пульсар 10M Канал 10 Текущий -- adress: 10  channel: 0	10	0	02ce4681-7be0-47c9-acd4-67a6c8d439e9	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
91bb7c43-f802-4ebd-a8fe-75f833acedeb	Пульсар 10M Канал 7 Суточный -- adress: 7  channel: 0	7	0	fb97edae-10f5-4772-9a4e-73e2b0ab488b	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
93891c5a-1c8f-4906-b7f0-961dc8ad3c9f	Пульсар 16M Канал 15 Текущий -- adress: 15  channel: 0	15	0	37595211-23ea-49de-ba78-c529df6e577f	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
96035c7c-ee7c-41f6-9723-8a75dd9ed573	Пульсар 10M Канал 9 Суточный -- adress: 9  channel: 0	9	0	af4b173b-8292-48c9-8f6a-e18061d75893	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
99ab1a30-fde8-4b81-9f9e-2f731516ce1b	Пульсар 16M Канал 11 Текущий -- adress: 11  channel: 0	11	0	21449962-b377-42bf-ac23-b1f4ae148df9	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
9b5ab67b-40aa-4536-8b7c-340a773ab31b	Пульсар 16M Канал 10 Суточный -- adress: 10  channel: 0	10	0	02ce4681-7be0-47c9-acd4-67a6c8d439e9	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
9e6e308f-abec-4b47-9b99-9cb590c55d0c	Пульсар 16M Канал 2 Суточный -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
c7f6a397-833d-4020-9d2b-38c19bec272c	Пульсар 16M Канал 12 Текущий -- adress: 12  channel: 0	12	0	9b457f63-51f9-491e-8a6f-1a9aa5ac2e62	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
cd489c4b-6e74-4c65-bfee-c0fa78a853bf	Пульсар 16M Канал 7 Текущий -- adress: 7  channel: 0	7	0	fb97edae-10f5-4772-9a4e-73e2b0ab488b	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
d82c7576-8e5e-4e93-ae10-58459b31e4a0	Пульсар 16M Канал 5 Суточный -- adress: 5  channel: 0	5	0	2fb7f1b6-dd14-4576-b66f-5bad98bea65d	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
e3f1325e-3018-40ba-b94a-ab6d6ac093e9	Пульсар 16M Канал 1 Текущий -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
e6815dd5-fbbc-480f-8b95-025d7f9a0403	Пульсар 16M Канал 3 Суточный -- adress: 3  channel: 0	3	0	070e5074-1c09-4826-bbb7-39607ee6b6c8	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
e8521cd7-2f38-4619-935d-8fe86234dbe7	Пульсар 16M Канал 9 Текущий -- adress: 9  channel: 0	9	0	af4b173b-8292-48c9-8f6a-e18061d75893	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
fcc28118-66c0-4cdf-aeba-5da1171aae48	Пульсар 2M Канал 1 Текущий -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	6599be9a-1f4d-4a6e-a3d9-fb054b8d44e8	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
f2bbf267-456e-477a-95d2-abb94c78ba43	Эльф 1.08 Энергия Текущий -- adress: 1  channel: 0	1	0	64f9b17d-d599-428d-8849-5db3d37c7b0e	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
e8c20ce7-bdb6-4ea6-8401-cee28049a7d7	Меркурий 230 T0 A+ Текущий -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
dade3324-b9b0-41c8-bc76-70f617573e43	Эльф 1.08 ElfErr Текущий -- adress: 4  channel: 0	4	0	4715571a-8fd3-41a9-862b-6deeabb40c26	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
dad6e2eb-e978-46f4-b7ec-442834b04e7a	Эльф 1.08 Объем Текущий -- adress: 2  channel: 0	2	0	092c67af-25ce-41ca-85ce-cb96953c930d	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
d3c9563d-51ed-4ca7-922f-ac3731065ead	Эльф 1.08 ElfTon Текущий -- adress: 3  channel: 0	3	0	7adc8719-8150-439d-992d-97b0d306af8d	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
cecfa314-8b7b-4bdb-aadf-31444e739fae	Меркурий 230 T4 A+ Текущий -- adress: 0  channel: 4	0	4	1d1d1038-2789-4fcf-a420-8be0ba20d99a	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
c36dcc64-6d02-4957-a931-9d09f87a670d	Пульсар16 Расход ХВС Суточный -- adress: 2  channel: 0	2	0	855aef13-ccb0-4478-ae1e-65d3681e89f6	baf23191-8b7e-410d-8053-a654c11aaf58	bb986590-63cb-4b9f-8f4b-1b96335c5441
b6ceb8d6-fb7d-49c1-95fd-a0ce8303c0df	Меркурий 230 T4 A+ Месячный -- adress: 0  channel: 4	0	4	1d1d1038-2789-4fcf-a420-8be0ba20d99a	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
b02153a4-00c0-4800-a55a-c7f9dfbb14e7	Эльф 1.08 Объем Архивный -- adress: 2  channel: 0	2	0	092c67af-25ce-41ca-85ce-cb96953c930d	1c5a8a80-1c51-4733-8332-4ed8d510a650	597eeb75-5d7e-4514-9255-12cc9e6cf97d
af047098-bd45-4579-a60c-b75bed376bbe	Эльф 1.08 ElfErr Архивный -- adress: 4  channel: 0	4	0	4715571a-8fd3-41a9-862b-6deeabb40c26	1c5a8a80-1c51-4733-8332-4ed8d510a650	597eeb75-5d7e-4514-9255-12cc9e6cf97d
acca627e-f21a-4f8b-be7e-038f534b5d11	Эльф 1.08 Ti Текущий -- adress: 5  channel: 0	5	0	bb56b908-a67d-48f3-95c5-4c8eec379056	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
79741ba9-e8b8-4352-862e-17a9c4d928ce	Меркурий 230 T3 A+ Месячный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
632f76fb-4dd9-4e7d-86a0-a57a27fc648a	Меркурий 230 Ub Текущий -- adress: 8  channel: 2	8	2	00b7f1f2-c8c7-482d-88c1-7d6bc0335a78	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
4c93dd55-1ec2-48c7-9865-9ceab580b7b3	Меркурий 230 T0 R+ Текущий -- adress: 2  channel: 0	2	0	40e69bf7-fc3f-4a90-8264-988e819a2e9f	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
ae439e1f-5c4b-494c-8a53-a61b85c804a0	Эльф 1.08 Энергия Архивный -- adress: 1  channel: 0	1	0	64f9b17d-d599-428d-8849-5db3d37c7b0e	1c5a8a80-1c51-4733-8332-4ed8d510a650	597eeb75-5d7e-4514-9255-12cc9e6cf97d
345a24a4-95b7-4f67-b004-716706ed2560	Меркурий 230 T0 R+ Суточный -- adress: 2  channel: 0	2	0	40e69bf7-fc3f-4a90-8264-988e819a2e9f	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	bb986590-63cb-4b9f-8f4b-1b96335c5441
2c2f7176-8b77-44f4-9678-4773e95e67ce	Пульсар 10M Канал 6 Суточный -- adress: 6  channel: 0	6	0	44d47679-97a0-4444-8f30-bd30d4861789	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
48a42afe-d9ac-4180-a733-6dd5f9d9ca80	Пульсар 16M Канал 3 Текущий -- adress: 3  channel: 0	3	0	070e5074-1c09-4826-bbb7-39607ee6b6c8	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
612d2f20-d454-4e14-910b-1fd89bbb31dd	Пульсар 16M Канал 4 Суточный -- adress: 4  channel: 0	4	0	aef66fe2-d8de-4697-874f-d91ef48386e4	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
6fc4c39c-9a43-4cb7-a066-c40fd2ca47e5	Пульсар 10M Канал 9 Текущий -- adress: 9  channel: 0	9	0	af4b173b-8292-48c9-8f6a-e18061d75893	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
85c4295e-bc6a-46ec-9866-0bf9f77c6904	Пульсар 16M Канал 5 Текущий -- adress: 5  channel: 0	5	0	2fb7f1b6-dd14-4576-b66f-5bad98bea65d	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
908e88f0-f9a0-421d-bbe7-9bafdf5d2565	Пульсар 16M Канал 16 Суточный -- adress: 16  channel: 0	16	0	2e91f015-633d-4e7c-ad10-3cfd88e77aa6	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
9203f5ed-d5da-4462-91d1-5aea42e99124	Пульсар 16M Канал 8 Суточный -- adress: 8  channel: 0	8	0	35ff522d-0d31-41a1-a9fd-a388a5cbf266	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
99a99024-65b4-44dd-99fc-6a5cf1d4aaee	Пульсар 10M Канал 2 Суточный -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
a1cb319d-ac09-466d-894b-91d90aba4239	Пульсар 2M Канал 2 Суточный -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	6599be9a-1f4d-4a6e-a3d9-fb054b8d44e8	bb986590-63cb-4b9f-8f4b-1b96335c5441
b6bdfae8-4f27-4056-af79-d746b44038ee	Пульсар 10M Канал 5 Суточный -- adress: 5  channel: 0	5	0	2fb7f1b6-dd14-4576-b66f-5bad98bea65d	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
cf24b669-1c5b-4db7-936a-5f9d5c8be928	Пульсар 10M Канал 8 Суточный -- adress: 8  channel: 0	8	0	35ff522d-0d31-41a1-a9fd-a388a5cbf266	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
e4068568-d8c4-42ab-9957-7292753e2891	Пульсар 16M Канал 9 Суточный -- adress: 9  channel: 0	9	0	af4b173b-8292-48c9-8f6a-e18061d75893	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
f29062a4-ab60-4117-8f85-0cdec634c797	Пульсар 16M Канал 8 Текущий -- adress: 8  channel: 0	8	0	35ff522d-0d31-41a1-a9fd-a388a5cbf266	7cd88751-d232-410c-a0ef-6354a79112f1	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
fc4a9568-4674-4a80-b497-e4f34399acd5	Пульсар 16M Канал 1 Суточный -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
17789c36-4593-4ff2-94eb-1d0cebdb5366	Меркурий 230 T1 A+ Месячный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
01487323-a28f-419e-9589-2563d785ab2a	Эльф 1.08 To Текущий -- adress: 5  channel: 1	5	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
00b7f7c5-37f3-494a-8ceb-5a62f9ebf4e3	Пульсар 16M Канал 12 Суточный -- adress: 12  channel: 0	12	0	9b457f63-51f9-491e-8a6f-1a9aa5ac2e62	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
0239dffb-de88-45e5-b6f6-18bf39f92525	Пульсар 2M Канал 1 Суточный -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	6599be9a-1f4d-4a6e-a3d9-fb054b8d44e8	bb986590-63cb-4b9f-8f4b-1b96335c5441
034374bd-2dfb-4568-aa16-84255df33c88	Пульсар 10M Канал 4 Суточный -- adress: 4  channel: 0	4	0	aef66fe2-d8de-4697-874f-d91ef48386e4	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	bb986590-63cb-4b9f-8f4b-1b96335c5441
084aa5f4-75d5-41f6-b0d6-9f2403eacd2c	Пульсар 10M Канал 7 Текущий -- adress: 7  channel: 0	7	0	fb97edae-10f5-4772-9a4e-73e2b0ab488b	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
17e9c8fe-0d69-4466-b64e-185452c61555	Пульсар 16M Канал 14 Суточный -- adress: 14  channel: 0	14	0	e0f6b50f-127d-4189-a376-3494d2afbdba	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
25de493d-c680-4ca6-ac02-b778022ee151	Пульсар 16M Канал 15 Суточный -- adress: 15  channel: 0	15	0	37595211-23ea-49de-ba78-c529df6e577f	7cd88751-d232-410c-a0ef-6354a79112f1	bb986590-63cb-4b9f-8f4b-1b96335c5441
25e09d4d-3a48-4381-ad5d-b783c03c4d35	Пульсар 10M Канал 5 Текущий -- adress: 5  channel: 0	5	0	2fb7f1b6-dd14-4576-b66f-5bad98bea65d	cae994a2-6ab9-4ffa-aac3-f21491a2de0b	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
86cd925b-48c2-40b8-b211-f116e0e6dbea	Меркурий 200 T0 A+ Месячный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	6224d20b-1781-4c39-8799-b1446b60774d	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
62a3796a-eaae-445d-9166-2ad517186b78	Меркурий 200 T1 A+ Месячный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	6224d20b-1781-4c39-8799-b1446b60774d	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
5f6e1e3d-4128-4cfe-94cf-57ac84a7694a	Меркурий 200 T2 A+ Месячный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	6224d20b-1781-4c39-8799-b1446b60774d	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
0c28c135-58f2-4dff-a222-9f3d9f3c742b	Меркурий 200 T3 A+ Месячный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	6224d20b-1781-4c39-8799-b1446b60774d	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
6e7f0d37-df5c-4850-991e-b5d7cb793924	Эльф 1.08 Канал 1 Текущий -- adress: 6  channel: 1	6	1	5df2cb38-bfb5-4d96-9df4-815e48b52682	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
de7bfdfd-c17f-4a7c-942d-b28e85db33cb	Эльф 1.08 Канал 2 Текущий -- adress: 6  channel: 2	6	2	d68113c9-0f5b-43bd-815c-2a66f304c8f6	1c5a8a80-1c51-4733-8332-4ed8d510a650	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
9af27a62-d6c8-4b67-bd36-da7103e0b1f1	Эльф 1.08 Канал 1 Суточный -- adress: 6  channel: 1	6	1	5df2cb38-bfb5-4d96-9df4-815e48b52682	1c5a8a80-1c51-4733-8332-4ed8d510a650	bb986590-63cb-4b9f-8f4b-1b96335c5441
86acc33d-7bea-4977-a5b5-c5858ce9a09d	Эльф 1.08 Канал 2 Суточный -- adress: 6  channel: 2	6	2	d68113c9-0f5b-43bd-815c-2a66f304c8f6	1c5a8a80-1c51-4733-8332-4ed8d510a650	bb986590-63cb-4b9f-8f4b-1b96335c5441
e7f2ffba-9a40-43e1-80f3-ddd22596cdb8	Саяны Комбик Q Система1 Суточный -- adress: 0  channel: 1	0	1	b33393b2-78aa-4921-a548-d603ec8ca4cc	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
6f9cd79e-ca34-447e-8ad1-d54531389fe1	Саяны Комбик Q Система2 Суточный -- adress: 0  channel: 2	0	2	08c8bc27-59e1-4be3-9e16-5c0289aeea4d	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
b05de8e2-6176-4fc0-bc44-79ceb4229c80	Саяны Комбик M Система1 Суточный -- adress: 2  channel: 1	2	1	7a72d894-11fe-45ea-9e51-52711c01adf2	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
5f256e9b-1cb3-4f27-a53a-d08b446dda58	Саяны Комбик M Система2 Суточный -- adress: 2  channel: 2	2	2	04ea0711-7a10-4350-8fc9-aec608703ffb	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
75474616-f3db-4903-91d5-1f22f6593394	Саяны Комбик T Канал1 Суточный -- adress: 1  channel: 1	1	1	13e0918d-b288-4aeb-a034-4d2269c0d899	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
f3210c5b-afde-4c9a-b201-9c7c403c4cf2	Саяны Комбик T Канал2 Суточный -- adress: 1  channel: 2	1	2	a6c58808-5211-4c4a-8be5-2709e1b1b303	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
b12762a0-0a06-49a4-b842-8ad3378f4602	Саяны Комбик T Канал3 Суточный -- adress: 1  channel: 3	1	3	e3cddacf-7e95-4865-b9ac-e7f2c0fc99b2	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
472ba2fd-cc06-4147-a1e7-c1bb66096536	Саяны Комбик T Канал4 Суточный -- adress: 1  channel: 4	1	4	eb98b248-37e9-4674-8ba6-083b7a4fad2e	5429b439-233e-4944-b91b-4b521a10f77b	bb986590-63cb-4b9f-8f4b-1b96335c5441
b6e89205-3814-463d-86d1-f52cec7d8962	Меркурий 230-УМ T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	20e4767a-49e5-4f84-890c-25e311339c28	bb986590-63cb-4b9f-8f4b-1b96335c5441
7f3c42e6-4000-4373-a0e6-37e66ce819a9	Меркурий 230-УМ T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	20e4767a-49e5-4f84-890c-25e311339c28	bb986590-63cb-4b9f-8f4b-1b96335c5441
c6512649-56ea-4214-aa33-84516bfe8dc1	Меркурий 230-УМ T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	20e4767a-49e5-4f84-890c-25e311339c28	bb986590-63cb-4b9f-8f4b-1b96335c5441
4e20bda9-6e75-4b0f-a99a-0e4c1cd07d3b	Меркурий 230-УМ T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	20e4767a-49e5-4f84-890c-25e311339c28	bb986590-63cb-4b9f-8f4b-1b96335c5441
9cbc001d-a262-481f-a1aa-47d02bf18af1	Меркурий 200 T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	6224d20b-1781-4c39-8799-b1446b60774d	bb986590-63cb-4b9f-8f4b-1b96335c5441
5e312de9-34cd-4ba7-a744-c9b94a77d98b	Меркурий 200 T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	6224d20b-1781-4c39-8799-b1446b60774d	bb986590-63cb-4b9f-8f4b-1b96335c5441
4260ea05-78f8-4c5c-9172-fa161fa96068	Меркурий 200 T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	6224d20b-1781-4c39-8799-b1446b60774d	bb986590-63cb-4b9f-8f4b-1b96335c5441
24ae9f51-40a4-4758-a826-a5f8286e1a2e	Пульсар Теплосчётчик Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
a3da78fb-b07b-4d53-a980-54b51e26819a	Пульсар Теплосчётчик Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
de66ecd2-b243-467c-8d1a-cfcb42377300	Пульсар Теплосчётчик Ti Суточный -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
d3433b80-cb8c-4038-a682-947e6d05955e	Пульсар Теплосчётчик To Суточный -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
209894a8-8d19-4e4d-bad8-1767eec4fedf	Пульсар ХВС Объем ХВС Суточный -- adress: 1  channel: 1	1	1	a49db310-391f-4479-b57d-aa7ac84dc2d8	f1789bb7-7fcd-4124-8432-40320559890f	bb986590-63cb-4b9f-8f4b-1b96335c5441
61101fa3-a96a-4934-9482-e32036c12829	Меркурий 230-УМ R+ Профиль Получасовой -- adress: 2  channel: 0	2	0	475ac5ee-3ddd-4311-a0fb-d4bf531cbafd	20e4767a-49e5-4f84-890c-25e311339c28	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
922ad57c-8f5e-4f00-a78d-e3ba89ef859f	Меркурий 230-УМ A+ Профиль Получасовой -- adress: 0  channel: 0	0	0	9ad9b931-fe2b-463d-b47f-f0a471279313	20e4767a-49e5-4f84-890c-25e311339c28	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
b65d4227-69a5-487b-9999-5539ca3fc004	Меркурий 200 T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	6224d20b-1781-4c39-8799-b1446b60774d	bb986590-63cb-4b9f-8f4b-1b96335c5441
7175f6c7-b816-40f6-86f4-e08a309c08f6	Меркурий 230 Error_code Текущий -- adress: 99  channel: 0	99	0	4d6bb331-7266-481d-9256-741850dd1518	423b33a7-2d68-47b6-b4f6-5b470aedc4f4	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
097122a4-b7d0-4700-add2-bc99a58347d0	Danfoss SonoSelect  Объем Текущий -- adress: 1  channel: 64	1	64	092c67af-25ce-41ca-85ce-cb96953c930d	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
1d246b01-7fd8-441e-af1b-9851acf5f104	Danfoss SonoSelect To Текущий -- adress: 23  channel: 32	23	32	62bb153e-a48f-49c4-8628-39d0a3574aa4	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
2119043e-687e-4b31-b862-adac531e39da	Danfoss SonoSelect Ti Текущий -- adress: 21  channel: 32	21	32	bb56b908-a67d-48f3-95c5-4c8eec379056	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
3c763ebc-6ad4-4193-967f-f352bfae92c5	Danfoss SonoSelect Объем Месячный -- adress: 1  channel: 64	1	64	092c67af-25ce-41ca-85ce-cb96953c930d	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
510ba9e6-c18b-4982-9763-2ad86c8a8245	SonoSelect Danfoss Энергия Суточный -- adress: 9  channel: 64	9	64	64f9b17d-d599-428d-8849-5db3d37c7b0e	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
7a5d6dd3-3a34-40e4-90af-0c00252b978d	Danfoss SonoSelect Энергия Месячный -- adress: 9  channel: 64	9	64	64f9b17d-d599-428d-8849-5db3d37c7b0e	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
83ba885f-1881-45db-9d63-52195e67cf64	Danfoss SonoSelect Объем Суточный -- adress: 1  channel: 64	1	64	092c67af-25ce-41ca-85ce-cb96953c930d	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
a8940b63-2002-4a28-b671-a455419c1229	Danfoss SonoSelect Ti Суточный -- adress: 21  channel: 32	21	32	bb56b908-a67d-48f3-95c5-4c8eec379056	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
af254ed7-d4ab-4293-8aaf-8bb13c81efb7	Danfoss SonoSelect Энергия Текущий -- adress: 9  channel: 64	9	64	64f9b17d-d599-428d-8849-5db3d37c7b0e	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3242af58-ba57-4d8b-83fa-284bd8f4bd9b
caf11a15-27ff-4c0d-9b18-d55028e4840b	Danfoss SonoSelect Ti Месячный -- adress: 21  channel: 32	21	32	bb56b908-a67d-48f3-95c5-4c8eec379056	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
db1ed365-e85e-4547-aef6-89fed020898f	Danfoss SonoSelect To Суточный -- adress: 23  channel: 32	23	32	62bb153e-a48f-49c4-8628-39d0a3574aa4	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
f76371c9-5ecd-44b2-835e-5fc4cdce7141	Danfoss SonoSelect To Месячный -- adress: 23  channel: 32	23	32	62bb153e-a48f-49c4-8628-39d0a3574aa4	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
087b785e-5d59-4956-9cd3-57706f9557e6	СЭТ-4ТМ.03М T0 R+ Суточный -- adress: 1  channel: 0	1	0	40e69bf7-fc3f-4a90-8264-988e819a2e9f	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	bb986590-63cb-4b9f-8f4b-1b96335c5441
3d365f91-8bd3-476e-b07e-3f79134f6853	СЭТ-4ТМ.03М T0 R+ Месячный -- adress: 1  channel: 0	1	0	40e69bf7-fc3f-4a90-8264-988e819a2e9f	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
4f505e17-7d71-4cf8-9880-c6ce33612e6e	СЭТ-4ТМ.03М A+ Профиль Получасовой -- adress: 0  channel: 0	0	0	9ad9b931-fe2b-463d-b47f-f0a471279313	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
aa83b499-6a9e-40e1-b68b-dc84fec8490b	СЭТ-4ТМ.03М T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	bb986590-63cb-4b9f-8f4b-1b96335c5441
e7624c25-9852-4ffd-8777-b2bfd16c29a8	СЭТ-4ТМ.03М T0 A+ Месячный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
03d32edf-c9d8-4f49-ba11-e775c0c403f6	СЭТ-4ТМ.03М T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	bb986590-63cb-4b9f-8f4b-1b96335c5441
55237552-8678-483e-8073-5d6c567371f4	СЭТ-4ТМ.03М T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	bb986590-63cb-4b9f-8f4b-1b96335c5441
e3db7e77-90a5-455f-96f5-7c257cb4ab76	СЭТ-4ТМ.03М T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	bb986590-63cb-4b9f-8f4b-1b96335c5441
55abd40d-fb3c-4100-88f2-46d79be7733a	СЭТ-4ТМ.03М R+ Профиль Получасовой -- adress: 2  channel: 0	2	0	475ac5ee-3ddd-4311-a0fb-d4bf531cbafd	66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
31bc817a-2ccd-4021-a8a1-7d63d97dae2c	СТК Пульс Вода Объем ХВС Суточный -- adress: 0  channel: 1	0	1	a49db310-391f-4479-b57d-aa7ac84dc2d8	fbc9874c-1dc4-4cb0-95e7-4ff6ca7ab17f	bb986590-63cb-4b9f-8f4b-1b96335c5441
c5b9362b-5c59-47bb-bc61-b3b556b24dc3	СТК Пульс Вода Объем ХВС Месячный -- adress: 0  channel: 1	0	1	a49db310-391f-4479-b57d-aa7ac84dc2d8	fbc9874c-1dc4-4cb0-95e7-4ff6ca7ab17f	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
14275dc3-eebb-4b95-aaf1-066ee4edab4e	Пульс СТК Теплосчётчик Энергия Суточный -- adress: 0  channel: 0	0	0	64f9b17d-d599-428d-8849-5db3d37c7b0e	bb111ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
9a97d8b8-992f-4e43-a6e0-9f1dc89d2dec	Пульс СТК Теплосчётчик Объем Суточный -- adress: 1  channel: 0	1	0	092c67af-25ce-41ca-85ce-cb96953c930d	bb111ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
27b8f3a1-b10d-4327-9505-31f730a3b62b	Пульс СТК Теплосчётчик Ti Суточный -- adress: 5  channel: 0	5	0	bb56b908-a67d-48f3-95c5-4c8eec379056	bb111ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
1944aeec-58a6-48d4-bbcb-24d0ce3a3e1a	Пульс СТК Теплосчётчик To Суточный -- adress: 6  channel: 0	6	0	62bb153e-a48f-49c4-8628-39d0a3574aa4	bb111ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
1ae0a516-2975-4a6e-95e3-23412e0f2e67	Пульс СТК ГВС Объем ГВС Суточный -- adress: 0  channel: 1	0	1	1068fe5c-6de1-455e-8700-abd5ce98039c	12c9874c-1dc4-4cb0-95e7-4ff6ca7ab17f	bb986590-63cb-4b9f-8f4b-1b96335c5441
49f1197f-c6ae-4081-afbc-587ac614a3c3	Пульс СТК ГВС Объем ГВС Месячный -- adress: 0  channel: 1	0	1	1068fe5c-6de1-455e-8700-abd5ce98039c	12c9874c-1dc4-4cb0-95e7-4ff6ca7ab17f	3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f
5fc2ff3b-999e-4154-ba49-84d3971369b0	Пульсар ГВС Объем ГВС Суточный -- adress: 1  channel: 1	1	1	1068fe5c-6de1-455e-8700-abd5ce98039c	a1a349ba-e070-4ec9-975d-9f39e61c34da	bb986590-63cb-4b9f-8f4b-1b96335c5441
ba344ec3-d390-48e0-811c-991b25d9734d	Пульсар Холодосчётчик Энергия Суточный -- adress: 20  channel: 0	20	0	64f9b17d-d599-428d-8849-5db3d37c7b0e	c1ae0de6-f071-4e07-8452-09059eef187b	bb986590-63cb-4b9f-8f4b-1b96335c5441
6a50c871-8101-4a44-82c6-6214bd7a5ddd	Пульсар Холодосчётчик Ti Суточный -- adress: 21  channel: 0	21	0	bb56b908-a67d-48f3-95c5-4c8eec379056	c1ae0de6-f071-4e07-8452-09059eef187b	bb986590-63cb-4b9f-8f4b-1b96335c5441
244de93e-4dcd-41e2-bcc4-db1a113ead0a	Пульсар Холодосчётчик To Суточный -- adress: 22  channel: 0	22	0	62bb153e-a48f-49c4-8628-39d0a3574aa4	c1ae0de6-f071-4e07-8452-09059eef187b	bb986590-63cb-4b9f-8f4b-1b96335c5441
8fd07daa-4ad0-4124-acbe-aca6da2301d0	Пульсар Холодосчётчик Объем Суточный -- adress: 23  channel: 0	23	0	092c67af-25ce-41ca-85ce-cb96953c930d	c1ae0de6-f071-4e07-8452-09059eef187b	bb986590-63cb-4b9f-8f4b-1b96335c5441
2161a1c4-6d66-4e9b-8dbb-9f7ab1bab67d	Пульсар 3Ф4Т T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	bb986590-63cb-4b9f-8f4b-1b96335c5441
5f11bcf5-b058-4062-b259-6b96c80367b7	Пульсар 3Ф4Т T1 A+ Суточный -- adress: 1  channel: 0	1	0	a30f5530-c027-4d8a-815b-6abfb1d81028	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	bb986590-63cb-4b9f-8f4b-1b96335c5441
e3b0a6c1-20d7-4753-b165-e29c78a1d9e9	Пульсар 3Ф4Т T2 A+ Суточный -- adress: 2  channel: 0	2	0	6e822182-8dca-47f6-a25b-8599423f342e	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	bb986590-63cb-4b9f-8f4b-1b96335c5441
3aff9cc3-110b-4467-add7-c19d319a01cc	Пульсар 3Ф4Т T3 A+ Суточный -- adress: 3  channel: 0	3	0	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	bb986590-63cb-4b9f-8f4b-1b96335c5441
7f273543-3985-43b0-a027-21311961ecb7	Пульсар 3Ф4Т T4 A+ Суточный -- adress: 4  channel: 0	4	0	1d1d1038-2789-4fcf-a420-8be0ba20d99a	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	bb986590-63cb-4b9f-8f4b-1b96335c5441
a02431c6-7daf-4f0e-b35d-b19916c5a940	Энергомера СЕ301 A+ Профиль Получасовой -- adress: 0  channel: 0	0	0	9ad9b931-fe2b-463d-b47f-f0a471279313	17d88dbc-23b9-490a-9895-58ad24fe459d	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
610a6bf6-d00a-4fd4-a41e-0a0d9ffcba2f	Энергомера СЕ301 R+ Профиль Получасовой -- adress: 2  channel: 0	2	0	475ac5ee-3ddd-4311-a0fb-d4bf531cbafd	17d88dbc-23b9-490a-9895-58ad24fe459d	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
dc142b91-20a3-4048-bbfb-571bd969fd66	Энергомера СЕ301 T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	17d88dbc-23b9-490a-9895-58ad24fe459d	bb986590-63cb-4b9f-8f4b-1b96335c5441
63594901-393e-4fd9-bb1c-1da237d1264d	Энергомера СЕ301 T1 A+ Суточный -- adress: 1  channel: 0	1	0	a30f5530-c027-4d8a-815b-6abfb1d81028	17d88dbc-23b9-490a-9895-58ad24fe459d	bb986590-63cb-4b9f-8f4b-1b96335c5441
ff7837a5-5552-4fc0-a66e-a554f92c1f02	Энергомера СЕ301 T2 A+ Суточный -- adress: 2  channel: 0	2	0	6e822182-8dca-47f6-a25b-8599423f342e	17d88dbc-23b9-490a-9895-58ad24fe459d	bb986590-63cb-4b9f-8f4b-1b96335c5441
15e387b9-45ef-44fc-8110-a8d823af9140	Энергомера СЕ301 T3 A+ Суточный -- adress: 3  channel: 0	3	0	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	17d88dbc-23b9-490a-9895-58ad24fe459d	bb986590-63cb-4b9f-8f4b-1b96335c5441
dce68a94-2fb1-4856-acd6-2a1b13d5ec99	Пульсар Теплосчётчик Error_code Суточный -- adress: 24  channel: 0	24	0	4d6bb331-7266-481d-9256-741850dd1518	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
dd95cc37-023c-4d15-861d-8a7363f36d9c	Sanext Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	e8fa5e00-e1b9-4ef3-bc39-b8439a44b540	bb986590-63cb-4b9f-8f4b-1b96335c5441
f83d191d-1252-4257-ab85-5d0bba9a04c2	Sanext Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	e8fa5e00-e1b9-4ef3-bc39-b8439a44b540	bb986590-63cb-4b9f-8f4b-1b96335c5441
e2baef4b-3cfe-4f19-aec7-0d77f5c8a822	Sanext To Суточный -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	e8fa5e00-e1b9-4ef3-bc39-b8439a44b540	bb986590-63cb-4b9f-8f4b-1b96335c5441
ae423b31-9b3d-4ab3-a6cf-8b745faf48f0	Sanext Ti Суточный -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	e8fa5e00-e1b9-4ef3-bc39-b8439a44b540	bb986590-63cb-4b9f-8f4b-1b96335c5441
a11b0730-3975-40c1-bd2f-ed0c1a3132dc	Valtec 16M Канал 1 Суточный -- adress: 1  channel: 0	1	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
9d2832c8-f116-434d-ab48-0f28cbfc03ad	Valtec 16M Канал 2 Суточный -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
4fe447ea-de07-4d97-ad4f-20ded5503ddb	Valtec 16M Канал 3 Суточный -- adress: 3  channel: 0	3	0	070e5074-1c09-4826-bbb7-39607ee6b6c8	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
f859f4ed-166e-4b44-9df3-f3a60d778c35	Valtec 16M Канал 4 Суточный -- adress: 4  channel: 0	4	0	aef66fe2-d8de-4697-874f-d91ef48386e4	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
c1b97126-d5f8-4d8c-acc4-08eaa017d5fa	Valtec 16M Канал 5 Суточный -- adress: 5  channel: 0	5	0	2fb7f1b6-dd14-4576-b66f-5bad98bea65d	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
ca29cbf2-ab61-4cb0-b9fd-99121cb45b1f	Valtec 16M Канал 6 Суточный -- adress: 6  channel: 0	6	0	44d47679-97a0-4444-8f30-bd30d4861789	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
28c0bd41-1281-4272-b33e-234669294644	Valtec 16M Канал 7 Суточный -- adress: 7  channel: 0	7	0	fb97edae-10f5-4772-9a4e-73e2b0ab488b	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
616608c0-2343-4d22-b065-d8d5f9769731	Valtec 16M Канал 8 Суточный -- adress: 8  channel: 0	8	0	35ff522d-0d31-41a1-a9fd-a388a5cbf266	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
22ff1bd3-506b-40db-9137-2f01a923698d	Valtec 16M Канал 9 Суточный -- adress: 9  channel: 0	9	0	af4b173b-8292-48c9-8f6a-e18061d75893	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
48a5e8d8-d065-423c-a7ac-f126048687f7	Valtec 16M Канал 10 Суточный -- adress: 10  channel: 0	10	0	02ce4681-7be0-47c9-acd4-67a6c8d439e9	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
9b2cb997-1bb0-4230-92f7-3cd01032e5b9	Valtec 16M Канал 11 Суточный -- adress: 11  channel: 0	11	0	21449962-b377-42bf-ac23-b1f4ae148df9	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
fe4e2925-d986-4727-b3d5-bd3f809009e5	Valtec 16M Канал 12 Суточный -- adress: 12  channel: 0	12	0	9b457f63-51f9-491e-8a6f-1a9aa5ac2e62	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
a49323aa-135d-4a3f-93b8-1e32762e64e7	Valtec 16M Канал 13 Суточный -- adress: 13  channel: 0	13	0	77c7effc-99b2-4e67-bad9-cef3f3ae47df	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
aae6e088-7dcb-49a6-aafc-df4834ceca11	Valtec 16M Канал 14 Суточный -- adress: 14  channel: 0	14	0	e0f6b50f-127d-4189-a376-3494d2afbdba	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
1e1d2cef-11fc-4b81-9201-ce19a85cacab	Valtec 16M Канал 15 Суточный -- adress: 15  channel: 0	15	0	37595211-23ea-49de-ba78-c529df6e577f	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
310b935b-e7f9-47d3-8c87-a8ae13a3c81d	Valtec 16M Канал 16 Суточный -- adress: 16  channel: 0	16	0	2e91f015-633d-4e7c-ad10-3cfd88e77aa6	d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	bb986590-63cb-4b9f-8f4b-1b96335c5441
0166c378-5696-489e-92fb-a1d360fc2921	Danfoss SonoSelect Канал 1 Суточный -- adress: 31  channel: 0	31	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
b18bc638-eb07-429e-9c59-d859604be48f	Danfoss SonoSelect Канал 2 Суточный -- adress: 32  channel: 0	32	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	bb986590-63cb-4b9f-8f4b-1b96335c5441
af842772-2e25-45d0-9c40-3b21f30fe808	Пульсар Теплосчётчик Канал 1 Суточный -- adress: 31  channel: 0	31	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
318bd700-815c-46fe-aa7c-1e5265bab53e	Пульсар Теплосчётчик Канал 2 Суточный -- adress: 32  channel: 0	32	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
b34e9c13-f8fc-4baa-acaa-4aa2b01e2866	Пульсар ХВС battery_voltage Суточный -- adress: 2  channel: 0	2	0	06f68849-3e99-4f36-9650-a2687a82f468	f1789bb7-7fcd-4124-8432-40320559890f	bb986590-63cb-4b9f-8f4b-1b96335c5441
82e5717b-a4ec-4f88-9c18-338e5a0f8d30	Пульсар ГВС battery_voltage Суточный -- adress: 2  channel: 0	2	0	06f68849-3e99-4f36-9650-a2687a82f468	a1a349ba-e070-4ec9-975d-9f39e61c34da	bb986590-63cb-4b9f-8f4b-1b96335c5441
c1efbc03-04b8-4f6f-abaf-645c25d601b6	Пульсар Теплосчётчик battery_voltage Суточный -- adress: 2  channel: 0	2	0	06f68849-3e99-4f36-9650-a2687a82f468	82b96b1c-31cf-4753-9d64-d22e2f4d036e	bb986590-63cb-4b9f-8f4b-1b96335c5441
4ff80736-bcc7-47e6-9314-e505b837191d	ЭкоНом ХВС Объем ХВС Суточный -- adress: 1  channel: 1	1	1	a49db310-391f-4479-b57d-aa7ac84dc2d8	50098019-7418-4661-baa9-b913de3596da	bb986590-63cb-4b9f-8f4b-1b96335c5441
9f280064-b8c7-4037-8a3c-617301221427	ЭкоНом ГВС Объем ГВС Суточный -- adress: 1  channel: 1	1	1	1068fe5c-6de1-455e-8700-abd5ce98039c	e2e6c4c5-636a-432a-bdbf-6a5ab4b1fdee	bb986590-63cb-4b9f-8f4b-1b96335c5441
b22a28d0-9cb1-45eb-baba-5bb696ceb50d	ЭкоНом Теплосчётчик Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	aefa5648-2240-42b4-88cf-04b093a60187	bb986590-63cb-4b9f-8f4b-1b96335c5441
4400f32c-9074-4838-93cf-7c7066f088f5	ЭкоНом Теплосчётчик Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	aefa5648-2240-42b4-88cf-04b093a60187	bb986590-63cb-4b9f-8f4b-1b96335c5441
5d9407e9-8ff7-4d8b-937e-d47edfe27e31	ЭкоНом Теплосчётчик Ti Суточный -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	aefa5648-2240-42b4-88cf-04b093a60187	bb986590-63cb-4b9f-8f4b-1b96335c5441
3c4bf80c-1a62-41ef-8bdd-9e9593ee0c56	ЭкоНом Теплосчётчик To Суточный -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	aefa5648-2240-42b4-88cf-04b093a60187	bb986590-63cb-4b9f-8f4b-1b96335c5441
1b93aeca-461c-468a-a0b9-792bd89001ab	Нартис СПОДЭС T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	8790eaeb-671b-4596-b80e-d6475d74382c	bb986590-63cb-4b9f-8f4b-1b96335c5441
e9e1c90f-7b4a-4ba0-a51e-e8b7a0cfbb41	Нартис СПОДЭС A+ Профиль Получасовой -- adress: 0  channel: 5	0	5	9ad9b931-fe2b-463d-b47f-f0a471279313	8790eaeb-671b-4596-b80e-d6475d74382c	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
4d8a4b75-695a-43e1-9a40-87c0e9f57e24	Нартис СПОДЭС R+ Профиль Получасовой -- adress: 0  channel: 6	0	6	475ac5ee-3ddd-4311-a0fb-d4bf531cbafd	8790eaeb-671b-4596-b80e-d6475d74382c	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
7b109795-7076-444c-ba75-0f6494e523c5	Декаст Теплосчётчик Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	b95134db-af0c-4eea-bc8e-32b2bcfc7e1d	bb986590-63cb-4b9f-8f4b-1b96335c5441
99fd51ba-2b1a-4cd3-adde-e0e744250d96	Декаст Теплосчётчик Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	b95134db-af0c-4eea-bc8e-32b2bcfc7e1d	bb986590-63cb-4b9f-8f4b-1b96335c5441
47c98a3e-0db8-4c51-8f2e-a4eed31039f9	Декаст Теплосчётчик Ti Суточный -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	b95134db-af0c-4eea-bc8e-32b2bcfc7e1d	bb986590-63cb-4b9f-8f4b-1b96335c5441
9a0c606e-6986-4a36-93a4-0769a2f851e9	Декаст Теплосчётчик To Суточный -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	b95134db-af0c-4eea-bc8e-32b2bcfc7e1d	bb986590-63cb-4b9f-8f4b-1b96335c5441
4fd62d3d-880f-4f00-81bd-41b380c012da	МЗТА Канал 3 Суточный -- adress: 3  channel: 0	3	0	070e5074-1c09-4826-bbb7-39607ee6b6c8	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
ec10fc08-9e1b-416b-ab8e-b6f2233c8196	МЗТА Канал 4 Суточный -- adress: 4  channel: 0	4	0	aef66fe2-d8de-4697-874f-d91ef48386e4	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
82ce9adf-0a2e-4ceb-8d95-89fc4d9df289	МЗТА Канал 2 Суточный -- adress: 2  channel: 0	2	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
12ea6b3b-4dcf-40e3-bdf1-9edb80b9585a	МЗТА Канал 5 Суточный -- adress: 5  channel: 0	5	0	2fb7f1b6-dd14-4576-b66f-5bad98bea65d	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
6352996a-dc82-4939-8e0d-8679af9a3cb4	МЗТА Канал 6 Суточный -- adress: 6  channel: 0	6	0	44d47679-97a0-4444-8f30-bd30d4861789	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
99c31bc4-0764-472a-91f9-774c7eacfaed	МЗТА Канал 7 Суточный -- adress: 7  channel: 0	7	0	fb97edae-10f5-4772-9a4e-73e2b0ab488b	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
f394d963-c94f-42ac-9a15-d83dd0a97e78	МЗТА Канал 8 Суточный -- adress: 8  channel: 0	8	0	35ff522d-0d31-41a1-a9fd-a388a5cbf266	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
8f16a338-23db-4fe0-99e1-3aad34897fda	МЗТА Канал 9 Суточный -- adress: 9  channel: 0	9	0	af4b173b-8292-48c9-8f6a-e18061d75893	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
949b3f73-a0bb-4037-8f13-cb30c815c226	Нартис СПОДЭС T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	8790eaeb-671b-4596-b80e-d6475d74382c	bb986590-63cb-4b9f-8f4b-1b96335c5441
14ba0cf1-d4c6-40d6-a70c-9ecdd2c73050	Нартис СПОДЭС T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	8790eaeb-671b-4596-b80e-d6475d74382c	bb986590-63cb-4b9f-8f4b-1b96335c5441
eac09f54-2365-4cc9-a4cc-cd375d3b5039	Нартис СПОДЭС T4 A+ Суточный -- adress: 0  channel: 4	0	4	1d1d1038-2789-4fcf-a420-8be0ba20d99a	8790eaeb-671b-4596-b80e-d6475d74382c	bb986590-63cb-4b9f-8f4b-1b96335c5441
11136ad3-a88e-40e5-8d19-cbf43032d17c	МЗТА Канал 10 Суточный -- adress: 10  channel: 0	10	0	02ce4681-7be0-47c9-acd4-67a6c8d439e9	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
41f7302d-4fe7-4b55-8cc4-5d12269671e1	МЗТА Канал 11 Суточный -- adress: 11  channel: 0	11	0	21449962-b377-42bf-ac23-b1f4ae148df9	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
6472c355-66cd-4f99-8c17-a01ad155449e	МЗТА Канал 12 Суточный -- adress: 12  channel: 0	12	0	9b457f63-51f9-491e-8a6f-1a9aa5ac2e62	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
5a4f437f-8b6d-4a59-9ec3-ad5f47cefccf	МЗТА Канал 13 Суточный -- adress: 13  channel: 0	13	0	77c7effc-99b2-4e67-bad9-cef3f3ae47df	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
447cf2bb-bc43-4a50-8cd0-b1cc0407d973	МЗТА Канал 14 Суточный -- adress: 14  channel: 0	14	0	e0f6b50f-127d-4189-a376-3494d2afbdba	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
98bcdfdd-8965-42f3-84fe-978d367be9eb	МЗТА Канал 15 Суточный -- adress: 15  channel: 0	15	0	37595211-23ea-49de-ba78-c529df6e577f	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
8663465e-64d1-49d9-915b-b0cd7d71a503	МЗТА Канал 16 Суточный -- adress: 16  channel: 0	16	0	2e91f015-633d-4e7c-ad10-3cfd88e77aa6	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
f7af4d4f-e542-406d-9ad2-44a5b8e9d506	МЗТА Канал 17 Суточный -- adress: 17  channel: 0	17	0	3c5923d1-8125-4af8-abf9-862e5b3b5439	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
ccd0c7f4-babd-4953-99c8-b6adf0cf1b12	МЗТА Канал 18 Суточный -- adress: 18  channel: 0	18	0	76245cb6-f5c9-4fa8-8c24-a71f32cc3179	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
7633d6a2-9cba-49d4-b456-a51e137b45f1	МЗТА Канал 19 Суточный -- adress: 19  channel: 0	19	0	4ec1972e-65a7-42c7-ba41-982f79bf60bd	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
a556773c-888a-4bb7-8ac4-e083630f0f28	МЗТА Канал 20 Суточный -- adress: 20  channel: 0	20	0	32e0ebca-2df4-45f8-807a-921f147210f0	295f91bd-3e05-435e-9eb8-bda7eddaf6a4	bb986590-63cb-4b9f-8f4b-1b96335c5441
2c129d66-9551-43af-b841-3beeb31974e1	Декаст ХВС Объем ХВС Суточный -- adress: 1  channel: 1	1	1	a49db310-391f-4479-b57d-aa7ac84dc2d8	657d8ad0-bdba-4459-a07e-4d4eb72950d6	bb986590-63cb-4b9f-8f4b-1b96335c5441
a2df1925-fa6a-4e41-9ded-01f17f8db55d	Декаст ГВС Объем ГВС Суточный -- adress: 1  channel: 1	1	1	1068fe5c-6de1-455e-8700-abd5ce98039c	36b6ea95-beb1-490d-a39f-06163bfcaae5	bb986590-63cb-4b9f-8f4b-1b96335c5441
bad0b995-04ac-4650-ada1-9ddec3574606	Danfoss SonoMeter-500 Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	5e1dbf09-6c37-4982-aa1e-a693d2b4f079	bb986590-63cb-4b9f-8f4b-1b96335c5441
751b8d48-b7f9-4b68-85a1-b1cb00e08dc2	Danfoss SonoMeter-500 Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	5e1dbf09-6c37-4982-aa1e-a693d2b4f079	bb986590-63cb-4b9f-8f4b-1b96335c5441
bc847426-44cf-4788-8abf-8ec84e81fb5f	Danfoss SonoMeter-500 Ti Суточный -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	5e1dbf09-6c37-4982-aa1e-a693d2b4f079	bb986590-63cb-4b9f-8f4b-1b96335c5441
230e16d7-d4d1-4a31-86a9-c962791dd0e0	Danfoss SonoMeter-500 To Суточный -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	5e1dbf09-6c37-4982-aa1e-a693d2b4f079	bb986590-63cb-4b9f-8f4b-1b96335c5441
b29f02ba-a5bf-4236-acae-6de1185536cf	Пульсар 3Ф4Т A+ Профиль Получасовой -- adress: 0  channel: 0	0	0	9ad9b931-fe2b-463d-b47f-f0a471279313	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
16087cc4-9360-4568-b15f-14a5e09dbd56	Пульсар 3Ф4Т R+ Профиль Получасовой -- adress: 2  channel: 0	2	0	475ac5ee-3ddd-4311-a0fb-d4bf531cbafd	5f9e013c-378d-4947-a1a7-33e6ebdc1cef	e78189b5-f9f9-4fdd-830e-5b98c342d7c1
ae250bd8-db9b-49ef-8153-adf2cee5b80e	Пульсар IoT Тепло-энергия Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	a3aa2833-4104-4ac4-a0fb-c34e4402d1d6	bb986590-63cb-4b9f-8f4b-1b96335c5441
af6b27af-03dd-4128-86b9-d58849950220	Пульсар IoT Тепло-объем Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	84bf3b54-d51d-48d7-902d-4826cdef7101	bb986590-63cb-4b9f-8f4b-1b96335c5441
dc619965-fe10-4ef8-b41f-9506cd579297	Пульсар IoT ВС Объем ВС Суточный -- adress: 1  channel: 1	1	1	5a765ed4-ba16-4b09-bb91-9d099a491c32	bc61d16e-4059-4f9b-b7df-55915a7a844b	bb986590-63cb-4b9f-8f4b-1b96335c5441
26f1708f-a6d7-4755-a8de-5773f5d78d1e	ВКТ9 Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
09372faf-0a0f-4e01-8922-e0e0727d5908	ВКТ9 Энергия ГВС Суточный -- adress: 7  channel: 2	7	2	03991c80-a277-43d4-8aff-716a301153bf	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
27ef159a-156b-485f-9a78-93516fdb1f49	ВКТ9 Объем_1 Суточный -- adress: 8  channel: 1	8	1	fbffd8b0-2ab5-4f21-95dd-c6227822ff9b	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
54bda39f-0a0b-4d18-b3bd-383340bcf483	ВКТ9 Объем_2 Суточный -- adress: 8  channel: 2	8	2	cdb9e994-b232-42f0-bba3-11d7714bb05b	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
9798a726-739d-419f-8ed6-41a3651c90ba	ВКТ9 Температура_1 Суточный -- adress: 2  channel: 1	2	1	5f7e51d1-d0a1-4a83-a3cd-ad8193cbce6b	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
232bd7a4-497b-4dde-94d0-7dde4a78e8f1	ВКТ9 Температура_2 Суточный -- adress: 2  channel: 2	2	2	77857b1e-62b2-436b-88aa-2a5681ae4eae	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
71b0014f-87b8-400f-a589-c9f73baca185	ВКТ9 THW Суточный -- adress: 2  channel: 3	2	3	fe51df5a-959f-446f-8086-a4fd0e02a465	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
1d105023-cd5d-4df8-a020-705f44ce7311	ВКТ9 dt_1 Суточный -- adress: 2  channel: 5	2	5	2f6586c6-3bc5-4250-b5aa-f87807483a68	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
9cf42823-594a-41ba-9273-9b36c5a04e59	ВКТ9 dt_2 Суточный -- adress: 2  channel: 6	2	6	0f29f4c0-f182-4ca4-a7ab-d976c7ea65bf	59963730-468e-441c-86d9-d08a3ed062fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
da5b2c6e-d222-437c-8222-201b67ebfef6	Теплосчётчик Ридан РУТ-01 Энергия_тепло Суточный -- adress: 7  channel: 1	7	1	3baa31f7-cc69-43ac-b45d-e7669d60f232	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
7072151e-6e29-41e4-bc55-0665942c4b6d	Теплосчётчик Ридан РУТ-01 Энергия_холод Суточный -- adress: 20  channel: 0	20	0	a38b5978-fefb-420b-8cac-23411dc46f68	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
21ec90c8-4722-4933-9d93-f3d531ac4086	Теплосчётчик Ридан РУТ-01 Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
aaca1772-5c13-4ab5-b983-b3bb3cd6f9b0	Теплосчётчик Ридан РУТ-01 Ti Суточный -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
a9a6a79b-e490-4efd-a85a-e7a19b68a700	Теплосчётчик Ридан РУТ-01 To Суточный -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
7a82197a-aee7-400c-8d63-8d9b9f3be475	Теплосчётчик Ридан РУТ-01 Канал 1 Суточный -- adress: 31  channel: 0	31	0	5df2cb38-bfb5-4d96-9df4-815e48b52682	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
89a38afd-9b1c-4c57-b851-95e3a49205be	Теплосчётчик Ридан РУТ-01 Канал 2 Суточный -- adress: 32  channel: 0	32	0	d68113c9-0f5b-43bd-815c-2a66f304c8f6	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
63f8d3c1-15f7-4fdc-954a-f4c080e36b3b	Теплосчётчик Ридан РУТ-01 Канал 3 Суточный -- adress: 33  channel: 0	33	0	070e5074-1c09-4826-bbb7-39607ee6b6c8	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
626464e3-25f7-46e2-9b7c-c7400858b783	Теплосчётчик Ридан РУТ-01 Канал 4 Суточный -- adress: 34  channel: 0	34	0	aef66fe2-d8de-4697-874f-d91ef48386e4	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
de41dc3f-d837-4772-a142-99f49b8dd5f7	Теплосчётчик Ридан РУТ-01 Error_code Суточный -- adress: 24  channel: 0	24	0	4d6bb331-7266-481d-9256-741850dd1518	4d714a5e-3af5-40fe-ab72-199ed8760ac3	bb986590-63cb-4b9f-8f4b-1b96335c5441
bf418620-56a2-4490-a5c2-856b62a2b1a0	Водосчётчик Ридан СГВ-15 ГВС magnet_time Суточный -- adress: 0  channel: 5	0	5	2175afa5-357d-41a1-9fe6-f2e8ce057ec5	0a5753cf-debd-45cb-8dd0-3905f36293fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
2dedf3cf-05f1-4c30-ab6e-e51315136d17	Водосчётчик Ридан СГВ-15 ГВС Объем_входящий Суточный -- adress: 0  channel: 3	0	3	736723cc-6be0-4e0b-95ce-d1194b8455fd	0a5753cf-debd-45cb-8dd0-3905f36293fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
fcbc58c0-631d-47b7-b200-a3a7036908f0	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_3 Суточный -- adress: 7  channel: 3	7	3	2f46ecbd-0089-4419-80bc-a92b8d207ebf	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
ec6fc0ca-5f75-4ad7-96b2-e66aee490d7e	ВЗЛЕТ ТСР-М ТСРВ-024М Энергия_1 Суточный -- adress: 7  channel: 1	7	1	009c284f-dffb-47a5-80ad-421f10569b8a	30936305-66a6-4459-b7d0-9c3ea8e2ba12	bb986590-63cb-4b9f-8f4b-1b96335c5441
f6f28d56-84bd-4cbc-8173-3ed85460093c	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_1 Суточный -- adress: 2  channel: 1	2	1	5f7e51d1-d0a1-4a83-a3cd-ad8193cbce6b	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
f54bb4f3-cae9-4d4e-af2f-769f13a1b200	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_6 Суточный -- adress: 2  channel: 6	2	6	006e1a1d-d477-4552-a870-960ece95a7ce	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
d1216f4e-35ad-4aa3-92dd-d5b8d576e9b7	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_6 Суточный -- adress: 8  channel: 6	8	6	5d7011b0-2739-4d86-a8b8-5e3302d584ca	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
9656b53b-49a7-4ff9-8694-dc8a5d95a3dd	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_5 Суточный -- adress: 8  channel: 5	8	5	47b4c408-0945-4e30-b59b-e05789338ef8	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
75a548d8-04bf-48a0-a18a-f70c8d2aefbe	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_1 Суточный -- adress: 7  channel: 1	7	1	009c284f-dffb-47a5-80ad-421f10569b8a	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
554ecd96-18c4-4f9f-9cee-305764cbcbc5	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_3 Суточный -- adress: 8  channel: 3	8	3	0d44a33e-9363-4ed2-8981-a7bc065c4f63	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
39b248ca-4928-4a69-958b-88c1b0aefa0f	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_2 Суточный -- adress: 7  channel: 2	7	2	5bb63f0e-4cf3-42d4-b62f-3fbcc1c9c20f	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
3702fc3a-7a0a-4cad-8d1c-a702d950b4af	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_4 Суточный -- adress: 8  channel: 4	8	4	06c71b5a-d20f-4cb5-8019-37e132c7b18d	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
0df5bd35-8a69-47da-9e28-2d7f3b492926	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_1 Суточный -- adress: 8  channel: 1	8	1	fbffd8b0-2ab5-4f21-95dd-c6227822ff9b	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
14645b7c-087d-4281-9bb8-8f7570311fb9	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_2 Суточный -- adress: 2  channel: 2	2	2	77857b1e-62b2-436b-88aa-2a5681ae4eae	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
9fb2b75e-904a-488a-9f83-7d79233c0bc9	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_4 Суточный -- adress: 2  channel: 4	2	4	a6ef4862-40d4-46bb-a5ab-d83365fa6c0d	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
8495f818-7c32-48fb-8c20-4283c20a4700	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_3 Суточный -- adress: 2  channel: 3	2	3	5b563fd5-7aa1-47ce-9558-d8766c3a5a0a	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
60001591-c938-4053-b3cc-91ae789dd715	ВЗЛЕТ ТСР-М ТСРВ-043 Температура_5 Суточный -- adress: 2  channel: 5	2	5	572e0d91-09aa-4f27-9951-dcd29ba76735	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
50c593c1-ab75-47c8-9c5c-da13713fcaf0	ВЗЛЕТ ТСР-М ТСРВ-043 Объем_2 Суточный -- adress: 8  channel: 2	8	2	cdb9e994-b232-42f0-bba3-11d7714bb05b	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
06fa9df2-c671-484d-a48a-18251f0a010f	ВЗЛЕТ ТСР-М ТСРВ-043 Энергия_4 Суточный -- adress: 7  channel: 4	7	4	0ccfef01-cf17-48b6-825e-bbfd297b3673	3a32cec9-d03a-4e46-a065-f81f92e5ead0	bb986590-63cb-4b9f-8f4b-1b96335c5441
cae77cb0-740f-4f0f-973b-4699f5a353b6	ВЗЛЕТ ТСР-М ТСРВ-024М Масса_1 Суточный -- adress: 9  channel: 1	9	1	15c66fb6-70cd-4649-9861-e9382314f45d	30936305-66a6-4459-b7d0-9c3ea8e2ba12	bb986590-63cb-4b9f-8f4b-1b96335c5441
c7d5aa55-10da-4075-bfa3-1b79ae924b1b	ВЗЛЕТ ТСР-М ТСРВ-024М Энергия_2 Суточный -- adress: 7  channel: 2	7	2	5bb63f0e-4cf3-42d4-b62f-3fbcc1c9c20f	30936305-66a6-4459-b7d0-9c3ea8e2ba12	bb986590-63cb-4b9f-8f4b-1b96335c5441
39d45f5f-f758-48cc-b55f-97a534114ffc	ВЗЛЕТ ТСР-М ТСРВ-024М Энергия_3 Суточный -- adress: 7  channel: 3	7	3	2f46ecbd-0089-4419-80bc-a92b8d207ebf	30936305-66a6-4459-b7d0-9c3ea8e2ba12	bb986590-63cb-4b9f-8f4b-1b96335c5441
3044cce6-0653-4fd4-9384-159d570abd27	ВЗЛЕТ ТСР-М ТСРВ-024М Масса_2 Суточный -- adress: 9  channel: 2	9	2	088d362f-689e-44bc-85c7-7a7b37ba87c7	30936305-66a6-4459-b7d0-9c3ea8e2ba12	bb986590-63cb-4b9f-8f4b-1b96335c5441
ba655bde-5621-4da9-a642-7542e73550fa	ВЗЛЕТ ТСР-М ТСРВ-024М Масса_3 Суточный -- adress: 9  channel: 3	9	3	d8e48314-1d79-460b-b0ab-acfb20115507	30936305-66a6-4459-b7d0-9c3ea8e2ba12	bb986590-63cb-4b9f-8f4b-1b96335c5441
e676cd88-ef85-4d3c-852e-14627b7c056b	Водосчётчик Ридан СГВ-15 ГВС Объем_выходящий Суточный -- adress: 0  channel: 4	0	4	576f857f-9458-4667-8a76-71017cbce095	0a5753cf-debd-45cb-8dd0-3905f36293fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
3fc2ea8f-237a-42ec-8f2f-d1b69e170ae4	Водосчётчик Ридан СГВ-15 ГВС magnet_flag Суточный -- adress: 0  channel: 6	0	6	cfbb6d8b-d2f4-4399-bd6a-2e95bd740a2b	0a5753cf-debd-45cb-8dd0-3905f36293fc	bb986590-63cb-4b9f-8f4b-1b96335c5441
56aefad0-0058-4ee2-95fe-aaf02e54c4ca	ВЗЛЕТ МР УРСВ-311 ГВС Объем_входящий Суточный -- adress: 0  channel: 3	0	3	736723cc-6be0-4e0b-95ce-d1194b8455fd	4d85e9a5-513e-419c-a02e-3e6ba79eafa7	bb986590-63cb-4b9f-8f4b-1b96335c5441
9e16351b-6725-4887-bbba-cb28418e25c0	ВЗЛЕТ МР УРСВ-311 ХВС Объем_входящий Суточный -- adress: 0  channel: 3	0	3	736723cc-6be0-4e0b-95ce-d1194b8455fd	af871462-2104-491d-9a83-e7dcd77364b1	bb986590-63cb-4b9f-8f4b-1b96335c5441
df15cfb8-8baa-4755-8f98-b0467efd18cf	Водосчётчик Ридан СГВ-15 ХВС Объем_входящий Суточный -- adress: 0  channel: 3	0	3	ab6723cc-6be0-4e0b-95ce-d1194b8455fd	b060fcdd-f52d-4914-9dca-2fbcc2a205d5	bb986590-63cb-4b9f-8f4b-1b96335c5441
89070715-65ca-42f2-90df-347039eee95d	Водосчётчик Ридан СГВ-15 ХВС Объем_выходящий Суточный -- adress: 0  channel: 4	0	4	cd6f857f-9458-4667-8a76-71017cbce095	b060fcdd-f52d-4914-9dca-2fbcc2a205d5	bb986590-63cb-4b9f-8f4b-1b96335c5441
0918da1d-27b8-43bf-ad9e-8a78645d9440	Водосчётчик Ридан СГВ-15 ХВС magnet_time Суточный -- adress: 0  channel: 5	0	5	ef75afa5-357d-41a1-9fe6-f2e8ce057ec5	b060fcdd-f52d-4914-9dca-2fbcc2a205d5	bb986590-63cb-4b9f-8f4b-1b96335c5441
0db11f70-373f-4bae-beb9-5d1e7afdda81	Водосчётчик Ридан СГВ-15 ХВС magnet_flag Суточный -- adress: 0  channel: 6	0	6	11bb6d8b-d2f4-4399-bd6a-2e95bd740a2b	b060fcdd-f52d-4914-9dca-2fbcc2a205d5	bb986590-63cb-4b9f-8f4b-1b96335c5441
d5417782-4ea5-4bfb-bc3f-21e8e7868aa9	Пульсар ГВС ГВС_current_error Суточный -- adress: 0  channel: 0	0	0	8a9cd773-36d8-46c4-b595-7544d69b67ba	a1a349ba-e070-4ec9-975d-9f39e61c34da	bb986590-63cb-4b9f-8f4b-1b96335c5441
649603aa-93a8-44df-ba55-e15e3bf44c0e	Пульсар ГВС ГВС_accumulated_error Суточный -- adress: 1  channel: 0	1	0	186b14a6-dfca-4edb-a4a6-548ba47b2b19	a1a349ba-e070-4ec9-975d-9f39e61c34da	bb986590-63cb-4b9f-8f4b-1b96335c5441
6ca83dce-dcc9-4e2d-94ca-e22ec855a65d	Пульсар ХВС ХВС_current_error Суточный -- adress: 0  channel: 0	0	0	ab0d249b-2bbb-4f35-a534-d3a82108ecbc	f1789bb7-7fcd-4124-8432-40320559890f	bb986590-63cb-4b9f-8f4b-1b96335c5441
3c066109-31bf-4256-83de-40ccd02e20fd	Пульсар ХВС ХВС_accumulated_error Суточный -- adress: 1  channel: 0	1	0	4dc55400-40c4-4720-a916-45ac920e6a45	f1789bb7-7fcd-4124-8432-40320559890f	bb986590-63cb-4b9f-8f4b-1b96335c5441
634d9f9a-a7f2-479e-9904-147cfa800ccc	Нартис СПОДЭС T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	8790eaeb-671b-4596-b80e-d6475d74382c	bb986590-63cb-4b9f-8f4b-1b96335c5441
58d49e69-c779-4e5a-98bf-f598c833ce3e	CE308 СПОДЭС T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	84244574-8fee-47a6-a546-15b01c82f778	bb986590-63cb-4b9f-8f4b-1b96335c5441
f27e1847-ff1c-417c-8e3e-4c653f3dc72e	CE308 СПОДЭС T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	84244574-8fee-47a6-a546-15b01c82f778	bb986590-63cb-4b9f-8f4b-1b96335c5441
22e995cc-a170-43b7-9cd4-e3da4ea28ace	CE308 СПОДЭС T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	84244574-8fee-47a6-a546-15b01c82f778	bb986590-63cb-4b9f-8f4b-1b96335c5441
dfbc97bc-1d20-491e-97ad-8dced70f1ac7	CE308 СПОДЭС T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	84244574-8fee-47a6-a546-15b01c82f778	bb986590-63cb-4b9f-8f4b-1b96335c5441
5ec99a35-51ef-4d93-b0c3-4da0667339e9	МИРТЕК-32-РУ-D37 T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	2d99741f-b22e-4926-af61-056e956b24b0	bb986590-63cb-4b9f-8f4b-1b96335c5441
88810096-9bfb-4190-b82c-e1d29e19152d	МИРТЕК-32-РУ-D37 T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	2d99741f-b22e-4926-af61-056e956b24b0	bb986590-63cb-4b9f-8f4b-1b96335c5441
8f51964e-2652-4956-9396-17cd9e243068	МИРТЕК-32-РУ-D37 T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	2d99741f-b22e-4926-af61-056e956b24b0	bb986590-63cb-4b9f-8f4b-1b96335c5441
84c7b310-1608-4fb2-89ff-a93ed00cb862	МИРТЕК-32-РУ-D37 T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	2d99741f-b22e-4926-af61-056e956b24b0	bb986590-63cb-4b9f-8f4b-1b96335c5441
0688928a-bf26-4aa8-8e50-e3fe31f8ae8c	Пульсар 405 Теплосчётчик Ti Суточный -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
0ee60478-1024-4281-a9f7-0e93f118d8d9	Пульсар 405 Теплосчётчик To Суточный -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
ab892f72-f26c-40c4-bf4f-c5f81fb16ecb	Пульсар 405 Теплосчётчик Объем Суточный -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
9036e603-7b32-4759-8653-4eb48535bd6c	Пульсар 405 Теплосчётчик Энергия Суточный -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
72f7e34e-a6e7-4ab7-a72f-eb391220662a	Пульсар 405 Теплосчётчик Gi Суточный -- adress: 9  channel: 1	9	1	c19d784b-119c-4bee-a0cb-92bddc4b1d55	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
fb9c55b4-cb27-4f20-aa2c-b25b7d18c73d	Пульсар 405 Теплосчётчик Go Суточный -- adress: 10  channel: 1	10	1	f1dc85e8-5d13-4517-96e1-3c748a209c0d	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
6766e7ad-dd9c-445e-b163-e2a06b408313	Пульсар 405 Теплосчётчик Pi Суточный -- adress: 11  channel: 1	11	1	679fed74-2097-47b7-a928-cdd1577b509f	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
0d534194-dc81-4500-b7b5-0ea8162777e4	Пульсар 405 Теплосчётчик Po Суточный -- adress: 12  channel: 1	12	1	067fb77b-d21c-4f28-ae05-4063514c6192	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
bd26a158-e8cf-4038-b7c9-e0b6b6d3dc93	Пульсар 405 Теплосчётчик operating_hours Суточный -- adress: 13  channel: 1	13	1	330217e8-78e2-4a3d-b257-ea2e6c617213	a91aa386-0de1-4dd3-a702-db980e788fcd	bb986590-63cb-4b9f-8f4b-1b96335c5441
fbe43c67-122a-4155-a3de-ffe6cee4e60a	Вис.Т-ТС Ti Часовой -- adress: 3  channel: 1	3	1	bb56b908-a67d-48f3-95c5-4c8eec379056	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
e2618b23-8db2-4d6b-8ea1-adb413aa43b7	Вис.Т-ТС Go Часовой -- adress: 10  channel: 1	10	1	f1dc85e8-5d13-4517-96e1-3c748a209c0d	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
db5aa6d6-84fe-4294-8765-8ae334bff927	Вис.Т-ТС To Часовой -- adress: 4  channel: 1	4	1	62bb153e-a48f-49c4-8628-39d0a3574aa4	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
a2962079-6df5-4e8f-bcec-a9cf2905afff	Вис.Т-ТС operating_hours Часовой -- adress: 13  channel: 1	13	1	330217e8-78e2-4a3d-b257-ea2e6c617213	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
a01b2e7c-84ec-42c5-b872-fe6e4ebc8684	Вис.Т-ТС Объем Часовой -- adress: 8  channel: 1	8	1	092c67af-25ce-41ca-85ce-cb96953c930d	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
970096c6-0923-402e-92de-b75494a32ffa	Вис.Т-ТС Gi Часовой -- adress: 9  channel: 1	9	1	c19d784b-119c-4bee-a0cb-92bddc4b1d55	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
4f50e1c1-f7f7-43f3-befd-748e78fba47e	Вис.Т-ТС Энергия Часовой -- adress: 7  channel: 1	7	1	64f9b17d-d599-428d-8849-5db3d37c7b0e	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
20bf2a30-421f-4e3b-bd70-2028a0ccbc52	Вис.Т-ТС Pi Часовой -- adress: 11  channel: 1	11	1	679fed74-2097-47b7-a928-cdd1577b509f	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
1a8dcaa6-a726-4b3b-aaed-3222d58f4887	Вис.Т-ТС Po Часовой -- adress: 12  channel: 1	12	1	067fb77b-d21c-4f28-ae05-4063514c6192	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
587da852-512a-461c-92c8-4dfb6f5df0ed	Вис.Т-ТС Энергия Часовой -- adress: 7 channel: 2	7	2	64f9b17d-d599-428d-8849-5db3d37c7b0e	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
1a53df66-e623-4571-be0c-32d6a85f6c11	Вис.Т-ТС Объем Часовой -- adress: 8 channel: 2	8	2	092c67af-25ce-41ca-85ce-cb96953c930d	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
191c4768-1cb3-450c-9d1a-fe3615c8f6b5	Вис.Т-ТС Ti Часовой -- adress: 3 channel: 2	3	2	bb56b908-a67d-48f3-95c5-4c8eec379056	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
c4cbec74-3580-4b1e-bf23-34e9a1aa5844	Вис.Т-ТС To Часовой -- adress: 4 channel: 2	4	2	62bb153e-a48f-49c4-8628-39d0a3574aa4	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
f0b315df-213a-4522-abf2-9b76a9ca665d	Вис.Т-ТС Gi Часовой -- adress: 9 channel: 2	9	2	c19d784b-119c-4bee-a0cb-92bddc4b1d55	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
0de7cff4-c459-413d-a9b3-c3a2e78f9087	Вис.Т-ТС Go Часовой -- adress: 10 channel: 2	10	2	f1dc85e8-5d13-4517-96e1-3c748a209c0d	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
b42181a3-e788-43aa-9b19-b40f920d84d9	Вис.Т-ТС Pi Часовой -- adress: 11 channel: 2	11	2	679fed74-2097-47b7-a928-cdd1577b509f	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
ccfb4ca1-fa98-45da-98cb-6e8a33c2fdb8	Вис.Т-ТС Po Часовой -- adress: 12 channel: 2	12	2	067fb77b-d21c-4f28-ae05-4063514c6192	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
e3e46248-5f52-4d18-a0b4-1cad42677c8e	Вис.Т-ТС operating_hours Часовой -- adress: 13 channel: 2	13	2	330217e8-78e2-4a3d-b257-ea2e6c617213	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
03f473eb-29c8-4eea-8332-d08cebd3b553	Вис.Т-ТС Энергия Часовой -- adress: 7 channel: 3	7	3	64f9b17d-d599-428d-8849-5db3d37c7b0e	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
9ee3ff1d-c85a-4db1-a170-f86fb4ae4a91	Вис.Т-ТС Объем Часовой -- adress: 8 channel: 3	8	3	092c67af-25ce-41ca-85ce-cb96953c930d	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
6107f421-020f-4000-be29-9cbd8eb1ba3c	Вис.Т-ТС Ti Часовой -- adress: 3 channel: 3	3	3	bb56b908-a67d-48f3-95c5-4c8eec379056	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
7a617b2d-40f8-4b9b-8f8b-e954d9437dac	Вис.Т-ТС To Часовой -- adress: 4 channel: 3	4	3	62bb153e-a48f-49c4-8628-39d0a3574aa4	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
a0fb81ca-d5f3-4d0f-81d6-e6f1e071637d	Вис.Т-ТС Gi Часовой -- adress: 9 channel: 3	9	3	c19d784b-119c-4bee-a0cb-92bddc4b1d55	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
fffd11eb-1fa2-4cb3-abbb-49f9f4428719	Вис.Т-ТС Go Часовой -- adress: 10 channel: 3	10	3	f1dc85e8-5d13-4517-96e1-3c748a209c0d	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
dd109630-ac3d-4b0d-8b53-fd11d5ea7cb1	Вис.Т-ТС Pi Часовой -- adress: 11 channel: 3	11	3	679fed74-2097-47b7-a928-cdd1577b509f	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
811d9ade-f63b-4039-b469-7876676d00f5	Вис.Т-ТС Po Часовой -- adress: 12 channel: 3	12	3	067fb77b-d21c-4f28-ae05-4063514c6192	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
3e7c7f07-db60-4c23-9676-34511ee42772	Вис.Т-ТС operating_hours Часовой -- adress: 13 channel: 3	13	3	330217e8-78e2-4a3d-b257-ea2e6c617213	ce1acf72-1660-4fee-bedf-a36777a41702	a2966e59-3ba9-48d8-a886-d27b9003bfa1
41280140-8377-4be1-a242-e520d193ee5b	Энергомера СЕ102 R51 T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	bf98a5cd-963b-403d-80e5-d0577bf45741	bb986590-63cb-4b9f-8f4b-1b96335c5441
539d0465-23b5-4474-b519-1a0549d31183	Энергомера СЕ102 R51 T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	bf98a5cd-963b-403d-80e5-d0577bf45741	bb986590-63cb-4b9f-8f4b-1b96335c5441
eca9377e-8e12-4e69-af38-5e0f5179521d	Энергомера СЕ102 R51 T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	bf98a5cd-963b-403d-80e5-d0577bf45741	bb986590-63cb-4b9f-8f4b-1b96335c5441
a00d116f-6497-4f18-97e4-d432d7812693	Энергомера СЕ102 R51 T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	bf98a5cd-963b-403d-80e5-d0577bf45741	bb986590-63cb-4b9f-8f4b-1b96335c5441
b788cff3-da11-4f60-8d55-2441d183637e	CE207 СПОДЭС T0 A+ Суточный -- adress: 0  channel: 0	0	0	0e1b1524-e9d2-4585-a6ee-4c499bdf86e9	91d05ae9-925e-45ab-9c4e-fc9b1ad96499	bb986590-63cb-4b9f-8f4b-1b96335c5441
bb4ce9e8-2586-4d12-9c5a-3d3e834b26f3	CE207 СПОДЭС T1 A+ Суточный -- adress: 0  channel: 1	0	1	a30f5530-c027-4d8a-815b-6abfb1d81028	91d05ae9-925e-45ab-9c4e-fc9b1ad96499	bb986590-63cb-4b9f-8f4b-1b96335c5441
3a62764f-1da9-4ce1-a05d-7c4ff6c26271	CE207 СПОДЭС T2 A+ Суточный -- adress: 0  channel: 2	0	2	6e822182-8dca-47f6-a25b-8599423f342e	91d05ae9-925e-45ab-9c4e-fc9b1ad96499	bb986590-63cb-4b9f-8f4b-1b96335c5441
32c9f65b-43f9-4593-9b0d-652e490d004b	CE207 СПОДЭС T3 A+ Суточный -- adress: 0  channel: 3	0	3	3aa0b0ca-d62d-497d-a9d5-5d2f7e2d4c67	91d05ae9-925e-45ab-9c4e-fc9b1ad96499	bb986590-63cb-4b9f-8f4b-1b96335c5441
\.


--
-- TOC entry 3822 (class 0 OID 156112)
-- Dependencies: 266
-- Data for Name: product_coefficients_kilns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_coefficients_kilns (id, sfid, coefficient) FROM stdin;
\.


--
-- TOC entry 3824 (class 0 OID 156116)
-- Dependencies: 268
-- Data for Name: product_info_kilns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_info_kilns (id, dt, kiln_code, product_caption, product_count, product_coefficient, product_weight) FROM stdin;
\.


--
-- TOC entry 3826 (class 0 OID 156120)
-- Dependencies: 270
-- Data for Name: product_type_kilns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type_kilns (id, nm, kind_id) FROM stdin;
\.


--
-- TOC entry 3833 (class 0 OID 174760)
-- Dependencies: 279
-- Data for Name: report_configs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_configs (guid, number, name, show_lic_num, separator, round_size, comment_to_excel, show_stoyak, show_floors, num_is_string, null_field, order_fields, order_direction, is_active, guid_resources) FROM stdin;
b81bad51-a1af-4e81-a05b-72c2051f7dac	1	Потребление за период по T0 A+ и T0 R+	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
3f2c6791-ae52-43e6-9f2e-37784344f569	2	Простой отчёт	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
695beab5-82ed-4da7-9663-a571218b3c45	3	Показания за период. 3 тарифа	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
30645a75-620b-4bfb-a3fd-a42de6e50c65	4	Получасовки	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
3c9ea91d-bb8f-4a77-ae75-08c6322dea00	6	Часовые приращения энергии	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
de574093-3185-43b6-8023-174aec490867	7	Удельный расход электроэнергии	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
1a85d716-ecfe-43fe-b2fa-217c61363555	8	Режимный день	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
f3655731-8d58-4c32-8fe0-c12c3348274f	14	Показания по электричеству на дату. 2 тарифа	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
eda4a455-d296-4392-93cf-7c83d2248204	16	Показания по электричеству на дату. 3 тарифа	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
67d5be2d-885d-41be-b657-147a5f0a0db7	17	Потребление по электричеству за период. 3 тарифа	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
06c2f446-586a-4cd3-bbcc-98b431ffffb9	25	Срез показаний электричество	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
9676121c-9c06-4e6e-a130-d748be61ff4e	27	Срез показаний электричество 2 зоны	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
735c44b1-6448-4d19-b542-f4e9f3124e53	29	Срез показаний электричество 3 зоны	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
3c4197f8-8bc5-4e2d-a7cb-61270ad5b915	31	Потребление по электричеству за период. 2 тарифа	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
2abe208a-7e53-4e14-9231-179534e00e30	40	Сверка заводских номеров приборов	f	,	3	f	f	f	f	Н/Д		asc	t	ba710cff-e390-48ca-b442-70141c9864f7
a84327f5-85be-459f-aa76-99d7851cf17e	41	Отчёт по форме 80020	f	,	3	f	f	f	f	Н/Д		asc	t	ba710cff-e390-48ca-b442-70141c9864f7
ea5863e0-f99f-49e7-8587-84137311b879	44	Отчёт по электричеству на дату	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
bc0a07f9-16ca-4fb0-a6a4-4d1a38dc2b96	68	Режимный день электричество	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
a4a20f95-8872-4f25-9060-20f880a835f6	69	График потребления электроэнергии по дням	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
671067b9-f5ed-41af-b128-601c5d2704ca	71	Отчёт по форме 80040	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
fbe000fd-312b-4b3e-b3c8-a0cfcf779338	72	Показания по электричеству на дату. 3 тарифа v3	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
d834852f-5373-4f66-8d20-95860c8821b5	77	Потребление за период электричество баланс	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
e62f4ffe-3cde-4835-9145-1ed1ac6f67ed	86	Статистика опросов. Электричество	f	,	3	f	f	f	f	Н/Д		asc	t	ba710cff-e390-48ca-b442-70141c9864f7
7d74e15b-4ce2-4b92-9735-0803ebdb00fe	89	Отчёт по потреблению электричества для ботсада	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
4df484a5-aaba-466d-8a7a-dba88b3d8065	91	Потребление по электричеству за период. 3 тарифа (с графиком)	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
a134db00-530c-4c06-b4cc-298fcbc1e557	95	График потребления электроэнергии по дням 3 тарифа R+ A+	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
21938a8e-a407-48f2-bec7-dcaab6e492c6	98	Восстановленный суточный срез из получасовок	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
e67674f6-4105-472b-bc92-15b37a60dda8	99	Вывод всех получасовок за период	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
c925cdaa-3928-4ce9-853b-905d6621b97d	102	Показания по электричеству на дату. 3 тарифа с комментарием	t	,	3	t	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
6811174f-3b89-4f85-8ecb-b201d77a21ec	103	Потребление по электричеству 2 зоны	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
da40ecc6-96e7-492b-bf2b-0bcde9cc4b9b	104	Показания по электричеству на дату. 2 тарифа с комментарием	t	,	3	t	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
c7a378cd-c2d9-4a39-9e03-cce3544564b7	105	Потребление по электричеству 1 зона	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
491dedee-0111-4aca-8faa-22f034aed0a8	106	Показания по электричеству на дату. 1 зона с комментарием	t	,	3	t	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
f28bca23-5162-49b3-b895-63be16720c15	107	Потребление по электричеству для Подольска	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
33bbdbbf-393b-46bd-8b99-9ae631f33b7e	108	Показания по электричеству на дату для Подольска	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
081e3d6c-d5ef-4919-b6d0-b16805317b76	113	Потребление за период. 3 тарифа	t	,	3	f	f	f	f	Н/Д		asc	t	ba710cff-e390-48ca-b442-70141c9864f7
b01dc997-7533-4219-8bf6-17edf6c1d2be	114	Показания на дату. 3 тарифа	t	,	3	t	f	f	f	Н/Д		asc	t	ba710cff-e390-48ca-b442-70141c9864f7
1c66b5ca-62ae-4441-a6a7-34b7f7c9cff6	120	Показания на выбранный день за год по электричеству	t	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
b74d9709-945c-41e2-bb54-bb7fe38c5e67	126	Часовки за месяц по электричеству. Интервальный акт	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
365aa6c9-00b8-43c6-82c1-4c06918aa2bf	128	Часовки за месяц по электричеству. Интегральный акт	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
e328ceaa-43fe-4c1e-a117-94af606168e6	143	Анализ потребления по получасовкам за период	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
db0cdd30-f327-42fc-be8e-600be9666bdc	148	Отчёт по потреблению для мос.электрики на Дискавери	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
4809afb3-d333-4248-810a-0f41c756cf9b	172	Электричество интегральный из шаблона	f	,	3	f	f	f	f	Н/Д		asc	f	ba710cff-e390-48ca-b442-70141c9864f7
ce4619db-5441-475e-a018-da047c6497ef	9	Отчёт по всем ресурсам за период	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
dab992c9-3c5b-44b1-b5f6-bb58f138348d	10	Показания по воде	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
451e3c9b-bc18-48d9-9c5e-602e09eab5bf	11	Потребление по воде	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
335a19d2-857e-4f6e-9fa0-084e6059f279	12	Потребление по воде с идентификаторами	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
44b1a7c2-cd88-432a-89ad-6d31f7c083fe	26	Показания по ГВС и ХВС последние считанные	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
95d622d2-e6fa-4c64-baea-47703455491e	28	Показания по ГВС и ХВС	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
97d2101e-e49c-4f58-896f-9751c8f3c5dc	42	Отчёт по всем ресурсам на дату	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
7ace0985-3adc-4562-9ee1-acdc9ee8c4f4	46	Отчёт по воде на дату	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
2fb29706-3aa6-4157-a9c3-15a1c20ea8bc	76	Все ресурсы на дату	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
968de9aa-1d13-4480-9fbc-b109b562b96b	79	Потребление по воде за период импульсные (с графиком)	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
bc9f0b17-3761-4a9d-978b-4d0047d99180	92	Статус всех ресурсов за месяц	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
63faa36f-264c-470e-9f30-13964fb5a21b	93	Отчёт по потреблению воды для ботсада	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
f2782855-0493-409f-a72e-2ecbc12e7d31	101	Потребление по воде за период импульсные для Мантулинской	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
5c2506ed-7fe8-4d19-8923-69eee3bb1273	34	Показания по ХВС Текон	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
84ea2c01-17b5-4290-9a21-9bfc1ead4b40	35	Потребление по ХВС Текон за период	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
05585774-310b-429d-a5ae-2715448e9d64	52	Показания по ХВС Эльф	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
b7bbe7c3-a49f-448f-892e-d3d15706b7bf	53	Потребление по ХВС Эльф	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
923a49df-6071-4c0b-a3c2-9a2e01b5198a	109	Потребление по воде ТЭМ-104	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
f977844a-8150-45df-ac5a-64dbfff69213	110	Показания по воде ТЭМ-104 на дату	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
e7ca04ab-27e5-422c-8ec8-cab41410a67b	57	Потребление за период с водосчётчиков Пульсар	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
93a8980e-8170-4956-ad7f-e2e413fa7288	58	Показания на дату с водосчётчиков Пульсар	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
ae241c8e-d25f-4a23-8a57-a92100aad055	60	Показания по стоякам в одну строку с водосчётчиков Пульсар	f	,	3	f	t	f	f	Н/Д		asc	t	47f0b64c-2bf6-45b4-972b-601f473a3752
f31a6cfb-d089-4378-931f-5e1f2e105218	66	Показания на дату по Эльф-тепло и вода	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
6f541734-dab3-4763-9545-91f4702d35a7	67	Потребление по стоякам в одну строку с водосчётчика Пульсар	f	,	3	f	f	f	f	Н/Д		asc	t	47f0b64c-2bf6-45b4-972b-601f473a3752
e822c0d2-ed79-4325-8917-fa9b57d8dd14	73	Потребление за период с водосчётчиков Пульсар (с графиком)	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
2ff971b7-b8a8-4755-ba7e-889bf5cd6df7	83	Потребление по месяцам с эльфов ХВ и ГВ	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
fc100bfc-facc-4a96-b36c-ac96f813a375	84	Показания по воде Эльф	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
3a1dbf1a-c897-4067-bdc4-dbadfe7462d9	85	Потребление за период с эльфов ХВ и ГВ	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
7ae76c97-c7ae-4942-9654-9e2452c31804	94	Статистика опросов. Вода цифровая	f	,	3	f	f	f	f	Н/Д		asc	t	47f0b64c-2bf6-45b4-972b-601f473a3752
3b2bdc77-6007-4f6b-bf3b-472197eca52b	132	Показания по стоякам в одну строку на дату с регистраторов Пульсар (импульс)	f	,	3	f	t	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
2c775430-d27c-4752-802e-cce6c8921ecb	137	Потребление за период с водосчётчиков Пульсар (копия 73)	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
36c12486-2802-4135-90e4-d310a21e1ce4	138	Показания на дату с водосчётчиков Пульсар (копия 58)	f	,	3	f	f	f	f	Н/Д		asc	t	47f0b64c-2bf6-45b4-972b-601f473a3752
9e0375ce-3900-4bc0-af97-04c9b7855133	139	Отчёт по потреблению для мосводоканала на Пресня-Сити	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
c740e529-4cf7-400f-8f28-50ab07c6aeb0	140	Вода батарейка Пульсар	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
0aef03d1-9b52-465d-866f-d54315c48762	141	Потребление за период с водосчётчиков Эконом	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
50ad01ef-48b2-4c6b-accc-6d4b80274280	142	Показания на дату с водосчётчиков Эконом	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
1c7a7ffd-d1f5-4f78-af50-714970e03e99	145	Отчёт по потреблению для мосводоканала на Дискавери	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
47af2010-b95f-447c-97d9-7280d448fa43	146	Отчёт по потреблению для мосводоканала на Дискавери из шаблона	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
23221df9-22ee-473e-9814-ff0631d44298	147	Анализ потребления воды	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
b9df9608-0400-453c-8ed4-234b79aaa0e7	151	Показания на 2 даты ГВС и ХВС	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
20fff02b-ce14-4db4-948c-cd38185ba3dc	152	Показания на дату с водосчётчиков Пульсар (с этажами)	f	,	3	f	t	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
efbb9893-18ec-46c1-8bbe-0f23bae9bf04	157	Потребление воды с приборов iot	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
f48610cb-f948-45fc-b2b8-bc55028a6506	158	Показания воды с приборов iot	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
ba54f8e5-06f5-4ac5-9036-63a7b51d764f	173	Отчёт по воде по шаблону на 2 даты	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
aced17f4-9212-41cc-8eb9-78a9c4373f99	176	Отчёт об ошибках и батарейке водосчётчика Пульсар	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
97d44cee-bf1d-42ba-bb2d-218b3417fa4b	166	Показания воды с приборов Ридан	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
465a2a68-0823-413b-9906-06763c23263e	167	Потребление воды с приборов Ридан	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
beb7c9f9-5415-4a38-be89-dbf377615363	170	Показания воды с приборов Vzlet	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
9e57870f-d6d2-47c4-8d8d-982dbedae7b0	171	Потребление воды с приборов Vzlet	f	,	3	f	f	f	f	Н/Д		asc	f	47f0b64c-2bf6-45b4-972b-601f473a3752
aaebf979-9172-4cee-8e93-c92258315831	36	Показания по ГВС Текон	f	,	3	f	f	f	f	Н/Д		asc	f	57ec8f42-69c6-4f79-81bb-8ea139407aa9
e8281018-41ae-41f0-a34e-aa84d1d970f0	37	Потребление по ГВС Текон за период	f	,	3	f	f	f	f	Н/Д		asc	f	57ec8f42-69c6-4f79-81bb-8ea139407aa9
5d910c76-fd78-4b12-b777-f89ed7cbce71	54	Показания по ГВС Эльф	f	,	3	f	f	f	f	Н/Д		asc	f	57ec8f42-69c6-4f79-81bb-8ea139407aa9
1910a805-2cda-46e4-8df3-33edb64d44d4	55	Потребление по ГВС Эльф	f	,	3	f	f	f	f	Н/Д		asc	f	57ec8f42-69c6-4f79-81bb-8ea139407aa9
9731041d-1e9b-495b-b784-9f2bf41b53ab	117	Потребление за период с холодосчётчиков Пульсар	f	,	3	f	f	f	f	Н/Д		asc	t	06cabd95-80dc-472f-acc7-cad95d4cacb0
31211aeb-6070-420c-abe6-19cea77043c4	118	Показания на дату с холодосчётчиков Пульсар	f	,	3	f	f	f	f	Н/Д		asc	f	06cabd95-80dc-472f-acc7-cad95d4cacb0
fd3bbb4f-47ec-45c2-8019-2e7249c8b1a6	154	Показания с холодосчётчиков Пульсар	f	,	3	f	t	f	f	Н/Д		asc	t	06cabd95-80dc-472f-acc7-cad95d4cacb0
78eda9e1-3c12-4242-a056-a3f1bccd7969	18	Показания по теплу	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
7d5fb629-40dd-4561-9597-fad31a4f921a	19	Потребление по теплу	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
15c0feec-de7b-4e8a-ae06-99d80d262cc4	20	Текущие показания по теплу	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
13b1308e-86be-4579-9fe9-e65053e5aa87	30	Показания по теплосчётчикам Саяны	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
29818d54-6b3e-4823-b8f7-31f2cda9fda1	32	Показания по теплосчётчикам Саяны последние считанные	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
34314542-07b9-4adf-9b50-2b0f88177dac	33	Потребление по теплосчётчикам Саяны за период	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
d65f467a-18ed-435b-8c51-d89ffaf15bc1	48	Отчёт по теплу за последнюю дату для бухгалтерии	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
40b746e0-3748-48fb-bb74-f94703581b0d	50	Показания по теплу Текон	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
44b5191d-4670-4083-96c6-6d7ed3b6a5a4	51	Потребление по теплу Текон	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
8f04c828-e88f-4340-91d3-1e7de741f365	56	Показания с теплосчётчиков Пульсар	f	,	2	f	f	f	f	Н/Д		asc	t	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
c2ba956e-d95a-49e8-a02b-0ff81d2932a2	59	Потребление за период с теплосчётчиков Пульсар	f	,	2	f	f	f	f	Н/Д		asc	t	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
a8ff0034-e653-4db0-b83a-48468622d2b1	61	Показания на дату с теплосчётчиков Пульсар (копия 59)	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
ff038334-675a-4201-af25-25426117ca83	62	Показания на дату с теплосчётчиков Пульсар (копия 56)	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
74925835-70c9-4a68-a04a-26732cc5f418	63	Потребление за период Эльф-тепло	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
8f6a4d22-1e58-4362-8b44-ec50b768e464	64	Показания на дату Эльф-тепло	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
358d30bb-1346-42e6-a307-88e02f2460c3	74	Показания по теплу Карат	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
3fb509a5-6e0f-459f-b282-999db9723e3e	75	Потребление по теплу Карат	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
f26fbe8f-c9c5-4838-9e01-f3a1174a9dae	81	Потребление на дату с теплосчётчиков Пульсар (с графиком)	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
c34f3b5e-1dbf-4195-840c-1772fe6e36db	88	Статистика опросов. Тепло	f	,	2	f	f	f	f	Н/Д		asc	t	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
eafe54c0-e82a-4725-b1cc-2641a5d6bfba	97	Потребление по теплу Данфосс	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
31705aee-429e-42bf-99ac-7f1e658020f6	100	Показания по теплу Данфосс	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
66486342-b11b-4df1-871d-19804ed6d7da	111	Потребление по теплу ТЭМ-104	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
2c77e227-ce32-4c7a-a94f-fe3f153a5a75	112	Показания по теплу ТЭМ-104 на дату	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
42d6601a-e069-4aab-b61e-7db182a9ea78	115	Потребление за период с теплосчётчиков Пульс СТК	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
4de3622f-3c24-456a-8396-c83623dec620	116	Показания на дату теплосчётчиков Пульс СТК	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
e70ad41e-7c6b-4224-ac75-651a6af8f62a	124	Показания на выбранный день за год по теплу	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
45424596-18b7-4c9b-b7fd-a128282da205	130	Коды ошибок с теплосчётчиков Пульсар	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
361c3aee-2265-412c-bdce-aa45a5cd2513	136	Показания по стоякам в одну строку на дату с теплосчётчиков Пульсар	f	,	2	f	t	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
22c9478d-d2a7-4842-a13c-e0174d59ed08	144	Показания на дату с теплосчётчиков Пульсар (с этажами)	f	,	2	f	t	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
fb21cdac-50d5-4c32-8b58-32b97afedd84	150	Отчёт по потреблению тепла на Дискавери из шаблона	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
a6efef15-aaf2-4773-addd-17eb9fe78175	155	Потребление за период тепло импульсное	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
1e6a1fd9-e96a-47e7-a8de-28fb023b0850	156	Показания на дату тепло импульсное	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
12961729-102d-4fcd-86e5-2ac969cf0a97	159	Потребление тепла с приборов iot	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
eef00667-5959-43b8-9327-aaf79a33d24b	160	Показания тепла с приборов iot	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
305099ba-ca3d-43d9-a062-d2c3b0935c5d	162	Показания тепла с приборов VKT9	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
543f0e35-9733-4f6f-a693-3fdf07ab6ca0	164	Показания тепла с приборов Ридан	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
ef93dcfa-e244-44fa-b25c-a9f8cb3d62a3	165	Потребление тепла с приборов Ридан	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
6ce206c4-1631-46ae-b95e-fcfab65e2aea	168	Показания тепла с приборов Vzlet	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
6a84211b-1cbb-4d04-97e2-3a80fd2b6bc1	169	Потребление тепла с приборов Vzlet	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
14a72373-15df-4a61-9507-8f56f2582f65	174	Отчёт об ошибках и батарейке теплосчётчика Пульсар	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
24bc08a2-6af0-4cd4-a478-1cdfc2c00eb8	175	Отчёт месячный протокол учёта тепловой энергии за месяц	f	,	2	f	f	f	f	Н/Д		asc	f	c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3
f4492eef-f8fc-49b5-84be-bf431b6949d0	22	Показания суточные по СПГ	f	,	3	f	f	f	f	Н/Д		asc	f	44af1849-73b1-4b52-9905-881c8bdb753d
03778907-cf5e-4b88-86c0-55d69c3bca52	38	Показания по воде с регистратора импульсов	f	,	3	f	f	f	f	Н/Д		asc	t	12574d66-2034-4c8e-8c8c-249757736858
f863504a-c69e-4898-b7c2-e188094c96cd	39	Потребление по воде с регистратора импульсов	f	,	3	f	f	f	f	Н/Д		asc	t	12574d66-2034-4c8e-8c8c-249757736858
19d277ce-65f1-40fa-af99-613f6a76e3ff	87	Потребление за период вода импульсная баланс	f	,	3	f	f	f	f	Н/Д		asc	f	12574d66-2034-4c8e-8c8c-249757736858
47cafcd4-1b03-49a2-8017-9aeaf0d3082e	90	Статистика опросов. Вода импульсная	f	,	3	f	f	f	f	Н/Д		asc	t	12574d66-2034-4c8e-8c8c-249757736858
d5a784a9-2c54-4bc0-b687-aa3076f5b761	96	Текущие показания по воде импульсные ПУ	f	,	3	f	f	f	f	Н/Д		asc	f	12574d66-2034-4c8e-8c8c-249757736858
0dfd3001-b462-40cc-9ae2-5528d809c787	133	Потребление по водосчётчикам импульсным с каналов Danfoss	f	,	3	f	f	f	f	Н/Д		asc	f	12574d66-2034-4c8e-8c8c-249757736858
d3025449-0e58-4fda-83ba-707ee8e5bb13	134	Показания по водосчётчикам импульсным с каналов Danfoss	f	,	3	f	f	f	f	Н/Д		asc	f	12574d66-2034-4c8e-8c8c-249757736858
2816d040-4d29-45cc-8fbb-44eb3f73453e	24	Прогрузка балансных групп	f	,	3	f	f	f	f	Н/Д		asc	f	c0534604-4cf3-4286-8428-8b846270e16f
\.


--
-- TOC entry 3781 (class 0 OID 155971)
-- Dependencies: 220
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resources (guid, name, type) FROM stdin;
06cabd95-80dc-472f-acc7-cad95d4cacb0	Холод	5
44af1849-73b1-4b52-9905-881c8bdb753d	Газ	6
47f0b64c-2bf6-45b4-972b-601f473a3752	ХВС	2
57ec8f42-69c6-4f79-81bb-8ea139407aa9	ГВС	3
ba710cff-e390-48ca-b442-70141c9864f7	Электричество	1
c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3	Тепло	4
12574d66-2034-4c8e-8c8c-249757736858	Импульс	7
c0534604-4cf3-4286-8428-8b846270e16f	Служебные	8
\.


--
-- TOC entry 3782 (class 0 OID 155974)
-- Dependencies: 221
-- Data for Name: taken_params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taken_params (id, name, guid, guid_meters, guid_params) FROM stdin;
14	тест Меркурий 230 Q Текущий -- adress: 6  channel: 0	3c2fcb57-2fee-4324-9022-e1cabb7a9394	8ac58ece-45a6-49a1-a14f-96cf49dc3ee0	e7617c95-7e42-4cfa-9acd-5bc119261c6d
\.


--
-- TOC entry 3812 (class 0 OID 156056)
-- Dependencies: 252
-- Data for Name: tcpip_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tcpip_settings (guid, ip_address, ip_port, write_timeout, read_timeout, attempts, delay_between_sending) FROM stdin;
c77d7468-8e1b-431f-9496-cfd58b3d999b	10.10.10.10	1001	300	700	3	400
daa8ab8b-41a0-45ba-9e8f-ac21de666c0f	185.144.137.88	6004	300	700	3	400
96b3545f-e4dc-4852-b9c2-a7ea5e4f6c9c	192.168.0.7	26	300	700	3	400
c2472aec-f9b7-482d-826a-ac1e8dc4d690	192.168.170.24	4002	300	700	3	400
35a80c2b-1799-4880-96af-3438a1acab23	192.168.0.7	23	300	700	3	400
\.


--
-- TOC entry 3829 (class 0 OID 156129)
-- Dependencies: 273
-- Data for Name: types_abonents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types_abonents (guid, name) FROM stdin;
01d52a6c-97bb-4e29-ad07-608d449e0ba2	АВР
a8c498a7-d7e1-4da7-84a9-d5cb3bac9b7d	ОДН
e4d813ca-e264-4579-ae15-385cdbf5d28c	Квартиры
ece19e65-f471-4d62-a517-410b007d4f65	Ввод
05c75cb3-7d6e-41a2-8b9b-fa93fdc0bca3	ВРУ
\.


--
-- TOC entry 3813 (class 0 OID 156059)
-- Dependencies: 253
-- Data for Name: types_meters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types_meters (guid, name, driver_name) FROM stdin;
1c5a8a80-1c51-4733-8332-4ed8d510a650	Эльф 1.08	elf108
20e4767a-49e5-4f84-890c-25e311339c28	Меркурий 230-УМ	um40rtu
423b33a7-2d68-47b6-b4f6-5b470aedc4f4	Меркурий 230	m230
42e28120-a4a6-4165-85e0-6a675448630a	Меркурий 233	m233
5429b439-233e-4944-b91b-4b521a10f77b	Саяны Комбик	sayani_kombik
6224d20b-1781-4c39-8799-b1446b60774d	Меркурий 200	m200
66b7ce6a-f280-4e54-8c8d-f69f34aabdf9	СЭТ-4ТМ.03М	set4tm
9a4f2233-204d-4ff2-98d7-9d84f34008ee	ТЭМ-104	tem4
aa491ede-e00b-4e1d-a8ba-1ef61dba1caa	Danfoss SonoSelect	karat_danfos
e8839bfd-af1c-43dd-8c05-5ed0ea61cd6e	ПСЧ-3ТА.04	psch3ta
fbc9874c-1dc4-4cb0-95e7-4ff6ca7ab17f	Пульс СТК ХВС	stk_water
bb111ede-e00b-4e1d-a8ba-1ef61dba1caa	Пульс СТК Теплосчётчик	stk_heat
12c9874c-1dc4-4cb0-95e7-4ff6ca7ab17f	Пульс СТК ГВС	stk_water
a1a349ba-e070-4ec9-975d-9f39e61c34da	Пульсар ГВС	pulsar_voda
f1789bb7-7fcd-4124-8432-40320559890f	Пульсар ХВС	pulsar_voda
6599be9a-1f4d-4a6e-a3d9-fb054b8d44e8	Пульсар 2M	pulsar_voda_rs485
6d7b64ac-3dba-40d6-8190-d397ae7b9361	Пульсар10	pulsar_voda_rs485
7cd88751-d232-410c-a0ef-6354a79112f1	Пульсар 16M	pulsar_voda_rs485
baf23191-8b7e-410d-8053-a654c11aaf58	Пульсар16	pulsar_voda_rs485
cae994a2-6ab9-4ffa-aac3-f21491a2de0b	Пульсар 10M	pulsar_voda_rs485
82b96b1c-31cf-4753-9d64-d22e2f4d036e	Пульсар Теплосчётчик	pulsar_teplo
c1ae0de6-f071-4e07-8452-09059eef187b	Пульсар Холодосчётчик	pulsar_teplo
5f9e013c-378d-4947-a1a7-33e6ebdc1cef	Пульсар 3Ф4Т	pulsar_e
17d88dbc-23b9-490a-9895-58ad24fe459d	Энергомера СЕ301	ce301
5edb1d1e-d63f-45b0-b4a4-7f7e1fec1628	Меркурий СПОДЭС	spodes
e8fa5e00-e1b9-4ef3-bc39-b8439a44b540	Sanext	sanext
d8613ccc-a5b4-406b-8a04-b70e08f7f7a8	Valtec 16M	valtec
50098019-7418-4661-baa9-b913de3596da	ЭкоНом ХВС	econom
e2e6c4c5-636a-432a-bdbf-6a5ab4b1fdee	ЭкоНом ГВС	econom
aefa5648-2240-42b4-88cf-04b093a60187	ЭкоНом Теплосчётчик	econom
8790eaeb-671b-4596-b80e-d6475d74382c	Нартис СПОДЭС	nartis_spodes
b95134db-af0c-4eea-bc8e-32b2bcfc7e1d	Декаст Теплосчётчик	decast
295f91bd-3e05-435e-9eb8-bda7eddaf6a4	МЗТА	mzta
9e7353a7-3bd3-4176-9a35-d152dcfcb74c	Danfoss RTU	danfoss
657d8ad0-bdba-4459-a07e-4d4eb72950d6	Декаст ХВС	decast
36b6ea95-beb1-490d-a39f-06163bfcaae5	Декаст ГВС	decast
5e1dbf09-6c37-4982-aa1e-a693d2b4f079	Danfoss SonoMeter-500	sonometer500
bc61d16e-4059-4f9b-b7df-55915a7a844b	Пульсар IoT ВС	pulsar_iot
84bf3b54-d51d-48d7-902d-4826cdef7101	Пульсар IoT Тепло-объем	pulsar_iot
a3aa2833-4104-4ac4-a0fb-c34e4402d1d6	Пульсар IoT Тепло-энергия	pulsar_iot
59963730-468e-441c-86d9-d08a3ed062fc	ВКТ9	teplocom
4d714a5e-3af5-40fe-ab72-199ed8760ac3	Теплосчётчик Ридан РУТ-01	ridan
3a32cec9-d03a-4e46-a065-f81f92e5ead0	ВЗЛЕТ ТСР-М ТСРВ-043	vzlet
30936305-66a6-4459-b7d0-9c3ea8e2ba12	ВЗЛЕТ ТСР-М ТСРВ-024М	vzlet
0a5753cf-debd-45cb-8dd0-3905f36293fc	Водосчётчик Ридан СГВ-15 ГВС	ridan
b060fcdd-f52d-4914-9dca-2fbcc2a205d5	Водосчётчик Ридан СГВ-15 ХВС	ridan
4d85e9a5-513e-419c-a02e-3e6ba79eafa7	ВЗЛЕТ МР УРСВ-311 ГВС	vzlet
af871462-2104-491d-9a83-e7dcd77364b1	ВЗЛЕТ МР УРСВ-311 ХВС	vzlet
84244574-8fee-47a6-a546-15b01c82f778	CE308 СПОДЭС	ce308_spodes
2d99741f-b22e-4926-af61-056e956b24b0	МИРТЕК-32-РУ-D37	mirtek
a91aa386-0de1-4dd3-a702-db980e788fcd	Пульсар 405 Теплосчётчик	pulsar
ce1acf72-1660-4fee-bedf-a36777a41702	Вис.Т-ТС	vist
bf98a5cd-963b-403d-80e5-d0577bf45741	Энергомера СЕ102 R51	energomera_ce102r51
91d05ae9-925e-45ab-9c4e-fc9b1ad96499	CE207 СПОДЭС	ce207_spodes
\.


--
-- TOC entry 3830 (class 0 OID 156132)
-- Dependencies: 274
-- Data for Name: types_params; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.types_params (guid, name, period, type) FROM stdin;
3242af58-ba57-4d8b-83fa-284bd8f4bd9b	Текущий	\N	0
3b0d3f12-f92f-476d-96d3-e1d2c1a19e2f	Месячный	\N	2
597eeb75-5d7e-4514-9255-12cc9e6cf97d	Архивный	\N	3
bb986590-63cb-4b9f-8f4b-1b96335c5441	Суточный	\N	1
e78189b5-f9f9-4fdd-830e-5b98c342d7c1	Получасовой	30	4
a2966e59-3ba9-48d8-a886-d27b9003bfa1	Часовой	60	5
\.


--
-- TOC entry 3831 (class 0 OID 156135)
-- Dependencies: 275
-- Data for Name: various_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.various_values (id, date, "time", value, status, id_taken_params) FROM stdin;
\.


--
-- TOC entry 3858 (class 0 OID 0)
-- Dependencies: 224
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 226
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 3860 (class 0 OID 0)
-- Dependencies: 228
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 148, true);


--
-- TOC entry 3861 (class 0 OID 0)
-- Dependencies: 231
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 3862 (class 0 OID 0)
-- Dependencies: 232
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- TOC entry 3863 (class 0 OID 0)
-- Dependencies: 234
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 3864 (class 0 OID 0)
-- Dependencies: 240
-- Name: current_values_archive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.current_values_archive_id_seq', 1, false);


--
-- TOC entry 3865 (class 0 OID 0)
-- Dependencies: 241
-- Name: current_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.current_values_id_seq', 1, false);


--
-- TOC entry 3866 (class 0 OID 0)
-- Dependencies: 243
-- Name: daily_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.daily_values_id_seq', 1338580, true);


--
-- TOC entry 3867 (class 0 OID 0)
-- Dependencies: 245
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1626, true);


--
-- TOC entry 3868 (class 0 OID 0)
-- Dependencies: 247
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 37, true);


--
-- TOC entry 3869 (class 0 OID 0)
-- Dependencies: 249
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 23, true);


--
-- TOC entry 3870 (class 0 OID 0)
-- Dependencies: 264
-- Name: monthly_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monthly_values_id_seq', 24229, true);


--
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 267
-- Name: product_coefficients_kilns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_coefficients_kilns_id_seq', 1, false);


--
-- TOC entry 3872 (class 0 OID 0)
-- Dependencies: 269
-- Name: product_info_kilns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_info_kilns_id_seq', 1, false);


--
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 271
-- Name: product_type_kilns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_type_kilns_id_seq', 1, false);


--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 272
-- Name: taken_params_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.taken_params_id_seq', 2, true);


--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 276
-- Name: various_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.various_values_id_seq', 201182, true);


--
-- TOC entry 3410 (class 2606 OID 156172)
-- Name: abonents abonents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abonents
    ADD CONSTRAINT abonents_pkey PRIMARY KEY (guid);


--
-- TOC entry 3452 (class 2606 OID 156174)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 3457 (class 2606 OID 156176)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 3460 (class 2606 OID 156178)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3454 (class 2606 OID 156180)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3463 (class 2606 OID 156182)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 3465 (class 2606 OID 156184)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3473 (class 2606 OID 156186)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3476 (class 2606 OID 156188)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 3467 (class 2606 OID 156190)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3479 (class 2606 OID 156192)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3482 (class 2606 OID 156194)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 3470 (class 2606 OID 156196)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 3485 (class 2606 OID 156198)
-- Name: balance_groups balance_groups_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_groups
    ADD CONSTRAINT balance_groups_name_key UNIQUE (name);


--
-- TOC entry 3487 (class 2606 OID 156200)
-- Name: balance_groups balance_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.balance_groups
    ADD CONSTRAINT balance_groups_pkey PRIMARY KEY (guid);


--
-- TOC entry 3491 (class 2606 OID 156202)
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (guid);


--
-- TOC entry 3493 (class 2606 OID 156204)
-- Name: comport_settings comport_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comport_settings
    ADD CONSTRAINT comport_settings_pkey PRIMARY KEY (guid);


--
-- TOC entry 3499 (class 2606 OID 156206)
-- Name: current_values_archive current_values_archive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_values_archive
    ADD CONSTRAINT current_values_archive_pkey PRIMARY KEY (id);


--
-- TOC entry 3496 (class 2606 OID 156208)
-- Name: current_values current_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_values
    ADD CONSTRAINT current_values_pkey PRIMARY KEY (id);


--
-- TOC entry 3502 (class 2606 OID 156210)
-- Name: daily_values daily_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_values
    ADD CONSTRAINT daily_values_pkey PRIMARY KEY (id);


--
-- TOC entry 3505 (class 2606 OID 156212)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3508 (class 2606 OID 156214)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 3510 (class 2606 OID 156216)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3512 (class 2606 OID 156218)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3515 (class 2606 OID 156220)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 3534 (class 2606 OID 156222)
-- Name: groups_80020 groups_80020_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups_80020
    ADD CONSTRAINT groups_80020_name_key UNIQUE (name);


--
-- TOC entry 3536 (class 2606 OID 156224)
-- Name: groups_80020 groups_80020_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups_80020
    ADD CONSTRAINT groups_80020_pkey PRIMARY KEY (guid);


--
-- TOC entry 3540 (class 2606 OID 156226)
-- Name: link_abonents_auth_user link_abonents_auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_abonents_auth_user
    ADD CONSTRAINT link_abonents_auth_user_pkey PRIMARY KEY (guid);


--
-- TOC entry 3414 (class 2606 OID 156228)
-- Name: link_abonents_taken_params link_abonents_taken_params_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_abonents_taken_params
    ADD CONSTRAINT link_abonents_taken_params_pkey PRIMARY KEY (guid);


--
-- TOC entry 3531 (class 2606 OID 156230)
-- Name: link_balance_groups_meters link_balance_groups_meters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_balance_groups_meters
    ADD CONSTRAINT link_balance_groups_meters_pkey PRIMARY KEY (guid);


--
-- TOC entry 3544 (class 2606 OID 156232)
-- Name: link_groups_80020_meters link_groups_80020_meters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_groups_80020_meters
    ADD CONSTRAINT link_groups_80020_meters_pkey PRIMARY KEY (guid);


--
-- TOC entry 3548 (class 2606 OID 156234)
-- Name: link_meters_comport_settings link_meters_comport_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_meters_comport_settings
    ADD CONSTRAINT link_meters_comport_settings_pkey PRIMARY KEY (guid);


--
-- TOC entry 3520 (class 2606 OID 156236)
-- Name: link_meters_tcpip_settings link_meters_tcpip_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_meters_tcpip_settings
    ADD CONSTRAINT link_meters_tcpip_settings_pkey PRIMARY KEY (guid);


--
-- TOC entry 3551 (class 2606 OID 156238)
-- Name: measurement measurement_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_name_key UNIQUE (name);


--
-- TOC entry 3553 (class 2606 OID 156240)
-- Name: measurement measurement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT measurement_pkey PRIMARY KEY (guid);


--
-- TOC entry 3419 (class 2606 OID 156242)
-- Name: meters meters_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meters
    ADD CONSTRAINT meters_name_key UNIQUE (name);


--
-- TOC entry 3421 (class 2606 OID 156244)
-- Name: meters meters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meters
    ADD CONSTRAINT meters_pkey PRIMARY KEY (guid);


--
-- TOC entry 3556 (class 2606 OID 156246)
-- Name: monthly_values monthly_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_values
    ADD CONSTRAINT monthly_values_pkey PRIMARY KEY (id);


--
-- TOC entry 3426 (class 2606 OID 156248)
-- Name: names_params names_params_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.names_params
    ADD CONSTRAINT names_params_name_key UNIQUE (name);


--
-- TOC entry 3428 (class 2606 OID 156250)
-- Name: names_params names_params_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.names_params
    ADD CONSTRAINT names_params_pkey PRIMARY KEY (guid);


--
-- TOC entry 3431 (class 2606 OID 156252)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (guid);


--
-- TOC entry 3436 (class 2606 OID 156254)
-- Name: params params_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_pkey PRIMARY KEY (guid);


--
-- TOC entry 3558 (class 2606 OID 156256)
-- Name: product_coefficients_kilns product_coefficients_kilns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_coefficients_kilns
    ADD CONSTRAINT product_coefficients_kilns_pkey PRIMARY KEY (id);


--
-- TOC entry 3560 (class 2606 OID 156258)
-- Name: product_info_kilns product_info_kilns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_info_kilns
    ADD CONSTRAINT product_info_kilns_pkey PRIMARY KEY (id);


--
-- TOC entry 3562 (class 2606 OID 156260)
-- Name: product_type_kilns product_type_kilns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type_kilns
    ADD CONSTRAINT product_type_kilns_pkey PRIMARY KEY (id);


--
-- TOC entry 3580 (class 2606 OID 174768)
-- Name: report_configs report_configs_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_configs
    ADD CONSTRAINT report_configs_number_key UNIQUE (number);


--
-- TOC entry 3582 (class 2606 OID 174766)
-- Name: report_configs report_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_configs
    ADD CONSTRAINT report_configs_pkey PRIMARY KEY (guid);


--
-- TOC entry 3439 (class 2606 OID 156262)
-- Name: resources resources_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_name_key UNIQUE (name);


--
-- TOC entry 3441 (class 2606 OID 156264)
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (guid);


--
-- TOC entry 3443 (class 2606 OID 156266)
-- Name: resources resources_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_type_key UNIQUE (type);


--
-- TOC entry 3445 (class 2606 OID 156268)
-- Name: taken_params taken_params_guid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taken_params
    ADD CONSTRAINT taken_params_guid_key UNIQUE (guid);


--
-- TOC entry 3449 (class 2606 OID 156270)
-- Name: taken_params taken_params_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taken_params
    ADD CONSTRAINT taken_params_pkey PRIMARY KEY (id);


--
-- TOC entry 3522 (class 2606 OID 156272)
-- Name: tcpip_settings tcpip_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tcpip_settings
    ADD CONSTRAINT tcpip_settings_pkey PRIMARY KEY (guid);


--
-- TOC entry 3565 (class 2606 OID 156274)
-- Name: types_abonents types_abonents_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_abonents
    ADD CONSTRAINT types_abonents_name_key UNIQUE (name);


--
-- TOC entry 3567 (class 2606 OID 156276)
-- Name: types_abonents types_abonents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_abonents
    ADD CONSTRAINT types_abonents_pkey PRIMARY KEY (guid);


--
-- TOC entry 3525 (class 2606 OID 156278)
-- Name: types_meters types_meters_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_meters
    ADD CONSTRAINT types_meters_name_key UNIQUE (name);


--
-- TOC entry 3527 (class 2606 OID 156280)
-- Name: types_meters types_meters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_meters
    ADD CONSTRAINT types_meters_pkey PRIMARY KEY (guid);


--
-- TOC entry 3570 (class 2606 OID 156282)
-- Name: types_params types_params_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_params
    ADD CONSTRAINT types_params_name_key UNIQUE (name);


--
-- TOC entry 3572 (class 2606 OID 156284)
-- Name: types_params types_params_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_params
    ADD CONSTRAINT types_params_pkey PRIMARY KEY (guid);


--
-- TOC entry 3574 (class 2606 OID 156286)
-- Name: types_params types_params_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.types_params
    ADD CONSTRAINT types_params_type_key UNIQUE (type);


--
-- TOC entry 3577 (class 2606 OID 156288)
-- Name: various_values various_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.various_values
    ADD CONSTRAINT various_values_pkey PRIMARY KEY (id);


--
-- TOC entry 3407 (class 1259 OID 156289)
-- Name: abonents_guid_objects_857b0c54; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX abonents_guid_objects_857b0c54 ON public.abonents USING btree (guid_objects);


--
-- TOC entry 3408 (class 1259 OID 156290)
-- Name: abonents_guid_types_abonents_3cb64746; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX abonents_guid_types_abonents_3cb64746 ON public.abonents USING btree (guid_types_abonents);


--
-- TOC entry 3450 (class 1259 OID 156291)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 3455 (class 1259 OID 156292)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 3458 (class 1259 OID 156293)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 3461 (class 1259 OID 156294)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 3471 (class 1259 OID 156295)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 3474 (class 1259 OID 156296)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 3477 (class 1259 OID 156297)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3480 (class 1259 OID 156298)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 3468 (class 1259 OID 156299)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 3483 (class 1259 OID 156300)
-- Name: balance_groups_name_fec79ce1_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX balance_groups_name_fec79ce1_like ON public.balance_groups USING btree (name varchar_pattern_ops);


--
-- TOC entry 3488 (class 1259 OID 156301)
-- Name: comments_guid_abonents_88d2658b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_guid_abonents_88d2658b ON public.comments USING btree (guid_abonents);


--
-- TOC entry 3489 (class 1259 OID 156302)
-- Name: comments_guid_resources_db7a6865; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_guid_resources_db7a6865 ON public.comments USING btree (guid_resources);


--
-- TOC entry 3497 (class 1259 OID 156303)
-- Name: current_values_archive_id_taken_params_bd0ccaac; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX current_values_archive_id_taken_params_bd0ccaac ON public.current_values_archive USING btree (id_taken_params);


--
-- TOC entry 3494 (class 1259 OID 156304)
-- Name: current_values_id_taken_params_4e96572c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX current_values_id_taken_params_4e96572c ON public.current_values USING btree (id_taken_params);


--
-- TOC entry 3500 (class 1259 OID 156305)
-- Name: daily_values_id_taken_params_46cd62fe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX daily_values_id_taken_params_46cd62fe ON public.daily_values USING btree (id_taken_params);


--
-- TOC entry 3503 (class 1259 OID 156306)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 3506 (class 1259 OID 156307)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 3513 (class 1259 OID 156308)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 3516 (class 1259 OID 156309)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 3532 (class 1259 OID 156310)
-- Name: groups_80020_name_9883e797_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX groups_80020_name_9883e797_like ON public.groups_80020 USING btree (name varchar_pattern_ops);


--
-- TOC entry 3537 (class 1259 OID 156311)
-- Name: link_abonents_auth_user_guid_abonents_e7542feb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_abonents_auth_user_guid_abonents_e7542feb ON public.link_abonents_auth_user USING btree (guid_abonents);


--
-- TOC entry 3538 (class 1259 OID 156312)
-- Name: link_abonents_auth_user_id_auth_user_55a3894c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_abonents_auth_user_id_auth_user_55a3894c ON public.link_abonents_auth_user USING btree (id_auth_user);


--
-- TOC entry 3411 (class 1259 OID 156313)
-- Name: link_abonents_taken_params_guid_abonents_8f90a9f6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_abonents_taken_params_guid_abonents_8f90a9f6 ON public.link_abonents_taken_params USING btree (guid_abonents);


--
-- TOC entry 3412 (class 1259 OID 156314)
-- Name: link_abonents_taken_params_guid_taken_params_d65e8dfd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_abonents_taken_params_guid_taken_params_d65e8dfd ON public.link_abonents_taken_params USING btree (guid_taken_params);


--
-- TOC entry 3528 (class 1259 OID 156315)
-- Name: link_balance_groups_meters_guid_balance_groups_9b5fbaf0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_balance_groups_meters_guid_balance_groups_9b5fbaf0 ON public.link_balance_groups_meters USING btree (guid_balance_groups);


--
-- TOC entry 3529 (class 1259 OID 156316)
-- Name: link_balance_groups_meters_guid_meters_af76376b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_balance_groups_meters_guid_meters_af76376b ON public.link_balance_groups_meters USING btree (guid_meters);


--
-- TOC entry 3541 (class 1259 OID 156317)
-- Name: link_groups_80020_meters_guid_groups_80020_3d30ca82; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_groups_80020_meters_guid_groups_80020_3d30ca82 ON public.link_groups_80020_meters USING btree (guid_groups_80020);


--
-- TOC entry 3542 (class 1259 OID 156318)
-- Name: link_groups_80020_meters_guid_meters_0886dfec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_groups_80020_meters_guid_meters_0886dfec ON public.link_groups_80020_meters USING btree (guid_meters);


--
-- TOC entry 3545 (class 1259 OID 156319)
-- Name: link_meters_comport_settings_guid_comport_settings_3e64dcda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_meters_comport_settings_guid_comport_settings_3e64dcda ON public.link_meters_comport_settings USING btree (guid_comport_settings);


--
-- TOC entry 3546 (class 1259 OID 156320)
-- Name: link_meters_comport_settings_guid_meters_7e1fd04f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_meters_comport_settings_guid_meters_7e1fd04f ON public.link_meters_comport_settings USING btree (guid_meters);


--
-- TOC entry 3517 (class 1259 OID 156321)
-- Name: link_meters_tcpip_settings_guid_meters_0fc18e0c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_meters_tcpip_settings_guid_meters_0fc18e0c ON public.link_meters_tcpip_settings USING btree (guid_meters);


--
-- TOC entry 3518 (class 1259 OID 156322)
-- Name: link_meters_tcpip_settings_guid_tcpip_settings_291d1b1a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX link_meters_tcpip_settings_guid_tcpip_settings_291d1b1a ON public.link_meters_tcpip_settings USING btree (guid_tcpip_settings);


--
-- TOC entry 3549 (class 1259 OID 156323)
-- Name: measurement_name_a2c092d3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX measurement_name_a2c092d3_like ON public.measurement USING btree (name varchar_pattern_ops);


--
-- TOC entry 3415 (class 1259 OID 156324)
-- Name: meters_guid_meters_b664ab0f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX meters_guid_meters_b664ab0f ON public.meters USING btree (guid_meters);


--
-- TOC entry 3416 (class 1259 OID 156325)
-- Name: meters_guid_types_meters_ccca66f0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX meters_guid_types_meters_ccca66f0 ON public.meters USING btree (guid_types_meters);


--
-- TOC entry 3417 (class 1259 OID 156326)
-- Name: meters_name_fa91ace3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX meters_name_fa91ace3_like ON public.meters USING btree (name varchar_pattern_ops);


--
-- TOC entry 3554 (class 1259 OID 156327)
-- Name: monthly_values_id_taken_params_b6daa757; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX monthly_values_id_taken_params_b6daa757 ON public.monthly_values USING btree (id_taken_params);


--
-- TOC entry 3422 (class 1259 OID 156328)
-- Name: names_params_guid_measurement_5c6d5462; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX names_params_guid_measurement_5c6d5462 ON public.names_params USING btree (guid_measurement);


--
-- TOC entry 3423 (class 1259 OID 156329)
-- Name: names_params_guid_resources_0be997c0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX names_params_guid_resources_0be997c0 ON public.names_params USING btree (guid_resources);


--
-- TOC entry 3424 (class 1259 OID 156330)
-- Name: names_params_name_ff08829f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX names_params_name_ff08829f_like ON public.names_params USING btree (name varchar_pattern_ops);


--
-- TOC entry 3429 (class 1259 OID 156331)
-- Name: objects_guid_parent_43be664f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX objects_guid_parent_43be664f ON public.objects USING btree (guid_parent);


--
-- TOC entry 3432 (class 1259 OID 156332)
-- Name: params_guid_names_params_177a9f30; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX params_guid_names_params_177a9f30 ON public.params USING btree (guid_names_params);


--
-- TOC entry 3433 (class 1259 OID 156333)
-- Name: params_guid_types_meters_b8a8f5e5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX params_guid_types_meters_b8a8f5e5 ON public.params USING btree (guid_types_meters);


--
-- TOC entry 3434 (class 1259 OID 156334)
-- Name: params_guid_types_params_89b31bb4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX params_guid_types_params_89b31bb4 ON public.params USING btree (guid_types_params);


--
-- TOC entry 3578 (class 1259 OID 174774)
-- Name: report_configs_guid_resources_8bf85f24; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX report_configs_guid_resources_8bf85f24 ON public.report_configs USING btree (guid_resources);


--
-- TOC entry 3437 (class 1259 OID 156335)
-- Name: resources_name_52c93631_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX resources_name_52c93631_like ON public.resources USING btree (name varchar_pattern_ops);


--
-- TOC entry 3446 (class 1259 OID 156336)
-- Name: taken_params_guid_meters_c0b7fa52; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taken_params_guid_meters_c0b7fa52 ON public.taken_params USING btree (guid_meters);


--
-- TOC entry 3447 (class 1259 OID 156337)
-- Name: taken_params_guid_params_b649ce54; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taken_params_guid_params_b649ce54 ON public.taken_params USING btree (guid_params);


--
-- TOC entry 3563 (class 1259 OID 156338)
-- Name: types_abonents_name_18b2cf8f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX types_abonents_name_18b2cf8f_like ON public.types_abonents USING btree (name varchar_pattern_ops);


--
-- TOC entry 3523 (class 1259 OID 156339)
-- Name: types_meters_name_d49cb7c3_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX types_meters_name_d49cb7c3_like ON public.types_meters USING btree (name varchar_pattern_ops);


--
-- TOC entry 3568 (class 1259 OID 156340)
-- Name: types_params_name_8b31520d_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX types_params_name_8b31520d_like ON public.types_params USING btree (name varchar_pattern_ops);


--
-- TOC entry 3575 (class 1259 OID 156341)
-- Name: various_values_id_taken_params_616b065b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX various_values_id_taken_params_616b065b ON public.various_values USING btree (id_taken_params);


--
-- TOC entry 3769 (class 2618 OID 156088)
-- Name: heat_abons _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.heat_abons AS
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents
           FROM public.comments
          WHERE (comments.guid_resources = 'c0491ede-e00b-4e1d-a8ba-1ef61dba1cd3'::uuid)
          ORDER BY comments.name, comments.date DESC
        )
 SELECT z1.ab_guid,
    z1.ab_name,
    z1.obj_name,
    z1.factory_number_manual,
    z1.res_name,
    last_comment.date,
    last_comment.name,
    last_comment.comment,
    z1.account_1,
    z1.account_2,
    z1.type_meter
   FROM (( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            objects.name AS obj_name,
            meters.factory_number_manual,
            resources.name AS res_name,
            abonents.account_1,
            abonents.account_2,
            types_meters.name AS type_meter
           FROM public.abonents,
            public.objects,
            public.link_abonents_taken_params,
            public.taken_params,
            public.params,
            public.meters,
            public.names_params,
            public.resources,
            public.types_meters
          WHERE (((abonents.guid_objects)::text = (objects.guid)::text) AND ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND ((taken_params.guid_params)::text = (params.guid)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((params.guid_names_params)::text = (names_params.guid)::text) AND ((names_params.guid_resources)::text = (resources.guid)::text) AND ((resources.name)::text = 'Тепло'::text) AND (meters.guid_types_meters = types_meters.guid))
          GROUP BY abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, types_meters.name) z1
     LEFT JOIN last_comment ON (((last_comment.guid_abonents)::text = (z1.ab_guid)::text)));


--
-- TOC entry 3774 (class 2618 OID 199352)
-- Name: electric_abons_2 _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.electric_abons_2 AS
 WITH last_comment AS (
         SELECT DISTINCT ON (comments.name) comments.date,
            comments.name,
            comments.comment,
            comments.guid_abonents
           FROM public.comments
        )
 SELECT z1.ab_guid,
    z1.ab_name,
    z1.obj_name,
    z1.factory_number_manual,
    z1.res_name,
    last_comment.date,
    last_comment.name,
    last_comment.comment,
    last_comment.guid_abonents,
    z1.ktt,
    z1.ktn,
    z1.a,
    z1.name_parent,
    z1.lic_num,
    z1.order_num
   FROM (( SELECT abonents.guid AS ab_guid,
            abonents.name AS ab_name,
            abonents.account_1 AS lic_num,
            abonents.account_2 AS order_num,
            objects.name AS obj_name,
            meters.factory_number_manual,
            resources.name AS res_name,
            link_abonents_taken_params.coefficient AS ktt,
            link_abonents_taken_params.coefficient_2 AS ktn,
            link_abonents_taken_params.coefficient_3 AS a,
            objects1.name AS name_parent
           FROM public.objects objects1,
            public.abonents,
            public.objects,
            public.link_abonents_taken_params,
            public.taken_params,
            public.params,
            public.meters,
            public.names_params,
            public.resources
          WHERE (((objects.guid_parent)::text = (objects1.guid)::text) AND ((abonents.guid_objects)::text = (objects.guid)::text) AND ((link_abonents_taken_params.guid_abonents)::text = (abonents.guid)::text) AND ((link_abonents_taken_params.guid_taken_params)::text = (taken_params.guid)::text) AND ((taken_params.guid_params)::text = (params.guid)::text) AND ((taken_params.guid_meters)::text = (meters.guid)::text) AND ((params.guid_names_params)::text = (names_params.guid)::text) AND ((names_params.guid_resources)::text = (resources.guid)::text) AND ((resources.name)::text = 'Электричество'::text))
          GROUP BY abonents.account_1, objects1.name, abonents.guid, abonents.name, objects.name, meters.factory_number_manual, resources.name, link_abonents_taken_params.coefficient, link_abonents_taken_params.coefficient_2, link_abonents_taken_params.coefficient_3
          ORDER BY abonents.name) z1
     LEFT JOIN last_comment ON (((last_comment.guid_abonents)::text = (z1.ab_guid)::text)));


--
-- TOC entry 3583 (class 2606 OID 156343)
-- Name: abonents abonents_guid_objects_857b0c54_fk_objects_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abonents
    ADD CONSTRAINT abonents_guid_objects_857b0c54_fk_objects_guid FOREIGN KEY (guid_objects) REFERENCES public.objects(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3584 (class 2606 OID 156348)
-- Name: abonents abonents_guid_types_abonents_3cb64746_fk_types_abonents_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abonents
    ADD CONSTRAINT abonents_guid_types_abonents_3cb64746_fk_types_abonents_guid FOREIGN KEY (guid_types_abonents) REFERENCES public.types_abonents(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3597 (class 2606 OID 156353)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3598 (class 2606 OID 156358)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3599 (class 2606 OID 156363)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3600 (class 2606 OID 156368)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3601 (class 2606 OID 156373)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3602 (class 2606 OID 156378)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3603 (class 2606 OID 156383)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3604 (class 2606 OID 156388)
-- Name: comments comments_guid_abonents_88d2658b_fk_abonents_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_guid_abonents_88d2658b_fk_abonents_guid FOREIGN KEY (guid_abonents) REFERENCES public.abonents(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3605 (class 2606 OID 156393)
-- Name: comments comments_guid_resources_db7a6865_fk_resources_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_guid_resources_db7a6865_fk_resources_guid FOREIGN KEY (guid_resources) REFERENCES public.resources(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3607 (class 2606 OID 156398)
-- Name: current_values_archive current_values_archi_id_taken_params_bd0ccaac_fk_taken_par; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_values_archive
    ADD CONSTRAINT current_values_archi_id_taken_params_bd0ccaac_fk_taken_par FOREIGN KEY (id_taken_params) REFERENCES public.taken_params(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3606 (class 2606 OID 156403)
-- Name: current_values current_values_id_taken_params_4e96572c_fk_taken_params_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_values
    ADD CONSTRAINT current_values_id_taken_params_4e96572c_fk_taken_params_id FOREIGN KEY (id_taken_params) REFERENCES public.taken_params(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3608 (class 2606 OID 156408)
-- Name: daily_values daily_values_id_taken_params_46cd62fe_fk_taken_params_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.daily_values
    ADD CONSTRAINT daily_values_id_taken_params_46cd62fe_fk_taken_params_id FOREIGN KEY (id_taken_params) REFERENCES public.taken_params(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3609 (class 2606 OID 156413)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3610 (class 2606 OID 156418)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3615 (class 2606 OID 156423)
-- Name: link_abonents_auth_user link_abonents_auth_user_guid_abonents_e7542feb_fk_abonents_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_abonents_auth_user
    ADD CONSTRAINT link_abonents_auth_user_guid_abonents_e7542feb_fk_abonents_guid FOREIGN KEY (guid_abonents) REFERENCES public.abonents(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3616 (class 2606 OID 156428)
-- Name: link_abonents_auth_user link_abonents_auth_user_id_auth_user_55a3894c_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_abonents_auth_user
    ADD CONSTRAINT link_abonents_auth_user_id_auth_user_55a3894c_fk_auth_user_id FOREIGN KEY (id_auth_user) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3585 (class 2606 OID 156433)
-- Name: link_abonents_taken_params link_abonents_taken__guid_abonents_8f90a9f6_fk_abonents_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_abonents_taken_params
    ADD CONSTRAINT link_abonents_taken__guid_abonents_8f90a9f6_fk_abonents_ FOREIGN KEY (guid_abonents) REFERENCES public.abonents(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3586 (class 2606 OID 156438)
-- Name: link_abonents_taken_params link_abonents_taken__guid_taken_params_d65e8dfd_fk_taken_par; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_abonents_taken_params
    ADD CONSTRAINT link_abonents_taken__guid_taken_params_d65e8dfd_fk_taken_par FOREIGN KEY (guid_taken_params) REFERENCES public.taken_params(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3613 (class 2606 OID 156443)
-- Name: link_balance_groups_meters link_balance_groups__guid_balance_groups_9b5fbaf0_fk_balance_g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_balance_groups_meters
    ADD CONSTRAINT link_balance_groups__guid_balance_groups_9b5fbaf0_fk_balance_g FOREIGN KEY (guid_balance_groups) REFERENCES public.balance_groups(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3614 (class 2606 OID 156448)
-- Name: link_balance_groups_meters link_balance_groups_meters_guid_meters_af76376b_fk_meters_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_balance_groups_meters
    ADD CONSTRAINT link_balance_groups_meters_guid_meters_af76376b_fk_meters_guid FOREIGN KEY (guid_meters) REFERENCES public.meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3617 (class 2606 OID 156453)
-- Name: link_groups_80020_meters link_groups_80020_me_guid_groups_80020_3d30ca82_fk_groups_80; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_groups_80020_meters
    ADD CONSTRAINT link_groups_80020_me_guid_groups_80020_3d30ca82_fk_groups_80 FOREIGN KEY (guid_groups_80020) REFERENCES public.groups_80020(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3618 (class 2606 OID 156458)
-- Name: link_groups_80020_meters link_groups_80020_meters_guid_meters_0886dfec_fk_meters_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_groups_80020_meters
    ADD CONSTRAINT link_groups_80020_meters_guid_meters_0886dfec_fk_meters_guid FOREIGN KEY (guid_meters) REFERENCES public.meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3619 (class 2606 OID 156463)
-- Name: link_meters_comport_settings link_meters_comport__guid_comport_setting_3e64dcda_fk_comport_s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_meters_comport_settings
    ADD CONSTRAINT link_meters_comport__guid_comport_setting_3e64dcda_fk_comport_s FOREIGN KEY (guid_comport_settings) REFERENCES public.comport_settings(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3620 (class 2606 OID 156468)
-- Name: link_meters_comport_settings link_meters_comport__guid_meters_7e1fd04f_fk_meters_gu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_meters_comport_settings
    ADD CONSTRAINT link_meters_comport__guid_meters_7e1fd04f_fk_meters_gu FOREIGN KEY (guid_meters) REFERENCES public.meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3611 (class 2606 OID 156473)
-- Name: link_meters_tcpip_settings link_meters_tcpip_se_guid_tcpip_settings_291d1b1a_fk_tcpip_set; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_meters_tcpip_settings
    ADD CONSTRAINT link_meters_tcpip_se_guid_tcpip_settings_291d1b1a_fk_tcpip_set FOREIGN KEY (guid_tcpip_settings) REFERENCES public.tcpip_settings(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3612 (class 2606 OID 156478)
-- Name: link_meters_tcpip_settings link_meters_tcpip_settings_guid_meters_0fc18e0c_fk_meters_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link_meters_tcpip_settings
    ADD CONSTRAINT link_meters_tcpip_settings_guid_meters_0fc18e0c_fk_meters_guid FOREIGN KEY (guid_meters) REFERENCES public.meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3587 (class 2606 OID 156483)
-- Name: meters meters_guid_meters_b664ab0f_fk_meters_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meters
    ADD CONSTRAINT meters_guid_meters_b664ab0f_fk_meters_guid FOREIGN KEY (guid_meters) REFERENCES public.meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3588 (class 2606 OID 156488)
-- Name: meters meters_guid_types_meters_ccca66f0_fk_types_meters_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meters
    ADD CONSTRAINT meters_guid_types_meters_ccca66f0_fk_types_meters_guid FOREIGN KEY (guid_types_meters) REFERENCES public.types_meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3621 (class 2606 OID 156493)
-- Name: monthly_values monthly_values_id_taken_params_b6daa757_fk_taken_params_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monthly_values
    ADD CONSTRAINT monthly_values_id_taken_params_b6daa757_fk_taken_params_id FOREIGN KEY (id_taken_params) REFERENCES public.taken_params(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3589 (class 2606 OID 156498)
-- Name: names_params names_params_guid_measurement_5c6d5462_fk_measurement_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.names_params
    ADD CONSTRAINT names_params_guid_measurement_5c6d5462_fk_measurement_guid FOREIGN KEY (guid_measurement) REFERENCES public.measurement(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3590 (class 2606 OID 156503)
-- Name: names_params names_params_guid_resources_0be997c0_fk_resources_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.names_params
    ADD CONSTRAINT names_params_guid_resources_0be997c0_fk_resources_guid FOREIGN KEY (guid_resources) REFERENCES public.resources(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3591 (class 2606 OID 156508)
-- Name: objects objects_guid_parent_43be664f_fk_objects_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objects
    ADD CONSTRAINT objects_guid_parent_43be664f_fk_objects_guid FOREIGN KEY (guid_parent) REFERENCES public.objects(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3592 (class 2606 OID 156513)
-- Name: params params_guid_names_params_177a9f30_fk_names_params_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_guid_names_params_177a9f30_fk_names_params_guid FOREIGN KEY (guid_names_params) REFERENCES public.names_params(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3593 (class 2606 OID 156518)
-- Name: params params_guid_types_meters_b8a8f5e5_fk_types_meters_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_guid_types_meters_b8a8f5e5_fk_types_meters_guid FOREIGN KEY (guid_types_meters) REFERENCES public.types_meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3594 (class 2606 OID 156523)
-- Name: params params_guid_types_params_89b31bb4_fk_types_params_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_guid_types_params_89b31bb4_fk_types_params_guid FOREIGN KEY (guid_types_params) REFERENCES public.types_params(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3623 (class 2606 OID 174769)
-- Name: report_configs report_configs_guid_resources_8bf85f24_fk_resources_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_configs
    ADD CONSTRAINT report_configs_guid_resources_8bf85f24_fk_resources_guid FOREIGN KEY (guid_resources) REFERENCES public.resources(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3595 (class 2606 OID 156528)
-- Name: taken_params taken_params_guid_meters_c0b7fa52_fk_meters_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taken_params
    ADD CONSTRAINT taken_params_guid_meters_c0b7fa52_fk_meters_guid FOREIGN KEY (guid_meters) REFERENCES public.meters(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3596 (class 2606 OID 156533)
-- Name: taken_params taken_params_guid_params_b649ce54_fk_params_guid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taken_params
    ADD CONSTRAINT taken_params_guid_params_b649ce54_fk_params_guid FOREIGN KEY (guid_params) REFERENCES public.params(guid) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3622 (class 2606 OID 156538)
-- Name: various_values various_values_id_taken_params_616b065b_fk_taken_params_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.various_values
    ADD CONSTRAINT various_values_id_taken_params_616b065b_fk_taken_params_id FOREIGN KEY (id_taken_params) REFERENCES public.taken_params(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-09-30 00:47:36

--
-- PostgreSQL database dump complete
--

