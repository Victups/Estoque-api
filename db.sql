--
-- PostgreSQL database dump
--

\restrict ad8I00bBQkqImqnp58do51vL6Y5OkRNCVy6KCcDDOD004EVL0UohSpXDIn8tLbh

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

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

--
-- Name: movimento_tipo_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.movimento_tipo_enum AS ENUM (
    'entrada',
    'saida'
);


ALTER TYPE public.movimento_tipo_enum OWNER TO postgres;

--
-- Name: role_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.role_enum AS ENUM (
    'admin',
    'gestor',
    'estoquista',
    'relatorios'
);


ALTER TYPE public.role_enum OWNER TO postgres;

--
-- Name: tipo_contato_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipo_contato_enum AS ENUM (
    'telefone',
    'email',
    'whatsapp',
    'instagram',
    'telegram',
    'outro'
);


ALTER TYPE public.tipo_contato_enum OWNER TO postgres;

--
-- Name: unidade_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.unidade_enum AS ENUM (
    'un',
    'kg',
    'L',
    'pac',
    'cx',
    'g',
    'ml'
);


ALTER TYPE public.unidade_enum OWNER TO postgres;

--
-- Name: gerar_codigo_lote(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gerar_codigo_lote() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.codigo_lote IS NULL OR NEW.codigo_lote = '' THEN
        NEW.codigo_lote := 'L' || LPAD(NEW.id::TEXT, 3, '0');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.gerar_codigo_lote() OWNER TO postgres;

--
-- Name: gerar_codigo_produto(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gerar_codigo_produto() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Se não tiver código preenchido, gera automaticamente
    IF NEW.codigo IS NULL OR NEW.codigo = '' THEN
        NEW.codigo := 'PROD' || LPAD(NEW.id::text, 3, '0');
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.gerar_codigo_produto() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auditoria_alteracoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditoria_alteracoes (
    audit_id bigint NOT NULL,
    tabela character varying(100) NOT NULL,
    registro_id bigint NOT NULL,
    operacao character(1) NOT NULL,
    dados_antes jsonb,
    dados_depois jsonb,
    usuario_id integer,
    audit_timestamp timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.auditoria_alteracoes OWNER TO postgres;

--
-- Name: auditoria_alteracoes_audit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auditoria_alteracoes_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditoria_alteracoes_audit_id_seq OWNER TO postgres;

--
-- Name: auditoria_alteracoes_audit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auditoria_alteracoes_audit_id_seq OWNED BY public.auditoria_alteracoes.audit_id;


--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id integer CONSTRAINT categoria_id_categoria_not_null NOT NULL,
    nome character varying(100) CONSTRAINT categoria_nome_not_null NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- Name: COLUMN categorias.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.categorias.ativo IS 'Indica se a categoria está ativa (true) ou inativa (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_id_categoria_seq OWNER TO postgres;

--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.categorias.id;


--
-- Name: contatos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contatos (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    valor character varying(50),
    tipo_contato public.tipo_contato_enum,
    codigo_pais character varying(10),
    data_criacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.contatos OWNER TO postgres;

--
-- Name: contatos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contatos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contatos_id_seq OWNER TO postgres;

--
-- Name: contatos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contatos_id_seq OWNED BY public.contatos.id;


--
-- Name: depositos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.depositos (
    id integer CONSTRAINT deposito_id_deposito_not_null NOT NULL,
    nome character varying(100) CONSTRAINT deposito_nome_not_null NOT NULL,
    id_endereco integer,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.depositos OWNER TO postgres;

--
-- Name: COLUMN depositos.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.depositos.ativo IS 'Indica se o depósito está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- Name: deposito_id_deposito_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deposito_id_deposito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deposito_id_deposito_seq OWNER TO postgres;

--
-- Name: deposito_id_deposito_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deposito_id_deposito_seq OWNED BY public.depositos.id;


--
-- Name: enderecos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enderecos (
    id integer CONSTRAINT endereco_id_endereco_not_null NOT NULL,
    logradouro character varying(100) CONSTRAINT endereco_logradouro_not_null NOT NULL,
    numero character varying(20),
    complemento character varying(255),
    cep character varying(20) CONSTRAINT endereco_cep_not_null NOT NULL,
    id_municipio integer NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.enderecos OWNER TO postgres;

--
-- Name: endereco_id_endereco_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.enderecos ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.endereco_id_endereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: fornecedor_endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fornecedor_endereco (
    id_fornecedor integer NOT NULL,
    id_endereco integer NOT NULL,
    tipo_endereco character varying(50) NOT NULL
);


ALTER TABLE public.fornecedor_endereco OWNER TO postgres;

--
-- Name: fornecedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fornecedores (
    id integer CONSTRAINT fornecedor_id_fornecedor_not_null NOT NULL,
    nome character varying(150) CONSTRAINT fornecedor_nome_not_null NOT NULL,
    cnpj character varying(20),
    id_contato integer,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.fornecedores OWNER TO postgres;

--
-- Name: COLUMN fornecedores.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fornecedores.ativo IS 'Indica se o fornecedor está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fornecedor_id_fornecedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fornecedor_id_fornecedor_seq OWNER TO postgres;

--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fornecedor_id_fornecedor_seq OWNED BY public.fornecedores.id;


--
-- Name: fornecedores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.fornecedores ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fornecedores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: localizacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.localizacoes (
    id integer CONSTRAINT localizacao_id_localizacao_not_null NOT NULL,
    id_deposito integer CONSTRAINT localizacao_id_deposito_not_null NOT NULL,
    corredor character varying(50),
    prateleira character varying(50),
    secao character varying(50),
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.localizacoes OWNER TO postgres;

--
-- Name: COLUMN localizacoes.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.localizacoes.ativo IS 'Indica se a localização está ativa (true) ou inativa (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- Name: localizacao_id_localizacao_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.localizacao_id_localizacao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.localizacao_id_localizacao_seq OWNER TO postgres;

--
-- Name: localizacao_id_localizacao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.localizacao_id_localizacao_seq OWNED BY public.localizacoes.id;


--
-- Name: marcas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marcas (
    id integer CONSTRAINT marca_id_marca_not_null NOT NULL,
    nome character varying(100) CONSTRAINT marca_nome_not_null NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.marcas OWNER TO postgres;

--
-- Name: COLUMN marcas.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.marcas.ativo IS 'Indica se a marca está ativa (true) ou inativa (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- Name: marca_id_marca_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.marca_id_marca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.marca_id_marca_seq OWNER TO postgres;

--
-- Name: marca_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.marca_id_marca_seq OWNED BY public.marcas.id;


--
-- Name: movimentacao_estoque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movimentacao_estoque (
    id integer CONSTRAINT movimentacao_estoque_id_mov_not_null NOT NULL,
    id_produto integer NOT NULL,
    quantidade numeric(10,2) NOT NULL,
    data_mov timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_lote integer NOT NULL,
    tipo_movimento public.movimento_tipo_enum DEFAULT 'entrada'::public.movimento_tipo_enum NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by integer,
    updated_by integer,
    CONSTRAINT chk_quantidade_mov_nonnegative CHECK ((quantidade >= (0)::numeric))
);


ALTER TABLE public.movimentacao_estoque OWNER TO postgres;

--
-- Name: movimentacao_estoque_id_mov_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movimentacao_estoque_id_mov_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movimentacao_estoque_id_mov_seq OWNER TO postgres;

--
-- Name: movimentacao_estoque_id_mov_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movimentacao_estoque_id_mov_seq OWNED BY public.movimentacao_estoque.id;


--
-- Name: municipio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.municipio (
    id integer CONSTRAINT municipio_id_municipio_not_null NOT NULL,
    nome character varying(150) NOT NULL,
    id_uf integer NOT NULL,
    bairro character varying(150),
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.municipio OWNER TO postgres;

--
-- Name: municipio_id_municipio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.municipio ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.municipio_id_municipio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: produto_fornecedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto_fornecedor (
    id_produto integer NOT NULL,
    id_fornecedor integer NOT NULL,
    data_cadastro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_log_id integer
);


ALTER TABLE public.produto_fornecedor OWNER TO postgres;

--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    id integer CONSTRAINT produto_id_produto_not_null NOT NULL,
    nome character varying(150) CONSTRAINT produto_nome_not_null NOT NULL,
    codigo character varying(50) CONSTRAINT produto_codigo_not_null NOT NULL,
    descricao character varying(500),
    id_unidade_medida integer CONSTRAINT produto_id_unidade_medida_not_null NOT NULL,
    id_marca integer,
    id_categoria integer,
    responsavel_cadastro integer CONSTRAINT produto_responsavel_cadastro_not_null NOT NULL,
    data_cadastro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_log_id integer,
    estoque_minimo numeric(10,2) DEFAULT 10.00,
    is_perecivel boolean DEFAULT false,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by integer,
    updated_by integer
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- Name: COLUMN produtos.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.produtos.ativo IS 'Indica se o produto está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- Name: produto_id_produto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_id_produto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produto_id_produto_seq OWNER TO postgres;

--
-- Name: produto_id_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_id_produto_seq OWNED BY public.produtos.id;


--
-- Name: produto_lotes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto_lotes (
    id integer CONSTRAINT produto_lote_id_lote_not_null NOT NULL,
    id_produto integer CONSTRAINT produto_lote_id_produto_not_null NOT NULL,
    codigo_lote character varying(50) CONSTRAINT produto_lote_codigo_lote_not_null NOT NULL,
    data_validade date,
    quantidade numeric(10,2) DEFAULT 0 CONSTRAINT produto_lote_quantidade_not_null NOT NULL,
    data_entrada date DEFAULT CURRENT_DATE CONSTRAINT produto_lote_data_entrada_not_null NOT NULL,
    responsavel_cadastro integer CONSTRAINT produto_lote_responsavel_cadastro_not_null NOT NULL,
    custo_unitario numeric(10,2),
    usuario_log_id integer,
    id_localizacao integer,
    ativo boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by integer,
    updated_by integer,
    CONSTRAINT chk_custo_nonnegative CHECK ((custo_unitario >= (0)::numeric)),
    CONSTRAINT chk_quantidade_nonnegative CHECK ((quantidade >= (0)::numeric))
);


ALTER TABLE public.produto_lotes OWNER TO postgres;

--
-- Name: produto_lote_id_lote_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produto_lote_id_lote_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produto_lote_id_lote_seq OWNER TO postgres;

--
-- Name: produto_lote_id_lote_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_lote_id_lote_seq OWNED BY public.produto_lotes.id;


--
-- Name: produtos_alergenos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos_alergenos (
    id integer CONSTRAINT produto_alergeno_id_produto_not_null NOT NULL,
    nome character varying(100) CONSTRAINT produto_alergeno_nome_not_null NOT NULL
);


ALTER TABLE public.produtos_alergenos OWNER TO postgres;

--
-- Name: produtos_alergenos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produtos_alergenos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produtos_alergenos_id_seq OWNER TO postgres;

--
-- Name: produtos_alergenos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produtos_alergenos_id_seq OWNED BY public.produtos_alergenos.id;


--
-- Name: registro_movimentacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registro_movimentacoes (
    id integer NOT NULL,
    id_lote integer,
    id_produto integer,
    id_usuario integer,
    valor_total numeric(10,2),
    data_criacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    usuario_log_id integer,
    id_localizacao integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by integer,
    updated_by integer,
    ativo boolean DEFAULT true NOT NULL,
    quantidade numeric(10,2) DEFAULT 0 NOT NULL,
    tipo_movimento public.movimento_tipo_enum DEFAULT 'entrada'::public.movimento_tipo_enum NOT NULL,
    preco_unitario numeric(10,2),
    observacao character varying(255),
    id_localizacao_origem integer,
    id_localizacao_destino integer,
    CONSTRAINT registro_movimentacoes_valor_total_check CHECK ((valor_total >= (0)::numeric))
);


ALTER TABLE public.registro_movimentacoes OWNER TO postgres;

--
-- Name: registro_movimentacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.registro_movimentacoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.registro_movimentacoes_id_seq OWNER TO postgres;

--
-- Name: registro_movimentacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.registro_movimentacoes_id_seq OWNED BY public.registro_movimentacoes.id;


--
-- Name: uf; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uf (
    id integer CONSTRAINT uf_id_uf_not_null NOT NULL,
    sigla character(2) NOT NULL,
    nome character varying(100) NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.uf OWNER TO postgres;

--
-- Name: uf_id_uf_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.uf ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.uf_id_uf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: unidade_medidas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unidade_medidas (
    id integer CONSTRAINT unidade_medida_id_unidade_medida_not_null NOT NULL,
    descricao character varying(50) CONSTRAINT unidade_medida_descricao_not_null NOT NULL,
    abreviacao public.unidade_enum,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.unidade_medidas OWNER TO postgres;

--
-- Name: unidade_medida_id_unidade_medida_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unidade_medida_id_unidade_medida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidade_medida_id_unidade_medida_seq OWNER TO postgres;

--
-- Name: unidade_medida_id_unidade_medida_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidade_medida_id_unidade_medida_seq OWNED BY public.unidade_medidas.id;


--
-- Name: usuario_uf_permissao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_uf_permissao (
    id_usuario integer NOT NULL,
    id_uf integer NOT NULL
);


ALTER TABLE public.usuario_uf_permissao OWNER TO postgres;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer CONSTRAINT usuarios_id_usuario_not_null NOT NULL,
    nome character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    senha character varying(255) NOT NULL,
    id_contato integer,
    role public.role_enum DEFAULT 'relatorios'::public.role_enum NOT NULL,
    id_uf integer,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: COLUMN usuarios.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.usuarios.ativo IS 'Indica se o usuário está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id;


--
-- Name: auditoria_alteracoes audit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_alteracoes ALTER COLUMN audit_id SET DEFAULT nextval('public.auditoria_alteracoes_audit_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_categoria_seq'::regclass);


--
-- Name: contatos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contatos ALTER COLUMN id SET DEFAULT nextval('public.contatos_id_seq'::regclass);


--
-- Name: depositos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositos ALTER COLUMN id SET DEFAULT nextval('public.deposito_id_deposito_seq'::regclass);


--
-- Name: localizacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localizacoes ALTER COLUMN id SET DEFAULT nextval('public.localizacao_id_localizacao_seq'::regclass);


--
-- Name: marcas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas ALTER COLUMN id SET DEFAULT nextval('public.marca_id_marca_seq'::regclass);


--
-- Name: movimentacao_estoque id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque ALTER COLUMN id SET DEFAULT nextval('public.movimentacao_estoque_id_mov_seq'::regclass);


--
-- Name: produto_lotes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes ALTER COLUMN id SET DEFAULT nextval('public.produto_lote_id_lote_seq'::regclass);


--
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produto_id_produto_seq'::regclass);


--
-- Name: registro_movimentacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes ALTER COLUMN id SET DEFAULT nextval('public.registro_movimentacoes_id_seq'::regclass);


--
-- Name: unidade_medidas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidade_medidas ALTER COLUMN id SET DEFAULT nextval('public.unidade_medida_id_unidade_medida_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- Data for Name: auditoria_alteracoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auditoria_alteracoes (audit_id, tabela, registro_id, operacao, dados_antes, dados_depois, usuario_id, audit_timestamp) FROM stdin;
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias (id, nome, ativo) FROM stdin;
1	Laticínios	t
2	Grãos e Cereais	t
3	Bebidas	t
4	Mercearia	t
5	Frios e Embutidos	t
\.


--
-- Data for Name: contatos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contatos (id, nome, valor, tipo_contato, codigo_pais, data_criacao, ativo) FROM stdin;
1	Admin Sys	admin@sistema.com	email	\N	2025-10-10 16:35:16.208943	t
2	João Almoxarife	62988776655	whatsapp	55	2025-10-10 16:35:16.208943	t
3	Maria Gerente	maria.gerente@empresa.com	email	\N	2025-10-10 16:35:16.208943	t
4	Distribuidora Alimentos GO	contato@distribuidorago.com	email	\N	2025-10-10 16:35:16.208943	t
5	Laticínios Centro-Oeste	6232324545	telefone	55	2025-10-10 16:35:16.208943	t
6	Frios Brasil S.A.	vendas@friosbrasil.com	email	\N	2025-10-10 16:35:16.208943	t
\.


--
-- Data for Name: depositos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depositos (id, nome, id_endereco, ativo) FROM stdin;
1	Depósito Central	1	t
2	Depósito de Refrigerados	2	t
\.


--
-- Data for Name: enderecos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enderecos (id, logradouro, numero, complemento, cep, id_municipio, ativo) FROM stdin;
1	Avenida Principal	100	Sala 1	75250-000	1	t
2	Rua das Flores	250	\N	74210-000	2	t
3	Avenida Comercial	1234	Galpão A	74905-000	3	t
4	Rodovia BR-153	Km 5	Lote 2	74905-100	3	t
5	Avenida Industrial	5678	\N	13010-001	5	t
\.


--
-- Data for Name: fornecedor_endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fornecedor_endereco (id_fornecedor, id_endereco, tipo_endereco) FROM stdin;
1	3	Comercial
2	4	Fábrica
3	5	Matriz
\.


--
-- Data for Name: fornecedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fornecedores (id, nome, cnpj, id_contato, ativo) FROM stdin;
1	Distribuidora de Alimentos Goiás	01.234.567/0001-89	4	t
2	Laticínios Centro-Oeste	98.765.432/0001-10	5	t
3	Frios Brasil S.A.	11.222.333/0001-44	6	t
\.


--
-- Data for Name: localizacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.localizacoes (id, id_deposito, corredor, prateleira, secao, ativo) FROM stdin;
1	1	A1	P1	S1	t
2	1	A2	P2	S1	t
3	2	B1	P1	S1	t
4	2	B2	P2	S2	t
\.


--
-- Data for Name: marcas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marcas (id, nome, ativo) FROM stdin;
1	Piracanjuba	t
2	Italac	t
3	Tio João	t
4	Camil	t
5	Coca-Cola	t
6	Sadia	t
7	Perdigão	t
\.


--
-- Data for Name: movimentacao_estoque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movimentacao_estoque (id, id_produto, quantidade, data_mov, id_lote, tipo_movimento, created_at, updated_at, created_by, updated_by) FROM stdin;
1	1	100.00	2025-10-10 16:35:16.547107	1	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
2	2	80.00	2025-10-10 16:35:16.547107	2	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
3	6	5000.00	2025-10-10 16:35:16.547107	3	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
4	1	200.00	2025-10-10 16:35:16.547107	4	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
5	3	300.00	2025-10-10 16:35:16.547107	5	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
6	3	250.00	2025-10-10 16:35:16.547107	6	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
7	4	400.00	2025-10-10 16:35:16.547107	7	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
8	5	150.00	2025-10-10 16:35:16.547107	8	entrada	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
9	1	20.00	2025-10-10 16:35:16.57941	1	saida	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
10	3	50.00	2025-10-10 16:35:16.57941	5	saida	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
11	6	150.00	2025-10-10 16:35:16.57941	3	saida	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
\.


--
-- Data for Name: municipio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.municipio (id, nome, id_uf, bairro, ativo) FROM stdin;
1	Senador Canedo	1	Centro	t
2	Goiânia	1	Setor Bueno	t
3	Aparecida de Goiânia	1	Vila Brasília	t
4	São Paulo	2	Paulista	t
5	Campinas	2	Centro	t
\.


--
-- Data for Name: produto_fornecedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_fornecedor (id_produto, id_fornecedor, data_cadastro, usuario_log_id) FROM stdin;
1	2	2025-10-10 16:35:16.441844	1
2	2	2025-10-10 16:35:16.441844	1
3	1	2025-10-10 16:35:16.441844	1
4	1	2025-10-10 16:35:16.441844	1
5	1	2025-10-10 16:35:16.441844	1
6	3	2025-10-10 16:35:16.441844	1
\.


--
-- Data for Name: produto_lotes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_lotes (id, id_produto, codigo_lote, data_validade, quantidade, data_entrada, responsavel_cadastro, custo_unitario, usuario_log_id, id_localizacao, ativo, created_at, updated_at, created_by, updated_by) FROM stdin;
1	1	L001	2025-10-25	100.00	2025-10-10	2	4.50	\N	3	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
2	2	L002	2025-11-08	80.00	2025-10-10	2	2.10	\N	3	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
3	6	L003	2025-10-20	5000.00	2025-10-10	2	0.02	\N	4	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
4	1	L004	2026-02-15	200.00	2025-10-10	2	4.55	\N	3	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
5	3	L005	2026-08-20	300.00	2025-10-10	2	22.50	\N	1	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
6	3	L006	2026-09-10	250.00	2025-10-10	2	22.90	\N	1	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
7	4	L007	2027-01-10	400.00	2025-10-10	2	8.50	\N	1	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
8	5	L008	2026-06-01	150.00	2025-10-10	3	7.80	\N	2	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
\.


--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (id, nome, codigo, descricao, id_unidade_medida, id_marca, id_categoria, responsavel_cadastro, data_cadastro, usuario_log_id, estoque_minimo, is_perecivel, ativo, created_at, updated_at, created_by, updated_by) FROM stdin;
1	Leite Integral UHT	PROD001	Leite de vaca integral longa vida	3	1	1	1	2025-10-10 16:35:16.413901	\N	50.00	f	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
2	Iogurte Natural	PROD002	Iogurte natural sem açúcar	1	2	1	1	2025-10-10 16:35:16.413901	\N	30.00	f	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
3	Arroz Agulhinha Tipo 1	PROD003	Arroz branco longo fino	2	3	2	2	2025-10-10 16:35:16.413901	\N	100.00	f	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
4	Feijão Carioca	PROD004	Feijão carioca tipo 1	4	4	2	2	2025-10-10 16:35:16.413901	\N	80.00	f	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
5	Refrigerante de Cola	PROD005	Refrigerante sabor cola 2L	3	5	3	3	2025-10-10 16:35:16.413901	\N	40.00	f	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
6	Presunto Cozido Fatiado	PROD006	Presunto cozido sem capa de gordura	6	6	5	3	2025-10-10 16:35:16.413901	\N	2000.00	f	t	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N
\.


--
-- Data for Name: produtos_alergenos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos_alergenos (id, nome) FROM stdin;
1	Contém Lactose
1	Contém proteínas do leite
2	Contém Lactose
\.


--
-- Data for Name: registro_movimentacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registro_movimentacoes (id, id_lote, id_produto, id_usuario, valor_total, data_criacao, usuario_log_id, id_localizacao, created_at, updated_at, created_by, updated_by, ativo, quantidade, tipo_movimento, preco_unitario, observacao, id_localizacao_origem, id_localizacao_destino) FROM stdin;
1	1	1	2	450.00	2025-10-10 16:35:16.616542	\N	3	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	100.00	entrada	4.50	\N	\N	3
2	2	2	2	168.00	2025-10-10 16:35:16.616542	\N	3	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	80.00	entrada	2.10	\N	\N	3
3	3	6	2	100.00	2025-10-10 16:35:16.616542	\N	4	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	5000.00	entrada	0.02	\N	\N	4
4	4	1	2	910.00	2025-10-10 16:35:16.616542	\N	3	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	200.00	entrada	4.55	\N	\N	3
5	5	3	2	6750.00	2025-10-10 16:35:16.616542	\N	1	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	300.00	entrada	22.50	\N	\N	1
6	6	3	2	5725.00	2025-10-10 16:35:16.616542	\N	1	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	250.00	entrada	22.90	\N	\N	1
7	7	4	2	3400.00	2025-10-10 16:35:16.616542	\N	1	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	400.00	entrada	8.50	\N	\N	1
8	8	5	3	1170.00	2025-10-10 16:35:16.616542	\N	2	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	150.00	entrada	7.80	\N	\N	2
9	1	1	3	\N	2025-10-10 16:35:16.616542	\N	3	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	20.00	saida	0.00	Venda para mercado local	3	\N
10	5	3	3	\N	2025-10-10 16:35:16.616542	\N	1	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	50.00	saida	0.00	Venda para restaurante	1	\N
11	3	6	3	\N	2025-10-10 16:35:16.616542	\N	4	2025-11-06 14:16:28.849556-03	2025-11-06 14:16:28.849556-03	\N	\N	t	150.00	saida	0.00	Uso interno na padaria	4	\N
\.


--
-- Data for Name: uf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uf (id, sigla, nome, ativo) FROM stdin;
1	GO	Goiás	t
2	SP	São Paulo	t
3	RJ	Rio de Janeiro	t
\.


--
-- Data for Name: unidade_medidas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unidade_medidas (id, descricao, abreviacao, ativo) FROM stdin;
1	Unidade	un	t
2	Quilograma	kg	t
3	Litro	L	t
4	Pacote	pac	t
5	Caixa	cx	t
6	Grama	g	t
7	Mililitro	ml	t
\.


--
-- Data for Name: usuario_uf_permissao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_uf_permissao (id_usuario, id_uf) FROM stdin;
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nome, email, senha, id_contato, role, id_uf, ativo) FROM stdin;
1	Administrador	admin@sistema.com	senha_super_segura_hash	1	admin	\N	t
3	Maria Souza	maria.souza@empresa.com	senha_segura_hash_456	3	gestor	\N	t
2	João da Silva	joao.silva@empresa.com	senha_segura_hash_123	2	estoquista	\N	t
\.


--
-- Name: auditoria_alteracoes_audit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auditoria_alteracoes_audit_id_seq', 1, false);


--
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 5, true);


--
-- Name: contatos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contatos_id_seq', 6, true);


--
-- Name: deposito_id_deposito_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deposito_id_deposito_seq', 2, true);


--
-- Name: endereco_id_endereco_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_id_endereco_seq', 5, true);


--
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fornecedor_id_fornecedor_seq', 1, false);


--
-- Name: fornecedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fornecedores_id_seq', 3, true);


--
-- Name: localizacao_id_localizacao_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.localizacao_id_localizacao_seq', 4, true);


--
-- Name: marca_id_marca_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.marca_id_marca_seq', 7, true);


--
-- Name: movimentacao_estoque_id_mov_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movimentacao_estoque_id_mov_seq', 11, true);


--
-- Name: municipio_id_municipio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.municipio_id_municipio_seq', 5, true);


--
-- Name: produto_id_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_id_produto_seq', 6, true);


--
-- Name: produto_lote_id_lote_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_lote_id_lote_seq', 8, true);


--
-- Name: produtos_alergenos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produtos_alergenos_id_seq', 1, false);


--
-- Name: registro_movimentacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registro_movimentacoes_id_seq', 11, true);


--
-- Name: uf_id_uf_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uf_id_uf_seq', 3, true);


--
-- Name: unidade_medida_id_unidade_medida_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidade_medida_id_unidade_medida_seq', 7, true);


--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 3, true);


--
-- Name: auditoria_alteracoes auditoria_alteracoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_alteracoes
    ADD CONSTRAINT auditoria_alteracoes_pkey PRIMARY KEY (audit_id);


--
-- Name: categorias categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- Name: contatos contatos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contatos
    ADD CONSTRAINT contatos_pkey PRIMARY KEY (id);


--
-- Name: depositos deposito_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositos
    ADD CONSTRAINT deposito_pkey PRIMARY KEY (id);


--
-- Name: enderecos endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- Name: fornecedor_endereco fornecedor_endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedor_endereco
    ADD CONSTRAINT fornecedor_endereco_pkey PRIMARY KEY (id_fornecedor, id_endereco);


--
-- Name: fornecedores fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (id);


--
-- Name: fornecedores fornecedores_cnpj_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_cnpj_key UNIQUE (cnpj);


--
-- Name: localizacoes localizacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localizacoes
    ADD CONSTRAINT localizacao_pkey PRIMARY KEY (id);


--
-- Name: marcas marca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marca_pkey PRIMARY KEY (id);


--
-- Name: movimentacao_estoque movimentacao_estoque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT movimentacao_estoque_pkey PRIMARY KEY (id);


--
-- Name: municipio municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_pkey PRIMARY KEY (id);


--
-- Name: produto_fornecedor pk_produto_fornecedor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_fornecedor
    ADD CONSTRAINT pk_produto_fornecedor PRIMARY KEY (id_produto, id_fornecedor);


--
-- Name: produtos_alergenos pk_produtos_alergenos; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos_alergenos
    ADD CONSTRAINT pk_produtos_alergenos PRIMARY KEY (id, nome);


--
-- Name: produtos produto_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_codigo_key UNIQUE (codigo);


--
-- Name: produto_lotes produto_lote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_pkey PRIMARY KEY (id);


--
-- Name: produtos produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- Name: registro_movimentacoes registro_movimentacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_pkey PRIMARY KEY (id);


--
-- Name: uf uf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uf
    ADD CONSTRAINT uf_pkey PRIMARY KEY (id);


--
-- Name: uf uf_sigla_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uf
    ADD CONSTRAINT uf_sigla_key UNIQUE (sigla);


--
-- Name: unidade_medidas unidade_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidade_medidas
    ADD CONSTRAINT unidade_medida_pkey PRIMARY KEY (id);


--
-- Name: marcas unique_nome; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT unique_nome UNIQUE (nome);


--
-- Name: usuario_uf_permissao usuario_uf_permissao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_uf_permissao
    ADD CONSTRAINT usuario_uf_permissao_pkey PRIMARY KEY (id_usuario, id_uf);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: idx_auditoria_alteracoes_tbl; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auditoria_alteracoes_tbl ON public.auditoria_alteracoes USING btree (tabela, registro_id);


--
-- Name: idx_auditoria_alteracoes_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auditoria_alteracoes_usuario ON public.auditoria_alteracoes USING btree (usuario_id, audit_timestamp);


--
-- Name: idx_categorias_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categorias_ativo ON public.categorias USING btree (ativo);


--
-- Name: idx_depositos_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_depositos_ativo ON public.depositos USING btree (ativo);


--
-- Name: idx_fornecedores_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fornecedores_ativo ON public.fornecedores USING btree (ativo);


--
-- Name: idx_localizacoes_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_localizacoes_ativo ON public.localizacoes USING btree (ativo);


--
-- Name: idx_marcas_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_marcas_ativo ON public.marcas USING btree (ativo);


--
-- Name: idx_mov_est_produto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mov_est_produto ON public.movimentacao_estoque USING btree (id_produto);


--
-- Name: idx_produtos_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produtos_ativo ON public.produtos USING btree (ativo);


--
-- Name: idx_reg_mov_audit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reg_mov_audit ON public.registro_movimentacoes USING btree (usuario_log_id, updated_at);


--
-- Name: idx_reg_mov_tipo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reg_mov_tipo ON public.registro_movimentacoes USING btree (tipo_movimento);


--
-- Name: idx_reg_mov_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reg_mov_usuario ON public.registro_movimentacoes USING btree (id_usuario);


--
-- Name: idx_usuarios_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_ativo ON public.usuarios USING btree (ativo);


--
-- Name: produto_lotes trg_gerar_codigo_lote; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_gerar_codigo_lote BEFORE INSERT ON public.produto_lotes FOR EACH ROW EXECUTE FUNCTION public.gerar_codigo_lote();


--
-- Name: produtos trg_gerar_codigo_produto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_gerar_codigo_produto BEFORE INSERT ON public.produtos FOR EACH ROW EXECUTE FUNCTION public.gerar_codigo_produto();


--
-- Name: auditoria_alteracoes auditoria_usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_alteracoes
    ADD CONSTRAINT auditoria_usuario_fk FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: enderecos endereco_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT endereco_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES public.municipio(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: depositos fk_deposito_endereco; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositos
    ADD CONSTRAINT fk_deposito_endereco FOREIGN KEY (id_endereco) REFERENCES public.enderecos(id);


--
-- Name: produto_fornecedor fk_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_fornecedor
    ADD CONSTRAINT fk_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedores(id);


--
-- Name: fornecedores fk_fornecedor_contato; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fk_fornecedor_contato FOREIGN KEY (id_contato) REFERENCES public.contatos(id);


--
-- Name: produto_lotes fk_lote_localizacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT fk_lote_localizacao FOREIGN KEY (id_localizacao) REFERENCES public.localizacoes(id);


--
-- Name: movimentacao_estoque fk_movimento_lote; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT fk_movimento_lote FOREIGN KEY (id_lote) REFERENCES public.produto_lotes(id);


--
-- Name: produto_fornecedor fk_produto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_fornecedor
    ADD CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- Name: registro_movimentacoes fk_registro_localizacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT fk_registro_localizacao FOREIGN KEY (id_localizacao) REFERENCES public.localizacoes(id);


--
-- Name: usuarios fk_usuario_contato; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuario_contato FOREIGN KEY (id_contato) REFERENCES public.contatos(id);


--
-- Name: fornecedor_endereco fornecedor_endereco_id_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedor_endereco
    ADD CONSTRAINT fornecedor_endereco_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES public.enderecos(id);


--
-- Name: fornecedor_endereco fornecedor_endereco_id_fornecedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedor_endereco
    ADD CONSTRAINT fornecedor_endereco_id_fornecedor_fkey FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedores(id);


--
-- Name: localizacoes localizacao_id_deposito_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localizacoes
    ADD CONSTRAINT localizacao_id_deposito_fkey FOREIGN KEY (id_deposito) REFERENCES public.depositos(id);


--
-- Name: movimentacao_estoque mov_est_created_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT mov_est_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id);


--
-- Name: movimentacao_estoque mov_est_updated_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT mov_est_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id);


--
-- Name: movimentacao_estoque movimentacao_estoque_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT movimentacao_estoque_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- Name: municipio municipio_id_uf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id);


--
-- Name: produtos_alergenos produto_alergeno_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos_alergenos
    ADD CONSTRAINT produto_alergeno_id_produto_fkey FOREIGN KEY (id) REFERENCES public.produtos(id);


--
-- Name: produtos produto_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);


--
-- Name: produtos produto_id_marca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_id_marca_fkey FOREIGN KEY (id_marca) REFERENCES public.marcas(id);


--
-- Name: produtos produto_id_unidade_medida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_id_unidade_medida_fkey FOREIGN KEY (id_unidade_medida) REFERENCES public.unidade_medidas(id);


--
-- Name: produto_lotes produto_lote_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- Name: produto_lotes produto_lote_responsavel_cadastro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_responsavel_cadastro_fkey FOREIGN KEY (responsavel_cadastro) REFERENCES public.usuarios(id);


--
-- Name: produto_lotes produto_lote_usuario_log_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id);


--
-- Name: produto_lotes produto_lotes_created_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lotes_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id);


--
-- Name: produto_lotes produto_lotes_updated_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lotes_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id);


--
-- Name: produtos produto_responsavel_cadastro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_responsavel_cadastro_fkey FOREIGN KEY (responsavel_cadastro) REFERENCES public.usuarios(id);


--
-- Name: produtos produto_usuario_log_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id);


--
-- Name: produtos produtos_created_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id);


--
-- Name: produtos produtos_updated_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id);


--
-- Name: registro_movimentacoes reg_mov_created_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT reg_mov_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id);


