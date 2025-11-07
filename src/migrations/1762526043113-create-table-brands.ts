import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableBrands1762526043113 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.marca_id_marca_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.marcas (
        id integer NOT NULL,
        nome varchar(100) NOT NULL,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT marca_pkey PRIMARY KEY (id),
        CONSTRAINT unique_nome UNIQUE (nome)
      )
    `);

    await queryRunner.query(`ALTER TABLE public.marcas ALTER COLUMN id SET DEFAULT nextval('public.marca_id_marca_seq')`);
    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_marcas_ativo ON public.marcas (ativo)`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_marcas_ativo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.marcas`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.marca_id_marca_seq`);
  }
}
