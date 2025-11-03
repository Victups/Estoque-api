--
-- PostgreSQL database dump
--

\restrict cGU5esJ0K63XdD04MmhBxT4f52GDajpHgYjdroUgIHI1hbrf5cRDflbPjYw3ggC

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-11-03 10:06:36

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
-- TOC entry 889 (class 1247 OID 29595)
-- Name: movimento_tipo_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.movimento_tipo_enum AS ENUM (
    'entrada',
    'saida'
);


ALTER TYPE public.movimento_tipo_enum OWNER TO postgres;

--
-- TOC entry 892 (class 1247 OID 29600)
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
-- TOC entry 895 (class 1247 OID 29610)
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
-- TOC entry 898 (class 1247 OID 29624)
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
-- TOC entry 255 (class 1255 OID 29639)
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
-- TOC entry 256 (class 1255 OID 29640)
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
-- TOC entry 219 (class 1259 OID 29641)
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id integer CONSTRAINT categoria_id_categoria_not_null NOT NULL,
    nome character varying(100) CONSTRAINT categoria_nome_not_null NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 219
-- Name: COLUMN categorias.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.categorias.ativo IS 'Indica se a categoria está ativa (true) ou inativa (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- TOC entry 220 (class 1259 OID 29646)
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
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 220
-- Name: categoria_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.categorias.id;


--
-- TOC entry 221 (class 1259 OID 29647)
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
-- TOC entry 222 (class 1259 OID 29653)
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
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 222
-- Name: contatos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contatos_id_seq OWNED BY public.contatos.id;


--
-- TOC entry 223 (class 1259 OID 29654)
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
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN depositos.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.depositos.ativo IS 'Indica se o depósito está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- TOC entry 224 (class 1259 OID 29659)
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
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 224
-- Name: deposito_id_deposito_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deposito_id_deposito_seq OWNED BY public.depositos.id;


--
-- TOC entry 225 (class 1259 OID 29660)
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
-- TOC entry 226 (class 1259 OID 29667)
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
-- TOC entry 227 (class 1259 OID 29668)
-- Name: fornecedor_endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fornecedor_endereco (
    id_fornecedor integer NOT NULL,
    id_endereco integer NOT NULL,
    tipo_endereco character varying(50) NOT NULL
);


ALTER TABLE public.fornecedor_endereco OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 29674)
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
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 228
-- Name: COLUMN fornecedores.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.fornecedores.ativo IS 'Indica se o fornecedor está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- TOC entry 229 (class 1259 OID 29679)
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
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 229
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fornecedor_id_fornecedor_seq OWNED BY public.fornecedores.id;


--
-- TOC entry 230 (class 1259 OID 29680)
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
-- TOC entry 231 (class 1259 OID 29681)
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
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 231
-- Name: COLUMN localizacoes.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.localizacoes.ativo IS 'Indica se a localização está ativa (true) ou inativa (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- TOC entry 232 (class 1259 OID 29686)
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
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 232
-- Name: localizacao_id_localizacao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.localizacao_id_localizacao_seq OWNED BY public.localizacoes.id;


--
-- TOC entry 233 (class 1259 OID 29687)
-- Name: marcas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marcas (
    id integer CONSTRAINT marca_id_marca_not_null NOT NULL,
    nome character varying(100) CONSTRAINT marca_nome_not_null NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.marcas OWNER TO postgres;

--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 233
-- Name: COLUMN marcas.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.marcas.ativo IS 'Indica se a marca está ativa (true) ou inativa (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- TOC entry 234 (class 1259 OID 29692)
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
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 234
-- Name: marca_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.marca_id_marca_seq OWNED BY public.marcas.id;


--
-- TOC entry 235 (class 1259 OID 29693)
-- Name: movimentacao_estoque; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movimentacao_estoque (
    id integer CONSTRAINT movimentacao_estoque_id_mov_not_null NOT NULL,
    id_produto integer NOT NULL,
    quantidade numeric(10,2) NOT NULL,
    data_mov timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    id_usuario integer NOT NULL,
    observacao character varying(255),
    preco_unitario numeric(10,2) DEFAULT 0 NOT NULL,
    id_lote integer NOT NULL,
    usuario_log_id integer,
    tipo_movimento public.movimento_tipo_enum DEFAULT 'entrada'::public.movimento_tipo_enum NOT NULL,
    id_localizacao_origem integer,
    id_localizacao_destino integer,
    CONSTRAINT chk_preco_unitario_nonnegative CHECK ((preco_unitario >= (0)::numeric)),
    CONSTRAINT chk_quantidade_mov_nonnegative CHECK ((quantidade >= (0)::numeric))
);


ALTER TABLE public.movimentacao_estoque OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 29708)
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
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 236
-- Name: movimentacao_estoque_id_mov_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movimentacao_estoque_id_mov_seq OWNED BY public.movimentacao_estoque.id;


--
-- TOC entry 237 (class 1259 OID 29709)
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
-- TOC entry 238 (class 1259 OID 29715)
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
-- TOC entry 239 (class 1259 OID 29716)
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
-- TOC entry 240 (class 1259 OID 29722)
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
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 240
-- Name: COLUMN produtos.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.produtos.ativo IS 'Indica se o produto está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- TOC entry 241 (class 1259 OID 29735)
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
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 241
-- Name: produto_id_produto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_id_produto_seq OWNED BY public.produtos.id;


