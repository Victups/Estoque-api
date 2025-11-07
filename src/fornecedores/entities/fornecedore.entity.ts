import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany, JoinColumn } from 'typeorm';
import { Contato } from '../../contatos/entities/contato.entity';
import { ProdutoFornecedor } from '../../produto-fornecedor/entities/produto-fornecedor.entity';

@Entity('fornecedores')
export class Fornecedore {
	@PrimaryGeneratedColumn()
	id: number;

	@Column({ length: 150 })
	nome: string;

	@Column({ length: 20, nullable: true })
	cnpj?: string;

	@ManyToOne(() => Contato, { nullable: true, onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
	@JoinColumn({ name: 'id_contato' })
	contato?: Contato;

	@Column({ default: true })
	ativo: boolean;

	@OneToMany(() => ProdutoFornecedor, (pf) => pf.fornecedor, { cascade: false })
	produtos: ProdutoFornecedor[];
}
