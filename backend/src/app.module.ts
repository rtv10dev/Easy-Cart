import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ProductsModule } from './products/products.module';
import { MessagingModule } from './messages/messaging.module';
import config from '../config';

@Module({
  imports: [
    MongooseModule.forRoot(config.mongo.url, config.mongo.settings),
    ProductsModule,
    MessagingModule,
  ],
})
export class AppModule {}
