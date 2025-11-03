import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Marca } from '../../marcas/entities/marca.entity';
import { UnidadeMedida } from '../../unidades/entities/unidade-medida.entity';
import { Categoria } from '../../categorias/entities/categoria.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { ProdutoFornecedor } from '../../produto-fornecedor/entities/produto-fornecedor.entity';

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

	@ManyToOne(() => UnidadeMedida, { nullable: false })
	@JoinColumn({ name: 'id_unidade_medida' })
	unidadeMedida: UnidadeMedida;

	@ManyToOne(() => Marca, { nullable: true })
	@JoinColumn({ name: 'id_marca' })
	marca?: Marca;

	@ManyToOne(() => Categoria, { nullable: true })
	@JoinColumn({ name: 'id_categoria' })
	categoria?: Categoria;

	@ManyToOne(() => Usuario, { nullable: false })
	@JoinColumn({ name: 'responsavel_cadastro' })
	responsavelCadastro: Usuario;

	@OneToMany(() => ProdutoLote, (l) => l.produto)
	lotes: ProdutoLote[];

	@OneToMany(() => ProdutoFornecedor, (pf) => pf.produto)
	fornecedores: ProdutoFornecedor[];

	@Column('numeric', { precision: 10, scale: 2, default: 10 })
	estoqueMinimo: number;

	@Column({ name: 'is_perecivel', default: false })
	isPerecivel: boolean;

	@Column({ default: true })
	ativo: boolean;
}
