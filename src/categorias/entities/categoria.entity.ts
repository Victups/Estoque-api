import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Produto } from '../../produtos/entities/produto.entity';

@Entity('categorias')
export class Categoria {
	@PrimaryGeneratedColumn()
	id: number;

	@Column({ length: 150 })
	nome: string;

	@Column({ length: 500, nullable: true })
	descricao?: string;

	@Column({ default: true })
	ativo: boolean;

	@OneToMany(() => Produto, (p) => p.categoria)
	produtos?: Produto[];
}
