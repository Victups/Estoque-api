import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Contato } from './entities/contato.entity';
import { CreateContatoDto } from './dto/create-contato.dto';
import { UpdateContatoDto } from './dto/update-contato.dto';

@Injectable()
export class ContatosService {
  constructor(
    @InjectRepository(Contato)
    private readonly repo: Repository<Contato>,
  ) {}

  async create(createContatoDto: CreateContatoDto): Promise<Contato> {
    const contato = this.repo.create({
      nome: createContatoDto.nome,
      valor: createContatoDto.valor,
      tipo_contato: createContatoDto.tipo_contato,
      codigo_pais: createContatoDto.codigo_pais,
      ativo: createContatoDto.ativo,
    });
    return this.repo.save(contato);
  }

  async findAll(): Promise<Contato[]> {
    return this.repo.find({
      relations: ['fornecedores', 'usuarios'],
    });
  }

  async findOne(id: number): Promise<Contato> {
    const contato = await this.repo.findOne({
      where: { id },
      relations: ['fornecedores', 'usuarios'],
    });
    
    if (!contato) {
      throw new NotFoundException(`Contato com id ${id} não encontrado`);
    }
    
    return contato;
  }

  async update(id: number, updateContatoDto: UpdateContatoDto): Promise<Contato> {
    const contato = await this.repo.preload({
      id,
      nome: updateContatoDto.nome,
      valor: updateContatoDto.valor,
      tipo_contato: updateContatoDto.tipo_contato,
      codigo_pais: updateContatoDto.codigo_pais,
      ativo: updateContatoDto.ativo,
    });
    if (!contato) {
      throw new NotFoundException(`Contato com id ${id} não encontrado`);
    }
    return this.repo.save(contato);
  }

  async remove(id: number): Promise<void> {
    const contato = await this.findOne(id);
    await this.repo.remove(contato);
  }
}