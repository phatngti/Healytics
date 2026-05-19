import { StripNullPropertiesPipe } from './strip-null-properties.pipe';

describe('StripNullPropertiesPipe', () => {
  const pipe = new StripNullPropertiesPipe();

  it('strips null properties recursively from nested plain objects and arrays', () => {
    const result = pipe.transform(
      {
        name: 'Updated service',
        description: null,
        productDefinition: {
          durationMinutes: null,
          staffAssignmentType: 'specific',
        },
        media: [
          {
            url: 'https://example.com/image.jpg',
            mediaType: null,
          },
        ],
      },
      { type: 'body' },
    );

    expect(result).toEqual({
      name: 'Updated service',
      productDefinition: {
        staffAssignmentType: 'specific',
      },
      media: [
        {
          url: 'https://example.com/image.jpg',
        },
      ],
    });
  });

  it('preserves non-plain object values', () => {
    const createdAt = new Date('2026-05-19T00:00:00.000Z');

    const result = pipe.transform(
      {
        createdAt,
      },
      { type: 'body' },
    );

    expect(result).toEqual({ createdAt });
  });
});
