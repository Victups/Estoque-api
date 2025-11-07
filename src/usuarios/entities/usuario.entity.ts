import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Contato } from '../../contatos/entities/contato.entity';
import { Produto } from '../../produtos/entities/produto.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { MovimentacaoEstoque } from '../../movimentacoes/entities/movimentacao-estoque.entity';
import { RegistroMovimentacao } from '../../estoques/entities/registro-movimentacao.entity';
import { Dashboard } from '../../dashboards/entities/dashboard.entity';

@Entity('usuarios')
export class Usuario {
	@PrimaryGeneratedColumn()
	id: number;

	@Column({ length: 150 })
	nome: string;

	@Column({ length: 150, unique: true })
	email: string;

	@Column({ length: 255 })
	senha: string;

	@ManyToOne(() => Contato, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
	@JoinColumn({ name: 'id_contato' })
	contato?: Contato;

	@Column({ name: 'id_uf', nullable: true })
	idUf?: number;

	@Column({ default: true })
	ativo: boolean;

	@Column({ type: 'varchar', length: 20, default: 'relatorios' })
	role: string;

	@OneToMany(() => Produto, (p) => p.responsavelCadastro, { cascade: false })
	produtosResponsavel?: Produto[];

	@OneToMany(() => Produto, (p) => p.usuarioLog, { cascade: false })
	produtosLog?: Produto[];

	@OneToMany(() => Produto, (p) => p.createdBy, { cascade: false })
	produtosCriados?: Produto[];

	@OneToMany(() => Produto, (p) => p.updatedBy, { cascade: false })
	produtosAtualizados?: Produto[];

	@OneToMany(() => ProdutoLote, (l) => l.responsavelCadastro, { cascade: false })
	lotesResponsavel?: ProdutoLote[];

	@OneToMany(() => ProdutoLote, (l) => l.usuarioLog, { cascade: false })
	lotesLog?: ProdutoLote[];

	@OneToMany(() => ProdutoLote, (l) => l.createdBy, { cascade: false })
	lotesCriados?: ProdutoLote[];

	@OneToMany(() => ProdutoLote, (l) => l.updatedBy, { cascade: false })
	lotesAtualizados?: ProdutoLote[];

	@OneToMany(() => MovimentacaoEstoque, (m) => m.createdBy, { cascade: false })
	movimentacoesCriadas?: MovimentacaoEstoque[];

	@OneToMany(() => MovimentacaoEstoque, (m) => m.updatedBy, { cascade: false })
	movimentacoesAtualizadas?: MovimentacaoEstoque[];

	@OneToMany(() => RegistroMovimentacao, (r) => r.usuario, { cascade: false })
	registrosMovimentacao?: RegistroMovimentacao[];

	@OneToMany(() => RegistroMovimentacao, (r) => r.usuarioLog, { cascade: false })
	registrosMovimentacaoLog?: RegistroMovimentacao[];

	@OneToMany(() => RegistroMovimentacao, (r) => r.createdBy, { cascade: false })
	registrosCriados?: RegistroMovimentacao[];

	@OneToMany(() => RegistroMovimentacao, (r) => r.updatedBy, { cascade: false })
	registrosAtualizados?: RegistroMovimentacao[];

	@OneToMany(() => Dashboard, (d) => d.owner, { cascade: false })
	dashboards?: Dashboard[];
}
