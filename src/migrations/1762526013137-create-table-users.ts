import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateTableUsers1762526013137 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE SEQUENCE IF NOT EXISTS public.usuarios_id_usuario_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS public.usuarios (
        id integer NOT NULL,
        nome varchar(100) NOT NULL,
        email varchar(150) NOT NULL,
        senha varchar(255) NOT NULL,
        id_contato integer,
        role public.role_enum DEFAULT 'relatorios'::public.role_enum NOT NULL,
        id_uf integer,
        ativo boolean DEFAULT true NOT NULL,
        CONSTRAINT usuarios_pkey PRIMARY KEY (id),
        CONSTRAINT usuarios_email_key UNIQUE (email),
        CONSTRAINT fk_usuario_contato FOREIGN KEY (id_contato) REFERENCES public.contatos(id),
        CONSTRAINT usuarios_id_uf_fkey FOREIGN KEY (id_uf) REFERENCES public.uf(id)
      )
    `);

    await queryRunner.query(`
      ALTER TABLE public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_usuario_seq')
    `);

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS idx_usuarios_ativo ON public.usuarios (ativo)
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS public.idx_usuarios_ativo`);
    await queryRunner.query(`DROP TABLE IF EXISTS public.usuarios`);
    await queryRunner.query(`DROP SEQUENCE IF EXISTS public.usuarios_id_usuario_seq`);
  }
}
