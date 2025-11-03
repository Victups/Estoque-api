import { Type } from 'class-transformer';
import { IsEmail, IsInt, IsNotEmpty, IsOptional, IsString, MaxLength, IsBoolean, IsIn } from 'class-validator';

export class CreateUsuarioDto {

	@IsString()
	@IsNotEmpty()
	@MaxLength(100)
	nome: string;

	@IsEmail()
	@IsNotEmpty()
	@MaxLength(150)
	email: string;

	@IsString()
	@IsNotEmpty()
	@MaxLength(255)
	senha: string;

	@Type(() => Number)
	@IsInt()
	@IsOptional()
	id_contato?: number;

	@IsIn(['admin','gestor','estoquista','relatorios'])
	@IsOptional()
	role?: string;

	@Type(() => Number)
	@IsInt()
	@IsOptional()
	id_uf?: number;

	@IsBoolean()
	@IsOptional()
	ativo?: boolean;

}
