import { Injectable } from '@nestjs/common';
import { BookingSpecialistResponseDto } from '@/categories/dto/booking-specialist-response.dto';
import { BookingServiceResponseDto } from '@/employees/dto/booking-service-response.dto';
import { BookingSearchResponseDto } from '../dto/booking-search-response.dto';
import { BookingSearchDocument } from '../types';
import { ElasticsearchBookingService } from './elasticsearch-booking.service';

@Injectable()
export class BookingSearchService {
  constructor(private readonly elasticsearch: ElasticsearchBookingService) {}

  async search(
    query: string,
    limit: number,
  ): Promise<BookingSearchResponseDto> {
    const normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) {
      return { services: [], specialists: [] };
    }

    const normalizedLimit = Math.min(Math.max(limit || 5, 1), 20);
    const documents = await this.elasticsearch.search(
      normalizedQuery,
      normalizedLimit,
    );

    const services: BookingServiceResponseDto[] = [];
    const specialists: BookingSpecialistResponseDto[] = [];
    const seenServices = new Set<string>();
    const seenSpecialists = new Set<string>();

    for (const document of documents) {
      if (
        document.type === 'service' &&
        services.length < normalizedLimit &&
        !seenServices.has(document.entityId)
      ) {
        seenServices.add(document.entityId);
        services.push(this.toServiceDto(document));
      }

      if (
        document.type === 'specialist' &&
        specialists.length < normalizedLimit &&
        !seenSpecialists.has(document.entityId)
      ) {
        seenSpecialists.add(document.entityId);
        specialists.push(this.toSpecialistDto(document));
      }
    }

    return { services, specialists };
  }

  private toServiceDto(
    document: BookingSearchDocument,
  ): BookingServiceResponseDto {
    const dto = new BookingServiceResponseDto();
    dto.id = document.serviceId ?? document.entityId;
    dto.title = document.name;
    dto.imageUrl = document.imageUrl ?? null;
    dto.duration = document.duration ?? '';
    dto.durationMinutes = document.durationMinutes ?? null;
    dto.price = document.price ?? '';
    dto.priceVnd = document.priceVnd ?? null;
    dto.clinicName = document.clinicName ?? null;
    dto.clinicAddress = document.clinicAddress ?? null;
    dto.distance = null;
    return dto;
  }

  private toSpecialistDto(
    document: BookingSearchDocument,
  ): BookingSpecialistResponseDto {
    const dto = new BookingSpecialistResponseDto();
    dto.id = document.specialistId ?? document.entityId;
    dto.eligibilityId = document.eligibilityId ?? '';
    dto.name = document.name;
    dto.specialty = document.specialty ?? document.role ?? 'Specialist';
    dto.avatarUrl = document.avatarUrl ?? null;
    return dto;
  }
}
