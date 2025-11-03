import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { Deposito } from '../../depositos/entities/deposito.entity';

@Entity('localizacoes')
export class Localizacao {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Deposito, { nullable: false })
  @JoinColumn({ name: 'id_deposito' })
  deposito: Deposito;

  @Column({ type: 'varchar', length: 50, nullable: true })
  corredor?: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  prateleira?: string;

  @Column({ type: 'varchar', length: 50, nullable: true })
  secao?: string;

  @Column({ type: 'boolean', default: true })
  ativo: boolean;
}
