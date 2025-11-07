import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateDatabaseEnum1762525392213 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`CREATE TYPE IF NOT EXISTS public.movimento_tipo_enum AS ENUM ('entrada', 'saida')`);
    await queryRunner.query(`CREATE TYPE IF NOT EXISTS public.role_enum AS ENUM ('admin', 'gestor', 'estoquista', 'relatorios')`);
    await queryRunner.query(
      `CREATE TYPE IF NOT EXISTS public.tipo_contato_enum AS ENUM ('telefone', 'email', 'whatsapp', 'instagram', 'telegram', 'outro')`,
    );
    await queryRunner.query(`CREATE TYPE IF NOT EXISTS public.unidade_enum AS ENUM ('un', 'kg', 'L', 'pac', 'cx', 'g', 'ml')`);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TYPE IF EXISTS public.unidade_enum`);
    await queryRunner.query(`DROP TYPE IF EXISTS public.tipo_contato_enum`);
    await queryRunner.query(`DROP TYPE IF EXISTS public.role_enum`);
    await queryRunner.query(`DROP TYPE IF EXISTS public.movimento_tipo_enum`);
  }
}
