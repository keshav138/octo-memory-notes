--
-- PostgreSQL database dump
--

\restrict eearibwbhtzfyzY7ZoKWoQSsvacTBdCCE5GmfHFou08edJBWLGpZgVMr1kVC3gQ

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.token_blacklist_outstandingtoken DROP CONSTRAINT IF EXISTS token_blacklist_outs_user_id_83bc629a_fk_auth_user;
ALTER TABLE IF EXISTS ONLY public.token_blacklist_blacklistedtoken DROP CONSTRAINT IF EXISTS token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk;
ALTER TABLE IF EXISTS ONLY public.tasks_task DROP CONSTRAINT IF EXISTS tasks_task_project_id_a2815f0c_fk_tasks_project_id;
ALTER TABLE IF EXISTS ONLY public.tasks_task DROP CONSTRAINT IF EXISTS tasks_task_created_by_id_1345568a_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.tasks_task DROP CONSTRAINT IF EXISTS tasks_task_assigned_to_id_e8821f61_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.tasks_project_team_members DROP CONSTRAINT IF EXISTS tasks_project_team_members_user_id_5e8f8768_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.tasks_project_team_members DROP CONSTRAINT IF EXISTS tasks_project_team_m_project_id_c2108215_fk_tasks_pro;
ALTER TABLE IF EXISTS ONLY public.tasks_project DROP CONSTRAINT IF EXISTS tasks_project_created_by_id_91543690_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.tasks_notification DROP CONSTRAINT IF EXISTS tasks_notifications_recipient_id_df5633b7_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.tasks_notification DROP CONSTRAINT IF EXISTS tasks_notification_task_id_0e908a3c_fk_tasks_task_id;
ALTER TABLE IF EXISTS ONLY public.tasks_comment DROP CONSTRAINT IF EXISTS tasks_comment_user_id_13cb3eb1_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.tasks_comment DROP CONSTRAINT IF EXISTS tasks_comment_task_id_8e8bc4fe_fk_tasks_task_id;
ALTER TABLE IF EXISTS ONLY public.tasks_activity DROP CONSTRAINT IF EXISTS tasks_activity_user_id_5050826c_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.tasks_activity DROP CONSTRAINT IF EXISTS tasks_activity_project_id_615af84d_fk_tasks_project_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_group_id_97559544_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
DROP INDEX IF EXISTS public.token_blacklist_outstandingtoken_user_id_83bc629a;
DROP INDEX IF EXISTS public.token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_like;
DROP INDEX IF EXISTS public.tasks_task_project_id_a2815f0c;
DROP INDEX IF EXISTS public.tasks_task_created_by_id_1345568a;
DROP INDEX IF EXISTS public.tasks_task_assigned_to_id_e8821f61;
DROP INDEX IF EXISTS public.tasks_project_team_members_user_id_5e8f8768;
DROP INDEX IF EXISTS public.tasks_project_team_members_project_id_c2108215;
DROP INDEX IF EXISTS public.tasks_project_created_by_id_91543690;
DROP INDEX IF EXISTS public.tasks_notifications_recipient_id_df5633b7;
DROP INDEX IF EXISTS public.tasks_notification_task_id_0e908a3c;
DROP INDEX IF EXISTS public.tasks_comment_user_id_13cb3eb1;
DROP INDEX IF EXISTS public.tasks_comment_task_id_8e8bc4fe;
DROP INDEX IF EXISTS public.tasks_activity_user_id_5050826c;
DROP INDEX IF EXISTS public.tasks_activity_project_id_615af84d;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.auth_user_username_6821ab7c_like;
DROP INDEX IF EXISTS public.auth_user_user_permissions_user_id_a95ead1b;
DROP INDEX IF EXISTS public.auth_user_user_permissions_permission_id_1fbb5f2c;
DROP INDEX IF EXISTS public.auth_user_groups_user_id_6a12ed8b;
DROP INDEX IF EXISTS public.auth_user_groups_group_id_97559544;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
ALTER TABLE IF EXISTS ONLY public.token_blacklist_outstandingtoken DROP CONSTRAINT IF EXISTS token_blacklist_outstandingtoken_pkey;
ALTER TABLE IF EXISTS ONLY public.token_blacklist_outstandingtoken DROP CONSTRAINT IF EXISTS token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq;
ALTER TABLE IF EXISTS ONLY public.token_blacklist_blacklistedtoken DROP CONSTRAINT IF EXISTS token_blacklist_blacklistedtoken_token_id_key;
ALTER TABLE IF EXISTS ONLY public.token_blacklist_blacklistedtoken DROP CONSTRAINT IF EXISTS token_blacklist_blacklistedtoken_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks_task DROP CONSTRAINT IF EXISTS tasks_task_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks_project_team_members DROP CONSTRAINT IF EXISTS tasks_project_team_members_project_id_user_id_74e6a210_uniq;
ALTER TABLE IF EXISTS ONLY public.tasks_project_team_members DROP CONSTRAINT IF EXISTS tasks_project_team_members_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks_project DROP CONSTRAINT IF EXISTS tasks_project_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks_notification DROP CONSTRAINT IF EXISTS tasks_notifications_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks_comment DROP CONSTRAINT IF EXISTS tasks_comment_pkey;
ALTER TABLE IF EXISTS ONLY public.tasks_activity DROP CONSTRAINT IF EXISTS tasks_activity_pkey;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_username_key;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_group_id_94350c0c_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
DROP TABLE IF EXISTS public.token_blacklist_outstandingtoken;
DROP TABLE IF EXISTS public.token_blacklist_blacklistedtoken;
DROP TABLE IF EXISTS public.tasks_task;
DROP TABLE IF EXISTS public.tasks_project_team_members;
DROP TABLE IF EXISTS public.tasks_project;
DROP TABLE IF EXISTS public.tasks_notification;
DROP TABLE IF EXISTS public.tasks_comment;
DROP TABLE IF EXISTS public.tasks_activity;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP TABLE IF EXISTS public.auth_user_user_permissions;
DROP TABLE IF EXISTS public.auth_user_groups;
DROP TABLE IF EXISTS public.auth_user;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
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
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
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
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
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
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: tasks_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks_activity (
    id bigint NOT NULL,
    action character varying(200) NOT NULL,
    details text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    project_id bigint NOT NULL
);


ALTER TABLE public.tasks_activity OWNER TO postgres;

--
-- Name: tasks_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tasks_activity ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tasks_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tasks_comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks_comment (
    id bigint NOT NULL,
    text text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    task_id bigint NOT NULL
);


ALTER TABLE public.tasks_comment OWNER TO postgres;

--
-- Name: tasks_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tasks_comment ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tasks_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tasks_notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks_notification (
    id bigint CONSTRAINT tasks_notifications_id_not_null NOT NULL,
    message character varying(256) CONSTRAINT tasks_notifications_message_not_null NOT NULL,
    is_read boolean CONSTRAINT tasks_notifications_is_read_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT tasks_notifications_created_at_not_null NOT NULL,
    recipient_id integer CONSTRAINT tasks_notifications_recipient_id_not_null NOT NULL,
    task_id bigint
);


ALTER TABLE public.tasks_notification OWNER TO postgres;

--
-- Name: tasks_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tasks_notification ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tasks_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tasks_project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks_project (
    id bigint NOT NULL,
    project_name character varying(200) NOT NULL,
    description text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_by_id integer NOT NULL
);


ALTER TABLE public.tasks_project OWNER TO postgres;