--
-- TOC entry 242 (class 1259 OID 29736)
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
    CONSTRAINT chk_custo_nonnegative CHECK ((custo_unitario >= (0)::numeric)),
    CONSTRAINT chk_quantidade_nonnegative CHECK ((quantidade >= (0)::numeric))
);


ALTER TABLE public.produto_lotes OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 29749)
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
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 243
-- Name: produto_lote_id_lote_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produto_lote_id_lote_seq OWNED BY public.produto_lotes.id;


--
-- TOC entry 244 (class 1259 OID 29750)
-- Name: produtos_alergenos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos_alergenos (
    id integer CONSTRAINT produto_alergeno_id_produto_not_null NOT NULL,
    nome character varying(100) CONSTRAINT produto_alergeno_nome_not_null NOT NULL
);


ALTER TABLE public.produtos_alergenos OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 29755)
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
-- TOC entry 5323 (class 0 OID 0)
-- Dependencies: 245
-- Name: produtos_alergenos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produtos_alergenos_id_seq OWNED BY public.produtos_alergenos.id;


--
-- TOC entry 246 (class 1259 OID 29756)
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
    CONSTRAINT registro_movimentacoes_valor_total_check CHECK ((valor_total >= (0)::numeric))
);


ALTER TABLE public.registro_movimentacoes OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 29762)
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
-- TOC entry 5326 (class 0 OID 0)
-- Dependencies: 247
-- Name: registro_movimentacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.registro_movimentacoes_id_seq OWNED BY public.registro_movimentacoes.id;


--
-- TOC entry 248 (class 1259 OID 29763)
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
-- TOC entry 249 (class 1259 OID 29769)
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
-- TOC entry 250 (class 1259 OID 29770)
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
-- TOC entry 251 (class 1259 OID 29775)
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
-- TOC entry 5331 (class 0 OID 0)
-- Dependencies: 251
-- Name: unidade_medida_id_unidade_medida_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unidade_medida_id_unidade_medida_seq OWNED BY public.unidade_medidas.id;


--
-- TOC entry 252 (class 1259 OID 29776)
-- Name: usuario_uf_permissao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_uf_permissao (
    id_usuario integer NOT NULL,
    id_uf integer NOT NULL
);


ALTER TABLE public.usuario_uf_permissao OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 29781)
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
-- TOC entry 5334 (class 0 OID 0)
-- Dependencies: 253
-- Name: COLUMN usuarios.ativo; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.usuarios.ativo IS 'Indica se o usuário está ativo (true) ou inativo (false). Usar inativação ao invés de DELETE para manter histórico.';


--
-- TOC entry 254 (class 1259 OID 29792)
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
-- TOC entry 5336 (class 0 OID 0)
-- Dependencies: 254
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id;


--
-- TOC entry 4960 (class 2604 OID 29793)
-- Name: categorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_categoria_seq'::regclass);


--
-- TOC entry 4962 (class 2604 OID 29794)
-- Name: contatos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contatos ALTER COLUMN id SET DEFAULT nextval('public.contatos_id_seq'::regclass);


--
-- TOC entry 4965 (class 2604 OID 29795)
-- Name: depositos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositos ALTER COLUMN id SET DEFAULT nextval('public.deposito_id_deposito_seq'::regclass);


--
-- TOC entry 4969 (class 2604 OID 29796)
-- Name: localizacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localizacoes ALTER COLUMN id SET DEFAULT nextval('public.localizacao_id_localizacao_seq'::regclass);


--
-- TOC entry 4971 (class 2604 OID 29797)
-- Name: marcas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas ALTER COLUMN id SET DEFAULT nextval('public.marca_id_marca_seq'::regclass);


--
-- TOC entry 4973 (class 2604 OID 29798)
-- Name: movimentacao_estoque id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque ALTER COLUMN id SET DEFAULT nextval('public.movimentacao_estoque_id_mov_seq'::regclass);


--
-- TOC entry 4984 (class 2604 OID 29799)
-- Name: produto_lotes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes ALTER COLUMN id SET DEFAULT nextval('public.produto_lote_id_lote_seq'::regclass);


--
-- TOC entry 4979 (class 2604 OID 29800)
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produto_id_produto_seq'::regclass);


--
-- TOC entry 4988 (class 2604 OID 29801)
-- Name: registro_movimentacoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes ALTER COLUMN id SET DEFAULT nextval('public.registro_movimentacoes_id_seq'::regclass);


--
-- TOC entry 4991 (class 2604 OID 29802)
-- Name: unidade_medidas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidade_medidas ALTER COLUMN id SET DEFAULT nextval('public.unidade_medida_id_unidade_medida_seq'::regclass);


--
-- TOC entry 4993 (class 2604 OID 29803)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 5239 (class 0 OID 29641)
-- Dependencies: 219
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
-- TOC entry 5241 (class 0 OID 29647)
-- Dependencies: 221
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
-- TOC entry 5243 (class 0 OID 29654)
-- Dependencies: 223
-- Data for Name: depositos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.depositos (id, nome, id_endereco, ativo) FROM stdin;
1	Depósito Central	1	t
2	Depósito de Refrigerados	2	t
\.


--
-- TOC entry 5245 (class 0 OID 29660)
-- Dependencies: 225
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
-- TOC entry 5247 (class 0 OID 29668)
-- Dependencies: 227
-- Data for Name: fornecedor_endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fornecedor_endereco (id_fornecedor, id_endereco, tipo_endereco) FROM stdin;
1	3	Comercial
2	4	Fábrica
3	5	Matriz
\.


