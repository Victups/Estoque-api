import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProdutoFornecedor } from './entities/produto-fornecedor.entity';
import { CreateProdutoFornecedorDto } from './dto/create-produto-fornecedor.dto';
import { UpdateProdutoFornecedorDto } from './dto/update-produto-fornecedor.dto';

@Injectable()
export class ProdutoFornecedorService {
  constructor(
    @InjectRepository(ProdutoFornecedor)
    private readonly repo: Repository<ProdutoFornecedor>,
  ) {}

  async create(createProdutoFornecedorDto: CreateProdutoFornecedorDto): Promise<ProdutoFornecedor> {
    const produtoFornecedor = this.repo.create({
      idProduto: createProdutoFornecedorDto.id_produto,
      idFornecedor: createProdutoFornecedorDto.id_fornecedor,
      usuarioLogId: createProdutoFornecedorDto.usuario_log_id,
      produto: { id: createProdutoFornecedorDto.id_produto } as any,
      fornecedor: { id: createProdutoFornecedorDto.id_fornecedor } as any,
    });
    return this.repo.save(produtoFornecedor);
  }

  async findAll(): Promise<ProdutoFornecedor[]> {
    return this.repo.find({
      relations: ['produto', 'fornecedor']
    });
  }

  async findOne(idProduto: number, idFornecedor: number): Promise<ProdutoFornecedor> {
    const produtoFornecedor = await this.repo.findOne({
      where: { idProduto, idFornecedor },
      relations: ['produto', 'fornecedor']
    });
    if (!produtoFornecedor) {
      throw new NotFoundException(`Relação produto-fornecedor não encontrada`);
    }
    return produtoFornecedor;
  }

  async update(idProduto: number, idFornecedor: number, updateProdutoFornecedorDto: UpdateProdutoFornecedorDto): Promise<ProdutoFornecedor> {
    const produtoFornecedor = await this.findOne(idProduto, idFornecedor);
    if (updateProdutoFornecedorDto.usuario_log_id) {
      produtoFornecedor.usuarioLogId = updateProdutoFornecedorDto.usuario_log_id;
    }
    return this.repo.save(produtoFornecedor);
  }

  async remove(idProduto: number, idFornecedor: number): Promise<void> {
    const produtoFornecedor = await this.findOne(idProduto, idFornecedor);
    await this.repo.remove(produtoFornecedor);
  }
}