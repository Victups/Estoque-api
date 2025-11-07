import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableAddresses1762525961214 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.endereco_id_endereco_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.enderecos (
        id integer NOT NULL,
        logradouro varchar(100) NOT NULL,
        numero varchar(20),
        complemento varchar(255),
        cep varchar(20) NOT NULL,
        id_municipio integer NOT NULL,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT endereco_pkey PRIMARY KEY (id),
        CONSTRAINT endereco_id_municipio_fkey FOREIGN KEY (id_municipio)
          REFERENCES public.municipio(id)
          ON UPDATE CASCADE
          ON DELETE RESTRICT
      )
    `);

    await queryRunner.query(`
      ALTER TABLE public.enderecos ALTER COLUMN id SET DEFAULT nextval('public.endereco_id_endereco_seq')
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.enderecos`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.endereco_id_endereco_seq`);
  }
}