--
-- TOC entry 5248 (class 0 OID 29674)
-- Dependencies: 228
-- Data for Name: fornecedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fornecedores (id, nome, cnpj, id_contato, ativo) FROM stdin;
1	Distribuidora de Alimentos Goiás	01.234.567/0001-89	4	t
2	Laticínios Centro-Oeste	98.765.432/0001-10	5	t
3	Frios Brasil S.A.	11.222.333/0001-44	6	t
\.


--
-- TOC entry 5251 (class 0 OID 29681)
-- Dependencies: 231
-- Data for Name: localizacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.localizacoes (id, id_deposito, corredor, prateleira, secao, ativo) FROM stdin;
1	1	A1	P1	S1	t
2	1	A2	P2	S1	t
3	2	B1	P1	S1	t
4	2	B2	P2	S2	t
\.


--
-- TOC entry 5253 (class 0 OID 29687)
-- Dependencies: 233
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
-- TOC entry 5255 (class 0 OID 29693)
-- Dependencies: 235
-- Data for Name: movimentacao_estoque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movimentacao_estoque (id, id_produto, quantidade, data_mov, id_usuario, observacao, preco_unitario, id_lote, usuario_log_id, tipo_movimento, id_localizacao_origem, id_localizacao_destino) FROM stdin;
1	1	100.00	2025-10-10 16:35:16.547107	2	\N	4.50	1	\N	entrada	\N	3
2	2	80.00	2025-10-10 16:35:16.547107	2	\N	2.10	2	\N	entrada	\N	3
3	6	5000.00	2025-10-10 16:35:16.547107	2	\N	0.02	3	\N	entrada	\N	4
4	1	200.00	2025-10-10 16:35:16.547107	2	\N	4.55	4	\N	entrada	\N	3
5	3	300.00	2025-10-10 16:35:16.547107	2	\N	22.50	5	\N	entrada	\N	1
6	3	250.00	2025-10-10 16:35:16.547107	2	\N	22.90	6	\N	entrada	\N	1
7	4	400.00	2025-10-10 16:35:16.547107	2	\N	8.50	7	\N	entrada	\N	1
8	5	150.00	2025-10-10 16:35:16.547107	3	\N	7.80	8	\N	entrada	\N	2
9	1	20.00	2025-10-10 16:35:16.57941	3	Venda para mercado local	0.00	1	\N	saida	3	\N
10	3	50.00	2025-10-10 16:35:16.57941	3	Venda para restaurante	0.00	5	\N	saida	1	\N
11	6	150.00	2025-10-10 16:35:16.57941	3	Uso interno na padaria	0.00	3	\N	saida	4	\N
\.


--
-- TOC entry 5257 (class 0 OID 29709)
-- Dependencies: 237
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
-- TOC entry 5259 (class 0 OID 29716)
-- Dependencies: 239
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
-- TOC entry 5262 (class 0 OID 29736)
-- Dependencies: 242
-- Data for Name: produto_lotes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_lotes (id, id_produto, codigo_lote, data_validade, quantidade, data_entrada, responsavel_cadastro, custo_unitario, usuario_log_id, id_localizacao, ativo) FROM stdin;
1	1	L001	2025-10-25	100.00	2025-10-10	2	4.50	\N	3	t
2	2	L002	2025-11-08	80.00	2025-10-10	2	2.10	\N	3	t
3	6	L003	2025-10-20	5000.00	2025-10-10	2	0.02	\N	4	t
4	1	L004	2026-02-15	200.00	2025-10-10	2	4.55	\N	3	t
5	3	L005	2026-08-20	300.00	2025-10-10	2	22.50	\N	1	t
6	3	L006	2026-09-10	250.00	2025-10-10	2	22.90	\N	1	t
7	4	L007	2027-01-10	400.00	2025-10-10	2	8.50	\N	1	t
8	5	L008	2026-06-01	150.00	2025-10-10	3	7.80	\N	2	t
\.


--
-- TOC entry 5260 (class 0 OID 29722)
-- Dependencies: 240
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (id, nome, codigo, descricao, id_unidade_medida, id_marca, id_categoria, responsavel_cadastro, data_cadastro, usuario_log_id, estoque_minimo, is_perecivel, ativo) FROM stdin;
1	Leite Integral UHT	PROD001	Leite de vaca integral longa vida	3	1	1	1	2025-10-10 16:35:16.413901	\N	50.00	f	t
2	Iogurte Natural	PROD002	Iogurte natural sem açúcar	1	2	1	1	2025-10-10 16:35:16.413901	\N	30.00	f	t
3	Arroz Agulhinha Tipo 1	PROD003	Arroz branco longo fino	2	3	2	2	2025-10-10 16:35:16.413901	\N	100.00	f	t
4	Feijão Carioca	PROD004	Feijão carioca tipo 1	4	4	2	2	2025-10-10 16:35:16.413901	\N	80.00	f	t
5	Refrigerante de Cola	PROD005	Refrigerante sabor cola 2L	3	5	3	3	2025-10-10 16:35:16.413901	\N	40.00	f	t
6	Presunto Cozido Fatiado	PROD006	Presunto cozido sem capa de gordura	6	6	5	3	2025-10-10 16:35:16.413901	\N	2000.00	f	t
\.


--
-- TOC entry 5264 (class 0 OID 29750)
-- Dependencies: 244
-- Data for Name: produtos_alergenos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos_alergenos (id, nome) FROM stdin;
1	Contém Lactose
1	Contém proteínas do leite
2	Contém Lactose
\.


