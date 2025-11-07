import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Deposito } from '../../depositos/entities/deposito.entity';

@Entity('enderecos')
export class Endereco {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  logradouro: string;

  @Column({ length: 20, nullable: true })
  numero?: string;

  @Column({ length: 255, nullable: true })
  complemento?: string;

  @Column({ length: 20 })
  cep: string;

  @Column({ name: 'id_municipio', nullable: true })
  idMunicipio?: number;

  @Column({ default: true })
  ativo: boolean;

  @OneToMany(() => Deposito, (d) => d.endereco, { cascade: false })
  depositos?: Deposito[];
}
