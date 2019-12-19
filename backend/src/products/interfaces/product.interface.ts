import { Document } from 'mongoose';

export interface Product extends Document {
  readonly name: string;
  readonly user: string;
  readonly quantity: number;
  readonly checked: boolean;
}