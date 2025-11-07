import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableUnits1762526048412 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.unidade_medida_id_unidade_medida_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.unidade_medidas (
        id integer NOT NULL,
        descricao varchar(50) NOT NULL,
        abreviacao public.unidade_enum,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT unidade_medida_pkey PRIMARY KEY (id)
      )
    `);

    await queryRunner.query(
      `ALTER TABLE public.unidade_medidas ALTER COLUMN id SET DEFAULT nextval('public.unidade_medida_id_unidade_medida_seq')`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.unidade_medidas`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.unidade_medida_id_unidade_medida_seq`);
  }
}