--
-- TOC entry 5266 (class 0 OID 29756)
-- Dependencies: 246
-- Data for Name: registro_movimentacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registro_movimentacoes (id, id_lote, id_produto, id_usuario, valor_total, data_criacao, usuario_log_id, id_localizacao) FROM stdin;
1	1	1	2	450.00	2025-10-10 16:35:16.616542	\N	3
2	2	2	2	168.00	2025-10-10 16:35:16.616542	\N	3
3	3	6	2	100.00	2025-10-10 16:35:16.616542	\N	4
4	4	1	2	910.00	2025-10-10 16:35:16.616542	\N	3
5	5	3	2	6750.00	2025-10-10 16:35:16.616542	\N	1
6	6	3	2	5725.00	2025-10-10 16:35:16.616542	\N	1
7	7	4	2	3400.00	2025-10-10 16:35:16.616542	\N	1
8	8	5	3	1170.00	2025-10-10 16:35:16.616542	\N	2
9	1	1	3	\N	2025-10-10 16:35:16.616542	\N	3
10	5	3	3	\N	2025-10-10 16:35:16.616542	\N	1
11	3	6	3	\N	2025-10-10 16:35:16.616542	\N	4
\.


--
-- TOC entry 5268 (class 0 OID 29763)
-- Dependencies: 248
-- Data for Name: uf; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uf (id, sigla, nome, ativo) FROM stdin;
1	GO	Goiás	t
2	SP	São Paulo	t
3	RJ	Rio de Janeiro	t
\.


--
-- TOC entry 5270 (class 0 OID 29770)
-- Dependencies: 250
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
-- TOC entry 5272 (class 0 OID 29776)
-- Dependencies: 252
-- Data for Name: usuario_uf_permissao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario_uf_permissao (id_usuario, id_uf) FROM stdin;
\.


--
-- TOC entry 5273 (class 0 OID 29781)
-- Dependencies: 253
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nome, email, senha, id_contato, role, id_uf, ativo) FROM stdin;
1	Administrador	admin@sistema.com	senha_super_segura_hash	1	admin	\N	t
3	Maria Souza	maria.souza@empresa.com	senha_segura_hash_456	3	gestor	\N	t
2	João da Silva	joao.silva@empresa.com	senha_segura_hash_123	2	estoquista	\N	t
\.


--
-- TOC entry 5338 (class 0 OID 0)
-- Dependencies: 220
-- Name: categoria_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_id_categoria_seq', 5, true);


--
-- TOC entry 5339 (class 0 OID 0)
-- Dependencies: 222
-- Name: contatos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contatos_id_seq', 6, true);


--
-- TOC entry 5340 (class 0 OID 0)
-- Dependencies: 224
-- Name: deposito_id_deposito_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deposito_id_deposito_seq', 2, true);


--
-- TOC entry 5341 (class 0 OID 0)
-- Dependencies: 226
-- Name: endereco_id_endereco_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.endereco_id_endereco_seq', 5, true);


--
-- TOC entry 5342 (class 0 OID 0)
-- Dependencies: 229
-- Name: fornecedor_id_fornecedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fornecedor_id_fornecedor_seq', 1, false);


--
-- TOC entry 5343 (class 0 OID 0)
-- Dependencies: 230
-- Name: fornecedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fornecedores_id_seq', 3, true);


--
-- TOC entry 5344 (class 0 OID 0)
-- Dependencies: 232
-- Name: localizacao_id_localizacao_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.localizacao_id_localizacao_seq', 4, true);


--
-- TOC entry 5345 (class 0 OID 0)
-- Dependencies: 234
-- Name: marca_id_marca_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.marca_id_marca_seq', 7, true);


--
-- TOC entry 5346 (class 0 OID 0)
-- Dependencies: 236
-- Name: movimentacao_estoque_id_mov_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movimentacao_estoque_id_mov_seq', 11, true);


--
-- TOC entry 5347 (class 0 OID 0)
-- Dependencies: 238
-- Name: municipio_id_municipio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.municipio_id_municipio_seq', 5, true);


--
-- TOC entry 5348 (class 0 OID 0)
-- Dependencies: 241
-- Name: produto_id_produto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_id_produto_seq', 6, true);


--
-- TOC entry 5349 (class 0 OID 0)
-- Dependencies: 243
-- Name: produto_lote_id_lote_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_lote_id_lote_seq', 8, true);


--
-- TOC entry 5350 (class 0 OID 0)
-- Dependencies: 245
-- Name: produtos_alergenos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produtos_alergenos_id_seq', 1, false);


--
-- TOC entry 5351 (class 0 OID 0)
-- Dependencies: 247
-- Name: registro_movimentacoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registro_movimentacoes_id_seq', 11, true);


--
-- TOC entry 5352 (class 0 OID 0)
-- Dependencies: 249
-- Name: uf_id_uf_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uf_id_uf_seq', 3, true);


--
-- TOC entry 5353 (class 0 OID 0)
-- Dependencies: 251
-- Name: unidade_medida_id_unidade_medida_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unidade_medida_id_unidade_medida_seq', 7, true);


--
-- TOC entry 5354 (class 0 OID 0)
-- Dependencies: 254
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 3, true);


--
-- TOC entry 5002 (class 2606 OID 29805)
-- Name: categorias categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- TOC entry 5005 (class 2606 OID 29807)
-- Name: contatos contatos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contatos
    ADD CONSTRAINT contatos_pkey PRIMARY KEY (id);


