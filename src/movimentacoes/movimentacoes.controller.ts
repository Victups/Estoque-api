import { Controller, Get, Param } from '@nestjs/common';
import { MovimentacoesService } from './movimentacoes.service';

@Controller('movimentacoes')
export class MovimentacoesController {
	constructor(private readonly movimentacoesService: MovimentacoesService) {}

	@Get()
	findAll() {
		return this.movimentacoesService.findAll();
	}

	@Get(':id')
	findOne(@Param('id') id: string) {
		return this.movimentacoesService.findOne(+id);
	}
}
