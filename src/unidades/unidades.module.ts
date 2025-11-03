import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UnidadesController } from './unidades.controller';
import { UnidadesService } from './unidades.service';
import { UnidadeMedida } from './entities/unidade-medida.entity';

@Module({
  imports: [TypeOrmModule.forFeature([UnidadeMedida])],
  controllers: [UnidadesController],
  providers: [UnidadesService],
})
export class UnidadesModule {}
