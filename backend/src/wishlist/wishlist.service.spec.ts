import { NotFoundException } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Product } from '@/common/entities/product.entity';
import { UserWishlistItem } from '@/common/entities/user-wishlist-item.entity';
import {
  MockRepository,
  createMockRepository,
} from '../../test/mocks/mock-types';
import { WishlistService } from './wishlist.service';

describe('WishlistService', () => {
  let service: WishlistService;
  let wishlistRepo: MockRepository<UserWishlistItem>;
  let productRepo: MockRepository<Product>;

  const product = {
    id: 'product-1',
    name: 'Facial',
    basePrice: 799000,
    salePrice: null,
    media: [{ url: 'https://example.com/thumb.jpg', isThumbnail: true }],
  } as Product;

  beforeEach(async () => {
    wishlistRepo = createMockRepository<UserWishlistItem>();
    productRepo = createMockRepository<Product>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WishlistService,
        {
          provide: getRepositoryToken(UserWishlistItem),
          useValue: wishlistRepo,
        },
        { provide: getRepositoryToken(Product), useValue: productRepo },
      ],
    }).compile();

    service = module.get(WishlistService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('lists current user wishlist items newest first', async () => {
    wishlistRepo.find.mockResolvedValue([
      {
        id: 'wish-1',
        userId: 'user-1',
        productId: product.id,
        product,
        createdAt: new Date('2026-05-01T00:00:00.000Z'),
      },
    ]);

    const result = await service.list('user-1');

    expect(wishlistRepo.find).toHaveBeenCalledWith({
      where: { userId: 'user-1' },
      relations: ['product', 'product.media'],
      order: { createdAt: 'DESC' },
    });
    expect(result).toEqual([
      expect.objectContaining({
        id: 'wish-1',
        productId: product.id,
        title: 'Facial',
        imageUrl: 'https://example.com/thumb.jpg',
        price: '799.000đ',
      }),
    ]);
  });

  it('adds a wishlist item idempotently', async () => {
    productRepo.findOne.mockResolvedValue(product);
    wishlistRepo.findOne.mockResolvedValue(null);
    wishlistRepo.create.mockImplementation((value) => value);
    wishlistRepo.save.mockImplementation(async (value) => ({
      id: 'wish-1',
      createdAt: new Date('2026-05-01T00:00:00.000Z'),
      ...value,
    }));

    const result = await service.add('user-1', product.id);

    expect(wishlistRepo.save).toHaveBeenCalledWith({
      userId: 'user-1',
      productId: product.id,
    });
    expect(result).toEqual(
      expect.objectContaining({
        id: 'wish-1',
        productId: product.id,
        title: 'Facial',
      }),
    );
  });

  it('returns the existing wishlist item for duplicate adds', async () => {
    const existing = {
      id: 'wish-1',
      userId: 'user-1',
      productId: product.id,
      product,
      createdAt: new Date('2026-05-01T00:00:00.000Z'),
    };
    productRepo.findOne.mockResolvedValue(product);
    wishlistRepo.findOne.mockResolvedValue(existing);

    const result = await service.add('user-1', product.id);

    expect(wishlistRepo.save).not.toHaveBeenCalled();
    expect(result).toEqual(expect.objectContaining({ id: 'wish-1' }));
  });

  it('throws 404 when adding an unknown product', async () => {
    productRepo.findOne.mockResolvedValue(null);

    await expect(service.add('user-1', 'missing-product')).rejects.toThrow(
      NotFoundException,
    );
  });

  it('removes wishlist items idempotently', async () => {
    await service.remove('user-1', product.id);

    expect(wishlistRepo.delete).toHaveBeenCalledWith({
      userId: 'user-1',
      productId: product.id,
    });
  });
});
