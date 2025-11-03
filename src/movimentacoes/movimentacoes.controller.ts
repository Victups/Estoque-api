import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { MovimentacoesService } from './movimentacoes.service';
import { CreateMovimentacaoDto } from './dto/create-movimentacao.dto';
import { UpdateMovimentacaoDto } from './dto/update-movimentacao.dto';

@Controller('movimentacoes')
export class MovimentacoesController {
	constructor(private readonly movimentacoesService: MovimentacoesService) {}

	@Post()
	create(@Body() dto: CreateMovimentacaoDto) {
		return this.movimentacoesService.create(dto);
	}

	@Get()
	findAll() {
		return this.movimentacoesService.findAll();
	}

	@Get(':id')
	findOne(@Param('id') id: string) {
		return this.movimentacoesService.findOne(+id);
	}

	@Patch(':id')
	update(@Param('id') id: string, @Body() dto: UpdateMovimentacaoDto) {
		return this.movimentacoesService.update(+id, dto);
	}

	@Delete(':id')
	remove(@Param('id') id: string) {
		return this.movimentacoesService.remove(+id);
	}
}
