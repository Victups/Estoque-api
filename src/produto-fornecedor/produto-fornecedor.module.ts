import { Module } from '@nestjs/common';
import { ProdutoFornecedorController } from './produto-fornecedor.controller';
import { ProdutoFornecedorService } from './produto-fornecedor.service';

@Module({
  controllers: [ProdutoFornecedorController],
  providers: [ProdutoFornecedorService]
})
export class ProdutoFornecedorModule {}
