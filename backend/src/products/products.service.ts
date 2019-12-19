import { Model } from 'mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Product } from './interfaces/product.interface';
import { ProductDto } from './dto/product.dto';

@Injectable()
export class ProductsService {
  constructor(
    @InjectModel('Product') private readonly productModel: Model<Product>,
  ) {}

  async findAll(): Promise<Product[]> {
    return await this.productModel
      .find()
      .sort({ created_at: -1 })
      .exec();
  }

  async create(product: ProductDto): Promise<Product> {
    return await this.productModel.create(product);
  }

  async remove(id: string): Promise<String> {
    const query = { _id: id };
    await this.productModel.findOneAndRemove(query);
    return id;
  }

  async findOne(id: string): Promise<Product> {
    return await this.productModel.findById(id);
  }

  async update(id: string, product: ProductDto): Promise<Product> {
    const query = { _id: id };
    const options = { new: true };

    return await this.productModel
      .findOneAndUpdate(query, product, options)
      .exec();
  }

  async removeAll(): Promise<void> {
    return await this.productModel.deleteMany();
  }
}
