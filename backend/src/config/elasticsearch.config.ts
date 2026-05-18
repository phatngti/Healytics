import { registerAs } from '@nestjs/config';

export default registerAs('elasticsearch', () => ({
  enabled: process.env.ELASTICSEARCH_ENABLED !== 'false',
  node: process.env.ELASTICSEARCH_NODE || 'http://localhost:9200',
  username: process.env.ELASTICSEARCH_USERNAME || undefined,
  password: process.env.ELASTICSEARCH_PASSWORD || undefined,
  bookingIndex: process.env.ELASTICSEARCH_INDEX_BOOKING || 'booking_search_v1',
}));
