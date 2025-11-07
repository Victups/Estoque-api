import { Type } from 'class-transformer';
import {
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  MaxLength,
  Min,
} from 'class-validator';
import { TipoMovimentacao } from '../entities/movimentacao-estoque.entity';

export class CreateMovimentacaoDto {
  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_produto: number;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_lote: number;

  @Type(() => Number)
  @IsNumber()
  @IsNotEmpty()
  @Min(0)
  quantidade: number;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_usuario: number;

  @IsEnum(TipoMovimentacao)
  @IsNotEmpty()
  tipo_movimento: TipoMovimentacao;

  @IsNumber()
  @IsOptional()
  valor_total?: number;

  @IsNumber()
  @IsOptional()
  preco_unitario?: number;

  @IsString()
  @IsOptional()
  @MaxLength(255)
  observacao?: string;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  id_localizacao_origem?: number;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  id_localizacao_destino?: number;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  id_localizacao?: number;

  @Type(() => Number)
  @IsInt()
  @IsOptional()
  usuario_log_id?: number;

  @Type(() => Date)
  @IsOptional()
  data_mov?: Date;
}