import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LocaisController } from './locais.controller';
import { LocaisService } from './locais.service';
import { Localizacao } from './entities/localizacao.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Localizacao])],
  controllers: [LocaisController],
  providers: [LocaisService],
})
export class LocaisModule {}
