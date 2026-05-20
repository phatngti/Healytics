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
    return this.stripNullProperties(value);
  }

  private stripNullProperties(value: unknown): unknown {
    if (value === null || value === undefined || typeof value !== 'object') {
      return value;
    }

    if (Array.isArray(value)) {
      return value.map((item) => this.stripNullProperties(item));
    }

    if (!this.isPlainObject(value)) {
      return value;
    }

    const cleaned: Record<string, unknown> = {};

    for (const [key, val] of Object.entries(value)) {
      if (val !== null) {
        cleaned[key] = this.stripNullProperties(val);
      }
    }

    return cleaned;
  }

  private isPlainObject(value: object): value is Record<string, unknown> {
    const prototype = Object.getPrototypeOf(value);
    return prototype === Object.prototype || prototype === null;
  }
}
