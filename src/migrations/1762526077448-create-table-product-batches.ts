import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableProductBatches1762526077448 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.produto_lote_id_lote_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.produto_lotes (
        id integer NOT NULL,
        id_produto integer NOT NULL,
        codigo_lote varchar(50) NOT NULL,
        data_validade date,
        quantidade numeric(10,2) DEFAULT 0 NOT NULL,
        data_entrada date DEFAULT CURRENT_DATE NOT NULL,
        responsavel_cadastro integer NOT NULL,
        custo_unitario numeric(10,2),
        usuario_log_id integer,
        id_localizacao integer,
        ativo boolean DEFAULT true NOT NULL,
        created_at timestamptz DEFAULT now() NOT NULL,
        updated_at timestamptz DEFAULT now() NOT NULL,
        created_by integer,
        updated_by integer,
        CONSTRAINT produto_lote_pkey PRIMARY KEY (id),
        CONSTRAINT chk_custo_nonnegative CHECK (custo_unitario >= 0),
        CONSTRAINT chk_quantidade_nonnegative CHECK (quantidade >= 0),
        CONSTRAINT produto_lote_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id),
        CONSTRAINT produto_lote_responsavel_cadastro_fkey FOREIGN KEY (responsavel_cadastro) REFERENCES public.usuarios(id),
        CONSTRAINT produto_lote_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id),
        CONSTRAINT fk_lote_localizacao FOREIGN KEY (id_localizacao) REFERENCES public.localizacoes(id),
        CONSTRAINT produto_lotes_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id),
        CONSTRAINT produto_lotes_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id)
      )
    `);

    await queryRunner.query(`ALTER TABLE public.produto_lotes ALTER COLUMN id SET DEFAULT nextval('public.produto_lote_id_lote_seq')`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.produto_lotes`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.produto_lote_id_lote_seq`);
  }
}
