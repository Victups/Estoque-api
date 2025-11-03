import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Localizacao } from './entities/localizacao.entity';
import { CreateLocalDto } from './dto/create-local.dto';
import { UpdateLocalDto } from './dto/update-local.dto';

@Injectable()
export class LocaisService {
	constructor(
		@InjectRepository(Localizacao)
		private readonly repo: Repository<Localizacao>,
	) {}

	create(createLocalDto: CreateLocalDto) {
		return this.repo.save(createLocalDto as any);
	}

	findAll() {
		return this.repo.find();
	}

	findOne(id: number) {
		return this.repo.findOneBy({ id });
	}

	async update(id: number, updateLocalDto: UpdateLocalDto) {
		await this.repo.update(id, updateLocalDto as any);
		return this.findOne(id);
	}

	remove(id: number) {
		return this.repo.delete(id);
	}
}
