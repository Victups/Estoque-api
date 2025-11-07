import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableSupplierAddress1762526060386 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.fornecedor_endereco (
        id_fornecedor integer NOT NULL,
        id_endereco integer NOT NULL,
        tipo_endereco varchar(50) NOT NULL,
        CONSTRAINT fornecedor_endereco_pkey PRIMARY KEY (id_fornecedor, id_endereco),
        CONSTRAINT fornecedor_endereco_id_fornecedor_fkey FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedores(id),
        CONSTRAINT fornecedor_endereco_id_endereco_fkey FOREIGN KEY (id_endereco) REFERENCES public.enderecos(id)
      )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.fornecedor_endereco`);
  }
}
