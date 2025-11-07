import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableStates1762525949657 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.uf_id_uf_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.uf (
        id integer NOT NULL,
        sigla char(2) NOT NULL,
        nome varchar(100) NOT NULL,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT uf_pkey PRIMARY KEY (id),
        CONSTRAINT uf_sigla_key UNIQUE (sigla)
      )
    `);

    await queryRunner.query(`
      ALTER TABLE public.uf ALTER COLUMN id SET DEFAULT nextval('public.uf_id_uf_seq')
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.uf`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.uf_id_uf_seq`);
  }
}
