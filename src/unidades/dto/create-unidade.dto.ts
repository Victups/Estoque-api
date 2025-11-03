import { IsString, IsNotEmpty, MaxLength, IsEnum, IsBoolean, IsOptional } from 'class-validator';

enum UnidadeEnum {
  UNIDADE = 'un',
  QUILOGRAMA = 'kg',
  LITRO = 'L',
  PACOTE = 'pac',
  CAIXA = 'cx',
  GRAMA = 'g',
  MILILITRO = 'ml'
}

export class CreateUnidadeDto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(50)
  descricao: string;

  @IsEnum(UnidadeEnum)
  @IsOptional()
  abreviacao?: UnidadeEnum;

  @IsBoolean()
  @IsOptional()
  ativo?: boolean;
}