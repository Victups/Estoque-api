import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableUserStatePermissions1762526020639 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.usuario_uf_permissao (
        id_usuario integer NOT NULL,
        id_uf integer NOT NULL,
        CONSTRAINT usuario_uf_permissao_pkey PRIMARY KEY (id_usuario, id_uf),
        CONSTRAINT usuario_uf_permissao_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id),
        CONSTRAINT usuario_uf_permissao_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id)
      )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS public.usuario_uf_permissao`);
  }
}