--
-- TOC entry 5007 (class 2606 OID 29809)
-- Name: depositos deposito_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositos
    ADD CONSTRAINT deposito_pkey PRIMARY KEY (id);


--
-- TOC entry 5010 (class 2606 OID 29811)
-- Name: enderecos endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 5012 (class 2606 OID 29813)
-- Name: fornecedor_endereco fornecedor_endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedor_endereco
    ADD CONSTRAINT fornecedor_endereco_pkey PRIMARY KEY (id_fornecedor, id_endereco);


--
-- TOC entry 5014 (class 2606 OID 29815)
-- Name: fornecedores fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (id);


--
-- TOC entry 5016 (class 2606 OID 29817)
-- Name: fornecedores fornecedores_cnpj_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fornecedores_cnpj_key UNIQUE (cnpj);


--
-- TOC entry 5020 (class 2606 OID 29819)
-- Name: localizacoes localizacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localizacoes
    ADD CONSTRAINT localizacao_pkey PRIMARY KEY (id);


--
-- TOC entry 5023 (class 2606 OID 29821)
-- Name: marcas marca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT marca_pkey PRIMARY KEY (id);


--
-- TOC entry 5027 (class 2606 OID 29823)
-- Name: movimentacao_estoque movimentacao_estoque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT movimentacao_estoque_pkey PRIMARY KEY (id);


--
-- TOC entry 5029 (class 2606 OID 29825)
-- Name: municipio municipio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_pkey PRIMARY KEY (id);


--
-- TOC entry 5031 (class 2606 OID 29827)
-- Name: produto_fornecedor pk_produto_fornecedor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_fornecedor
    ADD CONSTRAINT pk_produto_fornecedor PRIMARY KEY (id_produto, id_fornecedor);


--
-- TOC entry 5040 (class 2606 OID 29829)
-- Name: produtos_alergenos pk_produtos_alergenos; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos_alergenos
    ADD CONSTRAINT pk_produtos_alergenos PRIMARY KEY (id, nome);


--
-- TOC entry 5034 (class 2606 OID 29831)
-- Name: produtos produto_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_codigo_key UNIQUE (codigo);


--
-- TOC entry 5038 (class 2606 OID 29833)
-- Name: produto_lotes produto_lote_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_pkey PRIMARY KEY (id);


--
-- TOC entry 5036 (class 2606 OID 29835)
-- Name: produtos produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- TOC entry 5042 (class 2606 OID 29837)
-- Name: registro_movimentacoes registro_movimentacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_pkey PRIMARY KEY (id);


--
-- TOC entry 5044 (class 2606 OID 29839)
-- Name: uf uf_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uf
    ADD CONSTRAINT uf_pkey PRIMARY KEY (id);


--
-- TOC entry 5046 (class 2606 OID 29841)
-- Name: uf uf_sigla_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uf
    ADD CONSTRAINT uf_sigla_key UNIQUE (sigla);


--
-- TOC entry 5048 (class 2606 OID 29843)
-- Name: unidade_medidas unidade_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unidade_medidas
    ADD CONSTRAINT unidade_medida_pkey PRIMARY KEY (id);


--
-- TOC entry 5025 (class 2606 OID 29845)
-- Name: marcas unique_nome; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcas
    ADD CONSTRAINT unique_nome UNIQUE (nome);


--
-- TOC entry 5050 (class 2606 OID 29847)
-- Name: usuario_uf_permissao usuario_uf_permissao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_uf_permissao
    ADD CONSTRAINT usuario_uf_permissao_pkey PRIMARY KEY (id_usuario, id_uf);


--
-- TOC entry 5053 (class 2606 OID 29849)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 5055 (class 2606 OID 29851)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 5003 (class 1259 OID 30056)
-- Name: idx_categorias_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_categorias_ativo ON public.categorias USING btree (ativo);


--
-- TOC entry 5008 (class 1259 OID 30058)
-- Name: idx_depositos_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_depositos_ativo ON public.depositos USING btree (ativo);


--
-- TOC entry 5017 (class 1259 OID 30054)
-- Name: idx_fornecedores_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_fornecedores_ativo ON public.fornecedores USING btree (ativo);


--
-- TOC entry 5018 (class 1259 OID 30059)
-- Name: idx_localizacoes_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_localizacoes_ativo ON public.localizacoes USING btree (ativo);


--
-- TOC entry 5021 (class 1259 OID 30057)
-- Name: idx_marcas_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_marcas_ativo ON public.marcas USING btree (ativo);


--
-- TOC entry 5032 (class 1259 OID 30053)
-- Name: idx_produtos_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_produtos_ativo ON public.produtos USING btree (ativo);


--
-- TOC entry 5051 (class 1259 OID 30055)
-- Name: idx_usuarios_ativo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuarios_ativo ON public.usuarios USING btree (ativo);


--
-- TOC entry 5091 (class 2620 OID 29852)
-- Name: produto_lotes trg_gerar_codigo_lote; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_gerar_codigo_lote BEFORE INSERT ON public.produto_lotes FOR EACH ROW EXECUTE FUNCTION public.gerar_codigo_lote();


--
-- TOC entry 5090 (class 2620 OID 29853)
-- Name: produtos trg_gerar_codigo_produto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_gerar_codigo_produto BEFORE INSERT ON public.produtos FOR EACH ROW EXECUTE FUNCTION public.gerar_codigo_produto();


