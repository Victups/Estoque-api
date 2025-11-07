import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Endereco } from './entities/endereco.entity';
import { CreateEnderecoDto } from './dto/create-endereco.dto';
import { UpdateEnderecoDto } from './dto/update-endereco.dto';

@Injectable()
export class EnderecosService {
  constructor(
    @InjectRepository(Endereco)
    private readonly repo: Repository<Endereco>,
  ) {}

  async create(createEnderecoDto: CreateEnderecoDto): Promise<Endereco> {
    const endereco = this.repo.create({
      logradouro: createEnderecoDto.logradouro,
      numero: createEnderecoDto.numero,
      complemento: createEnderecoDto.complemento,
      cep: createEnderecoDto.cep,
      idMunicipio: createEnderecoDto.id_municipio,
      ativo: createEnderecoDto.ativo,
    });
    return this.repo.save(endereco);
  }

  async findAll(): Promise<Endereco[]> {
    return this.repo.find({
      relations: ['depositos'],
    });
  }

  async findOne(id: number): Promise<Endereco> {
    const endereco = await this.repo.findOne({
      where: { id },
      relations: ['depositos', 'depositos.localizacoes'],
    });
    
    if (!endereco) {
      throw new NotFoundException(`Endereço com id ${id} não encontrado`);
    }
    
    return endereco;
  }

  async update(id: number, updateEnderecoDto: UpdateEnderecoDto): Promise<Endereco> {
    const endereco = await this.repo.preload({
      id,
      logradouro: updateEnderecoDto.logradouro,
      numero: updateEnderecoDto.numero,
      complemento: updateEnderecoDto.complemento,
      cep: updateEnderecoDto.cep,
      idMunicipio: updateEnderecoDto.id_municipio,
      ativo: updateEnderecoDto.ativo,
    });
    if (!endereco) {
      throw new NotFoundException(`Endereço com id ${id} não encontrado`);
    }
    return this.repo.save(endereco);
  }

  async remove(id: number): Promise<void> {
    const endereco = await this.findOne(id);
    await this.repo.remove(endereco);
  }
}