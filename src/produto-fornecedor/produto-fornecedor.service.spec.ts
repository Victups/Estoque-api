import { Test, TestingModule } from '@nestjs/testing';
import { ProdutoFornecedorService } from './produto-fornecedor.service';

describe('ProdutoFornecedorService', () => {
  let service: ProdutoFornecedorService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ProdutoFornecedorService],
    }).compile();

    service = module.get<ProdutoFornecedorService>(ProdutoFornecedorService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
