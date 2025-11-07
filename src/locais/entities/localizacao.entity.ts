import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Deposito } from '../../depositos/entities/deposito.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { RegistroMovimentacao } from '../../estoques/entities/registro-movimentacao.entity';

@Entity('localizacoes')
export class Localizacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Deposito, { nullable: false, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_deposito' })
  deposito: Deposito;

  @Column({ type: 'varchar', length: 50, nullable: true })
  corredor?: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  prateleira?: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  secao?: string;

  @Column({ type: 'boolean', default: true })
  ativo: boolean;

  @OneToMany(() => ProdutoLote, (l) => l.localizacao, { cascade: false })
  lotes?: ProdutoLote[];

  @OneToMany(() => RegistroMovimentacao, (r) => r.localizacao, { cascade: false })
  registrosMovimentacao?: RegistroMovimentacao[];

  @OneToMany(() => RegistroMovimentacao, (r) => r.localizacaoOrigem, { cascade: false })
  registrosOrigem?: RegistroMovimentacao[];

  @OneToMany(() => RegistroMovimentacao, (r) => r.localizacaoDestino, { cascade: false })
  registrosDestino?: RegistroMovimentacao[];
}
