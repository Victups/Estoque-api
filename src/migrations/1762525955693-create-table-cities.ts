import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableCities1762525955693 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.municipio_id_municipio_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.municipio (
        id integer NOT NULL,
        nome varchar(150) NOT NULL,
        id_uf integer NOT NULL,
        bairro varchar(150),
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT municipio_pkey PRIMARY KEY (id),
        CONSTRAINT municipio_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id)
      )
    `);

    await queryRunner.query(`
      ALTER TABLE public.municipio ALTER COLUMN id SET DEFAULT nextval('public.municipio_id_municipio_seq')
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.municipio`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.municipio_id_municipio_seq`);
  }
}
