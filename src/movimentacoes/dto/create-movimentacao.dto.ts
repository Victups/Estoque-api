import { Type } from 'class-transformer';
import { IsEnum, IsInt, IsNotEmpty, IsNumber, IsOptional, IsString, MaxLength, Min } from 'class-validator';

enum MovimentoTipoEnum {
  ENTRADA = 'entrada',
  SAIDA = 'saida'
}

export class CreateMovimentacaoDto {
  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_produto: number;

  @IsNumber()
  @IsNotEmpty()
  @Min(0)
  quantidade: number;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_usuario: number;

  @IsString()
  @IsOptional()
  @MaxLength(255)
  observacao?: string;

  @IsNumber()
  @IsNotEmpty()
  @Min(0)
  preco_unitario: number;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_lote: number;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  usuario_log_id?: number;

  @IsEnum(MovimentoTipoEnum)
  @IsNotEmpty()
  tipo_movimento: MovimentoTipoEnum;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  id_localizacao_origem?: number;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  id_localizacao_destino?: number;
}