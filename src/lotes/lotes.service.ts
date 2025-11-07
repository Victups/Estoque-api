import { Injectable, NotFoundException } from '@nestjs/common';
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

	async create(createDto: CreateLoteDto): Promise<ProdutoLote> {
		const codigoInformado = createDto.codigo_lote?.trim();
		let codigoLote = codigoInformado;
		let id: number | undefined;

		if (!codigoInformado) {
			const result = await this.repo.query(
				"SELECT nextval('public.produto_lote_id_lote_seq') AS id",
			);
			id = Number(result?.[0]?.id ?? result?.[0]?.nextval);
			codigoLote = `L${String(id).padStart(3, '0')}`;
		}

		const lote = this.repo.create({
			id,
			codigoLote,
			produto: { id: createDto.id_produto } as any,
			dataValidade: createDto.data_validade,
			quantidade: createDto.quantidade,
			dataEntrada: createDto.data_entrada,
			responsavelCadastro: { id: createDto.responsavel_cadastro } as any,
			custoUnitario: createDto.custo_unitario,
			localizacao: createDto.id_localizacao ? ({ id: createDto.id_localizacao } as any) : undefined,
			usuarioLog: createDto.usuario_log_id ? ({ id: createDto.usuario_log_id } as any) : undefined,
			usuarioLogId: createDto.usuario_log_id ?? undefined,
			ativo: createDto.ativo ?? true,
			createdBy: { id: createDto.responsavel_cadastro } as any,
			updatedBy: { id: createDto.responsavel_cadastro } as any,
		});
		return this.repo.save(lote);
	}

	async findAll(): Promise<ProdutoLote[]> {
		// Carrega todas as relações principais
		return this.repo.find({
			relations: [
				'produto',
				'produto.unidadeMedida',
				'produto.marca',
				'produto.categoria',
				'responsavelCadastro',
				'usuarioLog',
				'localizacao',
				'localizacao.deposito',
			],
		});
	}

	async findOne(id: number): Promise<ProdutoLote> {
		const lote = await this.repo.findOne({
			where: { id },
			relations: [
				'produto',
				'produto.unidadeMedida',
				'produto.marca',
				'produto.categoria',
				'responsavelCadastro',
				'usuarioLog',
				'localizacao',
				'localizacao.deposito',
				'movimentacoes',
				'registrosMovimentacao',
			],
		});

		if (!lote) {
			throw new NotFoundException(`Lote com id ${id} não encontrado`);
		}

		return lote;
	}

	async update(id: number, dto: UpdateLoteDto): Promise<ProdutoLote> {
		const payload: Partial<ProdutoLote> = {
			id,
		};

		if (dto.codigo_lote !== undefined) {
			const codigo = dto.codigo_lote?.trim();
			payload.codigoLote = codigo && codigo.length > 0 ? codigo : undefined;
		}
		if (dto.data_validade !== undefined) {
			payload.dataValidade = dto.data_validade;
		}
		if (dto.quantidade !== undefined) {
			payload.quantidade = dto.quantidade;
		}
		if (dto.data_entrada !== undefined) {
			payload.dataEntrada = dto.data_entrada;
		}
		if (dto.custo_unitario !== undefined) {
			payload.custoUnitario = dto.custo_unitario;
		}
		if (dto.ativo !== undefined) {
			payload.ativo = dto.ativo;
		}
		if (dto.id_produto) {
			payload.produto = { id: dto.id_produto } as any;
		}
		if (dto.responsavel_cadastro) {
			payload.responsavelCadastro = { id: dto.responsavel_cadastro } as any;
		}
		if (dto.id_localizacao !== undefined) {
			payload.localizacao = dto.id_localizacao
				? ({ id: dto.id_localizacao } as any)
				: undefined;
		}
		if (dto.usuario_log_id !== undefined) {
			payload.usuarioLog = dto.usuario_log_id ? ({ id: dto.usuario_log_id } as any) : undefined;
			payload.usuarioLogId = dto.usuario_log_id ?? undefined;
			payload.updatedBy = dto.usuario_log_id ? ({ id: dto.usuario_log_id } as any) : undefined;
		}

		const lote = await this.repo.preload(payload);

		if (!lote) {
			throw new NotFoundException(`Lote com id ${id} não encontrado`);
		}

		return this.repo.save(lote);
	}

	async remove(id: number): Promise<void> {
		const lote = await this.findOne(id);
		await this.repo.remove(lote);
	}
}