--
-- Name: registro_movimentacoes reg_mov_localizacao_dest_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT reg_mov_localizacao_dest_fk FOREIGN KEY (id_localizacao_destino) REFERENCES public.localizacoes(id);


--
-- Name: registro_movimentacoes reg_mov_localizacao_origem_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT reg_mov_localizacao_origem_fk FOREIGN KEY (id_localizacao_origem) REFERENCES public.localizacoes(id);


--
-- Name: registro_movimentacoes reg_mov_updated_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT reg_mov_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id);


--
-- Name: registro_movimentacoes registro_movimentacoes_id_lote_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_id_lote_fkey FOREIGN KEY (id_lote) REFERENCES public.produto_lotes(id);


--
-- Name: registro_movimentacoes registro_movimentacoes_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- Name: registro_movimentacoes registro_movimentacoes_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- Name: registro_movimentacoes registro_movimentacoes_usuario_log_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id);


--
-- Name: usuario_uf_permissao usuario_uf_permissao_id_uf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_uf_permissao
    ADD CONSTRAINT usuario_uf_permissao_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id);


--
-- Name: usuario_uf_permissao usuario_uf_permissao_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_uf_permissao
    ADD CONSTRAINT usuario_uf_permissao_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- Name: usuarios usuarios_id_uf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO gestor;
