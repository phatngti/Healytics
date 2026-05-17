import { Injectable, PipeTransform, ArgumentMetadata } from '@nestjs/common';

/**
 * Pipe that strips properties whose value is `null` from the incoming object.
 *
 * Use on PATCH endpoints where the client may send `null` to indicate
 * "no change" and only non-null values should be validated / persisted.
 *
 * Usage:
 *   @Body(new StripNullPropertiesPipe()) dto: UpdateSomethingDto
 */
@Injectable()
export class StripNullPropertiesPipe implements PipeTransform {
  transform(value: unknown, _metadata: ArgumentMetadata): unknown {
    if (value === null || value === undefined || typeof value !== 'object') {
      return value;
    }

    // Only strip top-level null values; nested objects are left intact
    // so that class-transformer / class-validator can handle them normally.
    const cleaned: Record<string, unknown> = {};

    for (const [key, val] of Object.entries(value)) {
      if (val !== null) {
        cleaned[key] = val;
      }
    }

    return cleaned;
  }
}
