import {
	Entity,
	PrimaryGeneratedColumn,
	Column,
	ManyToOne,
	OneToMany,
	JoinColumn,
	CreateDateColumn,
	UpdateDateColumn,
} from 'typeorm';
import { Marca } from '../../marcas/entities/marca.entity';
import { UnidadeMedida } from '../../unidades/entities/unidade-medida.entity';
import { Categoria } from '../../categorias/entities/categoria.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { ProdutoFornecedor } from '../../produto-fornecedor/entities/produto-fornecedor.entity';
import { MovimentacaoEstoque } from '../../movimentacoes/entities/movimentacao-estoque.entity';

@Entity('produtos')
export class Produto {
	@PrimaryGeneratedColumn()
	id: number;

	@Column({ length: 150 })
	nome: string;

	@Column({ length: 50 })
	codigo: string;

	@Column({ length: 500, nullable: true })
	descricao?: string;

	@ManyToOne(() => UnidadeMedida, { nullable: false, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
	@JoinColumn({ name: 'id_unidade_medida' })
	unidadeMedida: UnidadeMedida;

	@ManyToOne(() => Marca, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
	@JoinColumn({ name: 'id_marca' })
	marca?: Marca;

	@ManyToOne(() => Categoria, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
	@JoinColumn({ name: 'id_categoria' })
	categoria?: Categoria;

	@ManyToOne(() => Usuario, { nullable: false, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
	@JoinColumn({ name: 'responsavel_cadastro' })
	responsavelCadastro: Usuario;

	@OneToMany(() => ProdutoLote, (l) => l.produto, { cascade: false })
	lotes: ProdutoLote[];

	@OneToMany(() => ProdutoFornecedor, (pf) => pf.produto, { cascade: false })
	fornecedores: ProdutoFornecedor[];

	@Column('numeric', { precision: 10, scale: 2, default: 10 })
	estoqueMinimo: number;

	@Column({ name: 'is_perecivel', default: false })
	isPerecivel: boolean;

	@Column({ default: true })
	ativo: boolean;

	@Column({ name: 'usuario_log_id', nullable: true })
	usuarioLogId?: number;

	@ManyToOne(() => Usuario, { nullable: true, onDelete: 'SET NULL', onUpdate: 'CASCADE' })
	@JoinColumn({ name: 'usuario_log_id' })
	usuarioLog?: Usuario;

	@Column({ name: 'data_cadastro', type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
	dataCadastro: Date;

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

	@OneToMany(() => MovimentacaoEstoque, (m) => m.produto, { cascade: false })
	movimentacoes?: MovimentacaoEstoque[];
}
