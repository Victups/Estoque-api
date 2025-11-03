import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProdutoLote } from './entities/produto-lote.entity';
import { CreateLoteDto } from './dto/create-lote.dto';
import { UpdateLoteDto } from './dto/update-lote.dto';

@Injectable()
export class LotesService {
	constructor(
		@InjectRepository(ProdutoLote)
		private readonly repo: Repository<ProdutoLote>,
	) {}

	create(createDto: CreateLoteDto) {
		return this.repo.save(createDto as any);
	}

	findAll() {
		return this.repo.find();
	}

	findOne(id: number) {
		return this.repo.findOneBy({ id });
	}

	async update(id: number, dto: UpdateLoteDto) {
		await this.repo.update(id, dto as any);
		return this.findOne(id);
	}

	remove(id: number) {
		return this.repo.delete(id);
	}
}
