import * as mongoose from 'mongoose';

export const ProductSchema = new mongoose.Schema(
  {
    name: { type: String, unique: true },
    user: String,
    quantity: Number,
    checked: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' } },
);