GRANT USAGE ON SCHEMA public TO estoquista;
GRANT USAGE ON SCHEMA public TO relatorios;


--
-- Name: TABLE auditoria_alteracoes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.auditoria_alteracoes TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.auditoria_alteracoes TO estoquista;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.auditoria_alteracoes TO gestor;
GRANT SELECT ON TABLE public.auditoria_alteracoes TO relatorios;


--
-- Name: SEQUENCE auditoria_alteracoes_audit_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.auditoria_alteracoes_audit_id_seq TO admin;
GRANT ALL ON SEQUENCE public.auditoria_alteracoes_audit_id_seq TO gestor;


--
-- Name: TABLE categorias; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categorias TO admin;
GRANT SELECT ON TABLE public.categorias TO gestor;
GRANT SELECT ON TABLE public.categorias TO relatorios;


--
-- Name: SEQUENCE categoria_id_categoria_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.categoria_id_categoria_seq TO admin;
GRANT ALL ON SEQUENCE public.categoria_id_categoria_seq TO gestor;


--
-- Name: TABLE contatos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.contatos TO admin;
GRANT SELECT ON TABLE public.contatos TO gestor;
GRANT SELECT ON TABLE public.contatos TO relatorios;


--
-- Name: SEQUENCE contatos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.contatos_id_seq TO admin;
GRANT ALL ON SEQUENCE public.contatos_id_seq TO gestor;


