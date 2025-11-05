import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Contato } from '../../contatos/entities/contato.entity';
import { Produto } from '../../produtos/entities/produto.entity';
import { ProdutoLote } from '../../lotes/entities/produto-lote.entity';
import { MovimentacaoEstoque } from '../../movimentacoes/entities/movimentacao-estoque.entity';
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

	@ManyToOne(() => Contato, { nullable: true })
	@JoinColumn({ name: 'id_contato' })
	contato?: Contato;

	@OneToMany(() => Produto, (p) => p.responsavelCadastro)
	produtos?: Produto[];

	@OneToMany(() => ProdutoLote, (l) => l.responsavelCadastro)
	lotes?: ProdutoLote[];

	@OneToMany(() => MovimentacaoEstoque, (m) => m.usuario)
	movimentacoes?: MovimentacaoEstoque[];

	@OneToMany(() => Dashboard, (d) => d.owner)
	dashboards?: Dashboard[];
}
