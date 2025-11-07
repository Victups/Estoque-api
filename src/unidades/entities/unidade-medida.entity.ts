import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';

@Entity('unidade_medidas')
export class UnidadeMedida {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 50 })
  descricao: string;

  @Column({ type: 'varchar', length: 10, nullable: true })
  abreviacao?: string;

  @Column({ default: true })
  ativo: boolean;

  @OneToMany(() => Produto, (p) => p.unidadeMedida, { cascade: false })
  produtos: Produto[];
}
