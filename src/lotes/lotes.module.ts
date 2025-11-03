import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LotesController } from './lotes.controller';
import { LotesService } from './lotes.service';
import { ProdutoLote } from './entities/produto-lote.entity';

@Module({
  imports: [TypeOrmModule.forFeature([ProdutoLote])],
  controllers: [LotesController],
  providers: [LotesService],
})
export class LotesModule {}
