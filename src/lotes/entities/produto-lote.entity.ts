import {
	Entity,
	PrimaryGeneratedColumn,
	Column,
	ManyToOne,
	JoinColumn,
	OneToMany,
	CreateDateColumn,
	UpdateDateColumn,
} from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { Localizacao } from '../../locais/entities/localizacao.entity';
import { MovimentacaoEstoque } from '../../movimentacoes/entities/movimentacao-estoque.entity';
import { RegistroMovimentacao } from '../../estoques/entities/registro-movimentacao.entity';

@Entity('produto_lotes')
export class ProdutoLote {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Produto, { nullable: false, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
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

  @ManyToOne(() => Usuario, { nullable: false, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'responsavel_cadastro' })
  responsavelCadastro: Usuario;

  @Column('numeric', { name: 'custo_unitario', precision: 10, scale: 2, nullable: true })
  custoUnitario?: number;

  @ManyToOne(() => Localizacao, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_localizacao' })
  localizacao?: Localizacao;

  @Column({ name: 'usuario_log_id', nullable: true })
  usuarioLogId?: number;

  @ManyToOne(() => Usuario, { nullable: true, onDelete: 'SET NULL', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'usuario_log_id' })
  usuarioLog?: Usuario;

  @Column({ default: true })
  ativo: boolean;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @ManyToOne(() => Usuario, { nullable: true, onDelete: 'SET NULL', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'created_by' })
  createdBy?: Usuario;

  @ManyToOne(() => Usuario, { nullable: true, onDelete: 'SET NULL', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'updated_by' })
  updatedBy?: Usuario;

  @OneToMany(() => MovimentacaoEstoque, (m) => m.lote, { cascade: false })
  movimentacoes?: MovimentacaoEstoque[];

  @OneToMany(() => RegistroMovimentacao, (r) => r.lote, { cascade: false })
  registrosMovimentacao?: RegistroMovimentacao[];
}
