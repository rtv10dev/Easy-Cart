import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { ProductsController } from './products.controller';
import { ProductsService } from './products.service';
import { ProductSchema } from './schemas/product.schema';
import { MessagingModule } from 'src/messages/messaging.module';
import { MessagingService } from 'src/messages/messaging.service';

@Module({
  imports: [MongooseModule.forFeature([{ name: 'Product', schema: ProductSchema }]), MessagingModule],
  controllers: [ProductsController],
  providers: [ProductsService, MessagingService],
})
export class ProductsModule {}