import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EstoquesController } from './estoques.controller';
import { EstoquesService } from './estoques.service';
import { RegistroMovimentacao } from './entities/registro-movimentacao.entity';

@Module({
  imports: [TypeOrmModule.forFeature([RegistroMovimentacao])],
  controllers: [EstoquesController],
  providers: [EstoquesService],
})
export class EstoquesModule {}
