import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { DepositosService } from './depositos.service';
import { CreateDepositoDto } from './dto/create-deposito.dto';
import { UpdateDepositoDto } from './dto/update-deposito.dto';

@Controller('depositos')
export class DepositosController {
	constructor(private readonly depositosService: DepositosService) {}

	@Post()
	create(@Body() createDto: CreateDepositoDto) {
		return this.depositosService.create(createDto);
	}

	@Get()
	findAll() {
		return this.depositosService.findAll();
	}

	@Get(':id')
	findOne(@Param('id') id: string) {
		return this.depositosService.findOne(+id);
	}

	@Patch(':id')
	update(@Param('id') id: string, @Body() updateDto: UpdateDepositoDto) {
		return this.depositosService.update(+id, updateDto);
	}

	@Delete(':id')
	remove(@Param('id') id: string) {
		return this.depositosService.remove(+id);
	}
}
