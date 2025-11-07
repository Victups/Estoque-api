import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableSuppliers1762526054515 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.fornecedores_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.fornecedores (
        id integer NOT NULL,
        nome varchar(150) NOT NULL,
        cnpj varchar(20),
        id_contato integer,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT fornecedor_pkey PRIMARY KEY (id),
        CONSTRAINT fornecedores_cnpj_key UNIQUE (cnpj),
        CONSTRAINT fk_fornecedor_contato FOREIGN KEY (id_contato) REFERENCES public.contatos(id)
      )
    `);

    await queryRunner.query(`ALTER TABLE public.fornecedores ALTER COLUMN id SET DEFAULT nextval('public.fornecedores_id_seq')`);
    await queryRunner.query(`CREATE INDEX IF NOT EXISTS idx_fornecedores_ativo ON public.fornecedores (ativo)`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_fornecedores_ativo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.fornecedores`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.fornecedores_id_seq`);
  }
}
