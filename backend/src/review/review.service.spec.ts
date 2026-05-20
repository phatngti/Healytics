import { Test, TestingModule } from '@nestjs/testing';
import { ReviewService } from './review.service';
import { SubmitTreatmentReviewHandler } from './application/handlers/submit-treatment-review.handler';
import { SubmitSpecialistReviewHandler } from './application/handlers/submit-specialist-review.handler';
import { SubmitFacilityReviewHandler } from './application/handlers/submit-facility-review.handler';

describe('ReviewService', () => {
  let service: ReviewService;
  let submitTreatmentReviewHandler: { execute: jest.Mock };
  let submitSpecialistReviewHandler: { execute: jest.Mock };
  let submitFacilityReviewHandler: { execute: jest.Mock };

  beforeEach(async () => {
    submitTreatmentReviewHandler = { execute: jest.fn() };
    submitSpecialistReviewHandler = { execute: jest.fn() };
    submitFacilityReviewHandler = { execute: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReviewService,
        {
          provide: SubmitTreatmentReviewHandler,
          useValue: submitTreatmentReviewHandler,
        },
        {
          provide: SubmitSpecialistReviewHandler,
          useValue: submitSpecialistReviewHandler,
        },
        {
          provide: SubmitFacilityReviewHandler,
          useValue: submitFacilityReviewHandler,
        },
      ],
    }).compile();

    service = module.get<ReviewService>(ReviewService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('submitTreatmentReview', () => {
    it('should delegate to submitTreatmentReviewHandler', async () => {
      const expected = { id: 'review-1', rating: 5, comment: 'Great!' };
      submitTreatmentReviewHandler.execute.mockResolvedValue(expected);

      const dto = { bookingId: 'booking-1', rating: 5, comment: 'Great!' };
      const result = await service.submitTreatmentReview('user-1', dto as any);

      expect(submitTreatmentReviewHandler.execute).toHaveBeenCalledWith(
        'user-1',
        dto,
      );
      expect(result).toEqual(expected);
    });
  });

  describe('submitSpecialistReview', () => {
    it('should delegate to submitSpecialistReviewHandler', async () => {
      const expected = { id: 'review-2', rating: 4 };
      submitSpecialistReviewHandler.execute.mockResolvedValue(expected);

      const dto = {
        bookingId: 'booking-1',
        employeeId: 'emp-1',
        rating: 4,
      };
      const result = await service.submitSpecialistReview('user-1', dto as any);

      expect(submitSpecialistReviewHandler.execute).toHaveBeenCalledWith(
        'user-1',
        dto,
      );
      expect(result).toEqual(expected);
    });
  });

  describe('submitFacilityReview', () => {
    it('should delegate to submitFacilityReviewHandler', async () => {
      const expected = { id: 'review-3', rating: 5 };
      submitFacilityReviewHandler.execute.mockResolvedValue(expected);

      const dto = {
        appointmentId: 'booking-1',
        facilityId: 'facility-1',
        rating: 5,
      };
      const result = await service.submitFacilityReview('user-1', dto as any);

      expect(submitFacilityReviewHandler.execute).toHaveBeenCalledWith(
        'user-1',
        dto,
      );
      expect(result).toEqual(expected);
    });
  });
});
