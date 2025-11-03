import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProdutosModule } from './produtos/produtos.module';
import { FornecedoresModule } from './fornecedores/fornecedores.module';
import { CategoriasModule } from './categorias/categorias.module';
import { AuthModule } from './auth/auth.module';
import { UsuariosModule } from './usuarios/usuarios.module';
import { DashboardsModule } from './dashboards/dashboards.module';
import { LocaisModule } from './locais/locais.module';
import { EstoquesModule } from './estoques/estoques.module';
import { MovimentacoesModule } from './movimentacoes/movimentacoes.module';
import { LotesModule } from './lotes/lotes.module';
import { MarcasModule } from './marcas/marcas.module';
import { UnidadesModule } from './unidades/unidades.module';
import { DatabaseModule } from './database/database.module';
import { DepositosModule } from './depositos/depositos.module';
import { EnderecosController } from './enderecos/enderecos.controller';
import { ContatosController } from './contatos/contatos.controller';
import { ProdutoFornecedorModule } from './produto-fornecedor/produto-fornecedor.module';
import { EnderecosModule } from './enderecos/enderecos.module';

@Module({
  imports: [ProdutosModule, FornecedoresModule, CategoriasModule, AuthModule, UsuariosModule, DashboardsModule, LocaisModule, EstoquesModule, MovimentacoesModule, LotesModule, MarcasModule, UnidadesModule, DatabaseModule, DepositosModule, ProdutoFornecedorModule, EnderecosModule],
  controllers: [AppController, EnderecosController, ContatosController],
  providers: [AppService],
})
export class AppModule {}
