import { Injectable, NotFoundException } from '@nestjs/common';
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

	async create(createLocalDto: CreateLocalDto): Promise<Localizacao> {
		const localizacao = this.repo.create({
			...createLocalDto,
			deposito: { id: createLocalDto.id_deposito } as any,
		});
		return this.repo.save(localizacao);
	}

	async findAll(): Promise<Localizacao[]> {
		return this.repo.find({
			relations: ['deposito', 'deposito.endereco'],
		});
	}

	async findOne(id: number): Promise<Localizacao> {
		const localizacao = await this.repo.findOne({
			where: { id },
			relations: [
				'deposito',
				'deposito.endereco',
				'lotes',
				'lotes.produto',
				'movimentacoesOrigem',
				'movimentacoesDestino',
				'registrosMovimentacao',
			],
		});

		if (!localizacao) {
			throw new NotFoundException(`Localização com id ${id} não encontrada`);
		}

		return localizacao;
	}

	async update(id: number, updateLocalDto: UpdateLocalDto): Promise<Localizacao> {
		const localizacao = await this.repo.preload({
			id,
			...updateLocalDto,
			...(updateLocalDto.id_deposito && {
				deposito: { id: updateLocalDto.id_deposito } as any,
			}),
		});

		if (!localizacao) {
			throw new NotFoundException(`Localização com id ${id} não encontrada`);
		}

		return this.repo.save(localizacao);
	}

	async remove(id: number): Promise<void> {
		const localizacao = await this.findOne(id);
		await this.repo.remove(localizacao);
	}
}
