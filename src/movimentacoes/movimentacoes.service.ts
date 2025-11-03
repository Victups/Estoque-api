import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MovimentacaoEstoque } from './entities/movimentacao-estoque.entity';
import { CreateMovimentacaoDto } from './dto/create-movimentacao.dto';
import { UpdateMovimentacaoDto } from './dto/update-movimentacao.dto';

@Injectable()
export class MovimentacoesService {
	constructor(
		@InjectRepository(MovimentacaoEstoque)
		private readonly repo: Repository<MovimentacaoEstoque>,
	) {}

	create(createDto: CreateMovimentacaoDto) {
		return this.repo.save(createDto as any);
	}

	findAll() {
		return this.repo.find();
	}

	findOne(id: number) {
		return this.repo.findOneBy({ id });
	}

	async update(id: number, dto: UpdateMovimentacaoDto) {
		await this.repo.update(id, dto as any);
		return this.findOne(id);
	}

	remove(id: number) {
		return this.repo.delete(id);
	}
}
