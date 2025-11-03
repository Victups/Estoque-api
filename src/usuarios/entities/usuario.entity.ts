import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

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
}
