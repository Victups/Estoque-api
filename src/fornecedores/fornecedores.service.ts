import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateFornecedoreDto } from './dto/create-fornecedore.dto';
import { UpdateFornecedoreDto } from './dto/update-fornecedore.dto';
import { Fornecedore } from './entities/fornecedore.entity';

@Injectable()
export class FornecedoresService {
  constructor(
    @InjectRepository(Fornecedore)
    private readonly repo: Repository<Fornecedore>,
  ) {}

  async create(createFornecedoreDto: CreateFornecedoreDto): Promise<Fornecedore> {
    const fornecedor = this.repo.create({
      ...createFornecedoreDto,
      contato: createFornecedoreDto.id_contato ? { id: createFornecedoreDto.id_contato } as any : undefined,
    });
    return this.repo.save(fornecedor);
  }

  async findAll(): Promise<Fornecedore[]> {
    return this.repo.find({
      relations: ['contato', 'produtos', 'produtos.produto'],
    });
  }

  async findOne(id: number): Promise<Fornecedore> {
    const fornecedor = await this.repo.findOne({
      where: { id },
      relations: ['contato', 'produtos', 'produtos.produto', 'produtos.produto.unidadeMedida'],
    });

    if (!fornecedor) {
      throw new NotFoundException(`Fornecedor com id ${id} não encontrado`);
    }

    return fornecedor;
  }

  async update(id: number, updateFornecedoreDto: UpdateFornecedoreDto): Promise<Fornecedore> {
    const fornecedor = await this.repo.preload({
      id,
      ...updateFornecedoreDto,
      ...(updateFornecedoreDto.id_contato && {
        contato: { id: updateFornecedoreDto.id_contato } as any,
      }),
    });

    if (!fornecedor) {
      throw new NotFoundException(`Fornecedor com id ${id} não encontrado`);
    }

    return this.repo.save(fornecedor);
  }

  async remove(id: number): Promise<void> {
    const fornecedor = await this.findOne(id);
    await this.repo.remove(fornecedor);
  }
}
