import { PartialType } from '@nestjs/mapped-types';
import { CreateCategoriaDto } from './create-categoria.dto';
import { IsNumber, IsString } from 'class-validator';

export class UpdateCategoriaDto extends PartialType(CreateCategoriaDto) {

@IsNumber()
readonly id?: number;

@IsString()
readonly name?: string;
}

