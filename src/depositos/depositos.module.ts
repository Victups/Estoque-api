import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DepositosController } from './depositos.controller';
import { DepositosService } from './depositos.service';
import { Deposito } from './entities/deposito.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Deposito])],
  controllers: [DepositosController],
  providers: [DepositosService],
})
export class DepositosModule {}