--
-- Name: TABLE depositos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.depositos TO admin;
GRANT SELECT ON TABLE public.depositos TO gestor;
GRANT SELECT ON TABLE public.depositos TO relatorios;


--
-- Name: SEQUENCE deposito_id_deposito_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.deposito_id_deposito_seq TO admin;
GRANT ALL ON SEQUENCE public.deposito_id_deposito_seq TO gestor;


--
-- Name: TABLE enderecos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.enderecos TO admin;
GRANT SELECT ON TABLE public.enderecos TO gestor;
GRANT SELECT ON TABLE public.enderecos TO relatorios;


--
-- Name: SEQUENCE endereco_id_endereco_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.endereco_id_endereco_seq TO admin;
GRANT ALL ON SEQUENCE public.endereco_id_endereco_seq TO gestor;


--
-- Name: TABLE fornecedor_endereco; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.fornecedor_endereco TO admin;
GRANT SELECT ON TABLE public.fornecedor_endereco TO gestor;
GRANT SELECT ON TABLE public.fornecedor_endereco TO relatorios;


--
-- Name: TABLE fornecedores; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.fornecedores TO admin;
GRANT SELECT ON TABLE public.fornecedores TO gestor;
GRANT SELECT ON TABLE public.fornecedores TO relatorios;


