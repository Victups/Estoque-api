import { PartialType } from '@nestjs/mapped-types';
import { CreateCategoriaDto } from './create-categoria.dto';
//import { IsNumber, IsString, IsBo } from 'class-validator';

export class UpdateCategoriaDto extends PartialType(CreateCategoriaDto) {
}

