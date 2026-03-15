import { registerAs } from '@nestjs/config';
import path from 'path';

export default registerAs('rabbitmq', () => ({
  url: process.env.RABBITMQ_URL || 'amqps://backend:backend%40rmq123@localhost:5671/healytics',
  checkoutQueue:
    process.env.RABBITMQ_QUEUE_CHECKOUT || 'checkout_queue',
  caCert: process.env.RABBITMQ_CA_CERT
    ? path.resolve(process.env.RABBITMQ_CA_CERT)
    : undefined,
  clientCert: process.env.RABBITMQ_CLIENT_CERT
    ? path.resolve(process.env.RABBITMQ_CLIENT_CERT)
    : undefined,
  clientKey: process.env.RABBITMQ_CLIENT_KEY
    ? path.resolve(process.env.RABBITMQ_CLIENT_KEY)
    : undefined,
}));
