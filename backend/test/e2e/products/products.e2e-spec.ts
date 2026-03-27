import { INestApplication } from '@nestjs/common';
import {
  createTestApp,
  closeTestApp,
  authenticateTestUser,
  authRequest,
} from '../../helpers/test-utils';
import {
  createServiceProductDto,
  createPhysicalProductDto,
  createCategoryDto,
  FAKE_UUID,
  TEST_MERCHANT_ID,
} from '../../fixtures/test-data.factory';

describe('Products (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;
  let createdProductId: string;
  let createdCategoryId: string;

  beforeAll(async () => {
    app = await createTestApp();
    const auth = await authenticateTestUser(app, 'products-test');
    accessToken = auth.accessToken;

    // Create a category for product tests
    const categoryRes = await authRequest(app, accessToken)
      .post('/categories')
      .send(createCategoryDto({ name: `Product Test Category ${Date.now()}` }));

    createdCategoryId = categoryRes.body.id;
  });

  afterAll(async () => {
    await closeTestApp(app);
  });

  describe('POST /products', () => {
    it('should create a new service product', async () => {
      const productData = createServiceProductDto({ categoryId: createdCategoryId });

      const res = await authRequest(app, accessToken)
        .post('/products')
        .send(productData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.name).toBe(productData.name);
      expect(res.body.slug).toBe(productData.slug);
      expect(res.body.type).toBe(productData.type);
      expect(res.body.basePrice).toBe(productData.basePrice);

      createdProductId = res.body.id;
    });

    it('should create a physical product', async () => {
      const productData = createPhysicalProductDto();

      const res = await authRequest(app, accessToken)
        .post('/products')
        .send(productData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.type).toBe('physical');
    });

    it('should create a product with media', async () => {
      const productData = createServiceProductDto({
        name: `Product With Media ${Date.now()}`,
        slug: `product-with-media-${Date.now()}`,
        media: [
          {
            url: 'https://example.com/image1.jpg',
            mediaType: 'IMAGE',
            isThumbnail: true,
            sortOrder: 0,
          },
          {
            url: 'https://example.com/image2.jpg',
            mediaType: 'IMAGE',
            isThumbnail: false,
            sortOrder: 1,
          },
        ],
      });

      const res = await authRequest(app, accessToken)
        .post('/products')
        .send(productData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
    });

    it('should fail to create product without required fields', async () => {
      const res = await authRequest(app, accessToken)
        .post('/products')
        .send({});

      expect(res.status).toBeGreaterThanOrEqual(400);
    });

    it('should fail to create product without merchantId', async () => {
      const res = await authRequest(app, accessToken)
        .post('/products')
        .send({
          name: 'Test Product',
          slug: 'test-product',
          type: 'service',
        });

      expect(res.status).toBeGreaterThanOrEqual(400);
    });
  });

  describe('GET /products', () => {
    it('should get all products', async () => {
      const res = await authRequest(app, accessToken).get('/products');

      expect([200, 201]).toContain(res.status);
      expect(Array.isArray(res.body)).toBe(true);
    });

    it('should filter products by merchantId', async () => {
      const res = await authRequest(app, accessToken).get(`/products?merchantId=${TEST_MERCHANT_ID}`);

      expect([200, 201]).toContain(res.status);
      expect(Array.isArray(res.body)).toBe(true);
      res.body.forEach((product: any) => {
        expect(product.merchantId).toBe(TEST_MERCHANT_ID);
      });
    });
  });

  describe('GET /products/:id', () => {
    it('should get a product by id', async () => {
      const res = await authRequest(app, accessToken).get(`/products/${createdProductId}`);

      expect([200, 201]).toContain(res.status);
      expect(res.body.id).toBe(createdProductId);
    });

    it('should return 404 for non-existent product', async () => {
      const res = await authRequest(app, accessToken).get(`/products/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });
  });

  describe('GET /products/slug/:slug', () => {
    it('should get a product by slug', async () => {
      const getRes = await authRequest(app, accessToken).get(`/products/${createdProductId}`);
      const slug = getRes.body.slug;

      const res = await authRequest(app, accessToken).get(`/products/slug/${slug}`);

      expect([200, 201]).toContain(res.status);
      expect(res.body.slug).toBe(slug);
    });

    it('should return 404 for non-existent slug', async () => {
      const res = await authRequest(app, accessToken).get('/products/slug/non-existent-slug-12345');

      expect(res.status).toBe(404);
    });
  });

  describe('PATCH /products/:id', () => {
    it('should update a product', async () => {
      const updateData = {
        name: `Updated Product ${Date.now()}`,
        description: 'Updated description',
        basePrice: 600000,
        status: 'active',
      };

      const res = await authRequest(app, accessToken)
        .patch(`/products/${createdProductId}`)
        .send(updateData);

      expect([200, 201]).toContain(res.status);
      expect(res.body.name).toBe(updateData.name);
      expect(res.body.description).toBe(updateData.description);
      expect(res.body.basePrice).toBe(updateData.basePrice);
    });

    it('should update product visibility', async () => {
      const res = await authRequest(app, accessToken)
        .patch(`/products/${createdProductId}`)
        .send({ isVisibleOnline: false });

      expect([200, 201]).toContain(res.status);
      expect(res.body.isVisibleOnline).toBe(false);
    });

    it('should return 404 when updating non-existent product', async () => {
      const res = await authRequest(app, accessToken)
        .patch(`/products/${FAKE_UUID}`)
        .send({ name: 'Updated' });

      expect(res.status).toBe(404);
    });
  });

  describe('DELETE /products/:id', () => {
    it('should delete a product', async () => {
      const productData = createServiceProductDto({
        name: `Product To Delete ${Date.now()}`,
        slug: `product-to-delete-${Date.now()}`,
      });

      const createRes = await authRequest(app, accessToken)
        .post('/products')
        .send(productData);

      const productToDeleteId = createRes.body.id;

      const res = await authRequest(app, accessToken).delete(`/products/${productToDeleteId}`);

      expect([200, 201, 204]).toContain(res.status);

      // Verify deletion
      const getRes = await authRequest(app, accessToken).get(`/products/${productToDeleteId}`);
      expect(getRes.status).toBe(404);
    });

    it('should return 404 when deleting non-existent product', async () => {
      const res = await authRequest(app, accessToken).delete(`/products/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });
  });
});
