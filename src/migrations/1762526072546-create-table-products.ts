import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableProducts1762526072546 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.produto_id_produto_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.produtos (
        id integer NOT NULL,
        nome varchar(150) NOT NULL,
        codigo varchar(50) NOT NULL,
        descricao varchar(500),
        id_unidade_medida integer NOT NULL,
        id_marca integer,
        id_categoria integer,
        responsavel_cadastro integer NOT NULL,
        data_cadastro timestamp DEFAULT CURRENT_TIMESTAMP,
        usuario_log_id integer,
        estoque_minimo numeric(10,2) DEFAULT 10.00,
        is_perecivel boolean DEFAULT false,
        ativo boolean DEFAULT true NOT NULL,
        created_at timestamptz DEFAULT now() NOT NULL,
        updated_at timestamptz DEFAULT now() NOT NULL,
        created_by integer,
        updated_by integer,
        CONSTRAINT produto_pkey PRIMARY KEY (id),
        CONSTRAINT produto_codigo_key UNIQUE (codigo),
        CONSTRAINT produto_id_unidade_medida_fkey FOREIGN KEY (id_unidade_medida) REFERENCES public.unidade_medidas(id),
        CONSTRAINT produto_id_marca_fkey FOREIGN KEY (id_marca) REFERENCES public.marcas(id),
        CONSTRAINT produto_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias(id),
        CONSTRAINT produto_responsavel_cadastro_fkey FOREIGN KEY (responsavel_cadastro) REFERENCES public.usuarios(id),
        CONSTRAINT produto_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id),
        CONSTRAINT produtos_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id),
        CONSTRAINT produtos_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id)
      )
    `);

    await queryRunner.query(`ALTER TABLE public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produto_id_produto_seq')`);
    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_produtos_ativo ON public.produtos (ativo)`);

    await queryRunner.query(`
      ALTER TABLE public.produto_fornecedor
        ADD CONSTRAINT fk_produto FOREIGN KEY (id_produto) REFERENCES public.produtos(id)
    `);
    await queryRunner.query(`
      ALTER TABLE public.produto_fornecedor
        ADD CONSTRAINT fk_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedores(id)
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE public.produto_fornecedor DROP CONSTRAINT IF EXISTS fk_fornecedor`);
    await queryRunner.query(`ALTER TABLE public.produto_fornecedor DROP CONSTRAINT IF EXISTS fk_produto`);
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_produtos_ativo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.produtos`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.produto_id_produto_seq`);
  }
}
