import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsOptional, IsString, MaxLength, IsBoolean } from 'class-validator';

// Nota: não existe tabela `dashboards` no db.sql — inferi campos comuns para um dashboard.
// Assunções: `title` obrigatório, `description` opcional, `ownerId` opcional (referencia usuário), `public` opcional.
export class CreateDashboardDto {

	@IsString()
	@IsNotEmpty()
	@MaxLength(200)
	title: string;

	@IsString()
	@IsOptional()
	@MaxLength(500)
	description?: string;

	@Type(() => Number)
	@IsInt()
	@IsOptional()
	ownerId?: number;

	@IsBoolean()
	@IsOptional()
	isPublic?: boolean;

}
