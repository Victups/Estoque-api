import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableStockMovements1762526087573 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.movimentacao_estoque_id_mov_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.movimentacao_estoque (
        id integer NOT NULL,
        id_produto integer NOT NULL,
        quantidade numeric(10,2) NOT NULL,
        data_mov timestamp DEFAULT CURRENT_TIMESTAMP,
        id_lote integer NOT NULL,
        tipo_movimento public.movimento_tipo_enum DEFAULT 'entrada'::public.movimento_tipo_enum NOT NULL,
        created_at timestamptz DEFAULT now() NOT NULL,
        updated_at timestamptz DEFAULT now() NOT NULL,
        created_by integer,
        updated_by integer,
        CONSTRAINT movimentacao_estoque_pkey PRIMARY KEY (id),
        CONSTRAINT chk_quantidade_mov_nonnegative CHECK (quantidade >= 0),
        CONSTRAINT movimentacao_estoque_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id),
        CONSTRAINT fk_movimento_lote FOREIGN KEY (id_lote) REFERENCES public.produto_lotes(id),
        CONSTRAINT mov_est_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id),
        CONSTRAINT mov_est_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id)
      )
    `);

    await queryRunner.query(
      `ALTER TABLE public.movimentacao_estoque ALTER COLUMN id SET DEFAULT nextval('public.movimentacao_estoque_id_mov_seq')`,
    );

    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_mov_est_produto ON public.movimentacao_estoque (id_produto)`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_mov_est_produto`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.movimentacao_estoque`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.movimentacao_estoque_id_mov_seq`);
  }
}
