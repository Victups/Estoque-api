import { Type } from 'class-transformer';
import { IsString, IsInt, IsNotEmpty, IsOptional, MaxLength, IsBoolean } from 'class-validator';

export class CreateLocalDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  corredor?: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  prateleira?: string;

  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  secao?: string;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_deposito: number;

  @IsBoolean()
  @IsOptional()
  ativo?: boolean;
}