--
-- Name: SEQUENCE fornecedor_id_fornecedor_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.fornecedor_id_fornecedor_seq TO admin;
GRANT ALL ON SEQUENCE public.fornecedor_id_fornecedor_seq TO gestor;


--
-- Name: SEQUENCE fornecedores_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.fornecedores_id_seq TO admin;
GRANT ALL ON SEQUENCE public.fornecedores_id_seq TO gestor;


--
-- Name: TABLE localizacoes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.localizacoes TO admin;
GRANT SELECT ON TABLE public.localizacoes TO gestor;
GRANT SELECT ON TABLE public.localizacoes TO estoquista;
GRANT SELECT ON TABLE public.localizacoes TO relatorios;


--
-- Name: SEQUENCE localizacao_id_localizacao_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.localizacao_id_localizacao_seq TO admin;
GRANT ALL ON SEQUENCE public.localizacao_id_localizacao_seq TO gestor;


--
-- Name: TABLE marcas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.marcas TO admin;
GRANT SELECT ON TABLE public.marcas TO gestor;
GRANT SELECT ON TABLE public.marcas TO relatorios;


--
-- Name: SEQUENCE marca_id_marca_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.marca_id_marca_seq TO admin;
GRANT ALL ON SEQUENCE public.marca_id_marca_seq TO gestor;


