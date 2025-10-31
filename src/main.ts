import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(...pipes:new ValidationPipe());
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
