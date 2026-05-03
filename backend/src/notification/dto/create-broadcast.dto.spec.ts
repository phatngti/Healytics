import { plainToInstance } from 'class-transformer';
import { validate } from 'class-validator';
import { CreateBroadcastDto } from './create-broadcast.dto';

describe('CreateBroadcastDto', () => {
  it('trims valid title and body values', async () => {
    const dto = plainToInstance(CreateBroadcastDto, {
      title: '  Maintenance starts at 01:00 ICT  ',
      body: '  The platform will enter maintenance mode.  ',
    });

    const errors = await validate(dto);

    expect(errors).toHaveLength(0);
    expect(dto.title).toBe('Maintenance starts at 01:00 ICT');
    expect(dto.body).toBe('The platform will enter maintenance mode.');
  });

  it('rejects whitespace-only title without relying on transform', async () => {
    const dto = Object.assign(new CreateBroadcastDto(), {
      title: '   ',
      body: 'The platform will enter maintenance mode.',
    });

    const errors = await validate(dto);

    expect(errors.some((error) => error.property === 'title')).toBe(true);
  });

  it('rejects whitespace-only body without relying on transform', async () => {
    const dto = Object.assign(new CreateBroadcastDto(), {
      title: 'Maintenance starts at 01:00 ICT',
      body: '   ',
    });

    const errors = await validate(dto);

    expect(errors.some((error) => error.property === 'body')).toBe(true);
  });

  it.each([
    ['title', { body: 'The platform will enter maintenance mode.' }],
    ['body', { title: 'Maintenance starts at 01:00 ICT' }],
  ])('rejects missing %s', async (field, payload) => {
    const dto = plainToInstance(CreateBroadcastDto, payload);

    const errors = await validate(dto);

    expect(errors.some((error) => error.property === field)).toBe(true);
  });
});
