import { ApiPropertyOptional } from '@nestjs/swagger';

export class SurveyResponseDto {
  @ApiPropertyOptional({
    description: 'Stored survey payload or null if none',
    example: {
      demographics: { age: 34, gender: 'female', postalCode: '94107' },
      lifestyle: { smoking: false, alcoholWeeklyUnits: 3, exercisePerWeek: 4 },
      conditions: [
        { name: 'hypertension', diagnosedYear: 2018 },
        { name: 'asthma', diagnosedYear: 2010 },
      ],
      questionnaire: [
        { questionId: 'q1', answer: 'yes' },
        { questionId: 'q2', answer: 'no' },
      ],
      submittedAt: '2025-11-22T12:34:56.789Z',
    },
  })
  survey?: Record<string, any> | null;
}