--
-- Name: tasks_project_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tasks_project ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tasks_project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tasks_project_team_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks_project_team_members (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.tasks_project_team_members OWNER TO postgres;

--
-- Name: tasks_project_team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tasks_project_team_members ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tasks_project_team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tasks_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks_task (
    id bigint NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    status character varying(20) NOT NULL,
    priority character varying(20) NOT NULL,
    due_date timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    assigned_to_id integer,
    created_by_id integer NOT NULL,
    project_id bigint NOT NULL
);


ALTER TABLE public.tasks_task OWNER TO postgres;

--
-- Name: tasks_task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tasks_task ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.tasks_task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: token_blacklist_blacklistedtoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token_blacklist_blacklistedtoken (
    id bigint NOT NULL,
    blacklisted_at timestamp with time zone NOT NULL,
    token_id bigint NOT NULL
);


ALTER TABLE public.token_blacklist_blacklistedtoken OWNER TO postgres;

--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.token_blacklist_blacklistedtoken ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.token_blacklist_blacklistedtoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: token_blacklist_outstandingtoken; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token_blacklist_outstandingtoken (
    id bigint NOT NULL,
    token text NOT NULL,
    created_at timestamp with time zone,
    expires_at timestamp with time zone NOT NULL,
    user_id integer,
    jti character varying(255) CONSTRAINT token_blacklist_outstandingtoken_jti_hex_not_null NOT NULL
);


ALTER TABLE public.token_blacklist_outstandingtoken OWNER TO postgres;

--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.token_blacklist_outstandingtoken ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.token_blacklist_outstandingtoken_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	3	add_permission
6	Can change permission	3	change_permission
7	Can delete permission	3	delete_permission
8	Can view permission	3	view_permission
9	Can add group	2	add_group
10	Can change group	2	change_group
11	Can delete group	2	delete_group
12	Can view group	2	view_group
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
25	Can add activity	7	add_activity
26	Can change activity	7	change_activity
27	Can delete activity	7	delete_activity
28	Can view activity	7	view_activity
29	Can add task	10	add_task
30	Can change task	10	change_task
31	Can delete task	10	delete_task
32	Can view task	10	view_task
33	Can add project	9	add_project
34	Can change project	9	change_project
35	Can delete project	9	delete_project
36	Can view project	9	view_project
37	Can add comment	8	add_comment
38	Can change comment	8	change_comment
39	Can delete comment	8	delete_comment
40	Can view comment	8	view_comment
41	Can add Blacklisted Token	11	add_blacklistedtoken
42	Can change Blacklisted Token	11	change_blacklistedtoken
43	Can delete Blacklisted Token	11	delete_blacklistedtoken
44	Can view Blacklisted Token	11	view_blacklistedtoken
45	Can add Outstanding Token	12	add_outstandingtoken
46	Can change Outstanding Token	12	change_outstandingtoken
47	Can delete Outstanding Token	12	delete_outstandingtoken
48	Can view Outstanding Token	12	view_outstandingtoken
49	Can add notifications	13	add_notifications
50	Can change notifications	13	change_notifications
51	Can delete notifications	13	delete_notifications
52	Can view notifications	13	view_notifications
53	Can add notification	13	add_notification
54	Can change notification	13	change_notification
55	Can delete notification	13	delete_notification
56	Can view notification	13	view_notification
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$1200000$PASGGT1CBHSmAU691opOdx$SXYoifxTYX0g+CAzhdn04YcSHZvEnNpTLRXP3polWZ0=	2026-02-24 23:10:00.358265+05:30	t	keshav			keshavrajmaiya@gmail.com	t	t	2026-02-15 17:09:46.900037+05:30
11	pbkdf2_sha256$1200000$zewhLwbYSkPGB1RjTd7WK8$Vk5wNdhcOavahLHiwwkaTa8RSAT1kUJTpWQH7GSIxbE=	\N	f	alice	Alice	Johnson	alice@test.com	f	t	2026-02-24 23:40:57.233983+05:30
12	pbkdf2_sha256$1200000$yq4gvF9TokXx7utwstda2R$Xo3yHfhuYczj9A6LLpb0FimpP9q+meOtf6CAFzmD3Ac=	\N	f	bob	Bob	Smith	bob@test.com	f	t	2026-02-24 23:40:58.567889+05:30
13	pbkdf2_sha256$1200000$ScF8ZiFT1fJ174zn5yLQk2$5N2XEm1Y4ak6uhdyo7x7Pxo5rusTknAtJl3/5py9+jc=	\N	f	charlie	Charlie	Brown	charlie@test.com	f	t	2026-02-24 23:40:59.854281+05:30
14	pbkdf2_sha256$1200000$1Nuq60rdqU8MoQCd53TDou$2aLTbWiEO3wd1+ZsewIRWb5SovYGaHWMtY0sATxFhKQ=	\N	f	diana	Diana	Williams	diana@test.com	f	t	2026-02-24 23:41:01.47691+05:30
15	pbkdf2_sha256$1200000$k5utQFoH31NKv1uTspCSQ1$9jUhNmXNGV9ImeyS6Nm/zf3J6FvBlvHv8ZzVe21AS80=	\N	f	eve	Eve	Davis	eve@test.com	f	t	2026-02-24 23:41:03.097953+05:30
16	pbkdf2_sha256$1200000$j0g8e5whAeAQTJQrxFklcW$NBe8RZvNtzSXCf6heTOfQb48CmlZiqW9YDchZrIsmtU=	\N	f	raghav	raghav	sharma	raghav@gmail.com	f	t	2026-02-26 01:43:51.121062+05:30
17	pbkdf2_sha256$1200000$0y3oZUY5Wzvq5cuWfOfxjI$WSaRM/jpyDO2aG/9XZsYkoHIk9f7hn+HFmfGh+7i5vY=	\N	f	sweety	sweety	singhania	swetty@gmail.com	f	t	2026-02-26 02:01:44.11539+05:30
18	pbkdf2_sha256$1200000$dzbt8ECzTNF7nIYqap5QZX$A44CiHxVjfVllc55OK34PET0d+w85HX4Me/fnjEEKLg=	\N	f	Savant	Savant	Jena	savant@gmail.com	f	t	2026-02-26 10:49:00.334925+05:30
19	pbkdf2_sha256$1200000$KQnx4PQ7h3Xfe2hh5KTIcb$joHcZQfBWqtcj0Xxnhkjj05bVvzjZv66FbdIM0jPv9o=	\N	f	Rishabh	Rishabh	Gupta	rishabhgupta@gmail.com	f	t	2026-02-26 13:19:26.68448+05:30
20	pbkdf2_sha256$1200000$NrMw0Otv7Lx8QT7sJbBu9J$9RGqn6ki6+POVw0DQjlXqDTwoa5oufZCs7MA7GEZbrQ=	\N	f	Yuvraj	Yuvraj	Pahwa	yuvraj@gmail.com	f	t	2026-02-26 13:40:37.852558+05:30
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2026-02-19 10:21:35.088069+05:30	2	balerion	1	[{"added": {}}]	4	1
2	2026-02-19 10:23:26.920315+05:30	3	meraxes	1	[{"added": {}}]	4	1
3	2026-02-19 10:24:23.288933+05:30	4	vhagar	1	[{"added": {}}]	4	1
4	2026-02-19 10:24:48.388082+05:30	5	vermithor	1	[{"added": {}}]	4	1
5	2026-02-19 10:25:33.257422+05:30	6	silverwing	1	[{"added": {}}]	4	1
6	2026-02-19 10:25:55.135017+05:30	7	dreamfyre	1	[{"added": {}}]	4	1
7	2026-02-19 10:27:40.445434+05:30	1	Website Redesign	1	[{"added": {}}]	9	1
8	2026-02-19 10:28:12.933286+05:30	2	Mobile App	1	[{"added": {}}]	9	1
9	2026-02-19 10:30:57.037244+05:30	1	Design Homepage - Website Redesign	1	[{"added": {}}]	10	1
10	2026-02-19 10:32:04.219696+05:30	2	Write API Docs - Website Redesign	1	[{"added": {}}]	10	1
11	2026-02-19 10:32:55.313986+05:30	3	Setup Database - Website Redesign	1	[{"added": {}}]	10	1
12	2026-02-19 10:33:22.815064+05:30	4	Create Wireframes - Mobile App	1	[{"added": {}}]	10	1
13	2026-02-19 10:34:11.437095+05:30	1	Comment by keshav on Design Homepage	1	[{"added": {}}]	8	1
14	2026-02-19 10:34:19.681355+05:30	2	Comment by keshav on Setup Database	1	[{"added": {}}]	8	1
15	2026-02-19 10:34:40.273723+05:30	3	Comment by meraxes on Write API Docs	1	[{"added": {}}]	8	1
16	2026-02-19 11:29:02.361336+05:30	5	Test task overdue - test_save	1	[{"added": {}}]	10	1
17	2026-02-19 13:01:50.654135+05:30	3	test_save	3		9	1
18	2026-02-19 13:02:16.651694+05:30	4	test_project	1	[{"added": {}}]	9	1
19	2026-02-19 13:25:09.988108+05:30	6	test3	1	[{"added": {}}]	9	1
20	2026-02-19 13:35:32.937869+05:30	7	test4	3		9	1
21	2026-02-19 13:35:32.937934+05:30	6	test3	3		9	1
22	2026-02-19 13:35:32.93796+05:30	5	test2	3		9	1
23	2026-02-19 13:35:32.937982+05:30	4	test_project	3		9	1
24	2026-02-19 13:35:43.299498+05:30	8	test	1	[{"added": {}}]	9	1
25	2026-02-19 13:40:18.482715+05:30	9	test2	1	[{"added": {}}]	9	1
26	2026-02-19 13:51:41.576813+05:30	9	test2	3		9	1
27	2026-02-19 13:51:41.576884+05:30	8	test	3		9	1
28	2026-02-19 13:51:50.287092+05:30	10	test	1	[{"added": {}}]	9	1
29	2026-02-19 13:56:16.901211+05:30	11	test2	1	[{"added": {}}]	9	1
30	2026-02-19 14:04:50.888398+05:30	12	test3	1	[{"added": {}}]	9	1
31	2026-02-19 14:10:47.529304+05:30	13	Test Project	3		9	1
32	2026-02-19 14:10:47.529387+05:30	12	test3	3		9	1
33	2026-02-19 14:10:47.529423+05:30	11	test2	3		9	1
34	2026-02-19 14:10:47.529454+05:30	10	test	3		9	1
35	2026-02-19 14:13:44.191833+05:30	14	Test Project	1	[{"added": {}}]	9	1
36	2026-02-20 19:01:36.421075+05:30	2	balerion	2	[{"changed": {"fields": ["password"]}}]	4	1
37	2026-02-22 10:38:46.625512+05:30	2	Mobile App	2	[{"changed": {"fields": ["Team members"]}}]	9	1
38	2026-02-22 10:38:54.091084+05:30	1	Website Redesign	2	[{"changed": {"fields": ["Team members"]}}]	9	1
39	2026-02-22 18:33:54.76074+05:30	4	vhagar	2	[{"changed": {"fields": ["password"]}}]	4	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	tasks	activity
8	tasks	comment
9	tasks	project
10	tasks	task
11	token_blacklist	blacklistedtoken
12	token_blacklist	outstandingtoken
13	tasks	notification
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-02-15 17:09:03.820737+05:30
2	auth	0001_initial	2026-02-15 17:09:03.953282+05:30
3	admin	0001_initial	2026-02-15 17:09:03.986024+05:30
4	admin	0002_logentry_remove_auto_add	2026-02-15 17:09:03.99481+05:30
5	admin	0003_logentry_add_action_flag_choices	2026-02-15 17:09:04.003502+05:30
6	contenttypes	0002_remove_content_type_name	2026-02-15 17:09:04.022494+05:30
7	auth	0002_alter_permission_name_max_length	2026-02-15 17:09:04.033396+05:30
8	auth	0003_alter_user_email_max_length	2026-02-15 17:09:04.044126+05:30
9	auth	0004_alter_user_username_opts	2026-02-15 17:09:04.05314+05:30
10	auth	0005_alter_user_last_login_null	2026-02-15 17:09:04.062551+05:30
11	auth	0006_require_contenttypes_0002	2026-02-15 17:09:04.064365+05:30
12	auth	0007_alter_validators_add_error_messages	2026-02-15 17:09:04.073152+05:30
13	auth	0008_alter_user_username_max_length	2026-02-15 17:09:04.088884+05:30
14	auth	0009_alter_user_last_name_max_length	2026-02-15 17:09:04.098395+05:30
15	auth	0010_alter_group_name_max_length	2026-02-15 17:09:04.109318+05:30
16	auth	0011_update_proxy_permissions	2026-02-15 17:09:04.116968+05:30
17	auth	0012_alter_user_first_name_max_length	2026-02-15 17:09:04.124121+05:30
18	sessions	0001_initial	2026-02-15 17:09:04.140285+05:30
19	tasks	0001_initial	2026-02-19 09:56:49.375491+05:30
20	tasks	0002_alter_task_assigned_to	2026-02-20 18:31:18.437759+05:30
21	token_blacklist	0001_initial	2026-02-20 18:31:18.756971+05:30
22	token_blacklist	0002_outstandingtoken_jti_hex	2026-02-20 18:31:18.787912+05:30
23	token_blacklist	0003_auto_20171017_2007	2026-02-20 18:31:18.830743+05:30
24	token_blacklist	0004_auto_20171017_2013	2026-02-20 18:31:18.885952+05:30
25	token_blacklist	0005_remove_outstandingtoken_jti	2026-02-20 18:31:18.932928+05:30
26	token_blacklist	0006_auto_20171017_2113	2026-02-20 18:31:18.970614+05:30
27	token_blacklist	0007_auto_20171017_2214	2026-02-20 18:31:19.122514+05:30
28	token_blacklist	0008_migrate_to_bigautofield	2026-02-20 18:31:19.225198+05:30
29	token_blacklist	0010_fix_migrate_to_bigautofield	2026-02-20 18:31:19.286871+05:30
30	token_blacklist	0011_linearizes_history	2026-02-20 18:31:19.289923+05:30
31	token_blacklist	0012_alter_outstandingtoken_user	2026-02-20 18:31:19.307242+05:30
32	token_blacklist	0013_alter_blacklistedtoken_options_and_more	2026-02-20 18:31:19.335556+05:30
33	tasks	0003_alter_task_status	2026-02-22 17:18:57.481666+05:30
34	tasks	0004_notifications	2026-03-05 22:24:36.580533+05:30
35	tasks	0005_rename_notifications_notification_and_more	2026-03-06 23:09:54.840819+05:30
36	tasks	0006_notification_task	2026-03-07 11:01:46.892597+05:30
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
j7hsgy1300npyr07zvwb1z06dtd68w8c	.eJxVjEsOAiEQBe_C2pDm1xCX7j0DaWiUUQPJMLMy3t2QzEK3r6reW0Tatxr3Uda4sDgLJU6_W6L8LG0CflC7d5l729YlyanIgw557Vxel8P9O6g06qw9BBcKIDhGR541KWMJrc2QTcGsPZgEQSPeklI2KU6BvXHElimz-HwBxU43tA:1vraU1:ZhrB0nDTfVTW7ugcKGbTyjQreIwdu9nlIymX2a0lF9w	2026-03-01 17:10:13.710194+05:30
3qljzkv0od2xn990pblbvkk2hcbsgd16	.eJxVjEsOAiEQBe_C2pDm1xCX7j0DaWiUUQPJMLMy3t2QzEK3r6reW0Tatxr3Uda4sDgLJU6_W6L8LG0CflC7d5l729YlyanIgw557Vxel8P9O6g06qw9BBcKIDhGR541KWMJrc2QTcGsPZgEQSPeklI2KU6BvXHElimz-HwBxU43tA:1vtQbY:0XpBvijtGA5RV7waIr-kFCzUzCrU10KtbHIf2Pd6f2c	2026-03-06 19:01:36.434691+05:30
6bj0hrwaldtc8mdwc5512egchg3iaqe3	.eJxVjEsOAiEQBe_C2pDm1xCX7j0DaWiUUQPJMLMy3t2QzEK3r6reW0Tatxr3Uda4sDgLJU6_W6L8LG0CflC7d5l729YlyanIgw557Vxel8P9O6g06qw9BBcKIDhGR541KWMJrc2QTcGsPZgEQSPeklI2KU6BvXHElimz-HwBxU43tA:1vu97q:e6ErChluOjb9iY5SPP98g2WLHkLxiJxDPk_i6x0bEMM	2026-03-08 18:33:54.772609+05:30
9n3vtw2qguv3veour7kxg2rc9o2rq0po	.eJxVjEsOAiEQBe_C2pDm1xCX7j0DaWiUUQPJMLMy3t2QzEK3r6reW0Tatxr3Uda4sDgLJU6_W6L8LG0CflC7d5l729YlyanIgw557Vxel8P9O6g06qw9BBcKIDhGR541KWMJrc2QTcGsPZgEQSPeklI2KU6BvXHElimz-HwBxU43tA:1vuU3D:gTvXYuK7yn_dRdSw1hCQURPKnW2deH_rZHdg77bBrwg	2026-03-09 16:54:31.854041+05:30
vquxj5f0m4hrij0j0gtkch0oqvq76viw	.eJxVjEsOAiEQBe_C2pDm1xCX7j0DaWiUUQPJMLMy3t2QzEK3r6reW0Tatxr3Uda4sDgLJU6_W6L8LG0CflC7d5l729YlyanIgw557Vxel8P9O6g06qw9BBcKIDhGR541KWMJrc2QTcGsPZgEQSPeklI2KU6BvXHElimz-HwBxU43tA:1vuwO8:Wms8wtNd06fRjLbd1CAzWIuO_IzsHoIt81nM7rHe0ZM	2026-03-10 23:10:00.36895+05:30
\.


--
-- Data for Name: tasks_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks_activity (id, action, details, "timestamp", user_id, project_id) FROM stdin;
9	created project	Project "Website Redesign" was created	2026-02-24 23:41:04.666115+05:30	11	17
10	added team member	bob was add to the project Website Redesign	2026-02-24 23:41:04.683488+05:30	11	17
11	added team member	charlie was add to the project Website Redesign	2026-02-24 23:41:04.685555+05:30	11	17
12	created project	Project "Mobile App Development" was created	2026-02-24 23:41:04.694397+05:30	12	18
13	added team member	charlie was add to the project Mobile App Development	2026-02-24 23:41:04.700654+05:30	12	18
14	added team member	diana was add to the project Mobile App Development	2026-02-24 23:41:04.702376+05:30	12	18
15	created project	Project "Marketing Campaign Q1" was created	2026-02-24 23:41:04.711148+05:30	11	19
16	added team member	diana was add to the project Marketing Campaign Q1	2026-02-24 23:41:04.716829+05:30	11	19
17	added team member	eve was add to the project Marketing Campaign Q1	2026-02-24 23:41:04.718433+05:30	11	19
18	created project	Project "Database Migration" was created	2026-02-24 23:41:04.72565+05:30	13	20
19	added team member	bob was add to the project Database Migration	2026-02-24 23:41:04.732341+05:30	13	20
20	created project	Project "Customer Portal" was created	2026-02-24 23:41:04.740432+05:30	14	21
21	added team member	alice was add to the project Customer Portal	2026-02-24 23:41:04.750082+05:30	14	21
22	added team member	eve was add to the project Customer Portal	2026-02-24 23:41:04.752913+05:30	14	21
23	created task	Task "Design Homepage Mockup" created	2026-02-24 23:41:04.799992+05:30	11	17
24	created task	Task "Implement Navigation Menu" created	2026-02-24 23:41:04.803529+05:30	11	17
25	created task	Task "Content Migration" created	2026-02-24 23:41:04.807765+05:30	12	17
26	created task	Task "SEO Optimization" created	2026-02-24 23:41:04.811655+05:30	11	17
27	created task	Task "Performance Testing" created	2026-02-24 23:41:04.814443+05:30	13	17
28	created task	Task "User Authentication Flow" created	2026-02-24 23:41:04.817073+05:30	12	18
29	created task	Task "Dashboard UI Design" created	2026-02-24 23:41:04.819189+05:30	12	18
30	created task	Task "API Integration" created	2026-02-24 23:41:04.823+05:30	13	18
31	created task	Task "Push Notifications" created	2026-02-24 23:41:04.826677+05:30	12	18
32	created task	Task "Social Media Strategy" created	2026-02-24 23:41:04.828822+05:30	11	19
33	created task	Task "Email Campaign Design" created	2026-02-24 23:41:04.83139+05:30	14	19
34	created task	Task "Landing Page Copy" created	2026-02-24 23:41:04.833643+05:30	11	19
35	created task	Task "Schema Analysis" created	2026-02-24 23:41:04.835342+05:30	13	20
36	created task	Task "Migration Script" created	2026-02-24 23:41:04.837456+05:30	13	20
37	created task	Task "Test Environment Setup" created	2026-02-24 23:41:04.840774+05:30	12	20
38	created task	Task "Ticket Submission Form" created	2026-02-24 23:41:04.843662+05:30	14	21
39	created task	Task "Ticket Status Dashboard" created	2026-02-24 23:41:04.845597+05:30	14	21
40	created task	Task "Email Notifications" created	2026-02-24 23:41:04.847288+05:30	15	21
41	added comment	Commented on task "Design Homepage Mockup"	2026-02-24 23:41:04.852045+05:30	12	17
42	added comment	Commented on task "Design Homepage Mockup"	2026-02-24 23:41:04.855279+05:30	11	17
43	added comment	Commented on task "Implement Navigation Menu"	2026-02-24 23:41:04.858186+05:30	13	17
44	added comment	Commented on task "Performance Testing"	2026-02-24 23:41:04.860959+05:30	11	17
45	added comment	Commented on task "Performance Testing"	2026-02-24 23:41:04.864175+05:30	13	17
46	added comment	Commented on task "Dashboard UI Design"	2026-02-24 23:41:04.867081+05:30	12	18
47	added comment	Commented on task "API Integration"	2026-02-24 23:41:04.870144+05:30	13	18
48	added comment	Commented on task "Social Media Strategy"	2026-02-24 23:41:04.872946+05:30	14	19
49	added comment	Commented on task "Landing Page Copy"	2026-02-24 23:41:04.876538+05:30	11	19
50	added comment	Commented on task "Migration Script"	2026-02-24 23:41:04.8789+05:30	12	20
51	created task	Task "Is this working" created	2026-02-25 00:44:55.641664+05:30	11	19
52	changed task priority	Task Is this working priority changed from MEDIUM to HIGH	2026-02-25 01:30:09.823196+05:30	11	19
53	changed task priority	Task Is this working priority changed from HIGH to MEDIUM	2026-02-25 01:39:52.166312+05:30	11	19
54	changed task priority	Task Is this working priority changed from MEDIUM to LOW	2026-02-25 01:40:03.21568+05:30	11	19
55	added comment	Commented on task "Is this working"	2026-02-25 01:41:31.146475+05:30	11	19
56	changed task status	Task Is this working status changed from IN_PROGRESS to DONE	2026-02-25 11:06:08.12018+05:30	11	19
57	deleted task	Task Content Migration was deleted	2026-02-25 11:40:43.196477+05:30	12	17
58	created task	Task "string" created	2026-02-25 13:11:17.268986+05:30	11	21
59	created task	Task "Testing Tassk" created	2026-02-25 13:29:54.476129+05:30	11	21
80	created task	Task "Admin Dashboard" created	2026-02-25 14:40:39.634272+05:30	15	21
81	created task	Task "Auto-Response Templates" created	2026-02-25 14:40:39.639912+05:30	11	21
82	added comment	Commented on task "Auto-Response Templates"	2026-02-25 14:40:39.642854+05:30	15	21
83	created task	Task "Customer Satisfaction Survey" created	2026-02-25 14:40:39.648731+05:30	14	21
84	created task	Task "User Profile Page" created	2026-02-25 14:40:39.655294+05:30	14	21
85	created task	Task "Analytics Reports" created	2026-02-25 14:40:39.661193+05:30	15	21
86	created task	Task "Knowledge Base" created	2026-02-25 14:40:39.66655+05:30	14	21
87	created task	Task "FAQ Section" created	2026-02-25 14:40:39.672382+05:30	14	21
88	created task	Task "Multi-language Support" created	2026-02-25 14:40:39.677381+05:30	14	21
89	created task	Task "Export Functionality" created	2026-02-25 14:40:39.683058+05:30	11	21
90	added comment	Commented on task "Export Functionality"	2026-02-25 14:40:39.685712+05:30	14	21
91	added comment	Commented on task "Export Functionality"	2026-02-25 14:40:39.688267+05:30	14	21
92	created task	Task "Password Reset Flow" created	2026-02-25 14:40:39.692824+05:30	15	21
93	created task	Task "Chat Widget Integration" created	2026-02-25 14:40:39.697554+05:30	11	21
94	added comment	Commented on task "Chat Widget Integration"	2026-02-25 14:40:39.69984+05:30	15	21
95	added comment	Commented on task "Chat Widget Integration"	2026-02-25 14:40:39.702046+05:30	15	21
96	created task	Task "Ticket Prioritization" created	2026-02-25 14:40:39.705776+05:30	14	21
97	added comment	Commented on task "Ticket Prioritization"	2026-02-25 14:40:39.708118+05:30	15	21
98	added comment	Commented on task "Ticket Prioritization"	2026-02-25 14:40:39.710724+05:30	15	21
99	added comment	Commented on task "Ticket Prioritization"	2026-02-25 14:40:39.713049+05:30	14	21
100	created task	Task "Replication Setup" created	2026-02-25 14:40:39.720085+05:30	13	20
101	created task	Task "Backup Strategy" created	2026-02-25 14:40:39.724139+05:30	13	20
102	added comment	Commented on task "Backup Strategy"	2026-02-25 14:40:39.727078+05:30	13	20
103	added comment	Commented on task "Backup Strategy"	2026-02-25 14:40:39.730564+05:30	13	20
104	created task	Task "Performance Benchmarks" created	2026-02-25 14:40:39.734939+05:30	13	20
105	added comment	Commented on task "Performance Benchmarks"	2026-02-25 14:40:39.737234+05:30	12	20
106	added comment	Commented on task "Performance Benchmarks"	2026-02-25 14:40:39.739622+05:30	12	20
107	created task	Task "Query Performance Analysis" created	2026-02-25 14:40:39.743745+05:30	12	20
108	added comment	Commented on task "Query Performance Analysis"	2026-02-25 14:40:39.746558+05:30	12	20
109	added comment	Commented on task "Query Performance Analysis"	2026-02-25 14:40:39.74891+05:30	12	20
110	added comment	Commented on task "Query Performance Analysis"	2026-02-25 14:40:39.751301+05:30	13	20
111	created task	Task "Documentation Update" created	2026-02-25 14:40:39.755336+05:30	12	20
112	added comment	Commented on task "Documentation Update"	2026-02-25 14:40:39.757444+05:30	12	20
113	created task	Task "Data Validation Scripts" created	2026-02-25 14:40:39.7612+05:30	12	20
114	created task	Task "Index Optimization" created	2026-02-25 14:40:39.764784+05:30	12	20
115	created task	Task "Training Materials" created	2026-02-25 14:40:39.768315+05:30	12	20
116	created task	Task "Connection Pool Configuration" created	2026-02-25 14:40:39.772298+05:30	13	20
117	created task	Task "Monitoring Setup" created	2026-02-25 14:40:39.776873+05:30	13	20
118	added comment	Commented on task "Monitoring Setup"	2026-02-25 14:40:39.779524+05:30	12	20
119	added comment	Commented on task "Monitoring Setup"	2026-02-25 14:40:39.782132+05:30	13	20
120	created task	Task "Rollback Plan" created	2026-02-25 14:40:39.786226+05:30	12	20
121	added comment	Commented on task "Rollback Plan"	2026-02-25 14:40:39.789047+05:30	12	20
122	added comment	Commented on task "Rollback Plan"	2026-02-25 14:40:39.79189+05:30	12	20
123	added comment	Commented on task "Rollback Plan"	2026-02-25 14:40:39.795077+05:30	13	20
124	created task	Task "Stakeholder Communication" created	2026-02-25 14:40:39.800527+05:30	13	20
125	added comment	Commented on task "Stakeholder Communication"	2026-02-25 14:40:39.802972+05:30	12	20
126	added comment	Commented on task "Stakeholder Communication"	2026-02-25 14:40:39.805411+05:30	12	20
127	added comment	Commented on task "Stakeholder Communication"	2026-02-25 14:40:39.807924+05:30	12	20
128	created task	Task "Budget Planning" created	2026-02-25 14:40:39.815474+05:30	11	19
129	created task	Task "Analytics Dashboard" created	2026-02-25 14:40:39.819682+05:30	11	19
130	created task	Task "Content Calendar" created	2026-02-25 14:40:39.824278+05:30	11	19
131	created task	Task "Competitor Analysis" created	2026-02-25 14:40:39.829179+05:30	11	19
132	created task	Task "LinkedIn Ad Campaign" created	2026-02-25 14:40:39.833428+05:30	15	19
133	created task	Task "A/B Testing Landing Pages" created	2026-02-25 14:40:39.837388+05:30	14	19
134	created task	Task "Video Script Writing" created	2026-02-25 14:40:39.841269+05:30	15	19
135	created task	Task "Brand Guidelines Update" created	2026-02-25 14:40:39.845588+05:30	15	19
136	created task	Task "Influencer Outreach" created	2026-02-25 14:40:39.849745+05:30	15	19
137	created task	Task "Google Ads Setup" created	2026-02-25 14:40:39.853745+05:30	14	19
138	added comment	Commented on task "Google Ads Setup"	2026-02-25 14:40:39.856257+05:30	14	19
139	added comment	Commented on task "Google Ads Setup"	2026-02-25 14:40:39.858803+05:30	15	19
140	added comment	Commented on task "Google Ads Setup"	2026-02-25 14:40:39.861341+05:30	14	19
141	created task	Task "Create Instagram Posts" created	2026-02-25 14:40:39.865323+05:30	15	19
142	created task	Task "Press Release" created	2026-02-25 14:40:39.869495+05:30	15	19
143	added comment	Commented on task "Press Release"	2026-02-25 14:40:39.871963+05:30	11	19
144	added comment	Commented on task "Press Release"	2026-02-25 14:40:39.874554+05:30	14	19
145	created task	Task "In-App Purchases" created	2026-02-25 14:40:39.88352+05:30	13	18
146	added comment	Commented on task "In-App Purchases"	2026-02-25 14:40:39.886311+05:30	13	18
147	added comment	Commented on task "In-App Purchases"	2026-02-25 14:40:39.889037+05:30	12	18
148	created task	Task "Dark Mode Support" created	2026-02-25 14:40:39.893575+05:30	13	18
149	created task	Task "Onboarding Flow" created	2026-02-25 14:40:39.899075+05:30	14	18
150	added comment	Commented on task "Onboarding Flow"	2026-02-25 14:40:39.902122+05:30	12	18
151	added comment	Commented on task "Onboarding Flow"	2026-02-25 14:40:39.904737+05:30	12	18
152	added comment	Commented on task "Onboarding Flow"	2026-02-25 14:40:39.907244+05:30	13	18
153	created task	Task "User Feedback Form" created	2026-02-25 14:40:39.91177+05:30	13	18
154	created task	Task "App Store Screenshots" created	2026-02-25 14:40:39.916486+05:30	13	18
155	created task	Task "Profile Settings Screen" created	2026-02-25 14:40:39.920473+05:30	14	18
156	created task	Task "Splash Screen Animation" created	2026-02-25 14:40:39.92455+05:30	12	18
157	created task	Task "Release Notes" created	2026-02-25 14:40:39.92918+05:30	14	18
158	added comment	Commented on task "Release Notes"	2026-02-25 14:40:39.931924+05:30	13	18
159	added comment	Commented on task "Release Notes"	2026-02-25 14:40:39.934579+05:30	14	18
160	created task	Task "App Icon Design" created	2026-02-25 14:40:39.938597+05:30	13	18
161	created task	Task "Crash Reporting Setup" created	2026-02-25 14:40:39.944035+05:30	13	18
162	created task	Task "Create About Us Page" created	2026-02-25 14:40:39.950347+05:30	13	17
163	added comment	Commented on task "Create About Us Page"	2026-02-25 14:40:39.953242+05:30	13	17
164	created task	Task "Add Social Share Buttons" created	2026-02-25 14:40:39.957206+05:30	13	17
165	created task	Task "SSL Certificate Setup" created	2026-02-25 14:40:39.962083+05:30	11	17
166	created task	Task "Update Footer Design" created	2026-02-25 14:40:39.967191+05:30	11	17
167	added comment	Commented on task "Update Footer Design"	2026-02-25 14:40:39.969356+05:30	11	17
168	added comment	Commented on task "Update Footer Design"	2026-02-25 14:40:39.971404+05:30	11	17
169	created task	Task "Add Search Functionality" created	2026-02-25 14:40:39.974775+05:30	12	17
170	created task	Task "Add Contact Form" created	2026-02-25 14:40:39.97935+05:30	12	17
171	created task	Task "Browser Compatibility Testing" created	2026-02-25 14:40:39.982761+05:30	13	17
172	added comment	Commented on task "Browser Compatibility Testing"	2026-02-25 14:40:39.984895+05:30	13	17
173	added comment	Commented on task "Browser Compatibility Testing"	2026-02-25 14:40:39.986748+05:30	13	17
174	created task	Task "Google Analytics Integration" created	2026-02-25 14:40:39.990593+05:30	13	17
175	created task	Task "Optimize Images" created	2026-02-25 14:40:39.994479+05:30	12	17
176	added comment	Commented on task "Optimize Images"	2026-02-25 14:40:39.997398+05:30	13	17
177	created task	Task "Create Sitemap" created	2026-02-25 14:40:40.000763+05:30	12	17
178	created task	Task "Accessibility Audit" created	2026-02-25 14:40:40.004198+05:30	12	17
179	created task	Task "Create FAQ Page" created	2026-02-25 14:40:40.008684+05:30	12	17
193	created task	Task "Checkpoint" created	2026-02-25 18:09:37.459324+05:30	11	21
194	changed task status	Task Export Functionality status changed from IN_PROGRESS to IN_REVIEW	2026-02-25 19:38:19.523323+05:30	11	21
195	changed task status	Task Export Functionality status changed from IN_REVIEW to IN_PROGRESS	2026-02-25 19:38:25.228594+05:30	11	21
196	changed task status	Task Export Functionality status changed from IN_PROGRESS to IN_REVIEW	2026-02-25 19:44:22.325246+05:30	11	21
197	changed task status	Task Export Functionality status changed from IN_REVIEW to IN_PROGRESS	2026-02-25 19:44:29.933633+05:30	11	21
198	added team member	keshav was add to the project Website Redesign	2026-02-25 21:41:26.660287+05:30	11	17
199	assigned task	Task Google Ads Setup assigned to alice	2026-02-25 22:14:06.309832+05:30	11	19
200	assigned task	Task A/B Testing Landing Pages assigned to diana	2026-02-25 22:15:10.754749+05:30	11	19
201	changed task status	Task Export Functionality status changed from IN_PROGRESS to DONE	2026-02-25 22:18:32.210976+05:30	11	21
202	created task	Task "For alice" created	2026-02-25 22:33:18.237161+05:30	15	21
203	deleted task	Task For alice was deleted	2026-02-25 22:38:18.256976+05:30	15	21
204	created task	Task "For alice" created	2026-02-25 22:38:27.002552+05:30	15	21
205	added comment	Commented on task "For alice"	2026-02-25 22:51:19.970822+05:30	11	21
206	changed task status	Task Checkpoint status changed from TODO to IN_REVIEW	2026-02-26 00:38:47.875474+05:30	11	21
207	changed task status	Task Optimize Images status changed from IN_REVIEW to IN_PROGRESS	2026-02-26 02:02:38.596925+05:30	11	17
208	added team member	sweety was add to the project Marketing Campaign Q1	2026-02-26 02:02:52.515652+05:30	11	19
209	added comment	Commented on task "For alice"	2026-02-26 09:11:24.486528+05:30	11	21
210	changed task status	Task Influencer Outreach status changed from IN_PROGRESS to IN_REVIEW	2026-02-26 10:36:41.478172+05:30	11	19
211	removed team member	alice removed from project Marketing Campaign Q1	2026-02-26 10:37:28.553847+05:30	11	19
212	removed team member	alice removed from project Marketing Campaign Q1	2026-02-26 10:37:37.382266+05:30	11	19
213	removed team member	alice removed from project Marketing Campaign Q1	2026-02-26 10:37:40.837689+05:30	11	19
214	removed team member	alice removed from project Marketing Campaign Q1	2026-02-26 10:37:44.614852+05:30	11	19
215	removed team member	sweety removed from project Marketing Campaign Q1	2026-02-26 10:44:23.561119+05:30	11	19
216	added team member	sweety was add to the project Marketing Campaign Q1	2026-02-26 10:44:31.887519+05:30	11	19
217	created project	Project "Django Backend API Design" was created	2026-02-26 10:47:41.723121+05:30	11	23
218	added team member	bob was add to the project Django Backend API Design	2026-02-26 10:47:41.731061+05:30	11	23
219	added team member	Savant was add to the project Django Backend API Design	2026-02-26 10:58:40.002303+05:30	11	23
220	created task	Task "API Working" created	2026-02-26 11:10:34.306278+05:30	11	23
221	added comment	Commented on task "API Working"	2026-02-26 11:11:11.714251+05:30	18	23
222	added comment	Commented on task "API Working"	2026-02-26 11:11:37.022881+05:30	11	23
223	added comment	Commented on task "API Working"	2026-02-26 11:12:06.742658+05:30	18	23
224	changed task status	Task API Working status changed from TODO to IN_PROGRESS	2026-02-26 11:22:12.569786+05:30	11	23
225	changed task status	Task Ticket Prioritization status changed from TODO to IN_PROGRESS	2026-02-26 12:48:29.02595+05:30	11	21
226	assigned task	Task Brand Guidelines Update assigned to diana	2026-02-26 12:51:07.188307+05:30	11	19
227	added team member	Yuvraj was add to the project Django Backend API Design	2026-02-26 13:41:35.167199+05:30	11	23
228	created task	Task "Frontend changes" created	2026-02-26 13:44:26.915007+05:30	11	23
229	added comment	Commented on task "Frontend changes"	2026-02-26 13:46:32.924619+05:30	20	23
230	changed task status	Task Frontend changes status changed from TODO to IN_REVIEW	2026-02-26 13:47:19.859729+05:30	20	23
231	added team member	bob was add to the project Marketing Campaign Q1	2026-02-26 13:50:22.008929+05:30	11	19
232	removed team member	diana removed from project Marketing Campaign Q1	2026-02-26 13:51:58.203316+05:30	11	19
233	changed task status	Task Chat Widget Integration status changed from TODO to IN_REVIEW	2026-02-26 13:54:09.866875+05:30	11	21
234	assigned task	Task LinkedIn Ad Campaign assigned to bob	2026-02-26 23:07:05.361218+05:30	11	19
235	changed task status	Task LinkedIn Ad Campaign status changed from IN_PROGRESS to TODO	2026-02-26 23:07:24.004774+05:30	11	19
236	changed task status	Task API Working status changed from IN_PROGRESS to TODO	2026-02-26 23:16:49.350387+05:30	11	23
237	changed task status	Task Frontend changes status changed from IN_REVIEW to IN_PROGRESS	2026-02-26 23:17:03.599143+05:30	11	23
238	changed task status	Task Frontend changes status changed from IN_PROGRESS to TODO	2026-02-26 23:18:12.826082+05:30	11	23
239	added team member	diana was add to the project Marketing Campaign Q1	2026-02-28 00:17:43.327666+05:30	11	19
240	removed team member	diana removed from project Marketing Campaign Q1	2026-02-28 00:17:51.303215+05:30	11	19
241	added team member	diana was add to the project Marketing Campaign Q1	2026-02-28 00:36:58.662918+05:30	11	19
242	removed team member	diana removed from project Marketing Campaign Q1	2026-02-28 00:40:44.452933+05:30	11	19
243	removed team member	diana was remove from the project Marketing Campaign Q1 All 3 tasks originally created by diana have been transferred to the project creator : alice	2026-02-28 00:40:44.463798+05:30	11	19
244	changed task status	Task Checkpoint status changed from IN_REVIEW to IN_PROGRESS	2026-02-28 00:52:13.468631+05:30	11	21
245	changed task status	Task Checkpoint status changed from IN_PROGRESS to IN_REVIEW	2026-02-28 00:52:15.744049+05:30	11	21
246	changed task priority	Task Frontend changes priority changed from MEDIUM to URGENT	2026-02-28 01:36:51.334693+05:30	11	23
247	added comment	Commented on task "Video Script Writing"	2026-02-28 01:42:24.241699+05:30	11	19
248	added team member	raghav was add to the project Marketing Campaign Q1	2026-02-28 01:43:29.309925+05:30	11	19
249	assigned task	Task Video Script Writing assigned to raghav	2026-02-28 01:43:40.103561+05:30	11	19
250	changed task status	Task Google Ads Setup status changed from TODO to IN_PROGRESS	2026-03-01 14:26:02.182579+05:30	11	19
251	added comment	Commented on task "Video Script Writing"	2026-03-01 14:26:19.198404+05:30	11	19
252	changed task status	Task Social Media Strategy status changed from IN_PROGRESS to IN_REVIEW	2026-03-01 14:26:34.250894+05:30	11	19
253	changed task status	Task Budget Planning status changed from TODO to IN_PROGRESS	2026-03-01 14:26:37.525835+05:30	11	19
254	created task	Task "Serializers" created	2026-03-07 10:57:48.618572+05:30	12	23
255	created task	Task "Serializers" created	2026-03-07 10:58:03.504888+05:30	12	23
256	created task	Task "Serializers" created	2026-03-07 11:02:03.253849+05:30	12	23
257	deleted task	Task Serializers was deleted	2026-03-07 11:02:07.805097+05:30	12	23
258	assigned task	Task Serializers assigned to alice	2026-03-07 11:02:40.139317+05:30	12	23
259	deleted task	Task Serializers was deleted	2026-03-07 11:03:13.544429+05:30	12	23
260	assigned task	Task Serializers assigned to Savant	2026-03-07 11:05:24.332797+05:30	11	23
261	added team member	Savant was add to the project Marketing Campaign Q1	2026-03-07 11:07:38.419255+05:30	11	19
262	assigned task	Task A/B Testing Landing Pages assigned to Savant	2026-03-07 11:08:02.128937+05:30	11	19
263	created task	Task "Checklist Task" created	2026-03-07 11:09:22.258997+05:30	11	23
264	created task	Task "Test 1" created	2026-03-07 11:26:58.155528+05:30	11	23
265	changed task status	Task Test 1 status changed from TODO to IN_PROGRESS	2026-03-07 11:34:11.1822+05:30	18	23
266	changed task status	Task Test 1 status changed from IN_PROGRESS to IN_REVIEW	2026-03-07 11:34:22.418919+05:30	18	23
267	changed task status	Task Test 1 status changed from IN_REVIEW to DONE	2026-03-07 11:34:30.709337+05:30	18	23
268	changed task status	Task Checklist Task status changed from IN_PROGRESS to IN_REVIEW	2026-03-07 11:55:22.380655+05:30	18	23
269	changed task status	Task Checklist Task status changed from IN_REVIEW to DONE	2026-03-07 11:55:25.506025+05:30	18	23
270	changed task status	Task Serializers status changed from TODO to DONE	2026-03-07 11:55:36.192023+05:30	18	23
271	added comment	Commented on task "A/B Testing Landing Pages"	2026-03-07 12:14:17.862929+05:30	12	19
272	assigned task	Task Brand Guidelines Update assigned to bob	2026-03-07 12:24:43.057504+05:30	11	19
273	changed task status	Task Create About Us Page status changed from IN_REVIEW to DONE	2026-03-07 12:32:44.312989+05:30	11	17
274	assigned task	Task For alice assigned to alice	2026-03-07 12:37:35.575881+05:30	14	21
\.


--
-- Data for Name: tasks_comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks_comment (id, text, created_at, user_id, task_id) FROM stdin;
7	Mockup looks great! Minor feedback: can we make the CTA button larger?	2026-02-24 23:41:04.848554+05:30	12	7
8	Good point, I'll update it now.	2026-02-24 23:41:04.853397+05:30	11	7
9	Navigation is almost done, just working on mobile responsiveness.	2026-02-24 23:41:04.856832+05:30	13	8
10	Performance metrics are looking good. Average load time under 2s.	2026-02-24 23:41:04.859274+05:30	11	11
11	Excellent! Let's get this approved.	2026-02-24 23:41:04.862153+05:30	13	11
12	Dashboard design needs review. Can we schedule a call?	2026-02-24 23:41:04.865376+05:30	12	13
13	API endpoints are all connected and working. Ready for testing.	2026-02-24 23:41:04.868149+05:30	13	14
14	Instagram content calendar draft is ready for review.	2026-02-24 23:41:04.871667+05:30	14	16
15	Updated the headline based on marketing feedback.	2026-02-24 23:41:04.874244+05:30	11	18
16	Migration script tested successfully on dev environment.	2026-02-24 23:41:04.877857+05:30	12	20
17	Can I do this?	2026-02-25 01:41:31.133417+05:30	11	25
25	Need clarification on requirements.	2026-02-25 14:40:39.641371+05:30	15	40
26	Need clarification on requirements.	2026-02-25 14:40:39.684456+05:30	14	47
27	Looks good to me!	2026-02-25 14:40:39.686938+05:30	14	47
28	Can someone help with this?	2026-02-25 14:40:39.698716+05:30	15	49
29	Need clarification on requirements.	2026-02-25 14:40:39.700943+05:30	15	49
30	Looks good to me!	2026-02-25 14:40:39.706904+05:30	15	50
31	Blocked by another task.	2026-02-25 14:40:39.709267+05:30	15	50
32	Ready for review.	2026-02-25 14:40:39.711951+05:30	14	50
33	Found a bug, fixing now.	2026-02-25 14:40:39.725573+05:30	13	52
34	Can someone help with this?	2026-02-25 14:40:39.728893+05:30	13	52
35	Working on this now.	2026-02-25 14:40:39.736083+05:30	12	53
36	Approved, moving forward.	2026-02-25 14:40:39.738461+05:30	12	53
37	Approved, moving forward.	2026-02-25 14:40:39.745321+05:30	12	54
38	Blocked by another task.	2026-02-25 14:40:39.747741+05:30	12	54
39	Need clarification on requirements.	2026-02-25 14:40:39.750123+05:30	13	54
40	Updated based on feedback.	2026-02-25 14:40:39.756407+05:30	12	55
41	Need clarification on requirements.	2026-02-25 14:40:39.778211+05:30	12	60
42	Approved, moving forward.	2026-02-25 14:40:39.780818+05:30	13	60
43	Blocked by another task.	2026-02-25 14:40:39.787659+05:30	12	61
44	Looks good to me!	2026-02-25 14:40:39.790427+05:30	12	61
45	Updated based on feedback.	2026-02-25 14:40:39.793496+05:30	13	61
46	Updated based on feedback.	2026-02-25 14:40:39.801771+05:30	12	62
47	Approved, moving forward.	2026-02-25 14:40:39.80418+05:30	12	62
48	Blocked by another task.	2026-02-25 14:40:39.806715+05:30	12	62
49	Working on this now.	2026-02-25 14:40:39.855009+05:30	14	72
50	Approved, moving forward.	2026-02-25 14:40:39.857504+05:30	15	72
51	Updated based on feedback.	2026-02-25 14:40:39.860116+05:30	14	72
52	Ready for review.	2026-02-25 14:40:39.870733+05:30	11	74
53	Need clarification on requirements.	2026-02-25 14:40:39.873334+05:30	14	74
54	Testing complete.	2026-02-25 14:40:39.884974+05:30	13	75
55	Found a bug, fixing now.	2026-02-25 14:40:39.887546+05:30	12	75
56	Can someone help with this?	2026-02-25 14:40:39.900602+05:30	12	77
57	Blocked by another task.	2026-02-25 14:40:39.903475+05:30	12	77
58	Blocked by another task.	2026-02-25 14:40:39.905998+05:30	13	77
59	Updated based on feedback.	2026-02-25 14:40:39.930577+05:30	13	82
60	Looks good to me!	2026-02-25 14:40:39.93325+05:30	14	82
61	Looks good to me!	2026-02-25 14:40:39.951493+05:30	13	85
62	Need clarification on requirements.	2026-02-25 14:40:39.968354+05:30	11	88
63	Ready for review.	2026-02-25 14:40:39.97039+05:30	11	88
64	Found a bug, fixing now.	2026-02-25 14:40:39.983821+05:30	13	91
65	Ready for review.	2026-02-25 14:40:39.985822+05:30	13	91
66	Looks good to me!	2026-02-25 14:40:39.996032+05:30	13	93
67	Yep cant access this!	2026-02-25 22:51:19.956167+05:30	11	99
68	Still cant access this	2026-02-26 09:11:24.480313+05:30	11	99
69	I dont think I can do this.	2026-02-26 11:11:11.706656+05:30	18	100
70	How dare you! Your internship is cancelled!	2026-02-26 11:11:37.018315+05:30	11	100
71	Maam chill out, I'll do it.	2026-02-26 11:12:06.737252+05:30	18	100
72	I will need 2 days to complete this as it is a bit complex.	2026-02-26 13:46:32.902793+05:30	20	101
73	Do we have a script ready for this?	2026-02-28 01:42:24.233423+05:30	11	69
74	We can do this!	2026-03-01 14:26:19.191941+05:30	11	69
75	I think I can do this better.	2026-03-07 12:14:17.835768+05:30	12	68
\.


--
-- Data for Name: tasks_notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks_notification (id, message, is_read, created_at, recipient_id, task_id) FROM stdin;
3	You have been assigned to: Serializers	t	2026-03-07 11:05:24.324772+05:30	18	103
4	alice added you to the project Marketing Campaign Q1	t	2026-03-07 11:07:38.423279+05:30	18	\N
5	You have been assigned to: A/B Testing Landing Pages	t	2026-03-07 11:08:02.114843+05:30	18	68
6	You were assigned to a new task: Checklist Task	t	2026-03-07 11:09:22.263224+05:30	18	105
2	You have been assigned to: Serializers	t	2026-03-07 11:02:40.127493+05:30	11	103
7	You were assigned to a new task: Test 1	t	2026-03-07 11:26:58.159384+05:30	18	106
8	Savant completed task: Test 1	t	2026-03-07 11:34:30.695935+05:30	11	106
9	Savant completed task: Checklist Task	t	2026-03-07 11:55:25.494359+05:30	11	105
10	Savant completed task: Serializers	t	2026-03-07 11:55:36.1798+05:30	11	103
11	bob commented on your task : A/B Testing Landing Pages	f	2026-03-07 12:14:17.868292+05:30	18	68
12	bob commented on a task you created: A/B Testing Landing Pages	t	2026-03-07 12:14:17.881743+05:30	11	\N
14	bob completed task: Create About Us Page	t	2026-03-07 12:32:44.28556+05:30	11	85
13	You have been assigned to: Brand Guidelines Update	t	2026-03-07 12:24:43.039711+05:30	12	70
15	You have been assigned to: For alice	f	2026-03-07 12:37:35.561208+05:30	11	99
\.


--
-- Data for Name: tasks_project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks_project (id, project_name, description, created_at, updated_at, created_by_id) FROM stdin;
18	Mobile App Development	Build iOS and Android app for customer portal	2026-02-24 23:41:04.68805+05:30	2026-02-24 23:41:04.688072+05:30	12
20	Database Migration	Migrate from MySQL to PostgreSQL	2026-02-24 23:41:04.720131+05:30	2026-02-24 23:41:04.720149+05:30	13
21	Customer Portal	Self-service portal for customer support tickets	2026-02-24 23:41:04.733984+05:30	2026-02-24 23:41:04.734012+05:30	14
17	Website Redesign	Complete redesign of company website with modern UI/UX	2026-02-24 23:41:04.656027+05:30	2026-02-25 21:41:26.638383+05:30	11
23	Django Backend API Design	Design an API that does basic crud.	2026-02-26 10:47:41.67105+05:30	2026-02-26 13:41:35.14841+05:30	11
19	Marketing Campaign Q1	Plan and execute Q1 2026 marketing initiatives	2026-02-24 23:41:04.70502+05:30	2026-03-07 11:07:38.404115+05:30	11
\.


--
-- Data for Name: tasks_project_team_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks_project_team_members (id, project_id, user_id) FROM stdin;
25	17	11
26	17	12
27	17	13
28	18	12
29	18	13
30	18	14
33	19	15
34	20	13
35	20	12
36	21	14
37	21	11
38	21	15
43	17	1
48	19	11
49	19	17
50	23	11
51	23	12
52	23	18
53	23	20
54	19	12
57	19	16
58	19	18
\.


--
-- Data for Name: tasks_task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks_task (id, title, description, status, priority, due_date, created_at, updated_at, assigned_to_id, created_by_id, project_id) FROM stdin;
44	Knowledge Base	Follow up on previous implementation	TODO	MEDIUM	2026-03-18 20:10:39.461992+05:30	2026-02-25 14:40:39.664553+05:30	2026-02-25 14:40:39.664566+05:30	11	14	21
45	FAQ Section	Initial research and planning phase	TODO	MEDIUM	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.67076+05:30	2026-02-25 14:40:39.67078+05:30	11	14	21
46	Multi-language Support	Documentation and handoff	TODO	HIGH	2026-02-23 20:10:39.461992+05:30	2026-02-25 14:40:39.675402+05:30	2026-02-25 14:40:39.675423+05:30	11	14	21
7	Design Homepage Mockup	Create wireframes and high-fidelity mockup for new homepage	DONE	HIGH	2026-02-28 05:11:04.756114+05:30	2026-02-24 23:41:04.796265+05:30	2026-02-24 23:41:04.796291+05:30	12	11	17
8	Implement Navigation Menu	Code responsive navigation with dropdown menus	IN_PROGRESS	HIGH	2026-03-07 05:11:04.756114+05:30	2026-02-24 23:41:04.801465+05:30	2026-02-24 23:41:04.801494+05:30	13	11	17
10	SEO Optimization	Optimize meta tags and site structure for SEO	TODO	MEDIUM	2026-02-28 05:11:04.756114+05:30	2026-02-24 23:41:04.809603+05:30	2026-02-24 23:41:04.809615+05:30	\N	11	17
11	Performance Testing	Load testing and performance optimization	IN_REVIEW	HIGH	2026-03-07 05:11:04.756114+05:30	2026-02-24 23:41:04.812962+05:30	2026-02-24 23:41:04.812973+05:30	13	13	17
12	User Authentication Flow	Implement login, signup, and password reset	DONE	URGENT	2026-02-23 05:11:04.756114+05:30	2026-02-24 23:41:04.81579+05:30	2026-02-24 23:41:04.815798+05:30	13	12	18
13	Dashboard UI Design	Design main dashboard interface	IN_PROGRESS	HIGH	2026-02-28 05:11:04.756114+05:30	2026-02-24 23:41:04.818074+05:30	2026-02-24 23:41:04.818082+05:30	14	12	18
14	API Integration	Connect frontend to backend API	IN_PROGRESS	URGENT	2026-03-07 05:11:04.756114+05:30	2026-02-24 23:41:04.820437+05:30	2026-02-24 23:41:04.820448+05:30	13	13	18
15	Push Notifications	Setup Firebase push notifications	TODO	MEDIUM	2026-02-23 05:11:04.756114+05:30	2026-02-24 23:41:04.825095+05:30	2026-02-24 23:41:04.825114+05:30	\N	12	18
18	Landing Page Copy	Write compelling copy for campaign landing page	IN_REVIEW	HIGH	2026-02-23 05:11:04.756114+05:30	2026-02-24 23:41:04.832616+05:30	2026-02-24 23:41:04.832625+05:30	11	11	19
19	Schema Analysis	Analyze current MySQL schema structure	DONE	URGENT	2026-02-28 05:11:04.756114+05:30	2026-02-24 23:41:04.834484+05:30	2026-02-24 23:41:04.834491+05:30	13	13	20
20	Migration Script	Write migration scripts for data transfer	IN_PROGRESS	URGENT	2026-03-07 05:11:04.756114+05:30	2026-02-24 23:41:04.836196+05:30	2026-02-24 23:41:04.836207+05:30	12	13	20
21	Test Environment Setup	Setup test PostgreSQL environment	TODO	HIGH	2026-02-23 05:11:04.756114+05:30	2026-02-24 23:41:04.839094+05:30	2026-02-24 23:41:04.83911+05:30	12	12	20
22	Ticket Submission Form	Create form for customers to submit support tickets	DONE	HIGH	2026-02-28 05:11:04.756114+05:30	2026-02-24 23:41:04.842355+05:30	2026-02-24 23:41:04.842364+05:30	15	14	21
23	Ticket Status Dashboard	Display open/closed ticket status	IN_PROGRESS	MEDIUM	2026-03-07 05:11:04.756114+05:30	2026-02-24 23:41:04.84461+05:30	2026-02-24 23:41:04.844617+05:30	11	14	21
24	Email Notifications	Send email when ticket status changes	TODO	LOW	2026-02-23 05:11:04.756114+05:30	2026-02-24 23:41:04.846442+05:30	2026-02-24 23:41:04.846449+05:30	\N	15	21
48	Password Reset Flow	Testing and quality assurance	DONE	LOW	2026-02-20 20:10:39.461992+05:30	2026-02-25 14:40:39.691218+05:30	2026-02-25 14:40:39.691244+05:30	14	15	21
25	Is this working	This is me, working or not>	DONE	LOW	2026-02-25 05:30:00+05:30	2026-02-25 00:44:55.634212+05:30	2026-02-25 11:06:08.112809+05:30	\N	11	19
26	task patched	string	TODO	LOW	2026-08-24 19:45:22+05:30	2026-02-25 13:11:17.261569+05:30	2026-02-25 13:12:24.236249+05:30	\N	11	21
27	Testing Tassk	Working	TODO	MEDIUM	2026-02-26 05:30:00+05:30	2026-02-25 13:29:54.448336+05:30	2026-02-25 13:29:54.448345+05:30	\N	11	21
39	Admin Dashboard	Follow up on previous implementation	IN_PROGRESS	LOW	2026-03-02 20:10:39.461992+05:30	2026-02-25 14:40:39.632408+05:30	2026-02-25 14:40:39.632468+05:30	\N	15	21
40	Auto-Response Templates	Review and update based on feedback	IN_REVIEW	MEDIUM	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.638171+05:30	2026-02-25 14:40:39.638196+05:30	15	11	21
41	Customer Satisfaction Survey	Testing and quality assurance	TODO	HIGH	2026-02-20 20:10:39.461992+05:30	2026-02-25 14:40:39.646823+05:30	2026-02-25 14:40:39.646835+05:30	\N	14	21
42	User Profile Page	High priority task that needs immediate attention	IN_PROGRESS	MEDIUM	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.652588+05:30	2026-02-25 14:40:39.652622+05:30	\N	14	21
43	Analytics Reports	Review and update based on feedback	IN_PROGRESS	MEDIUM	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.659302+05:30	2026-02-25 14:40:39.659343+05:30	\N	15	21
51	Replication Setup	Bug fixes and improvements	TODO	MEDIUM	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.718773+05:30	2026-02-25 14:40:39.718785+05:30	13	13	20
52	Backup Strategy	Documentation and handoff	IN_REVIEW	LOW	2026-03-02 20:10:39.461992+05:30	2026-02-25 14:40:39.7225+05:30	2026-02-25 14:40:39.722516+05:30	13	13	20
53	Performance Benchmarks	Testing and quality assurance	TODO	HIGH	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.733564+05:30	2026-02-25 14:40:39.733577+05:30	\N	13	20
54	Query Performance Analysis	Stakeholder review required	TODO	HIGH	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.74203+05:30	2026-02-25 14:40:39.742043+05:30	\N	12	20
55	Documentation Update	Follow up on previous implementation	IN_PROGRESS	URGENT	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.753827+05:30	2026-02-25 14:40:39.753839+05:30	\N	12	20
56	Data Validation Scripts	Implementation of new feature	IN_PROGRESS	MEDIUM	2026-02-23 20:10:39.461992+05:30	2026-02-25 14:40:39.759768+05:30	2026-02-25 14:40:39.759779+05:30	\N	12	20
57	Index Optimization	Review and update based on feedback	IN_PROGRESS	MEDIUM	2026-03-27 20:10:39.461992+05:30	2026-02-25 14:40:39.763534+05:30	2026-02-25 14:40:39.763552+05:30	13	12	20
58	Training Materials	Blocked pending external dependency	IN_PROGRESS	MEDIUM	2026-03-18 20:10:39.461992+05:30	2026-02-25 14:40:39.767099+05:30	2026-02-25 14:40:39.76711+05:30	12	12	20
59	Connection Pool Configuration	Bug fixes and improvements	TODO	LOW	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.770973+05:30	2026-02-25 14:40:39.770983+05:30	\N	13	20
60	Monitoring Setup	Follow up on previous implementation	TODO	HIGH	2026-03-18 20:10:39.461992+05:30	2026-02-25 14:40:39.775038+05:30	2026-02-25 14:40:39.775049+05:30	12	13	20
61	Rollback Plan	High priority task that needs immediate attention	IN_PROGRESS	URGENT	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.78483+05:30	2026-02-25 14:40:39.784843+05:30	13	12	20
50	Ticket Prioritization	Review and update based on feedback	IN_PROGRESS	MEDIUM	2026-03-07 20:10:39.461992+05:30	2026-02-25 14:40:39.704503+05:30	2026-02-26 12:48:29.013402+05:30	11	14	21
17	Email Campaign Design	Design email templates for drip campaign	TODO	MEDIUM	2026-03-07 05:11:04.756114+05:30	2026-02-24 23:41:04.829883+05:30	2026-02-24 23:41:04.829893+05:30	15	11	19
16	Social Media Strategy	Plan content calendar for Instagram and LinkedIn	IN_REVIEW	HIGH	2026-02-28 05:11:04.756114+05:30	2026-02-24 23:41:04.827754+05:30	2026-03-01 14:26:34.246474+05:30	\N	11	19
49	Chat Widget Integration	Follow up on previous implementation	IN_REVIEW	URGENT	2026-02-23 20:10:39.461992+05:30	2026-02-25 14:40:39.696098+05:30	2026-02-26 13:54:09.859015+05:30	15	11	21
47	Export Functionality	Bug fixes and improvements	DONE	MEDIUM	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.681094+05:30	2026-02-25 22:18:32.206392+05:30	14	11	21
62	Stakeholder Communication	Implementation of new feature	TODO	URGENT	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.797846+05:30	2026-02-25 14:40:39.797859+05:30	\N	13	20
66	Competitor Analysis	Blocked pending external dependency	IN_REVIEW	HIGH	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.82717+05:30	2026-02-25 14:40:39.827184+05:30	15	11	19
73	Create Instagram Posts	Stakeholder review required	IN_REVIEW	LOW	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.863951+05:30	2026-02-25 14:40:39.863962+05:30	15	15	19
74	Press Release	Bug fixes and improvements	DONE	MEDIUM	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.867977+05:30	2026-02-25 14:40:39.867987+05:30	11	15	19
75	In-App Purchases	High priority task that needs immediate attention	IN_REVIEW	MEDIUM	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.882009+05:30	2026-02-25 14:40:39.88202+05:30	14	13	18
76	Dark Mode Support	Documentation and handoff	TODO	LOW	2026-03-02 20:10:39.461992+05:30	2026-02-25 14:40:39.891789+05:30	2026-02-25 14:40:39.8918+05:30	14	13	18
77	Onboarding Flow	Initial research and planning phase	TODO	LOW	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.897469+05:30	2026-02-25 14:40:39.897486+05:30	14	14	18
78	User Feedback Form	Bug fixes and improvements	IN_PROGRESS	LOW	2026-03-18 20:10:39.461992+05:30	2026-02-25 14:40:39.910074+05:30	2026-02-25 14:40:39.910084+05:30	14	13	18
79	App Store Screenshots	Documentation and handoff	TODO	MEDIUM	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.915116+05:30	2026-02-25 14:40:39.915127+05:30	13	13	18
80	Profile Settings Screen	Testing and quality assurance	TODO	LOW	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.919082+05:30	2026-02-25 14:40:39.919093+05:30	13	14	18
81	Splash Screen Animation	Bug fixes and improvements	TODO	HIGH	2026-02-20 20:10:39.461992+05:30	2026-02-25 14:40:39.92316+05:30	2026-02-25 14:40:39.923171+05:30	12	12	18
82	Release Notes	Review and update based on feedback	TODO	LOW	2026-03-11 20:10:39.461992+05:30	2026-02-25 14:40:39.927549+05:30	2026-02-25 14:40:39.92756+05:30	14	14	18
83	App Icon Design	Initial research and planning phase	IN_REVIEW	URGENT	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.937192+05:30	2026-02-25 14:40:39.937202+05:30	\N	13	18
84	Crash Reporting Setup	Follow up on previous implementation	TODO	MEDIUM	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.942356+05:30	2026-02-25 14:40:39.942369+05:30	\N	13	18
86	Add Social Share Buttons	Bug fixes and improvements	TODO	LOW	2026-03-18 20:10:39.461992+05:30	2026-02-25 14:40:39.955877+05:30	2026-02-25 14:40:39.955886+05:30	11	13	17
87	SSL Certificate Setup	Stakeholder review required	TODO	LOW	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.960097+05:30	2026-02-25 14:40:39.960109+05:30	\N	11	17
88	Update Footer Design	Implementation of new feature	TODO	MEDIUM	2026-03-07 20:10:39.461992+05:30	2026-02-25 14:40:39.965087+05:30	2026-02-25 14:40:39.9651+05:30	\N	11	17
89	Add Search Functionality	Blocked pending external dependency	DONE	URGENT	2026-03-27 20:10:39.461992+05:30	2026-02-25 14:40:39.973462+05:30	2026-02-25 14:40:39.973472+05:30	12	12	17
90	Add Contact Form	Implementation of new feature	TODO	LOW	2026-02-20 20:10:39.461992+05:30	2026-02-25 14:40:39.977911+05:30	2026-02-25 14:40:39.977922+05:30	12	12	17
91	Browser Compatibility Testing	Stakeholder review required	TODO	MEDIUM	2026-03-07 20:10:39.461992+05:30	2026-02-25 14:40:39.981587+05:30	2026-02-25 14:40:39.981595+05:30	\N	13	17
92	Google Analytics Integration	Blocked pending external dependency	DONE	URGENT	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.989086+05:30	2026-02-25 14:40:39.989094+05:30	\N	13	17
94	Create Sitemap	Blocked pending external dependency	DONE	MEDIUM	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.999648+05:30	2026-02-25 14:40:39.999659+05:30	13	12	17
95	Accessibility Audit	Blocked pending external dependency	IN_PROGRESS	URGENT	2026-03-27 20:10:39.461992+05:30	2026-02-25 14:40:40.002885+05:30	2026-02-25 14:40:40.002895+05:30	12	12	17
96	Create FAQ Page	Implementation of new feature	DONE	LOW	2026-03-11 20:10:39.461992+05:30	2026-02-25 14:40:40.007357+05:30	2026-02-25 14:40:40.00737+05:30	\N	12	17
97	Checkpoint	are we getting there	IN_REVIEW	MEDIUM	2026-02-26 05:30:00+05:30	2026-02-25 18:09:37.43247+05:30	2026-02-28 00:52:15.739143+05:30	14	11	21
93	Optimize Images	Follow up on previous implementation	IN_PROGRESS	URGENT	2026-02-24 20:10:39.461992+05:30	2026-02-25 14:40:39.992809+05:30	2026-02-26 02:02:38.593321+05:30	\N	12	17
100	API Working	Create the endpoints for Create	TODO	HIGH	2026-02-28 05:30:00+05:30	2026-02-26 11:10:34.277506+05:30	2026-02-26 23:16:49.34608+05:30	18	11	23
71	Influencer Outreach	Implementation of new feature	IN_REVIEW	HIGH	2026-03-07 20:10:39.461992+05:30	2026-02-25 14:40:39.848325+05:30	2026-02-26 10:36:41.47428+05:30	11	15	19
101	Frontend changes	Change the ui.	TODO	URGENT	2026-02-27 05:30:00+05:30	2026-02-26 13:44:26.903476+05:30	2026-02-28 01:36:51.302772+05:30	20	11	23
69	Video Script Writing	Stakeholder review required	TODO	MEDIUM	2026-03-02 20:10:39.461992+05:30	2026-02-25 14:40:39.839918+05:30	2026-02-28 01:43:40.099261+05:30	16	15	19
67	LinkedIn Ad Campaign	Documentation and handoff	TODO	URGENT	2026-03-11 20:10:39.461992+05:30	2026-02-25 14:40:39.832097+05:30	2026-02-26 23:07:23.999989+05:30	12	15	19
72	Google Ads Setup	Review and update based on feedback	IN_PROGRESS	MEDIUM	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.852391+05:30	2026-03-01 14:26:02.173094+05:30	11	11	19
64	Analytics Dashboard	Review and update based on feedback	DONE	MEDIUM	2026-03-11 20:10:39.461992+05:30	2026-02-25 14:40:39.818131+05:30	2026-02-25 14:40:39.81814+05:30	\N	11	19
65	Content Calendar	High priority task that needs immediate attention	DONE	URGENT	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.822651+05:30	2026-02-25 14:40:39.822667+05:30	\N	11	19
63	Budget Planning	Follow up on previous implementation	IN_PROGRESS	URGENT	2026-02-20 20:10:39.461992+05:30	2026-02-25 14:40:39.813944+05:30	2026-03-01 14:26:37.521181+05:30	11	11	19
68	A/B Testing Landing Pages	Implementation of new feature	TODO	MEDIUM	2026-03-04 20:10:39.461992+05:30	2026-02-25 14:40:39.836034+05:30	2026-03-07 11:08:02.109308+05:30	18	11	19
106	Test 1	Complete all the checklists	DONE	MEDIUM	2026-03-09 05:30:00+05:30	2026-03-07 11:26:58.150121+05:30	2026-03-07 11:34:30.689668+05:30	18	11	23
105	Checklist Task	Complete all the checklists	DONE	MEDIUM	2026-03-09 05:30:00+05:30	2026-03-07 11:09:22.252577+05:30	2026-03-07 11:55:25.487996+05:30	18	11	23
103	Serializers	Create the serializes for the API's.	DONE	MEDIUM	2026-03-10 05:30:00+05:30	2026-03-07 10:58:03.498515+05:30	2026-03-07 11:55:36.172094+05:30	18	12	23
70	Brand Guidelines Update	Follow up on previous implementation	IN_PROGRESS	URGENT	2026-02-20 20:10:39.461992+05:30	2026-02-25 14:40:39.844247+05:30	2026-03-07 12:24:43.009635+05:30	12	15	19
85	Create About Us Page	Review and update based on feedback	DONE	MEDIUM	2026-02-27 20:10:39.461992+05:30	2026-02-25 14:40:39.948492+05:30	2026-03-07 12:32:44.265936+05:30	12	13	17
99	For alice	Check if you can alter it , alice	TODO	MEDIUM	2026-02-27 05:30:00+05:30	2026-02-25 22:38:26.996058+05:30	2026-03-07 12:37:35.556364+05:30	11	15	21
\.


--
-- Data for Name: token_blacklist_blacklistedtoken; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.token_blacklist_blacklistedtoken (id, blacklisted_at, token_id) FROM stdin;
\.


--
-- Data for Name: token_blacklist_outstandingtoken; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.token_blacklist_outstandingtoken (id, token, created_at, expires_at, user_id, jti) FROM stdin;
16	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA0MDcyMCwiaWF0IjoxNzcxOTU0MzIwLCJqdGkiOiI3YzRlNjI5NjU1NTg0ZDE1YTIyNGUyOTliYzY4YzI1MiIsInVzZXJfaWQiOiIxIn0.tGD60HP_dAUHDSTg4ghkhyQ8w5LD2FvH1yaecXck6VI	2026-02-24 23:02:00.908404+05:30	2026-02-25 23:02:00+05:30	1	7c4e629655584d15a224e299bc68c252
1	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTY3OTQ5OSwiaWF0IjoxNzcxNTkzMDk5LCJqdGkiOiJhMjAxNzdjYWM4Zjc0YmU0OGQzZmU0NTUyYWNjZTQ5MSIsInVzZXJfaWQiOiI4In0.PMzcqFQ2lksPsG8p5F5soCjLl8pHIvTS-6we8SPcleE	2026-02-20 18:41:39.319963+05:30	2026-02-21 18:41:39+05:30	\N	a20177cac8f74be48d3fe4552acce491
2	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTY4MDQ3MywiaWF0IjoxNzcxNTk0MDczLCJqdGkiOiI0YmI0YzAzM2ZlOTU0MWZhOTJhMmE4N2JiMWE4ZmEwYiIsInVzZXJfaWQiOiI5In0.PfKXUH8stb8Fb13_rHtv02DEaM8hSB29rQb8qjcilnw	2026-02-20 18:57:53.378104+05:30	2026-02-21 18:57:53+05:30	\N	4bb4c033fe9541fa92a2a87bb1a8fa0b
3	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTY4MDUxNSwiaWF0IjoxNzcxNTk0MTE1LCJqdGkiOiIyODVjMWNlYWNjN2Y0YTU5YjgwYmZmNDQxNWJlNjQ5MiIsInVzZXJfaWQiOiIxMCJ9.ShqzNxhUejRfy1aFLuasxkSBOAEhubmzRkNRY2p7grY	2026-02-20 18:58:35.504756+05:30	2026-02-21 18:58:35+05:30	\N	285c1ceacc7f4a59b80bff4415be6492
4	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTY4MDcxMCwiaWF0IjoxNzcxNTk0MzEwLCJqdGkiOiI1ZDMyMDQ2YTgzNmE0MTdkYWIwZjczMjE2MDcxOTgzOCIsInVzZXJfaWQiOiIyIn0.lIjm8wl_kvb7ZisTRodJrsIyGaCd6O15f2oj40WA--k	2026-02-20 19:01:50.441938+05:30	2026-02-21 19:01:50+05:30	\N	5d32046a836a417dab0f732160719838
5	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTY4MDgyNiwiaWF0IjoxNzcxNTk0NDI2LCJqdGkiOiJhNmRhOWFjNWE1OTQ0OWJlODZkY2Q0MjE0NGVhNDc2ZSIsInVzZXJfaWQiOiIyIn0.N1rX6jGdQPxN_NjrFmCHYKdbVnLe3XNwjW_xhz_2Xp0	2026-02-20 19:03:46.823179+05:30	2026-02-21 19:03:46+05:30	\N	a6da9ac5a59449be86dcd42144ea476e
6	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTY4MDg3MCwiaWF0IjoxNzcxNTk0NDcwLCJqdGkiOiJkOGI4NjVjZTVhODI0NzRmODAwNWZmNjQxYzIxNWRhMyIsInVzZXJfaWQiOiI4In0.kSoMUAk66kyFPtLhw5DovgUxicsvrgm6igNWHJpEFFg	2026-02-20 19:04:30.083001+05:30	2026-02-21 19:04:30+05:30	\N	d8b865ce5a82474f8005ff641c215da3
7	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTY4MTEyNiwiaWF0IjoxNzcxNTk0NzI2LCJqdGkiOiJmMmVjYmM4NDJmN2I0ZmY3YjBhMDYzMjgyZTViOTE3MCIsInVzZXJfaWQiOiIyIn0.teL6GfiZGex4og6f0kbwlhuMBSQWxXHdn-SnM-0cWbc	2026-02-20 19:08:46.995682+05:30	2026-02-21 19:08:46+05:30	\N	f2ecbc842f7b4ff7b0a063282e5b9170
8	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTgyMzM4NCwiaWF0IjoxNzcxNzM2OTg0LCJqdGkiOiJmOGY1YTIxNjliMDE0NzhlOWM1NDllMDliOWNkYTExNyIsInVzZXJfaWQiOiIyIn0.0GpKKJDbZ9NRDMxgenemA_gLEWP66qI9fWb_mIUrlzc	2026-02-22 10:39:44.703031+05:30	2026-02-23 10:39:44+05:30	\N	f8f5a2169b01478e9c549e09b9cda117
9	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTgyNDg5MywiaWF0IjoxNzcxNzM4NDkzLCJqdGkiOiI2NjVjNjk1NTIyNTA0NjVmOTFmMTUwYzdjZGU5NjA3MCIsInVzZXJfaWQiOiIyIn0.cJeXQMLPwycgOJRqjlcmS-7zEt4XSCZfUL5FOOCx6HU	2026-02-22 11:04:53.016813+05:30	2026-02-23 11:04:53+05:30	\N	665c69552250465f91f150c7cde96070
10	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTg0OTE3MSwiaWF0IjoxNzcxNzYyNzcxLCJqdGkiOiI5MjY5YzM3ODdlNWQ0MmEzYmYzN2ZhNDk4YWExY2Q3NyIsInVzZXJfaWQiOiIyIn0.2lVTr1ogeBJY79NLu1SuXxU3Jhfvrrvvx3S2x9v_3V8	2026-02-22 17:49:31.825757+05:30	2026-02-23 17:49:31+05:30	\N	9269c3787e5d42a3bf37fa498aa1cd77
11	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTg1MTg0OSwiaWF0IjoxNzcxNzY1NDQ5LCJqdGkiOiJmZDM3ZDMyMDJkZmI0MzBlOTc1OTA2NDdjNDVkYTRlNiIsInVzZXJfaWQiOiI0In0.OSamI1pVuCAySXS6prZgQ7sFkwelxrdn_Udt5ocY1tU	2026-02-22 18:34:09.816202+05:30	2026-02-23 18:34:09+05:30	\N	fd37d3202dfb430e97590647c45da4e6
12	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTkzMzAyMSwiaWF0IjoxNzcxODQ2NjIxLCJqdGkiOiJlOGNhMGE1NzUwYmE0NGRmODdjMDFkNmI3NTFhZDRmNCIsInVzZXJfaWQiOiI0In0.I1qAYckkEn4rzmUK1-GIU2-mj9CBD482Vpu4dt22eL4	2026-02-23 17:07:01.951943+05:30	2026-02-24 17:07:01+05:30	\N	e8ca0a5750ba44df87c01d6b751ad4f4
13	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTkzNDU0MiwiaWF0IjoxNzcxODQ4MTQyLCJqdGkiOiJkYjdiMGI2ZTBmYWM0MGY1ODQwOTk2ZmU5NTI0MjFkMSIsInVzZXJfaWQiOiIyIn0.u8GHjGucaz1t2sm-rbbFNPASyFcoyjPiR17U7ITOUsM	2026-02-23 17:32:22.55054+05:30	2026-02-24 17:32:22+05:30	\N	db7b0b6e0fac40f5840996fe952421d1
14	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk1MDY5MCwiaWF0IjoxNzcxODY0MjkwLCJqdGkiOiJlOWZhOGZkOGNjZTU0MjE3OWQyZjZhZDVlZjVlMDJjYSIsInVzZXJfaWQiOiIyIn0.EjxsUIaV3tsfypDkWYzvyrgR7aPGUkEKpod-14p_lO4	2026-02-23 22:01:30.330819+05:30	2026-02-24 22:01:30+05:30	\N	e9fa8fd8cce542179d2f6ad5ef5e02ca
15	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MTk2NTA1MywiaWF0IjoxNzcxODc4NjUzLCJqdGkiOiIyNzgwYzE5MWQyM2Y0NmY2OTI5ZGQwOGU3MDJmMzZjNCIsInVzZXJfaWQiOiIyIn0.RY3Vo1DwD-PF6Fo2MN5vIsgIXZtT0syeRr2CYCg-5VI	2026-02-24 02:00:53.036447+05:30	2026-02-25 02:00:53+05:30	\N	2780c191d23f46f6929dd08e702f36c4
17	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA0MTI0MSwiaWF0IjoxNzcxOTU0ODQxLCJqdGkiOiI4MDMyNzVlMWViNjQ0ODc4ODVkOWViNjk1YTRhM2YwMSIsInVzZXJfaWQiOiIyIn0.KkvsTlveK4R2yfOoGWXxCXHdQcyg5dxUbIYipBtkHUU	2026-02-24 23:10:41.28805+05:30	2026-02-25 23:10:41+05:30	\N	803275e1eb64487885d9eb695a4a3f01
18	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA0MzIzNiwiaWF0IjoxNzcxOTU2ODM2LCJqdGkiOiIzYWI4ODJiZTFlNmU0ZGQzOWY4Y2U1ZWM5YWQwZDIyNyIsInVzZXJfaWQiOiIxMSJ9.E-jnOKVxSZllDxo1At9d_cGxeGjhAWhJAbrTdnM-SnY	2026-02-24 23:43:56.925547+05:30	2026-02-25 23:43:56+05:30	11	3ab882be1e6e4dd39f8ce5ec9ad0d227
19	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA0Mzc1MiwiaWF0IjoxNzcxOTU3MzUyLCJqdGkiOiJhYjdhM2UwYTQ5NDY0YzI0YTRmNzcwZTE5YjMxODQyOCIsInVzZXJfaWQiOiIxMSJ9.kf2RoPTiQapluxgqKC-lzwNIM3adT2P2vP6s5umTuWQ	2026-02-24 23:52:32.866681+05:30	2026-02-25 23:52:32+05:30	11	ab7a3e0a49464c24a4f770e19b318428
20	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA0Njg2OSwiaWF0IjoxNzcxOTYwNDY5LCJqdGkiOiJhMzZiMWIyNzhiZTM0NWE0YTE4NzNmYTk0MThkODg0NSIsInVzZXJfaWQiOiIxMSJ9.5vJJToxYR5p-1iujjsKKqIoBzXUlYWvnhhtZ4Umlc-c	2026-02-25 00:44:29.845824+05:30	2026-02-26 00:44:29+05:30	11	a36b1b278be345a4a1873fa9418d8845
21	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA0OTI2OCwiaWF0IjoxNzcxOTYyODY4LCJqdGkiOiI4YjlkM2FhZGU5NzI0OWU3ODU5NWFiNzliYTJlMTdkYSIsInVzZXJfaWQiOiIxMSJ9.sPOQHcORyCtwMaCmx05XetCjI2eQhlNLOHc0fqvQZoU	2026-02-25 01:24:28.47224+05:30	2026-02-26 01:24:28+05:30	11	8b9d3aade97249e78595ab79ba2e17da
22	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA4MzU1OSwiaWF0IjoxNzcxOTk3MTU5LCJqdGkiOiI3NDlmOThiYWVkMTI0ZmJlYjYyM2Q4MTlmNjRlMTg3YSIsInVzZXJfaWQiOiIxMSJ9.SfJnoQlD1xV2XlPDPrW5g2xQIwNoj-ebYBgCLdLqOpk	2026-02-25 10:55:59.241851+05:30	2026-02-26 10:55:59+05:30	11	749f98baed124fbeb623d819f64e187a
23	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA5MTQ1OCwiaWF0IjoxNzcyMDA1MDU4LCJqdGkiOiI2NzEwMDg3MThhZWE0Yjg1YWU0YmEzNTJjMDNhNDYyMyIsInVzZXJfaWQiOiIxMSJ9.nF8JcCH8cNJckPmwm8plK1gI7aV7f73PP4pEwVKKjME	2026-02-25 13:07:38.488737+05:30	2026-02-26 13:07:38+05:30	11	671008718aea4b85ae4ba352c03a4623
24	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA5MTc4NiwiaWF0IjoxNzcyMDA1Mzg2LCJqdGkiOiJlY2Q4NDE1ODQ4YmI0OWQwOTI0Njg1ZDczNzU3ZTViZSIsInVzZXJfaWQiOiIxMSJ9.-mgWn2R-81NbGMzH2kZT9K4YFDPCscb-WgYhyRU5tcw	2026-02-25 13:13:06.309909+05:30	2026-02-26 13:13:06+05:30	11	ecd8415848bb49d0924685d73757e5be
25	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA5NTQxNSwiaWF0IjoxNzcyMDA5MDE1LCJqdGkiOiIyNmUyYWJkNTk5MTE0Zjc4OGMyNmRmYjg0YzAxYjMzYyIsInVzZXJfaWQiOiIxMSJ9.EpECtAGW_VOzOJB8jKLKuFFu9stxMQslIf946eWR8qk	2026-02-25 14:13:35.35572+05:30	2026-02-26 14:13:35+05:30	11	26e2abd599114f788c26dfb84c01b33c
26	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA5Njc2MywiaWF0IjoxNzcyMDEwMzYzLCJqdGkiOiJkZGM0OWJhYTUyZWU0NzZlODBlZDU2NzhlYTVmNjUzNiIsInVzZXJfaWQiOiIxMiJ9.jEvJFo6fbjcz0XaBAOk0KT-hczxjKnAnQaUm_YdT8_w	2026-02-25 14:36:03.842239+05:30	2026-02-26 14:36:03+05:30	12	ddc49baa52ee476e80ed5678ea5f6536
27	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA5NjgyMywiaWF0IjoxNzcyMDEwNDIzLCJqdGkiOiI2MDY5YmJmNzVhMzI0Nzg1ODdjNGNjNjZmZjUyZjUzMiIsInVzZXJfaWQiOiIxMyJ9.PokXPOTtbVo0oNU_f-8Ka3nKv57o0txD8PwCuX_N_H8	2026-02-25 14:37:03.087598+05:30	2026-02-26 14:37:03+05:30	13	6069bbf75a32478587c4cc66ff52f532
28	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjA5NzE0MCwiaWF0IjoxNzcyMDEwNzQwLCJqdGkiOiJiMmZiYThhOWExYjk0NTY2OGExYzIyOWIyMzIwZTZhZSIsInVzZXJfaWQiOiIxMSJ9.aHtCH_94RQZgRNJ3mDNjm1zTaNCjYabNipq60UPkdWs	2026-02-25 14:42:20.362165+05:30	2026-02-26 14:42:20+05:30	11	b2fba8a9a1b945668a1c229b2320e6ae
29	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEwMzYyMiwiaWF0IjoxNzcyMDE3MjIyLCJqdGkiOiIzNjIzMzM1YzZhNDg0OTMxODc5YTNmZjkwODRmOWU4OSIsInVzZXJfaWQiOiIxMSJ9.IKdSB4rNAOjIkfOq9F9POqRK7GZImrHhXluAwENGgTM	2026-02-25 16:30:22.570151+05:30	2026-02-26 16:30:22+05:30	11	3623335c6a484931879a3ff9084f9e89
30	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEwMzkzNCwiaWF0IjoxNzcyMDE3NTM0LCJqdGkiOiI2OGJkODE3NWYyMzc0ZTliYjM5YTVlODJlMDYwMzgxMSIsInVzZXJfaWQiOiIxMSJ9.meN8K-HXeo5_ExcQcLwvvI40fAgxX-3Y1I2s5qxOdP8	2026-02-25 16:35:34.024768+05:30	2026-02-26 16:35:34+05:30	11	68bd8175f2374e9bb39a5e82e0603811
31	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEwNTEyOSwiaWF0IjoxNzcyMDE4NzI5LCJqdGkiOiJhNGJjNDczMmE2NGE0OGU2YjU2NWY5OWViOWFhMGQ1NyIsInVzZXJfaWQiOiIxMSJ9.qxbhO9arJ24dV2dOvV3FmocRopxoMBSLBryXJN9D710	2026-02-25 16:55:29.762378+05:30	2026-02-26 16:55:29+05:30	11	a4bc4732a64a48e6b565f99eb9aa0d57
32	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEwODc4NSwiaWF0IjoxNzcyMDIyMzg1LCJqdGkiOiI4YWQ1MmY4OThjOGY0ZjFlODk4NDRlNDRlZjRlNzFhZiIsInVzZXJfaWQiOiIxMSJ9.lC4CY5GYbEpqvEyBM6z6GnwnHF2WNxkLAbuyiIj_aKo	2026-02-25 17:56:25.519007+05:30	2026-02-26 17:56:25+05:30	11	8ad52f898c8f4f1e89844e44ef4e71af
33	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjExMTM1NywiaWF0IjoxNzcyMDI0OTU3LCJqdGkiOiIxZGFlM2Q2ODVlMGY0YmQ0OGFjYmMwNWFmYTEwNGUxNCIsInVzZXJfaWQiOiIxMSJ9.CGNezzF1KDwHA96z5l8eMz_mK1FUbFjz01G_H9SN93c	2026-02-25 18:39:17.01873+05:30	2026-02-26 18:39:17+05:30	11	1dae3d685e0f4bd48acbc05afa104e14
34	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjExMzgyNCwiaWF0IjoxNzcyMDI3NDI0LCJqdGkiOiJkOGJiZTAzNzg3YWQ0ZjkxOTQzZjY1ZWU0ODAxNTY4NCIsInVzZXJfaWQiOiIxMSJ9.A_K6PyaudXGUOhUlO4gQ2Yc7Kd91cFm8o8Jwd62eA6U	2026-02-25 19:20:24.593882+05:30	2026-02-26 19:20:24+05:30	11	d8bbe03787ad4f91943f65ee48015684
35	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjExNzYxNiwiaWF0IjoxNzcyMDMxMjE2LCJqdGkiOiIwOTdjMWYzOTJmYjg0ODI4OWQwMDUzZDQwMzJhZDhhMCIsInVzZXJfaWQiOiIxMSJ9.x2Zzbt0z2wl6B1agrgwY9u62pHKpQ-WA-BFoSj48VAM	2026-02-25 20:23:36.557935+05:30	2026-02-26 20:23:36+05:30	11	097c1f392fb848289d0053d4032ad8a0
36	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEyMTk4NywiaWF0IjoxNzcyMDM1NTg3LCJqdGkiOiJiZTM2M2FkZjg3YWU0MTFkOGM2YjI0ZjllYTE2NTdjNiIsInVzZXJfaWQiOiIxMSJ9.EMzngwUDTbRKyBRSSzTZ7_wVhnB46CXVnTmAACi0Z6Y	2026-02-25 21:36:27.743544+05:30	2026-02-26 21:36:27+05:30	11	be363adf87ae411d8c6b24f9ea1657c6
37	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEyMzA5MiwiaWF0IjoxNzcyMDM2NjkyLCJqdGkiOiI4NzdlODI5Mjk2Njc0MzEyYWZhNDk1YWQ0YWYyMzZjNSIsInVzZXJfaWQiOiIxMSJ9.xAWJ9fOKbHFPNPH9zvUvwIasHGBFEXR9tT94P-Nshrw	2026-02-25 21:54:52.936345+05:30	2026-02-26 21:54:52+05:30	11	877e829296674312afa495ad4af236c5
38	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEyNTM3MywiaWF0IjoxNzcyMDM4OTczLCJqdGkiOiI4MTVmYjY1MGFmZDI0Zjg2ODIzMDBiMjZiMTEzNTk2YiIsInVzZXJfaWQiOiIxNSJ9.NLfW3lfPv7uCwRwkTA2bRV9nwJA58fRIvMKbWx3EDSA	2026-02-25 22:32:53.485675+05:30	2026-02-26 22:32:53+05:30	15	815fb650afd24f8682300b26b113596b
39	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEyNTczNiwiaWF0IjoxNzcyMDM5MzM2LCJqdGkiOiJjYWVmYTBhMjU2MWQ0Mzk0YTFkNDc0ODU4OTQ3ODAwYyIsInVzZXJfaWQiOiIxMSJ9.LWFxhofsX8oY94xiS6McUoqP4Dg0ioi3ZdzzT5COlCM	2026-02-25 22:38:56.618417+05:30	2026-02-26 22:38:56+05:30	11	caefa0a2561d4394a1d474858947800c
40	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEyOTYwNCwiaWF0IjoxNzcyMDQzMjA0LCJqdGkiOiJjOTM4OTcyOGQzMGI0YjA1OTQ5MmMyMjYyZmE0MTk1NCIsInVzZXJfaWQiOiIxMSJ9.M4lr4azioREeVRMiBu26TQeCLvobgDUmztEkeEL7f-Y	2026-02-25 23:43:24.199927+05:30	2026-02-26 23:43:24+05:30	11	c9389728d30b4b059492c2262fa41954
41	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNTEwNiwiaWF0IjoxNzcyMDQ4NzA2LCJqdGkiOiJiNzVlZDI2Yjk3MGM0Njc3YTBhNTc3YzdkODU5YzY0MiIsInVzZXJfaWQiOiIxMSJ9.ts_WR9BpVZ7C9Hyk2WoW4kHcod_AdwDGHprxPbQtsNI	2026-02-26 01:15:06.364947+05:30	2026-02-27 01:15:06+05:30	11	b75ed26b970c4677a0a577c7d859c642
42	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNjE4NCwiaWF0IjoxNzcyMDQ5Nzg0LCJqdGkiOiJkMzFkMzU4Yjg4ZjU0M2IxYjI5NTAyMzIxNmM3MTk4NCIsInVzZXJfaWQiOiIxMSJ9.x2FWyJnZm-qb28wPCpbKwTWGqIXPvgk16g-eV_s1Wf8	2026-02-26 01:33:04.92544+05:30	2026-02-27 01:33:04+05:30	11	d31d358b88f543b1b295023216c71984
43	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNjc4OSwiaWF0IjoxNzcyMDUwMzg5LCJqdGkiOiI1ZDBiYTQxODQzZWQ0MjdlYmMwZWEwYWMxYThiNjI1ZCIsInVzZXJfaWQiOiIxMSJ9.kcsQM1bYdkLT5a2ySCj5hhA_hPkZiQ7MKnJBSg8zit8	2026-02-26 01:43:09.141718+05:30	2026-02-27 01:43:09+05:30	11	5d0ba41843ed427ebc0ea0ac1a8b625d
44	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNjgzMiwiaWF0IjoxNzcyMDUwNDMyLCJqdGkiOiI5OTkyMGM1OTIxMzI0MDljYTljMTM3MTE0YmM2M2Y3MyIsInVzZXJfaWQiOiIxNiJ9.nVSvtNkHLbjZhwZGME54Cp4yuJvHmlENlYU0iLT0mWs	2026-02-26 01:43:52.481564+05:30	2026-02-27 01:43:52+05:30	16	99920c592132409ca9c137114bc63f73
45	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNzY4MCwiaWF0IjoxNzcyMDUxMjgwLCJqdGkiOiIxODIyODg5MGI0MWI0YjBmYjU4MDNhYzRlYmE2ODQ1ZiIsInVzZXJfaWQiOiIxMSJ9.UOVDqhbCpaLbHzZTx27GPntcxlMuMPBYkiShzKh4x3g	2026-02-26 01:58:00.834756+05:30	2026-02-27 01:58:00+05:30	11	18228890b41b4b0fb5803ac4eba6845f
46	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNzkwNSwiaWF0IjoxNzcyMDUxNTA1LCJqdGkiOiJkNjkxMDMzYjRiNzU0ODhmYTczYTI2MWEwYTUyZTJhZiIsInVzZXJfaWQiOiIxNyJ9.4hApLuFqSTEJMeK0wGyJRb-5MfRsN2PsKa0-0T3Uj1Y	2026-02-26 02:01:45.408875+05:30	2026-02-27 02:01:45+05:30	17	d691033b4b75488fa73a261a0a52e2af
47	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNzkwNiwiaWF0IjoxNzcyMDUxNTA2LCJqdGkiOiIxODUxMGFkZDhiZGI0M2U4OWY1ZmE1YmQzZTI0YWI3YyIsInVzZXJfaWQiOiIxNyJ9.Ja_YGSgL9HdNrORG_KZ3M_SmeF8rJg41Z9S2Y5Iy8DA	2026-02-26 02:01:46.738884+05:30	2026-02-27 02:01:46+05:30	17	18510add8bdb43e89f5fa5bd3e24ab7c
48	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjEzNzk0MSwiaWF0IjoxNzcyMDUxNTQxLCJqdGkiOiIwMjhkZTk4YzcyMjI0YWM0ODRiNzU4YjI3ZTlkYTg5MyIsInVzZXJfaWQiOiIxMSJ9.a0frC66jvQfhtlzJjK1DNr57iLF7Fb79Kk0lZDO0gpU	2026-02-26 02:02:21.022332+05:30	2026-02-27 02:02:21+05:30	11	028de98c72224ac484b758b27e9da893
49	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjE2MzIxNiwiaWF0IjoxNzcyMDc2ODE2LCJqdGkiOiI2ZTY0YTI5MjI3Y2Q0ZWZjOWVlYzM2ZTA3NmY5NzAzMCIsInVzZXJfaWQiOiIxMSJ9.Y_UeobrSk07t9oVHrUQ9O5vamdIPW4c3V4ikBr-UBw4	2026-02-26 09:03:36.319004+05:30	2026-02-27 09:03:36+05:30	11	6e64a29227cd4efc9eec36e076f97030
50	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjE2NjYwMCwiaWF0IjoxNzcyMDgwMjAwLCJqdGkiOiIxNGVlNWZkODU0MTk0ZTI2YmI3MzZjYWMyNjU3NTRlMCIsInVzZXJfaWQiOiIxMSJ9.TrXqGx3J1z8HJodMryykD8Nsx1yXPN3qk1jc09TsRuY	2026-02-26 10:00:00.198462+05:30	2026-02-27 10:00:00+05:30	11	14ee5fd854194e26bb736cac265754e0
51	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjE2Njc3MywiaWF0IjoxNzcyMDgwMzczLCJqdGkiOiIyN2M5NDRkNTU1MGI0MmFkOTZiZDQ3OWU2ZDQ4NWFkNCIsInVzZXJfaWQiOiIxMSJ9.C9QyRWoVuigewfOuw541fS3s3gcGGJT3Oddpx79YU0I	2026-02-26 10:02:53.080813+05:30	2026-02-27 10:02:53+05:30	11	27c944d5550b42ad96bd479e6d485ad4
52	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjE2OTU0MSwiaWF0IjoxNzcyMDgzMTQxLCJqdGkiOiJiYTA3ZmE2ZDk0YTQ0YjgwOTdkMjJjYWQ1ZDU1ZTlmNCIsInVzZXJfaWQiOiIxOCJ9.DXmLmTnHjhhyLi5LvJI4l7o2tCMUAFLSH0qX_snC5ow	2026-02-26 10:49:01.746152+05:30	2026-02-27 10:49:01+05:30	18	ba07fa6d94a44b8097d22cad5d55e9f4
53	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjE2OTU0MywiaWF0IjoxNzcyMDgzMTQzLCJqdGkiOiI1Y2JmMDUwNjc4MGU0ZDI5YTNjYjFhMThjNTY0OWUxZSIsInVzZXJfaWQiOiIxOCJ9.bM-jDNx0Q4i1TQteiA_65pm2XuOSl1APjaqMxcSeBIo	2026-02-26 10:49:03.329469+05:30	2026-02-27 10:49:03+05:30	18	5cbf0506780e4d29a3cb1a18c5649e1e
54	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjE3MDA2NiwiaWF0IjoxNzcyMDgzNjY2LCJqdGkiOiI2ZmM3MzM2OGU1MTY0MzdhOWFhMDg0MzQ1M2EwMzZmZCIsInVzZXJfaWQiOiIxMSJ9.btSEDkIf0sIJ4gO4v35L_fL3ffjM9gz2WwXSL1HL_28	2026-02-26 10:57:46.937416+05:30	2026-02-27 10:57:46+05:30	11	6fc73368e516437a9aa0843453a036fd
55	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjY4OTg0MCwiaWF0IjoxNzcyMDg1MDQwLCJqdGkiOiIwMmZlZGEyODcxYjE0YWYzYmQwOGNlMzZmZmZiNzFhMyIsInVzZXJfaWQiOiIxMSJ9.ftP6vJ6gDBYY4cOrA9l4g9DvKDBpxV1DabdDUFGc2LA	2026-02-26 11:20:40.626097+05:30	2026-03-05 11:20:40+05:30	11	02feda2871b14af3bd08ce36fffb71a3
56	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjY5NDgwNiwiaWF0IjoxNzcyMDkwMDA2LCJqdGkiOiI5M2ZkMDI3OGUzYTU0M2I1OGE0ZWUxZmEyOWM1YmFhNSIsInVzZXJfaWQiOiIxMSJ9.mQP80kDuPFim8dBI2tQA-FMAlRbAMMm4uIhY-nwtdP4	2026-02-26 12:43:26.246614+05:30	2026-03-05 12:43:26+05:30	11	93fd0278e3a543b58a4ee1fa29c5baa5
57	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjY5Njk2OCwiaWF0IjoxNzcyMDkyMTY4LCJqdGkiOiI1ZGE4MjA4ZWQyMTQ0ODQwYThiNGY5ZWI0NjJkN2IwOCIsInVzZXJfaWQiOiIxOSJ9.Oto7RUmYmZG5Rkzx0XtEmDEdTaTe-msw-SbtfdIS60E	2026-02-26 13:19:28.095082+05:30	2026-03-05 13:19:28+05:30	19	5da8208ed2144840a8b4f9eb462d7b08
58	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjY5Njk2OSwiaWF0IjoxNzcyMDkyMTY5LCJqdGkiOiJjMWMxMWZiMGU5MWI0OWI5ODNiZWMzM2UyYTY0MDE1MCIsInVzZXJfaWQiOiIxOSJ9.m1E0kgJv2poUTceTvvkW9R5325YiHzlYqmzCnSr05bA	2026-02-26 13:19:29.580317+05:30	2026-03-05 13:19:29+05:30	19	c1c11fb0e91b49b983bec33e2a640150
59	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjY5ODEzNiwiaWF0IjoxNzcyMDkzMzM2LCJqdGkiOiJkMGJiOTQ5ZDY1YTY0ZGUwODFjNGQyZmQ4ZDExMmFlMCIsInVzZXJfaWQiOiIxMSJ9.NJzsKkAGUvv0jbBldGw4JLX-dCqr2jXVuBJ8nJYETqQ	2026-02-26 13:38:56.170476+05:30	2026-03-05 13:38:56+05:30	11	d0bb949d65a64de081c4d2fd8d112ae0
60	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjY5ODIzOSwiaWF0IjoxNzcyMDkzNDM5LCJqdGkiOiI3NWJkOWNhNDViYTQ0NDRiYTRjZDBkNDExNTUwZDNjYyIsInVzZXJfaWQiOiIyMCJ9.zRpSc_lBMhj6eVGBh2j390mSIB2SU93SJ0Xsp-y4LPE	2026-02-26 13:40:39.81398+05:30	2026-03-05 13:40:39+05:30	20	75bd9ca45ba4444ba4cd0d411550d3cc
61	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjY5ODI0MSwiaWF0IjoxNzcyMDkzNDQxLCJqdGkiOiI0Y2E1M2VhN2I2OTI0YTIxYTg3NzVmZDRlYjQ5OTUwYyIsInVzZXJfaWQiOiIyMCJ9.bXHd5L7s8QOzKuw03dEBpLWW8hFqQv9gynwV5alt6aI	2026-02-26 13:40:41.962105+05:30	2026-03-05 13:40:41+05:30	20	4ca53ea7b6924a21a8775fd4eb49950c
62	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjczMjE2MCwiaWF0IjoxNzcyMTI3MzYwLCJqdGkiOiJkMGNjY2FmNmMzZDU0YjVhOGE3OTZmZGYyZmRmN2U0ZiIsInVzZXJfaWQiOiIxMSJ9.pcFCb8ScPI7Rq6D4OSdTLYTvXTCo2xVJnDLtmmOwXYY	2026-02-26 23:06:00.208548+05:30	2026-03-05 23:06:00+05:30	11	d0cccaf6c3d54b5a8a796fdf2fdf7e4f
63	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjczMjcyNiwiaWF0IjoxNzcyMTI3OTI2LCJqdGkiOiIxYTI5YWFhMzY4ODI0MmI0OTQ0NGU5Mjg3MTIwN2YxYyIsInVzZXJfaWQiOiIxOCJ9.Xb_Fidpe5no0kwLCb4Rx5ciRIBcOxnHViROCEqTriKA	2026-02-26 23:15:26.114823+05:30	2026-03-05 23:15:26+05:30	18	1a29aaa3688242b49444e92871207f1c
64	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjczMjc4NCwiaWF0IjoxNzcyMTI3OTg0LCJqdGkiOiI1MGRhNDA2ZDJmMzg0NzY3YjEwOTQ2OWE1OWExNzI2NCIsInVzZXJfaWQiOiIxMSJ9.QO7yB6ZkR2YuwGzBKnnRCJovPTrIYvodK7_NXupnYrc	2026-02-26 23:16:24.805098+05:30	2026-03-05 23:16:24+05:30	11	50da406d2f384767b109469a59a17264
65	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjgyMDY2MCwiaWF0IjoxNzcyMjE1ODYwLCJqdGkiOiI0NTQ0MWU1MWYxNzE0YWZmODY1OTE2Y2VlNzc1MDFmOCIsInVzZXJfaWQiOiIxMSJ9.xtrhXqimBYKOVpmUCpnfrYyCyNTLxRDyWdLza5mpeeU	2026-02-27 23:41:00.392686+05:30	2026-03-06 23:41:00+05:30	11	45441e51f1714aff865916cee77501f8
66	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjgyNDI2OCwiaWF0IjoxNzcyMjE5NDY4LCJqdGkiOiIxZjQ2NWRmOTZlOGY0NTI2YjliMmU1YTdhMzY0MzJlMyIsInVzZXJfaWQiOiIxMSJ9.6qH-XH1-H53_bgAuWEObOEISZSBbZf1N1XOgdwD3QD8	2026-02-28 00:41:08.106582+05:30	2026-03-07 00:41:08+05:30	11	1f465df96e8f4526b9b2e5a7a36432e3
67	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MjgyNzkwNSwiaWF0IjoxNzcyMjIzMTA1LCJqdGkiOiI4MWY5YWY2YjZkY2Y0YzFjOWM4N2YyOGY3YjJlMmRkMSIsInVzZXJfaWQiOiIxMSJ9._cs4irNUoUL1AJaYai9QUyqCnhFavqGqCme_q5N3B1Y	2026-02-28 01:41:45.511526+05:30	2026-03-07 01:41:45+05:30	11	81f9af6b6dcf4c1c9c87f28f7b2e2dd1
68	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3Mjk2MDA5NywiaWF0IjoxNzcyMzU1Mjk3LCJqdGkiOiJjYzEyMzhhZGQ4MmY0ZTFjOTUwYWJhM2Q1MDY4MDFhOSIsInVzZXJfaWQiOiIxMSJ9.vm0iRuUzXQLS2Dh1p5rycAs7aLO_eOzDx8XPcBVFteE	2026-03-01 14:24:57.506857+05:30	2026-03-08 14:24:57+05:30	11	cc1238add82f4e1c950aba3d506801a9
69	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQyNTQwNywiaWF0IjoxNzcyODIwNjA3LCJqdGkiOiI4YWZjMmU4NjZlYzk0YzEzYmVkZmQyYWYwNDZmY2FlMyIsInVzZXJfaWQiOiIxMSJ9._4VL3UMCZCbAMjx6TgWPj21CNl0SUfqFt_bWkjgAGFM	2026-03-06 23:40:07.255208+05:30	2026-03-13 23:40:07+05:30	11	8afc2e866ec94c13bedfd2af046fcae3
70	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQyNTQ0MSwiaWF0IjoxNzcyODIwNjQxLCJqdGkiOiI3NDU1N2EyMjVlNWQ0ZDU5OGQ5MDIwZmE4MGQ2OTMzZSIsInVzZXJfaWQiOiIxMiJ9.BdHHUXtPKeV5smAvO4RVFpCJAEffZsTDgN1P7yqVNx0	2026-03-06 23:40:41.497883+05:30	2026-03-13 23:40:41+05:30	12	74557a225e5d4d598d9020fa80d6933e
71	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ2NTM4OCwiaWF0IjoxNzcyODYwNTg4LCJqdGkiOiI2N2YwNDBlNzZlMzg0MjkwYjgzOTk0ZGJmY2UzNjVjMiIsInVzZXJfaWQiOiIxMSJ9.HrpOM-6bZwnOMAlYncovjmVWPK7Tp5XD_UppKOA6pFA	2026-03-07 10:46:28.266156+05:30	2026-03-14 10:46:28+05:30	11	67f040e76e384290b83994dbfce365c2
72	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ2NjAwNSwiaWF0IjoxNzcyODYxMjA1LCJqdGkiOiI5NjM4OWZhZDhkZjY0M2QyOGFlNGI0ZjE3ZWQzY2FiNyIsInVzZXJfaWQiOiIxMiJ9.7lX_NFya2g-cLvEywdW7WpRYmHmqZClGQcO0hyf-n64	2026-03-07 10:56:45.505844+05:30	2026-03-14 10:56:45+05:30	12	96389fad8df643d28ae4b4f17ed3cab7
73	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ2NjU0OSwiaWF0IjoxNzcyODYxNzQ5LCJqdGkiOiJhNzE4OTNmYTdiN2Q0ZWMzYWNkZTJiMTlkYTU5MWE0NSIsInVzZXJfaWQiOiIxOCJ9.ddETppnBoTxjJKRZSdi4lCW5r7GYKeeWqtxhFG5MvXU	2026-03-07 11:05:49.958299+05:30	2026-03-14 11:05:49+05:30	18	a71893fa7b7d4ec3acde2b19da591a45
74	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ2Nzc3MCwiaWF0IjoxNzcyODYyOTcwLCJqdGkiOiJjODliMDJjMmQ0Zjc0NWM5ODRlMzJhOWJhNTgzMDViOCIsInVzZXJfaWQiOiIxOCJ9.EnadjxgbvjBQSTK3qJJQTr8I-wsZi8ooTLkE8ieobyo	2026-03-07 11:26:10.765323+05:30	2026-03-14 11:26:10+05:30	18	c89b02c2d4f745c984e32a9ba58305b8
75	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ2OTA3NywiaWF0IjoxNzcyODY0Mjc3LCJqdGkiOiIwMGY2NTFjMDIwYTQ0MDI2ODlmYWUwZTA3YjFjZjQ4YSIsInVzZXJfaWQiOiIxOCJ9.uV_nQu_xIYDY3t0PHEjJpHhiRS_285N_pWioa8gm6SM	2026-03-07 11:47:57.429063+05:30	2026-03-14 11:47:57+05:30	18	00f651c020a4402689fae0e07b1cf48a
76	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ2OTU4MiwiaWF0IjoxNzcyODY0NzgyLCJqdGkiOiI4YmI4YTlkYWY2OTE0ZjZiODM0YWVmMDU1MWUwOGM3OCIsInVzZXJfaWQiOiIxMSJ9.AhbzwRAyvsMQlRInwL4WcE8Khvntg_TKmnUMmfnqeWQ	2026-03-07 11:56:22.241137+05:30	2026-03-14 11:56:22+05:30	11	8bb8a9daf6914f6b834aef0551e08c78
77	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ3MDYzOSwiaWF0IjoxNzcyODY1ODM5LCJqdGkiOiJhMzJlODE2MDc2YWM0NzdlYTQ2M2E2N2E0ZTZhZWY0YSIsInVzZXJfaWQiOiIxMiJ9.vvm96Th5hR4zyZ_M4T1G32d4varxbE5FMALyvan2Xvo	2026-03-07 12:13:59.25982+05:30	2026-03-14 12:13:59+05:30	12	a32e816076ac477ea463a67a4e6aef4a
78	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ3MTMwMSwiaWF0IjoxNzcyODY2NTAxLCJqdGkiOiI2MzY5MDY3YjJjMDQ0YTdhYmRhYzQ0ZTAyY2UzZjdjOCIsInVzZXJfaWQiOiIxMiJ9.gGHFs51fII1twcXktc7gzuRiF4svxgvZARRBSJBnmFA	2026-03-07 12:25:01.359075+05:30	2026-03-14 12:25:01+05:30	12	6369067b2c044a7abdac44e02ce3f7c8
79	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ3MjA0NSwiaWF0IjoxNzcyODY3MjQ1LCJqdGkiOiIzMDNhMDIwYmRkYzM0ZjdmODEzNmMwN2FlYjI0ZWM1MyIsInVzZXJfaWQiOiIxNCJ9.ewnB-RzPsLXTN-xCAB0pftpqcxkJA73mSHndM754QcM	2026-03-07 12:37:25.703001+05:30	2026-03-14 12:37:25+05:30	14	303a020bddc34f7f8136c07aeb24ec53
80	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc3MzQ3MjYwNSwiaWF0IjoxNzcyODY3ODA1LCJqdGkiOiJhODM1OGY4MTNiZTQ0NGVjYmM5ZDJjZTdkMjk4OGQ0NCIsInVzZXJfaWQiOiIxOCJ9.dcN8H-RlS-MHpn3XPlIue09_h2nZDExjo80AReSeMFA	2026-03-07 12:46:45.146391+05:30	2026-03-14 12:46:45+05:30	18	a8358f813be444ecbc9d2ce7d2988d44
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 56, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 20, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 39, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 13, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 36, true);


