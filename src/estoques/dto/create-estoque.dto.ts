import {
  IsNumber,
  IsOptional,
  IsDate,
  IsEnum,
  IsString,
  MaxLength,
  IsNotEmpty,
  Min,
  IsInt,
} from 'class-validator';
import { Type } from 'class-transformer';
import { TipoMovimentacao } from '../../movimentacoes/entities/movimentacao-estoque.entity';

export class CreateEstoqueDto {
  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_lote: number;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_produto: number;

  @Type(() => Number)
  @IsInt()
  @IsNotEmpty()
  id_usuario: number;

  @Type(() => Number)
  @IsNumber()
  @IsNotEmpty()
  @Min(0)
  quantidade: number;

  @IsEnum(TipoMovimentacao)
  @IsNotEmpty()
  tipo_movimento: TipoMovimentacao;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  valor_total?: number;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  preco_unitario?: number;

  @IsString()
  @IsOptional()
  @MaxLength(255)
  observacao?: string;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  id_localizacao?: number;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  usuario_log_id?: number;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  id_localizacao_origem?: number;

  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  id_localizacao_destino?: number;

  @IsDate()
  @Type(() => Date)
  @IsOptional()
  dataCriacao?: Date;
}