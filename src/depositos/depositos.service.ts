import { Injectable, NotFoundException } from '@nestjs/common';
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

	async create(createDto: CreateDepositoDto): Promise<Deposito> {
		const deposito = this.repo.create({
			...createDto,
			endereco: createDto.id_endereco ? { id: createDto.id_endereco } as any : undefined,
		});
		return this.repo.save(deposito);
	}

	async findAll(): Promise<Deposito[]> {
		return this.repo.find({
			relations: ['endereco', 'localizacoes'],
		});
	}

	async findOne(id: number): Promise<Deposito> {
		const deposito = await this.repo.findOne({
			where: { id },
			relations: ['endereco', 'localizacoes'],
		});

		if (!deposito) {
			throw new NotFoundException(`Depósito com id ${id} não encontrado`);
		}

		return deposito;
	}

	async update(id: number, dto: UpdateDepositoDto): Promise<Deposito> {
		const deposito = await this.repo.preload({
			id,
			...dto,
			...(dto.id_endereco && {
				endereco: { id: dto.id_endereco } as any,
			}),
		});

		if (!deposito) {
			throw new NotFoundException(`Depósito com id ${id} não encontrado`);
		}

		return this.repo.save(deposito);
	}

	async remove(id: number): Promise<void> {
		const deposito = await this.findOne(id);
		await this.repo.remove(deposito);
	}
}
