import { IsString, IsNotEmpty, IsOptional, MaxLength, IsInt, IsBoolean } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateDepositoDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  nome: string;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  id_endereco?: number;

  @IsBoolean()
  @IsOptional()
  ativo?: boolean;
}
