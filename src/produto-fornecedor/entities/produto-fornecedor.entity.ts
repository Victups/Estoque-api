import { Entity, Column, ManyToOne, PrimaryColumn, JoinColumn } from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';
import { Fornecedore } from '../../fornecedores/entities/fornecedore.entity';

@Entity('produto_fornecedor')
export class ProdutoFornecedor {
  @PrimaryColumn({ name: 'id_produto' })
  idProduto: number;

  @PrimaryColumn({ name: 'id_fornecedor' })
  idFornecedor: number;

  @ManyToOne(() => Produto, (p) => p.fornecedores, { onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_produto' })
  produto: Produto;

  @ManyToOne(() => Fornecedore, (f) => f.produtos, { onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({ name: 'id_fornecedor' })
  fornecedor: Fornecedore;

  @Column({ type: 'timestamp', name: 'data_cadastro', default: () => 'CURRENT_TIMESTAMP' })
  dataCadastro: Date;

  @Column({ name: 'usuario_log_id', nullable: true })
  usuarioLogId?: number;
}