--
-- Name: tasks_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_activity_id_seq', 274, true);


--
-- Name: tasks_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_comment_id_seq', 75, true);


--
-- Name: tasks_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_notifications_id_seq', 15, true);


--
-- Name: tasks_project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_project_id_seq', 23, true);


--
-- Name: tasks_project_team_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_project_team_members_id_seq', 58, true);


--
-- Name: tasks_task_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_task_id_seq', 106, true);


--
-- Name: token_blacklist_blacklistedtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_blacklist_blacklistedtoken_id_seq', 1, false);


--
-- Name: token_blacklist_outstandingtoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_blacklist_outstandingtoken_id_seq', 80, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: tasks_activity tasks_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_activity
    ADD CONSTRAINT tasks_activity_pkey PRIMARY KEY (id);


--
-- Name: tasks_comment tasks_comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_comment
    ADD CONSTRAINT tasks_comment_pkey PRIMARY KEY (id);


--
-- Name: tasks_notification tasks_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_notification
    ADD CONSTRAINT tasks_notifications_pkey PRIMARY KEY (id);


--
-- Name: tasks_project tasks_project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_project
    ADD CONSTRAINT tasks_project_pkey PRIMARY KEY (id);


--
-- Name: tasks_project_team_members tasks_project_team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_project_team_members
    ADD CONSTRAINT tasks_project_team_members_pkey PRIMARY KEY (id);