--
-- Name: TABLE movimentacao_estoque; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.movimentacao_estoque TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.movimentacao_estoque TO gestor;
GRANT SELECT,INSERT ON TABLE public.movimentacao_estoque TO estoquista;
GRANT SELECT ON TABLE public.movimentacao_estoque TO relatorios;


--
-- Name: SEQUENCE movimentacao_estoque_id_mov_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.movimentacao_estoque_id_mov_seq TO admin;
GRANT ALL ON SEQUENCE public.movimentacao_estoque_id_mov_seq TO gestor;


--
-- Name: TABLE municipio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.municipio TO admin;
GRANT SELECT ON TABLE public.municipio TO gestor;
GRANT SELECT ON TABLE public.municipio TO relatorios;


--
-- Name: SEQUENCE municipio_id_municipio_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.municipio_id_municipio_seq TO admin;
GRANT ALL ON SEQUENCE public.municipio_id_municipio_seq TO gestor;


--
-- Name: TABLE produto_fornecedor; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produto_fornecedor TO admin;
GRANT SELECT ON TABLE public.produto_fornecedor TO gestor;
GRANT SELECT ON TABLE public.produto_fornecedor TO relatorios;


--
-- Name: TABLE produtos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produtos TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.produtos TO gestor;
GRANT SELECT ON TABLE public.produtos TO estoquista;
GRANT SELECT ON TABLE public.produtos TO relatorios;


