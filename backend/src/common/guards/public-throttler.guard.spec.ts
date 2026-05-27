import { isThrottleEnabled } from './public-throttler.guard';

describe('isThrottleEnabled', () => {
  const originalThrottleEnabled = process.env.THROTTLE_ENABLED;

  afterEach(() => {
    if (originalThrottleEnabled === undefined) {
      delete process.env.THROTTLE_ENABLED;
    } else {
      process.env.THROTTLE_ENABLED = originalThrottleEnabled;
    }
  });

  it('defaults to enabled when THROTTLE_ENABLED is not configured', () => {
    delete process.env.THROTTLE_ENABLED;

    expect(isThrottleEnabled()).toBe(true);
  });

  it.each(['false', 'FALSE', '0', 'off', 'disabled', 'no'])(
    'disables throttling for %s',
    (value) => {
      expect(isThrottleEnabled(value)).toBe(false);
    },
  );

  it.each(['true', '1', 'on', 'enabled', 'yes', 'unexpected'])(
    'keeps throttling enabled for %s',
    (value) => {
      expect(isThrottleEnabled(value)).toBe(true);
    },
  );
});
