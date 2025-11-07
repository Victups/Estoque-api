import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableAuditLog1762525939937 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.auditoria_alteracoes_audit_id_seq
        AS bigint
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.auditoria_alteracoes (
        audit_id bigint NOT NULL,
        tabela varchar(100) NOT NULL,
        registro_id bigint NOT NULL,
        operacao char(1) NOT NULL,
        dados_antes jsonb,
        dados_depois jsonb,
        usuario_id integer,
        audit_timestamp timestamptz DEFAULT now() NOT NULL,
        CONSTRAINT auditoria_alteracoes_pkey PRIMARY KEY (audit_id),
        CONSTRAINT auditoria_usuario_fk FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id)
      )
    `);

    await queryRunner.query(`
      ALTER TABLE public.auditoria_alteracoes ALTER COLUMN audit_id SET DEFAULT nextval('public.auditoria_alteracoes_audit_id_seq')
    `);

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS idx_auditoria_alteracoes_tbl ON public.auditoria_alteracoes (tabela, registro_id)
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS idx_auditoria_alteracoes_usuario ON public.auditoria_alteracoes (usuario_id, audit_timestamp)
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_auditoria_alteracoes_usuario`);
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_auditoria_alteracoes_tbl`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.auditoria_alteracoes`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.auditoria_alteracoes_audit_id_seq`);
  }
}