--
-- Name: tasks_project_team_members tasks_project_team_members_project_id_user_id_74e6a210_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_project_team_members
    ADD CONSTRAINT tasks_project_team_members_project_id_user_id_74e6a210_uniq UNIQUE (project_id, user_id);


--
-- Name: tasks_task tasks_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_task
    ADD CONSTRAINT tasks_task_pkey PRIMARY KEY (id);


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blacklistedtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blacklistedtoken_pkey PRIMARY KEY (id);


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blacklistedtoken_token_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blacklistedtoken_token_id_key UNIQUE (token_id);


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq UNIQUE (jti);


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outstandingtoken_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outstandingtoken_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: tasks_activity_project_id_615af84d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_activity_project_id_615af84d ON public.tasks_activity USING btree (project_id);


--
-- Name: tasks_activity_user_id_5050826c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_activity_user_id_5050826c ON public.tasks_activity USING btree (user_id);


--
-- Name: tasks_comment_task_id_8e8bc4fe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_comment_task_id_8e8bc4fe ON public.tasks_comment USING btree (task_id);


--
-- Name: tasks_comment_user_id_13cb3eb1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_comment_user_id_13cb3eb1 ON public.tasks_comment USING btree (user_id);


--
-- Name: tasks_notification_task_id_0e908a3c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_notification_task_id_0e908a3c ON public.tasks_notification USING btree (task_id);


