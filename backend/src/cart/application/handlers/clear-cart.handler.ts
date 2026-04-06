import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CartItem } from '@/cart/entities/cart-item.entity';

@Injectable()
export class ClearCartHandler {
  constructor(
    @InjectRepository(CartItem)
    private readonly cartItemRepository: Repository<CartItem>,
  ) {}

  async execute(userId: string): Promise<void> {
    await this.cartItemRepository.delete({ userId });
  }
}