--
-- TOC entry 5057 (class 2606 OID 29854)
-- Name: enderecos endereco_id_municipio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enderecos
    ADD CONSTRAINT endereco_id_municipio_fkey FOREIGN KEY (id_municipio) REFERENCES public.municipio(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 5056 (class 2606 OID 29859)
-- Name: depositos fk_deposito_endereco; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.depositos
    ADD CONSTRAINT fk_deposito_endereco FOREIGN KEY (id_endereco) REFERENCES public.enderecos(id);


--
-- TOC entry 5069 (class 2606 OID 29864)
-- Name: produto_fornecedor fk_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_fornecedor
    ADD CONSTRAINT fk_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedores(id);


--
-- TOC entry 5060 (class 2606 OID 29869)
-- Name: fornecedores fk_fornecedor_contato; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedores
    ADD CONSTRAINT fk_fornecedor_contato FOREIGN KEY (id_contato) REFERENCES public.contatos(id);


--
-- TOC entry 5076 (class 2606 OID 29874)
-- Name: produto_lotes fk_lote_localizacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT fk_lote_localizacao FOREIGN KEY (id_localizacao) REFERENCES public.localizacoes(id);


--
-- TOC entry 5062 (class 2606 OID 29879)
-- Name: movimentacao_estoque fk_mov_destino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT fk_mov_destino FOREIGN KEY (id_localizacao_destino) REFERENCES public.localizacoes(id);


--
-- TOC entry 5063 (class 2606 OID 29884)
-- Name: movimentacao_estoque fk_mov_origem; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT fk_mov_origem FOREIGN KEY (id_localizacao_origem) REFERENCES public.localizacoes(id);


--
-- TOC entry 5064 (class 2606 OID 29889)
-- Name: movimentacao_estoque fk_movimento_lote; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT fk_movimento_lote FOREIGN KEY (id_lote) REFERENCES public.produto_lotes(id);


--
-- TOC entry 5070 (class 2606 OID 29894)
-- Name: produto_fornecedor fk_produto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_fornecedor
    ADD CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- TOC entry 5081 (class 2606 OID 29899)
-- Name: registro_movimentacoes fk_registro_localizacao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT fk_registro_localizacao FOREIGN KEY (id_localizacao) REFERENCES public.localizacoes(id);


--
-- TOC entry 5088 (class 2606 OID 29904)
-- Name: usuarios fk_usuario_contato; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT fk_usuario_contato FOREIGN KEY (id_contato) REFERENCES public.contatos(id);


--
-- TOC entry 5058 (class 2606 OID 29909)
-- Name: fornecedor_endereco fornecedor_endereco_id_endereco_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedor_endereco
    ADD CONSTRAINT fornecedor_endereco_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES public.enderecos(id);


--
-- TOC entry 5059 (class 2606 OID 29914)
-- Name: fornecedor_endereco fornecedor_endereco_id_fornecedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fornecedor_endereco
    ADD CONSTRAINT fornecedor_endereco_id_fornecedor_fkey FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedores(id);


--
-- TOC entry 5061 (class 2606 OID 29919)
-- Name: localizacoes localizacao_id_deposito_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localizacoes
    ADD CONSTRAINT localizacao_id_deposito_fkey FOREIGN KEY (id_deposito) REFERENCES public.depositos(id);


--
-- TOC entry 5065 (class 2606 OID 29924)
-- Name: movimentacao_estoque movimentacao_estoque_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT movimentacao_estoque_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- TOC entry 5066 (class 2606 OID 29929)
-- Name: movimentacao_estoque movimentacao_estoque_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT movimentacao_estoque_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- TOC entry 5067 (class 2606 OID 29934)
-- Name: movimentacao_estoque movimentacao_estoque_usuario_log_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimentacao_estoque
    ADD CONSTRAINT movimentacao_estoque_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id);


--
-- TOC entry 5068 (class 2606 OID 29939)
-- Name: municipio municipio_id_uf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipio
    ADD CONSTRAINT municipio_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id);


--
-- TOC entry 5080 (class 2606 OID 29944)
-- Name: produtos_alergenos produto_alergeno_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos_alergenos
    ADD CONSTRAINT produto_alergeno_id_produto_fkey FOREIGN KEY (id) REFERENCES public.produtos(id);


--
-- TOC entry 5071 (class 2606 OID 29949)
-- Name: produtos produto_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id);


--
-- TOC entry 5072 (class 2606 OID 29954)
-- Name: produtos produto_id_marca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_id_marca_fkey FOREIGN KEY (id_marca) REFERENCES public.marcas(id);


--
-- TOC entry 5073 (class 2606 OID 29959)
-- Name: produtos produto_id_unidade_medida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_id_unidade_medida_fkey FOREIGN KEY (id_unidade_medida) REFERENCES public.unidade_medidas(id);


--
-- TOC entry 5077 (class 2606 OID 29964)
-- Name: produto_lotes produto_lote_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- TOC entry 5078 (class 2606 OID 29969)
-- Name: produto_lotes produto_lote_responsavel_cadastro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_responsavel_cadastro_fkey FOREIGN KEY (responsavel_cadastro) REFERENCES public.usuarios(id);


--
-- TOC entry 5079 (class 2606 OID 29974)
-- Name: produto_lotes produto_lote_usuario_log_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_lotes
    ADD CONSTRAINT produto_lote_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id);


