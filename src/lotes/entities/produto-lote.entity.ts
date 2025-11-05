import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { Localizacao } from '../../locais/entities/localizacao.entity';
import { MovimentacaoEstoque } from '../../movimentacoes/entities/movimentacao-estoque.entity';

@Entity('produto_lotes')
export class ProdutoLote {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Produto, { nullable: false })
  @JoinColumn({ name: 'id_produto' })
  produto: Produto;

  @Column({ name: 'codigo_lote', type: 'varchar', length: 50 })
  codigoLote: string;

  @Column({ name: 'data_validade', type: 'date', nullable: true })
  dataValidade?: Date;

  @Column('numeric', { precision: 10, scale: 2, default: 0 })
  quantidade: number;

  @Column({ name: 'data_entrada', type: 'date' })
  dataEntrada: Date;

  @ManyToOne(() => Usuario, { nullable: false })
  @JoinColumn({ name: 'responsavel_cadastro' })
  responsavelCadastro: Usuario;

  @Column('numeric', { name: 'custo_unitario', precision: 10, scale: 2, nullable: true })
  custoUnitario?: number;

  @ManyToOne(() => Localizacao, { nullable: true })
  @JoinColumn({ name: 'id_localizacao' })
  localizacao?: Localizacao;

  @Column({ default: true })
  ativo: boolean;

  @OneToMany(() => MovimentacaoEstoque, (m) => m.lote)
  movimentacoes?: MovimentacaoEstoque[];
}
