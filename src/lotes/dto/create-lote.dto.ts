import { Type } from 'class-transformer';
import { IsString, IsInt, IsNotEmpty, IsOptional, MaxLength, IsDate, IsNumber, Min, IsBoolean } from 'class-validator';

export class CreateLoteDto {
  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_produto: number;

  @IsString()
  @IsOptional()
  @MaxLength(50)
  codigo_lote?: string;

  @Type(() => Date)
  @IsDate()
  @IsOptional()
  data_validade?: Date;

  @IsNumber()
  @IsNotEmpty()
  @Min(0)
  quantidade: number;

  @Type(() => Date)
  @IsDate()
  @IsNotEmpty()
  data_entrada: Date;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  responsavel_cadastro: number;

  @IsNumber()
  @IsOptional()
  @Min(0)
  custo_unitario?: number;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  usuario_log_id?: number;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  id_localizacao?: number;

  @IsBoolean()
  @IsOptional()
  ativo?: boolean;
}