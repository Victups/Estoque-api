import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateProdutoDto } from './dto/create-produto.dto';
import { UpdateProdutoDto } from './dto/update-produto.dto';
import { Produto } from './entities/produto.entity';

@Injectable()
export class ProdutosService {
  constructor(
    @InjectRepository(Produto)
    private readonly repo: Repository<Produto>,
  ) {}

  async create(createProdutoDto: CreateProdutoDto): Promise<Produto> {
    const codigoInformado = createProdutoDto.codigo?.trim();
    let codigo = codigoInformado;
    let id: number | undefined;

    if (!codigoInformado) {
      const result = await this.repo.query(
        "SELECT nextval('public.produto_id_produto_seq') AS id",
      );
      id = Number(result?.[0]?.id ?? result?.[0]?.nextval);
      codigo = `PROD${String(id).padStart(3, '0')}`;
    }

    const produto = this.repo.create({
      id,
      nome: createProdutoDto.nome,
      codigo,
      descricao: createProdutoDto.descricao,
      unidadeMedida: { id: createProdutoDto.id_unidade_medida } as any,
      marca: createProdutoDto.id_marca ? ({ id: createProdutoDto.id_marca } as any) : undefined,
      categoria: createProdutoDto.id_categoria
        ? ({ id: createProdutoDto.id_categoria } as any)
        : undefined,
      responsavelCadastro: { id: createProdutoDto.responsavel_cadastro } as any,
      usuarioLog: createProdutoDto.usuario_log_id
        ? ({ id: createProdutoDto.usuario_log_id } as any)
        : undefined,
      usuarioLogId: createProdutoDto.usuario_log_id ?? undefined,
      ativo: createProdutoDto.ativo ?? true,
      isPerecivel: createProdutoDto.is_perecivel ?? false,
      createdBy: { id: createProdutoDto.responsavel_cadastro } as any,
      updatedBy: { id: createProdutoDto.responsavel_cadastro } as any,
    });
    return this.repo.save(produto);
  }

  async findAll(): Promise<Produto[]> {
    return this.repo.find({
      relations: [
        'unidadeMedida',
        'marca',
        'categoria',
        'responsavelCadastro',
        'usuarioLog',
      ],
    });
  }

  async findOne(id: number): Promise<Produto> {
    const produto = await this.repo.findOne({
      where: { id },
      relations: [
        'unidadeMedida',
        'marca',
        'categoria',
        'responsavelCadastro',
        'usuarioLog',
        'lotes',
        'lotes.localizacao',
        'fornecedores',
        'fornecedores.fornecedor',
        'movimentacoes',
      ],
    });
    
    if (!produto) {
      throw new NotFoundException(`Produto com id ${id} não encontrado`);
    }
    
    return produto;
  }

  async update(id: number, updateProdutoDto: UpdateProdutoDto): Promise<Produto> {
    const produto = await this.repo.preload({
      id,
      ...updateProdutoDto,
      ...(updateProdutoDto.id_unidade_medida && {
        unidadeMedida: { id: updateProdutoDto.id_unidade_medida } as any,
      }),
      ...(updateProdutoDto.id_marca && {
        marca: { id: updateProdutoDto.id_marca } as any,
      }),
      ...(updateProdutoDto.id_categoria && {
        categoria: { id: updateProdutoDto.id_categoria } as any,
      }),
      ...(updateProdutoDto.responsavel_cadastro && {
        responsavelCadastro: { id: updateProdutoDto.responsavel_cadastro } as any,
      }),
      ...(updateProdutoDto.usuario_log_id && {
        usuarioLog: { id: updateProdutoDto.usuario_log_id } as any,
        usuarioLogId: updateProdutoDto.usuario_log_id,
        updatedBy: { id: updateProdutoDto.usuario_log_id } as any,
      }),
    });

    if (!produto) {
      throw new NotFoundException(`Produto com id ${id} não encontrado`);
    }

    return this.repo.save(produto);
  }

  async remove(id: number): Promise<void> {
    const produto = await this.findOne(id);
    await this.repo.remove(produto);
  }
}
