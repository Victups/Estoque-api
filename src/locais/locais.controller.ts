import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { LocaisService } from './locais.service';
import { CreateLocalDto } from './dto/create-local.dto';
import { UpdateLocalDto } from './dto/update-local.dto';

@Controller('locais')
export class LocaisController {
	constructor(private readonly locaisService: LocaisService) {}

	@Post()
	create(@Body() createLocalDto: CreateLocalDto) {
		return this.locaisService.create(createLocalDto);
	}

	@Get()
	findAll() {
		return this.locaisService.findAll();
	}

	@Get(':id')
	findOne(@Param('id') id: string) {
		return this.locaisService.findOne(+id);
	}

	@Patch(':id')
	update(@Param('id') id: string, @Body() updateLocalDto: UpdateLocalDto) {
		return this.locaisService.update(+id, updateLocalDto);
	}

	@Delete(':id')
	remove(@Param('id') id: string) {
		return this.locaisService.remove(+id);
	}
}
