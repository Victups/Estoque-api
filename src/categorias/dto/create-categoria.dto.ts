import { IsNumber, IsString } from "class-validator";

export class CreateCategoriaDto {
@IsNumber()
readonly id: number;

@IsString()
readonly name: string;

}
