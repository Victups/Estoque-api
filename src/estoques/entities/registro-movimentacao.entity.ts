import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { Localizacao } from '../../locais/entities/localizacao.entity';

@Entity('registro_movimentacoes')
export class RegistroMovimentacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => ProdutoLote, { nullable: true })
  @JoinColumn({ name: 'id_lote' })
  lote?: ProdutoLote;

  @ManyToOne(() => Produto, { nullable: true })
  @JoinColumn({ name: 'id_produto' })
  produto?: Produto;

  @ManyToOne(() => Usuario, { nullable: true })
  @JoinColumn({ name: 'id_usuario' })
  usuario?: Usuario;

  @Column('numeric', { name: 'valor_total', precision: 10, scale: 2, nullable: true })
  valorTotal?: number;

  @Column({ name: 'data_criacao', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  dataCriacao: Date;

  @Column({ name: 'usuario_log_id', nullable: true })
  usuarioLogId?: number;

  @ManyToOne(() => Localizacao, { nullable: true })
  @JoinColumn({ name: 'id_localizacao' })
  localizacao?: Localizacao;
}
