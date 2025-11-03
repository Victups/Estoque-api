import { Type } from 'class-transformer';
import { IsBoolean, IsInt, IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';

export class CreateCategoriaDto {

	@Type(() => Number)
	@IsInt()
	@IsOptional()
	readonly id?: number;

	@IsString()
	@IsNotEmpty()
	@MaxLength(100)
	readonly name: string;

	@IsBoolean()
	@IsOptional()
	readonly ativo?: boolean;

}
