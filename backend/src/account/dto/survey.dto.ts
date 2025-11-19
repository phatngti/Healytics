import { IsObject, IsNotEmpty } from 'class-validator';

export class SurveyDto {
  @IsNotEmpty()
  @IsObject()
  survey: Record<string, any>;
}