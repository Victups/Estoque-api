import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProdutosModule } from './produtos/produtos.module';
import { FornecedoresModule } from './fornecedores/fornecedores.module';
import { CategoriasModule } from './categorias/categorias.module';
import { AuthModule } from './auth/auth.module';
import { UsuariosModule } from './usuarios/usuarios.module';
import { DashboardsModule } from './dashboards/dashboards.module';

@Module({
  imports: [ProdutosModule, FornecedoresModule, CategoriasModule, AuthModule, UsuariosModule, DashboardsModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