--
-- TOC entry 5074 (class 2606 OID 29979)
-- Name: produtos produto_responsavel_cadastro_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_responsavel_cadastro_fkey FOREIGN KEY (responsavel_cadastro) REFERENCES public.usuarios(id);


--
-- TOC entry 5075 (class 2606 OID 29984)
-- Name: produtos produto_usuario_log_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produto_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id);


--
-- TOC entry 5082 (class 2606 OID 29989)
-- Name: registro_movimentacoes registro_movimentacoes_id_lote_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_id_lote_fkey FOREIGN KEY (id_lote) REFERENCES public.produto_lotes(id);


--
-- TOC entry 5083 (class 2606 OID 29994)
-- Name: registro_movimentacoes registro_movimentacoes_id_produto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id);


--
-- TOC entry 5084 (class 2606 OID 29999)
-- Name: registro_movimentacoes registro_movimentacoes_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- TOC entry 5085 (class 2606 OID 30004)
-- Name: registro_movimentacoes registro_movimentacoes_usuario_log_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_movimentacoes
    ADD CONSTRAINT registro_movimentacoes_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id);


--
-- TOC entry 5086 (class 2606 OID 30009)
-- Name: usuario_uf_permissao usuario_uf_permissao_id_uf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_uf_permissao
    ADD CONSTRAINT usuario_uf_permissao_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id);


--
-- TOC entry 5087 (class 2606 OID 30014)
-- Name: usuario_uf_permissao usuario_uf_permissao_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_uf_permissao
    ADD CONSTRAINT usuario_uf_permissao_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- TOC entry 5089 (class 2606 OID 30019)
-- Name: usuarios usuarios_id_uf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id);


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO gestor;
GRANT USAGE ON SCHEMA public TO estoquista;
GRANT USAGE ON SCHEMA public TO relatorios;


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE categorias; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categorias TO admin;
GRANT SELECT ON TABLE public.categorias TO gestor;
GRANT SELECT ON TABLE public.categorias TO relatorios;


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE categoria_id_categoria_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.categoria_id_categoria_seq TO admin;
GRANT ALL ON SEQUENCE public.categoria_id_categoria_seq TO gestor;


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE contatos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.contatos TO admin;
GRANT SELECT ON TABLE public.contatos TO gestor;
GRANT SELECT ON TABLE public.contatos TO relatorios;


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 222
-- Name: SEQUENCE contatos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.contatos_id_seq TO admin;
GRANT ALL ON SEQUENCE public.contatos_id_seq TO gestor;


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE depositos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.depositos TO admin;
GRANT SELECT ON TABLE public.depositos TO gestor;
GRANT SELECT ON TABLE public.depositos TO relatorios;


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 224
-- Name: SEQUENCE deposito_id_deposito_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.deposito_id_deposito_seq TO admin;
GRANT ALL ON SEQUENCE public.deposito_id_deposito_seq TO gestor;


--
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE enderecos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.enderecos TO admin;
GRANT SELECT ON TABLE public.enderecos TO gestor;
GRANT SELECT ON TABLE public.enderecos TO relatorios;


--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 226
-- Name: SEQUENCE endereco_id_endereco_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.endereco_id_endereco_seq TO admin;
GRANT ALL ON SEQUENCE public.endereco_id_endereco_seq TO gestor;


--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE fornecedor_endereco; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.fornecedor_endereco TO admin;
GRANT SELECT ON TABLE public.fornecedor_endereco TO gestor;
GRANT SELECT ON TABLE public.fornecedor_endereco TO relatorios;


--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE fornecedores; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.fornecedores TO admin;
GRANT SELECT ON TABLE public.fornecedores TO gestor;
GRANT SELECT ON TABLE public.fornecedores TO relatorios;


--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE fornecedor_id_fornecedor_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.fornecedor_id_fornecedor_seq TO admin;
GRANT ALL ON SEQUENCE public.fornecedor_id_fornecedor_seq TO gestor;


--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE fornecedores_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.fornecedores_id_seq TO admin;
GRANT ALL ON SEQUENCE public.fornecedores_id_seq TO gestor;


--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE localizacoes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.localizacoes TO admin;
GRANT SELECT ON TABLE public.localizacoes TO gestor;
GRANT SELECT ON TABLE public.localizacoes TO estoquista;
GRANT SELECT ON TABLE public.localizacoes TO relatorios;


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE localizacao_id_localizacao_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.localizacao_id_localizacao_seq TO admin;
GRANT ALL ON SEQUENCE public.localizacao_id_localizacao_seq TO gestor;


--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE marcas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.marcas TO admin;
GRANT SELECT ON TABLE public.marcas TO gestor;
GRANT SELECT ON TABLE public.marcas TO relatorios;


--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE marca_id_marca_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.marca_id_marca_seq TO admin;
GRANT ALL ON SEQUENCE public.marca_id_marca_seq TO gestor;


--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE movimentacao_estoque; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.movimentacao_estoque TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.movimentacao_estoque TO gestor;
GRANT SELECT,INSERT ON TABLE public.movimentacao_estoque TO estoquista;
GRANT SELECT ON TABLE public.movimentacao_estoque TO relatorios;


--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 236
-- Name: SEQUENCE movimentacao_estoque_id_mov_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.movimentacao_estoque_id_mov_seq TO admin;
GRANT ALL ON SEQUENCE public.movimentacao_estoque_id_mov_seq TO gestor;


--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE municipio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.municipio TO admin;
GRANT SELECT ON TABLE public.municipio TO gestor;
GRANT SELECT ON TABLE public.municipio TO relatorios;


