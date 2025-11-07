import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableCategories1762526035283 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.categoria_id_categoria_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.categorias (
        id integer NOT NULL,
        nome varchar(100) NOT NULL,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT categoria_pkey PRIMARY KEY (id)
      )
    `);

    await queryRunner.query(
      `ALTER TABLE public.categorias ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_categoria_seq')`,
    );

    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_categorias_ativo ON public.categorias (ativo)`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_categorias_ativo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.categorias`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.categoria_id_categoria_seq`);
  }
}
