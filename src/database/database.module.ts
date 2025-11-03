import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { DataSourceOptions } from 'typeorm';

export const dataSourceOptions: DataSourceOptions = {
  type: 'postgres',
  host: 'localhost',
  port: 5432,
  username: 'postgres',
  password: 'admin',
  database: 'produto',
  synchronize: true,
  // registra automaticamente todas as entities em src/**/entities/*.entity.ts ou .js
  entities: [__dirname + '/../**/entities/*.entities{.ts,.js}'],
};

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      useFactory: async () => ({
        ...dataSourceOptions,
      }),
    }),
  ],
})
export class DatabaseModule {}
