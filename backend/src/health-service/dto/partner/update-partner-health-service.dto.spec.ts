import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { StripNullPropertiesPipe } from '@/common/pipes/strip-null-properties.pipe';
import { StaffAssignmentType } from '@/health-service/enums/staff-assignment-type.enum';
import { UpdatePartnerHealthServiceDto } from './update-partner-health-service.dto';

describe('UpdatePartnerHealthServiceDto', () => {
  it('accepts a sparse nested productDefinition update', async () => {
    const dto = plainToInstance(UpdatePartnerHealthServiceDto, {
      employeeIds: ['2caecfa6-e9db-4a78-a3f1-acaae7698cce'],
      productDefinition: {
        staffAssignmentType: StaffAssignmentType.SPECIFIC,
      },
    });

    const errors = await validate(dto);

    expect(errors).toHaveLength(0);
  });

  it('still validates provided nested productDefinition values', async () => {
    const dto = plainToInstance(UpdatePartnerHealthServiceDto, {
      productDefinition: {
        durationMinutes: 0,
      },
    });

    const errors = await validate(dto);
    const productDefinitionError = errors.find(
      (error) => error.property === 'productDefinition',
    );

    expect(productDefinitionError?.children?.[0]?.property).toBe(
      'durationMinutes',
    );
    expect(productDefinitionError?.children?.[0]?.constraints).toHaveProperty(
      'min',
    );
  });

  it('validates after recursive null stripping removes nested null values', async () => {
    const pipe = new StripNullPropertiesPipe();
    const payload = pipe.transform(
      {
        productDefinition: {
          durationMinutes: null,
          staffAssignmentType: StaffAssignmentType.SPECIFIC,
        },
      },
      { type: 'body' },
    );

    const dto = plainToInstance(UpdatePartnerHealthServiceDto, payload);
    const errors = await validate(dto);

    expect(errors).toHaveLength(0);
  });
});
