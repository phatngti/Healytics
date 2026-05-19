import {
  ArgumentMetadata,
  NotFoundException,
  ValidationPipe,
} from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { UserClinicController } from './user-clinic.controller';
import { ClinicService } from './clinic.service';
import { GetClinicProductsQueryDto } from './dto/get-clinic-products-query.dto';
import { GetClinicReviewsQueryDto } from './dto/get-clinic-reviews-query.dto';

describe('UserClinicController', () => {
  let controller: UserClinicController;
  let clinicService: {
    getClinicInfo: jest.Mock;
    getClinicProducts: jest.Mock;
    getClinicReviews: jest.Mock;
    followClinic: jest.Mock;
    unfollowClinic: jest.Mock;
  };

  const validationPipe = new ValidationPipe({
    whitelist: true,
    transform: true,
    forbidNonWhitelisted: true,
  });

  const queryMetadata = (
    metatype: ArgumentMetadata['metatype'],
  ): ArgumentMetadata => ({
    type: 'query',
    metatype,
    data: '',
  });

  const clinicId = '11111111-1111-4111-8111-111111111111';
  const userId = '33333333-3333-4333-8333-333333333333';
  const categoryId = '22222222-2222-4222-8222-222222222222';

  beforeEach(async () => {
    clinicService = {
      getClinicInfo: jest.fn(),
      getClinicProducts: jest.fn(),
      getClinicReviews: jest.fn(),
      followClinic: jest.fn(),
      unfollowClinic: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserClinicController],
      providers: [{ provide: ClinicService, useValue: clinicService }],
    }).compile();

    controller = module.get<UserClinicController>(UserClinicController);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('delegates products queries with transformed params', async () => {
    clinicService.getClinicProducts.mockResolvedValue({
      categories: [{ id: 'all', label: 'All Services' }],
      products: [],
      totalCount: 0,
      hasMore: false,
    });

    const query = (await validationPipe.transform(
      {
        categoryId,
        search: 'laser',
        sort: 'price_asc',
        minPrice: '100000',
        maxPrice: '500000',
        minDuration: '30',
        maxDuration: '90',
        discountOnly: 'true',
        page: '2',
        limit: '5',
      },
      queryMetadata(GetClinicProductsQueryDto),
    )) as GetClinicProductsQueryDto;

    await controller.getClinicProducts(clinicId, query);

    expect(clinicService.getClinicProducts).toHaveBeenCalledWith(
      clinicId,
      expect.objectContaining({
        categoryId,
        search: 'laser',
        sort: 'price_asc',
        minPrice: 100000,
        maxPrice: 500000,
        minDuration: 30,
        maxDuration: 90,
        discountOnly: true,
        page: 2,
        limit: 5,
      }),
    );
  });

  it('surfaces 404 when the clinic does not exist', async () => {
    clinicService.getClinicInfo.mockRejectedValue(
      new NotFoundException(`Clinic with ID ${clinicId} not found`),
    );

    await expect(controller.getClinicInfo(clinicId, userId)).rejects.toThrow(
      NotFoundException,
    );
  });

  it('delegates follow and unfollow to the service', async () => {
    clinicService.followClinic.mockResolvedValue({ id: clinicId });
    clinicService.unfollowClinic.mockResolvedValue({ id: clinicId });

    await controller.followClinic(clinicId, userId);
    await controller.unfollowClinic(clinicId, userId);

    expect(clinicService.followClinic).toHaveBeenCalledWith(clinicId, userId);
    expect(clinicService.unfollowClinic).toHaveBeenCalledWith(clinicId, userId);
  });

  it('rejects invalid page values', async () => {
    await expect(
      validationPipe.transform(
        { page: '0' },
        queryMetadata(GetClinicProductsQueryDto),
      ),
    ).rejects.toThrow();
  });

  it('rejects invalid limit values', async () => {
    await expect(
      validationPipe.transform(
        { limit: '51' },
        queryMetadata(GetClinicProductsQueryDto),
      ),
    ).rejects.toThrow();
  });

  it('rejects invalid categoryId values', async () => {
    await expect(
      validationPipe.transform(
        { categoryId: 'all' },
        queryMetadata(GetClinicProductsQueryDto),
      ),
    ).rejects.toThrow();
  });

  it('rejects invalid product filter values', async () => {
    await expect(
      validationPipe.transform(
        { minPrice: '-1' },
        queryMetadata(GetClinicProductsQueryDto),
      ),
    ).rejects.toThrow();

    await expect(
      validationPipe.transform(
        { maxDuration: '-1' },
        queryMetadata(GetClinicProductsQueryDto),
      ),
    ).rejects.toThrow();
  });

  it('rejects invalid starCount values', async () => {
    await expect(
      validationPipe.transform(
        { starCount: '6' },
        queryMetadata(GetClinicReviewsQueryDto),
      ),
    ).rejects.toThrow();
  });
});