--
-- Name: SEQUENCE produto_id_produto_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produto_id_produto_seq TO admin;
GRANT ALL ON SEQUENCE public.produto_id_produto_seq TO gestor;


--
-- Name: TABLE produto_lotes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produto_lotes TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.produto_lotes TO gestor;
GRANT SELECT ON TABLE public.produto_lotes TO estoquista;
GRANT SELECT ON TABLE public.produto_lotes TO relatorios;


--
-- Name: COLUMN produto_lotes.quantidade; Type: ACL; Schema: public; Owner: postgres
--

GRANT UPDATE(quantidade) ON TABLE public.produto_lotes TO estoquista;


--
-- Name: SEQUENCE produto_lote_id_lote_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produto_lote_id_lote_seq TO admin;
GRANT ALL ON SEQUENCE public.produto_lote_id_lote_seq TO gestor;


--
-- Name: TABLE produtos_alergenos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produtos_alergenos TO admin;
GRANT SELECT ON TABLE public.produtos_alergenos TO gestor;
GRANT SELECT ON TABLE public.produtos_alergenos TO relatorios;


--
-- Name: SEQUENCE produtos_alergenos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produtos_alergenos_id_seq TO admin;
GRANT ALL ON SEQUENCE public.produtos_alergenos_id_seq TO gestor;


