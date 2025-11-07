import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableProductSupplier1762526066739 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.produto_fornecedor (
        id_produto integer NOT NULL,
        id_fornecedor integer NOT NULL,
        data_cadastro timestamp DEFAULT CURRENT_TIMESTAMP,
        usuario_log_id integer,
        CONSTRAINT pk_produto_fornecedor PRIMARY KEY (id_produto, id_fornecedor)
      )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.produto_fornecedor`);
  }
}
