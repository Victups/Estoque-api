import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Fornecedore } from '../../fornecedores/entities/fornecedore.entity';
import { Usuario } from '../../usuarios/entities/usuario.entity';

@Entity('contatos')
export class Contato {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 255 })
  nome: string;

  @Column({ length: 50, nullable: true })
  valor?: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  tipo_contato?: string;

  @Column({ length: 10, nullable: true })
  codigo_pais?: string;

  @Column({ type: 'timestamp', name: 'data_criacao', default: () => 'CURRENT_TIMESTAMP' })
  dataCriacao: Date;

  @Column({ default: true })
  ativo: boolean;

  @OneToMany(() => Fornecedore, (f) => f.contato, { cascade: false })
  fornecedores?: Fornecedore[];

  @OneToMany(() => Usuario, (u) => u.contato, { cascade: false })
  usuarios?: Usuario[];
}
