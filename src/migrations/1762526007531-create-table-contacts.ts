import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableContacts1762526007531 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.contatos_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.contatos (
        id integer NOT NULL,
        nome varchar(255) NOT NULL,
        valor varchar(50),
        tipo_contato public.tipo_contato_enum,
        codigo_pais varchar(10),
        data_criacao timestamp DEFAULT CURRENT_TIMESTAMP,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT contatos_pkey PRIMARY KEY (id)
      )
    `);

    await queryRunner.query(`
      ALTER TABLE public.contatos ALTER COLUMN id SET DEFAULT nextval('public.contatos_id_seq')
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.contatos`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.contatos_id_seq`);
  }
}
