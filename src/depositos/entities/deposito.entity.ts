import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { Endereco } from '../../enderecos/entities/endereco.entity';
import { Localizacao } from '../../locais/entities/localizacao.entity';

@Entity('depositos')
export class Deposito {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 100 })
  nome: string;

  @ManyToOne(() => Endereco, { nullable: true })
  @JoinColumn({ name: 'id_endereco' })
  endereco?: Endereco;

  @Column({ type: 'boolean', default: true })
  ativo: boolean;

  @OneToMany(() => Localizacao, (l) => l.deposito)
  localizacoes: Localizacao[];
}
