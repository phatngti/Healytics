import { IsObject, IsNotEmpty } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SurveyDto {
  @ApiProperty({
    description: 'Arbitrary survey payload. Example structure below.',
    example: {
      demographics: {
        age: 34,
        gender: 'female',
        postalCode: '94107',
      },
      lifestyle: {
        smoking: false,
        alcoholWeeklyUnits: 3,
        exercisePerWeek: 4,
      },
      conditions: [
        { name: 'hypertension', diagnosedYear: 2018 },
        { name: 'asthma', diagnosedYear: 2010 },
      ],
      questionnaire: [
        { questionId: 'q1', answer: 'yes' },
        { questionId: 'q2', answer: 'no' },
      ],
      submittedAt: new Date().toISOString(),
    },
  })
  @IsNotEmpty()
  @IsObject()
  survey: Record<string, any>;
}
