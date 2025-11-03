import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { MovimentacoesController } from './movimentacoes.controller';
import { MovimentacoesService } from './movimentacoes.service';
import { MovimentacaoEstoque } from './entities/movimentacao-estoque.entity';

@Module({
  imports: [TypeOrmModule.forFeature([MovimentacaoEstoque])],
  controllers: [MovimentacoesController],
  providers: [MovimentacoesService],
})
export class MovimentacoesModule {}
