import { DataSource } from 'typeorm';
import { config } from 'dotenv';

config({
  path: process.env.NODE_ENV === 'test' ? '.env.test' : '.env',
});

export default new DataSource({
  type: 'postgres',
  host: process.env.POSTGRES_HOST,
  port: parseInt(process.env.POSTGRES_PORT as string, 10),
  username: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
  entities: [__dirname + '/../src/**/*.entity{.ts,.js}'],
  migrations: [
    __dirname + '/scripts/*{.ts,.js}',
    __dirname + '/master-data/*{.ts,.js}',
  ],
  synchronize: false,
  ssl:
    process.env.POSTGRES_SSL === 'true' ? { rejectUnauthorized: false } : false,
});
