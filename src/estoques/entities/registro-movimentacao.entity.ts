import {
	Entity,
	PrimaryGeneratedColumn,
	Column,
	ManyToOne,
	JoinColumn,
	CreateDateColumn,
	UpdateDateColumn,
} from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { Localizacao } from '../../locais/entities/localizacao.entity';
import { TipoMovimentacao } from '../../movimentacoes/entities/movimentacao-estoque.entity';

@Entity('registro_movimentacoes')
export class RegistroMovimentacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => ProdutoLote, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_lote' })
  lote?: ProdutoLote;

  @ManyToOne(() => Produto, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_produto' })
  produto?: Produto;

  @ManyToOne(() => Usuario, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_usuario' })
  usuario?: Usuario;

  @Column('numeric', { name: 'valor_total', precision: 10, scale: 2, nullable: true })
  valorTotal?: number;

  @Column({ name: 'data_criacao', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  dataCriacao: Date;

  @Column({ name: 'usuario_log_id', nullable: true })
  usuarioLogId?: number;

  @ManyToOne(() => Usuario, { nullable: true, onDelete: 'SET NULL', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'usuario_log_id' })
  usuarioLog?: Usuario;

  @ManyToOne(() => Localizacao, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_localizacao' })
  localizacao?: Localizacao;

  @ManyToOne(() => Localizacao, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_localizacao_origem' })
  localizacaoOrigem?: Localizacao;

  @ManyToOne(() => Localizacao, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_localizacao_destino' })
  localizacaoDestino?: Localizacao;

  @Column({ name: 'ativo', default: true })
  ativo: boolean;

  @Column('numeric', { name: 'quantidade', precision: 10, scale: 2, default: 0 })
  quantidade: number;

  @Column({
    name: 'tipo_movimento',
    type: 'enum',
    enum: TipoMovimentacao,
    enumName: 'movimento_tipo_enum',
  })
  tipoMovimento: TipoMovimentacao;

  @Column('numeric', { name: 'preco_unitario', precision: 10, scale: 2, nullable: true })
  precoUnitario?: number;

  @Column({ name: 'observacao', type: 'varchar', length: 255, nullable: true })
  observacao?: string;

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
}
