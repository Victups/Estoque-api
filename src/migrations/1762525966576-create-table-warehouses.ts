import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableWarehouses1762525966576 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.deposito_id_deposito_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.depositos (
        id integer NOT NULL,
        nome varchar(100) NOT NULL,
        id_endereco integer,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT deposito_pkey PRIMARY KEY (id),
        CONSTRAINT fk_deposito_endereco FOREIGN KEY (id_endereco) REFERENCES public.enderecos(id)
      )
    `);

    await queryRunner.query(`
      ALTER TABLE public.depositos ALTER COLUMN id SET DEFAULT nextval('public.deposito_id_deposito_seq')
    `);

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS idx_depositos_ativo ON public.depositos (ativo)
    `);

    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.localizacao_id_localizacao_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.localizacoes (
        id integer NOT NULL,
        id_deposito integer NOT NULL,
        corredor varchar(50),
        prateleira varchar(50),
        secao varchar(50),
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT localizacao_pkey PRIMARY KEY (id),
        CONSTRAINT localizacao_id_deposito_fkey FOREIGN KEY (id_deposito) REFERENCES public.depositos(id)
      )
    `);

    await queryRunner.query(
      `ALTER TABLE public.localizacoes ALTER COLUMN id SET DEFAULT nextval('public.localizacao_id_localizacao_seq')`,
    );

    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_localizacoes_ativo ON public.localizacoes (ativo)`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_localizacoes_ativo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.localizacoes`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.localizacao_id_localizacao_seq`);
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_depositos_ativo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.depositos`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.deposito_id_deposito_seq`);
  }
}
