import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateUsuarioDto } from './dto/create-usuario.dto';
import { UpdateUsuarioDto } from './dto/update-usuario.dto';
import { Usuario } from './entities/usuario.entity';

@Injectable()
export class UsuariosService {
  constructor(
    @InjectRepository(Usuario)
    private readonly repo: Repository<Usuario>,
  ) {}

  async create(createUsuarioDto: CreateUsuarioDto): Promise<Usuario> {
    const usuario = this.repo.create({
      ...createUsuarioDto,
      contato: createUsuarioDto.id_contato ? { id: createUsuarioDto.id_contato } as any : undefined,
    });
    return this.repo.save(usuario);
  }

  async findAll(): Promise<Usuario[]> {
    return this.repo.find({
      relations: ['contato'],
    });
  }

  async findOne(id: number): Promise<Usuario> {
    const usuario = await this.repo.findOne({
      where: { id },
      relations: ['contato'],
    });
    
    if (!usuario) {
      throw new NotFoundException(`Usuário com id ${id} não encontrado`);
    }
    
    return usuario;
  }

  async update(id: number, updateUsuarioDto: UpdateUsuarioDto): Promise<Usuario> {
    const usuario = await this.repo.preload({
      id,
      ...updateUsuarioDto,
      ...(updateUsuarioDto.id_contato && {
        contato: { id: updateUsuarioDto.id_contato } as any,
      }),
    });

    if (!usuario) {
      throw new NotFoundException(`Usuário com id ${id} não encontrado`);
    }

    return this.repo.save(usuario);
  }

  async remove(id: number): Promise<void> {
    const usuario = await this.findOne(id);
    await this.repo.remove(usuario);
  }
}
