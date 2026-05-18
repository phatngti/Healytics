import { BookingSearchService } from './booking-search.service';

describe('BookingSearchService', () => {
  const elasticsearch = {
    search: jest.fn(),
  };
  let service: BookingSearchService;

  beforeEach(() => {
    jest.clearAllMocks();
    service = new BookingSearchService(elasticsearch as any);
  });

  it('returns empty groups without querying Elasticsearch for short text', async () => {
    const result = await service.search('a', 5);

    expect(result).toEqual({ services: [], specialists: [] });
    expect(elasticsearch.search).not.toHaveBeenCalled();
  });

  it('groups service and specialist documents and caps each group', async () => {
    elasticsearch.search.mockResolvedValue([
      {
        type: 'service',
        entityId: 'service-1',
        serviceId: 'service-1',
        name: 'Deep Tissue Massage',
        imageUrl: 'https://cdn.test/service.png',
        duration: '60 min',
        durationMinutes: 60,
        price: '850.000 VND',
        priceVnd: 850000,
        clinicName: 'Healytics Clinic',
        clinicAddress: 'District 1',
        updatedAt: new Date().toISOString(),
      },
      {
        type: 'specialist',
        entityId: 'employee-1',
        specialistId: 'employee-1',
        eligibilityId: 'eligibility-1',
        name: 'Dr. Anna Nguyen',
        specialty: 'Therapist',
        avatarUrl: 'https://cdn.test/employee.png',
        updatedAt: new Date().toISOString(),
      },
      {
        type: 'service',
        entityId: 'service-1',
        serviceId: 'service-1',
        name: 'Deep Tissue Massage',
        updatedAt: new Date().toISOString(),
      },
    ]);

    const result = await service.search('massage', 1);

    expect(elasticsearch.search).toHaveBeenCalledWith('massage', 1);
    expect(result.services).toHaveLength(1);
    expect(result.services[0]).toMatchObject({
      id: 'service-1',
      title: 'Deep Tissue Massage',
      duration: '60 min',
      price: '850.000 VND',
      clinicName: 'Healytics Clinic',
    });
    expect(result.specialists).toHaveLength(1);
    expect(result.specialists[0]).toMatchObject({
      id: 'employee-1',
      eligibilityId: 'eligibility-1',
      name: 'Dr. Anna Nguyen',
      specialty: 'Therapist',
    });
  });
});
