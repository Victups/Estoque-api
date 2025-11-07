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
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';

export enum TipoMovimentacao {
	ENTRADA = 'entrada',
	SAIDA = 'saida',
}

@Entity('movimentacao_estoque')
export class MovimentacaoEstoque {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Produto, { nullable: false, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_produto' })
  produto: Produto;

  @Column('numeric', { precision: 10, scale: 2 })
  quantidade: number;

  @Column({ name: 'data_mov', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  dataMov: Date;

  @ManyToOne(() => ProdutoLote, { nullable: false, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_lote' })
  lote: ProdutoLote;

  @Column({
    name: 'tipo_movimento',
    type: 'enum',
    enum: TipoMovimentacao,
    enumName: 'movimento_tipo_enum',
  })
  tipoMovimento: TipoMovimentacao;

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
