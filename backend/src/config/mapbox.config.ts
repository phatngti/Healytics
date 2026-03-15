import { registerAs } from '@nestjs/config';

export default registerAs('mapbox', () => ({
  /** Server-side access token — secret, for Geocoding + Matrix API */
  accessToken: process.env.MAPBOX_ACCESS_TOKEN || '',
  /** Public token — restricted scope, served to frontend/mobile SDKs */
  publicToken: process.env.MAPBOX_PUBLIC_TOKEN || '',
}));