--
-- Name: TABLE registro_movimentacoes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.registro_movimentacoes TO admin;
GRANT SELECT ON TABLE public.registro_movimentacoes TO gestor;
GRANT SELECT ON TABLE public.registro_movimentacoes TO relatorios;


--
-- Name: SEQUENCE registro_movimentacoes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.registro_movimentacoes_id_seq TO admin;
GRANT ALL ON SEQUENCE public.registro_movimentacoes_id_seq TO gestor;


--
-- Name: TABLE uf; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.uf TO admin;
GRANT SELECT ON TABLE public.uf TO gestor;
GRANT SELECT ON TABLE public.uf TO relatorios;


--
-- Name: SEQUENCE uf_id_uf_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.uf_id_uf_seq TO admin;
GRANT ALL ON SEQUENCE public.uf_id_uf_seq TO gestor;


--
-- Name: TABLE unidade_medidas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.unidade_medidas TO admin;
GRANT SELECT ON TABLE public.unidade_medidas TO gestor;
GRANT SELECT ON TABLE public.unidade_medidas TO relatorios;


--
-- Name: SEQUENCE unidade_medida_id_unidade_medida_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.unidade_medida_id_unidade_medida_seq TO admin;
GRANT ALL ON SEQUENCE public.unidade_medida_id_unidade_medida_seq TO gestor;


--
-- Name: TABLE usuario_uf_permissao; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuario_uf_permissao TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.usuario_uf_permissao TO gestor;
GRANT SELECT,INSERT,UPDATE ON TABLE public.usuario_uf_permissao TO estoquista;
GRANT SELECT ON TABLE public.usuario_uf_permissao TO relatorios;


--
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuarios TO admin;
GRANT SELECT ON TABLE public.usuarios TO gestor;
GRANT SELECT ON TABLE public.usuarios TO relatorios;


--
-- Name: SEQUENCE usuarios_id_usuario_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO admin;
GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO gestor;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO admin;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO gestor;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO admin;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,UPDATE ON TABLES TO estoquista;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO gestor;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES TO relatorios;


--
-- PostgreSQL database dump complete
--

\unrestrict ad8I00bBQkqImqnp58do51vL6Y5OkRNCVy6KCcDDOD004EVL0UohSpXDIn8tLbh

