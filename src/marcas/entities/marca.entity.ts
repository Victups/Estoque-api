import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';

@Entity('marcas')
export class Marca {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  nome: string;

  @Column({ default: true })
  ativo: boolean;

  @OneToMany(() => Produto, (p) => p.marca, { cascade: false })
  produtos: Produto[];
}
