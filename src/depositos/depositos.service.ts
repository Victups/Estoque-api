import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Deposito } from './entities/deposito.entity';
import { CreateDepositoDto } from './dto/create-deposito.dto';
import { UpdateDepositoDto } from './dto/update-deposito.dto';

@Injectable()
export class DepositosService {
	constructor(
		@InjectRepository(Deposito)
		private readonly repo: Repository<Deposito>,
	) {}

	create(createDto: CreateDepositoDto) {
		return this.repo.save(createDto as any);
	}

	findAll() {
		return this.repo.find();
	}

	findOne(id: number) {
		return this.repo.findOneBy({ id });
	}

	async update(id: number, dto: UpdateDepositoDto) {
		await this.repo.update(id, dto as any);
		return this.findOne(id);
	}

	remove(id: number) {
		return this.repo.delete(id);
	}
}