--
-- Name: tasks_notifications_recipient_id_df5633b7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_notifications_recipient_id_df5633b7 ON public.tasks_notification USING btree (recipient_id);


--
-- Name: tasks_project_created_by_id_91543690; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_project_created_by_id_91543690 ON public.tasks_project USING btree (created_by_id);


--
-- Name: tasks_project_team_members_project_id_c2108215; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_project_team_members_project_id_c2108215 ON public.tasks_project_team_members USING btree (project_id);


--
-- Name: tasks_project_team_members_user_id_5e8f8768; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_project_team_members_user_id_5e8f8768 ON public.tasks_project_team_members USING btree (user_id);


--
-- Name: tasks_task_assigned_to_id_e8821f61; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_task_assigned_to_id_e8821f61 ON public.tasks_task USING btree (assigned_to_id);


--
-- Name: tasks_task_created_by_id_1345568a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_task_created_by_id_1345568a ON public.tasks_task USING btree (created_by_id);


--
-- Name: tasks_task_project_id_a2815f0c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_task_project_id_a2815f0c ON public.tasks_task USING btree (project_id);


--
-- Name: token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_like ON public.token_blacklist_outstandingtoken USING btree (jti varchar_pattern_ops);


--
-- Name: token_blacklist_outstandingtoken_user_id_83bc629a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX token_blacklist_outstandingtoken_user_id_83bc629a ON public.token_blacklist_outstandingtoken USING btree (user_id);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_activity tasks_activity_project_id_615af84d_fk_tasks_project_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_activity
    ADD CONSTRAINT tasks_activity_project_id_615af84d_fk_tasks_project_id FOREIGN KEY (project_id) REFERENCES public.tasks_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_activity tasks_activity_user_id_5050826c_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_activity
    ADD CONSTRAINT tasks_activity_user_id_5050826c_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_comment tasks_comment_task_id_8e8bc4fe_fk_tasks_task_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_comment
    ADD CONSTRAINT tasks_comment_task_id_8e8bc4fe_fk_tasks_task_id FOREIGN KEY (task_id) REFERENCES public.tasks_task(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_comment tasks_comment_user_id_13cb3eb1_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_comment
    ADD CONSTRAINT tasks_comment_user_id_13cb3eb1_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_notification tasks_notification_task_id_0e908a3c_fk_tasks_task_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_notification
    ADD CONSTRAINT tasks_notification_task_id_0e908a3c_fk_tasks_task_id FOREIGN KEY (task_id) REFERENCES public.tasks_task(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_notification tasks_notifications_recipient_id_df5633b7_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_notification
    ADD CONSTRAINT tasks_notifications_recipient_id_df5633b7_fk_auth_user_id FOREIGN KEY (recipient_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_project tasks_project_created_by_id_91543690_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_project
    ADD CONSTRAINT tasks_project_created_by_id_91543690_fk_auth_user_id FOREIGN KEY (created_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_project_team_members tasks_project_team_m_project_id_c2108215_fk_tasks_pro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_project_team_members
    ADD CONSTRAINT tasks_project_team_m_project_id_c2108215_fk_tasks_pro FOREIGN KEY (project_id) REFERENCES public.tasks_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_project_team_members tasks_project_team_members_user_id_5e8f8768_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_project_team_members
    ADD CONSTRAINT tasks_project_team_members_user_id_5e8f8768_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_task tasks_task_assigned_to_id_e8821f61_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_task
    ADD CONSTRAINT tasks_task_assigned_to_id_e8821f61_fk_auth_user_id FOREIGN KEY (assigned_to_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_task tasks_task_created_by_id_1345568a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_task
    ADD CONSTRAINT tasks_task_created_by_id_1345568a_fk_auth_user_id FOREIGN KEY (created_by_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: tasks_task tasks_task_project_id_a2815f0c_fk_tasks_project_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_task
    ADD CONSTRAINT tasks_task_project_id_a2815f0c_fk_tasks_project_id FOREIGN KEY (project_id) REFERENCES public.tasks_project(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: token_blacklist_blacklistedtoken token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_blacklistedtoken
    ADD CONSTRAINT token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk FOREIGN KEY (token_id) REFERENCES public.token_blacklist_outstandingtoken(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: token_blacklist_outstandingtoken token_blacklist_outs_user_id_83bc629a_fk_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token_blacklist_outstandingtoken
    ADD CONSTRAINT token_blacklist_outs_user_id_83bc629a_fk_auth_user FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict eearibwbhtzfyzY7ZoKWoQSsvacTBdCCE5GmfHFou08edJBWLGpZgVMr1kVC3gQ

