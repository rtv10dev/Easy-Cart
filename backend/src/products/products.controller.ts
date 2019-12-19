import {
  Controller,
  Get,
  Put,
  Post,
  Delete,
  Body,
  Param,
  Logger,
  BadRequestException,
} from '@nestjs/common';
import { ProductsService } from './products.service';
import { Product } from './interfaces/product.interface';
import { ProductDto } from './dto/product.dto';
import { MessagingService } from 'src/messages/messaging.service';

@Controller('products')
export class ProductsController {
  private readonly logger = new Logger(ProductsController.name);
  constructor(
    private readonly productsService: ProductsService,
    private readonly messagingService: MessagingService,
  ) {}

  @Get()
  async findAll(): Promise<Product[]> {
    try {
      return this.productsService.findAll();
    } catch (err) {
      this.logger.error(`findAll ---- ${err}`);
      throw new BadRequestException();
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Product> {
    try {
      return await this.productsService.findOne(id);
    } catch (err) {
      this.logger.error(`findOne ---- ${err}`);
      throw new BadRequestException();
    }
  }

  @Post()
  async create(@Body() product: ProductDto): Promise<Product> {
    try {
      const productCreated = await this.productsService.create(product);
      await this.messagingService.sendMessage(productCreated);
      return productCreated;
    } catch (err) {
      this.logger.error(`create ---- ${err}`);
      throw new BadRequestException();
    }
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() product: ProductDto,
  ): Promise<Product> {
    try {
      const updatedProduct = await this.productsService.update(id, product);
      await this.messagingService.sendMessage();
      return updatedProduct;
    } catch (err) {
      this.logger.error(`update ---- ${err}`);
      throw new BadRequestException();
    }
  }

  @Delete(':id')
  async remove(@Param('id') id: string): Promise<String> {
    try {
      await this.productsService.remove(id);
      await this.messagingService.sendMessage();
      return id;
    } catch (err) {
      this.logger.error(`remove ---- ${err}`);
      throw new BadRequestException();
    }
  }

  @Delete()
  async removeAll(): Promise<void> {
    try {
      await this.productsService.removeAll();
      await this.messagingService.sendMessage();
    } catch(err) {
      this.logger.error(`removeAll ---- ${err}`);
      throw new BadRequestException();
    }
  }
}
