import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableProductAllergens1762526081935 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.produtos_alergenos_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.produtos_alergenos (
        id integer NOT NULL,
        nome varchar(100) NOT NULL,
        CONSTRAINT pk_produtos_alergenos PRIMARY KEY (id, nome),
        CONSTRAINT produto_alergeno_id_produto_fkey FOREIGN KEY (id) REFERENCES public.produtos(id)
      )
    `);

    await queryRunner.query(
      `ALTER TABLE public.produtos_alergenos ALTER COLUMN id SET DEFAULT nextval('public.produtos_alergenos_id_seq')`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.produtos_alergenos`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.produtos_alergenos_id_seq`);
  }
}
