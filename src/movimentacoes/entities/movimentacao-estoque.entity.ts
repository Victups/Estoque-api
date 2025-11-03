import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { Localizacao } from '../../locais/entities/localizacao.entity';

@Entity('movimentacao_estoque')
export class MovimentacaoEstoque {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Produto, { nullable: false })
  @JoinColumn({ name: 'id_produto' })
  produto: Produto;

  @Column('numeric', { precision: 10, scale: 2 })
  quantidade: number;

  @Column({ name: 'data_mov', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  dataMov: Date;

  @ManyToOne(() => Usuario, { nullable: false })
  @JoinColumn({ name: 'id_usuario' })
  usuario: Usuario;

  @Column({ type: 'varchar', length: 255, nullable: true })
  observacao?: string;

  @Column('numeric', { name: 'preco_unitario', precision: 10, scale: 2, default: 0 })
  precoUnitario: number;

  @ManyToOne(() => ProdutoLote, { nullable: false })
  @JoinColumn({ name: 'id_lote' })
  lote: ProdutoLote;

  @Column({ name: 'usuario_log_id', nullable: true })
  usuarioLogId?: number;

  @Column({ name: 'tipo_movimento', type: 'varchar', length: 10 })
  tipoMovimento: string;

  @ManyToOne(() => Localizacao, { nullable: true })
  @JoinColumn({ name: 'id_localizacao_origem' })
  localizacaoOrigem?: Localizacao;

  @ManyToOne(() => Localizacao, { nullable: true })
  @JoinColumn({ name: 'id_localizacao_destino' })
  localizacaoDestino?: Localizacao;
}