--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 238
-- Name: SEQUENCE municipio_id_municipio_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.municipio_id_municipio_seq TO admin;
GRANT ALL ON SEQUENCE public.municipio_id_municipio_seq TO gestor;


--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE produto_fornecedor; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produto_fornecedor TO admin;
GRANT SELECT ON TABLE public.produto_fornecedor TO gestor;
GRANT SELECT ON TABLE public.produto_fornecedor TO relatorios;


--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE produtos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produtos TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.produtos TO gestor;
GRANT SELECT ON TABLE public.produtos TO estoquista;
GRANT SELECT ON TABLE public.produtos TO relatorios;


--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 241
-- Name: SEQUENCE produto_id_produto_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produto_id_produto_seq TO admin;
GRANT ALL ON SEQUENCE public.produto_id_produto_seq TO gestor;


--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE produto_lotes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produto_lotes TO admin;
GRANT SELECT,INSERT,UPDATE ON TABLE public.produto_lotes TO gestor;
GRANT SELECT ON TABLE public.produto_lotes TO estoquista;
GRANT SELECT ON TABLE public.produto_lotes TO relatorios;


--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 242 5318
-- Name: COLUMN produto_lotes.quantidade; Type: ACL; Schema: public; Owner: postgres
--

GRANT UPDATE(quantidade) ON TABLE public.produto_lotes TO estoquista;


--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 243
-- Name: SEQUENCE produto_lote_id_lote_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produto_lote_id_lote_seq TO admin;
GRANT ALL ON SEQUENCE public.produto_lote_id_lote_seq TO gestor;


--
-- TOC entry 5322 (class 0 OID 0)
-- Dependencies: 244
-- Name: TABLE produtos_alergenos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produtos_alergenos TO admin;
GRANT SELECT ON TABLE public.produtos_alergenos TO gestor;
GRANT SELECT ON TABLE public.produtos_alergenos TO relatorios;


--
-- TOC entry 5324 (class 0 OID 0)
-- Dependencies: 245
-- Name: SEQUENCE produtos_alergenos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produtos_alergenos_id_seq TO admin;
GRANT ALL ON SEQUENCE public.produtos_alergenos_id_seq TO gestor;


--
-- TOC entry 5325 (class 0 OID 0)
-- Dependencies: 246
-- Name: TABLE registro_movimentacoes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.registro_movimentacoes TO admin;
GRANT SELECT ON TABLE public.registro_movimentacoes TO gestor;
GRANT SELECT ON TABLE public.registro_movimentacoes TO relatorios;


--
-- TOC entry 5327 (class 0 OID 0)
-- Dependencies: 247
-- Name: SEQUENCE registro_movimentacoes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.registro_movimentacoes_id_seq TO admin;
GRANT ALL ON SEQUENCE public.registro_movimentacoes_id_seq TO gestor;


--
-- TOC entry 5328 (class 0 OID 0)
-- Dependencies: 248
-- Name: TABLE uf; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.uf TO admin;
GRANT SELECT ON TABLE public.uf TO gestor;
GRANT SELECT ON TABLE public.uf TO relatorios;


--
-- TOC entry 5329 (class 0 OID 0)
-- Dependencies: 249
-- Name: SEQUENCE uf_id_uf_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.uf_id_uf_seq TO admin;
GRANT ALL ON SEQUENCE public.uf_id_uf_seq TO gestor;


--
-- TOC entry 5330 (class 0 OID 0)
-- Dependencies: 250
-- Name: TABLE unidade_medidas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.unidade_medidas TO admin;
GRANT SELECT ON TABLE public.unidade_medidas TO gestor;
GRANT SELECT ON TABLE public.unidade_medidas TO relatorios;


--
-- TOC entry 5332 (class 0 OID 0)
-- Dependencies: 251
-- Name: SEQUENCE unidade_medida_id_unidade_medida_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.unidade_medida_id_unidade_medida_seq TO admin;
GRANT ALL ON SEQUENCE public.unidade_medida_id_unidade_medida_seq TO gestor;


--
-- TOC entry 5333 (class 0 OID 0)
-- Dependencies: 252
-- Name: TABLE usuario_uf_permissao; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuario_uf_permissao TO admin;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.usuario_uf_permissao TO gestor;
GRANT SELECT,INSERT,UPDATE ON TABLE public.usuario_uf_permissao TO estoquista;
GRANT SELECT ON TABLE public.usuario_uf_permissao TO relatorios;


--
-- TOC entry 5335 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuarios TO admin;
GRANT SELECT ON TABLE public.usuarios TO gestor;
GRANT SELECT ON TABLE public.usuarios TO relatorios;


--
-- TOC entry 5337 (class 0 OID 0)
-- Dependencies: 254
-- Name: SEQUENCE usuarios_id_usuario_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO admin;
GRANT ALL ON SEQUENCE public.usuarios_id_usuario_seq TO gestor;


--
-- TOC entry 2154 (class 826 OID 30024)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO admin;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO gestor;


--
-- TOC entry 2155 (class 826 OID 30025)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO admin;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,UPDATE ON TABLES TO estoquista;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO gestor;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES TO relatorios;


-- Completed on 2025-11-03 10:06:40

--
-- PostgreSQL database dump complete
--

\unrestrict cGU5esJ0K63XdD04MmhBxT4f52GDajpHgYjdroUgIHI1hbrf5cRDflbPjYw3ggC

