import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Client } from '@elastic/elasticsearch';
import { BookingSearchDocument } from '../types';

@Injectable()
export class ElasticsearchBookingService implements OnModuleInit {
  private readonly logger = new Logger(ElasticsearchBookingService.name);
  private readonly client: Client | null;
  readonly indexName: string;
  readonly enabled: boolean;

  constructor(private readonly configService: ConfigService) {
    const config =
      this.configService.get<Record<string, string | boolean | undefined>>(
        'elasticsearch',
      ) ?? {};

    this.enabled = config.enabled !== false;
    this.indexName = String(config.bookingIndex ?? 'booking_search_v1');

    const node = config.node ? String(config.node) : undefined;
    if (!this.enabled || !node) {
      this.client = null;
      return;
    }

    const username = config.username ? String(config.username) : undefined;
    const password = config.password ? String(config.password) : undefined;
    this.client = new Client({
      node,
      auth:
        username && password
          ? {
              username,
              password,
            }
          : undefined,
    });
  }

  async onModuleInit(): Promise<void> {
    if (!this.client) return;

    try {
      await this.ensureIndex();
    } catch (error) {
      this.logger.warn(
        `Booking search index bootstrap skipped: ${(error as Error).message}`,
      );
    }
  }

  async ensureIndex(): Promise<void> {
    if (!this.client) return;

    const exists = await this.client.indices.exists({ index: this.indexName });
    if (exists) return;

    await this.client.indices.create({
      index: this.indexName,
      settings: {
        analysis: {
          filter: {
            booking_edge_ngram: {
              type: 'edge_ngram',
              min_gram: 2,
              max_gram: 20,
            },
          },
          analyzer: {
            booking_autocomplete: {
              type: 'custom',
              tokenizer: 'standard',
              filter: ['lowercase', 'asciifolding', 'booking_edge_ngram'],
            },
            booking_search: {
              type: 'custom',
              tokenizer: 'standard',
              filter: ['lowercase', 'asciifolding'],
            },
          },
        },
      },
      mappings: {
        dynamic: false,
        properties: {
          type: { type: 'keyword' },
          entityId: { type: 'keyword' },
          serviceId: { type: 'keyword' },
          specialistId: { type: 'keyword' },
          eligibilityId: { type: 'keyword' },
          name: {
            type: 'text',
            analyzer: 'booking_search',
            fields: {
              autocomplete: {
                type: 'text',
                analyzer: 'booking_autocomplete',
                search_analyzer: 'booking_search',
              },
              keyword: { type: 'keyword' },
            },
          },
          description: { type: 'text', analyzer: 'booking_search' },
          specialty: {
            type: 'text',
            analyzer: 'booking_search',
            fields: { keyword: { type: 'keyword' } },
          },
          role: { type: 'keyword' },
          serviceNames: {
            type: 'text',
            analyzer: 'booking_search',
            fields: {
              autocomplete: {
                type: 'text',
                analyzer: 'booking_autocomplete',
                search_analyzer: 'booking_search',
              },
            },
          },
          imageUrl: { type: 'keyword', index: false },
          avatarUrl: { type: 'keyword', index: false },
          duration: { type: 'keyword', index: false },
          durationMinutes: { type: 'integer' },
          price: { type: 'keyword', index: false },
          priceVnd: { type: 'double' },
          clinicName: { type: 'keyword', index: false },
          clinicAddress: { type: 'keyword', index: false },
          updatedAt: { type: 'date' },
        },
      },
    });
  }

  async search(query: string, limit: number): Promise<BookingSearchDocument[]> {
    if (!this.client) return [];

    try {
      await this.ensureIndex();
      const result = await this.client.search<BookingSearchDocument>({
        index: this.indexName,
        size: limit * 4,
        query: {
          bool: {
            should: [
              {
                match_phrase: {
                  name: {
                    query,
                    boost: 8,
                  },
                },
              },
              {
                match: {
                  'name.autocomplete': {
                    query,
                    boost: 5,
                  },
                },
              },
              {
                match: {
                  'serviceNames.autocomplete': {
                    query,
                    boost: 4,
                  },
                },
              },
              {
                multi_match: {
                  query,
                  fields: [
                    'name^4',
                    'description',
                    'specialty^3',
                    'serviceNames^2',
                    'role',
                  ],
                  fuzziness: 'AUTO',
                  operator: 'and',
                },
              },
            ],
            minimum_should_match: 1,
          },
        },
      });

      return result.hits.hits
        .map((hit) => hit._source)
        .filter((source): source is BookingSearchDocument => Boolean(source));
    } catch (error) {
      this.logger.warn(`Booking search failed: ${(error as Error).message}`);
      return [];
    }
  }

  async indexDocument(document: BookingSearchDocument): Promise<void> {
    if (!this.client) return;
    await this.ensureIndex();
    await this.client.index({
      index: this.indexName,
      id: `${document.type}:${document.entityId}`,
      document,
      refresh: false,
    });
  }

  async deleteDocument(
    type: 'service' | 'specialist',
    entityId: string,
  ): Promise<void> {
    if (!this.client) return;
    await this.client.delete(
      {
        index: this.indexName,
        id: `${type}:${entityId}`,
        refresh: false,
      },
      { ignore: [404] },
    );
  }

  async deleteAllBookingDocuments(): Promise<void> {
    if (!this.client) return;
    await this.ensureIndex();
    await this.client.deleteByQuery(
      {
        index: this.indexName,
        query: { match_all: {} },
        refresh: true,
        conflicts: 'proceed',
      },
      { ignore: [404] },
    );
  }
}
