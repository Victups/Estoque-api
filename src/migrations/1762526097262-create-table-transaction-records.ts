import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableTransactionRecords1762526097262 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.registro_movimentacoes_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.registro_movimentacoes (
        id integer NOT NULL,
        id_lote integer,
        id_produto integer,
        id_usuario integer,
        valor_total numeric(10,2),
        data_criacao timestamp DEFAULT CURRENT_TIMESTAMP,
        usuario_log_id integer,
        id_localizacao integer,
        created_at timestamptz DEFAULT now() NOT NULL,
        updated_at timestamptz DEFAULT now() NOT NULL,
        created_by integer,
        updated_by integer,
        ativo boolean DEFAULT true NOT NULL,
        quantidade numeric(10,2) DEFAULT 0 NOT NULL,
        tipo_movimento public.movimento_tipo_enum DEFAULT 'entrada'::public.movimento_tipo_enum NOT NULL,
        preco_unitario numeric(10,2),
        observacao varchar(255),
        id_localizacao_origem integer,
        id_localizacao_destino integer,
        CONSTRAINT registro_movimentacoes_pkey PRIMARY KEY (id),
        CONSTRAINT registro_movimentacoes_valor_total_check CHECK (valor_total >= 0),
        CONSTRAINT registro_movimentacoes_id_lote_fkey FOREIGN KEY (id_lote) REFERENCES public.produto_lotes(id),
        CONSTRAINT registro_movimentacoes_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produtos(id),
        CONSTRAINT registro_movimentacoes_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id),
        CONSTRAINT registro_movimentacoes_usuario_log_fkey FOREIGN KEY (usuario_log_id) REFERENCES public.usuarios(id),
        CONSTRAINT reg_mov_localizacao_dest_fk FOREIGN KEY (id_localizacao_destino) REFERENCES public.localizacoes(id),
        CONSTRAINT reg_mov_localizacao_origem_fk FOREIGN KEY (id_localizacao_origem) REFERENCES public.localizacoes(id),
        CONSTRAINT fk_registro_localizacao FOREIGN KEY (id_localizacao) REFERENCES public.localizacoes(id),
        CONSTRAINT reg_mov_created_by_fk FOREIGN KEY (created_by) REFERENCES public.usuarios(id),
        CONSTRAINT reg_mov_updated_by_fk FOREIGN KEY (updated_by) REFERENCES public.usuarios(id)
      )
    `);

    await queryRunner.query(
      `ALTER TABLE public.registro_movimentacoes ALTER COLUMN id SET DEFAULT nextval('public.registro_movimentacoes_id_seq')`,
    );

    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_reg_mov_tipo ON public.registro_movimentacoes (tipo_movimento)`);
    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_reg_mov_usuario ON public.registro_movimentacoes (id_usuario)`);
    await queryRunner.query(
      `CREATE INDEX IF NOT EXISTS idx_reg_mov_audit ON public.registro_movimentacoes (usuario_log_id, updated_at)`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_reg_mov_audit`);
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_reg_mov_usuario`);
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_reg_mov_tipo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.registro_movimentacoes`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.registro_movimentacoes_id_seq`);
  }
}
