import { INestApplication } from '@nestjs/common';
import {
  createTestApp,
  closeTestApp,
  authenticateTestUser,
  authRequest,
} from '../../helpers/test-utils';
import {
  createCategoryDto,
  FAKE_UUID,
} from '../../fixtures/test-data.factory';

describe('Categories (e2e)', () => {
  let app: INestApplication;
  let accessToken: string;
  let createdCategoryId: string;

  beforeAll(async () => {
    app = await createTestApp();
    const auth = await authenticateTestUser(app, 'categories-test');
    accessToken = auth.accessToken;
  });

  afterAll(async () => {
    await closeTestApp(app);
  });

  describe('POST /categories', () => {
    it('should create a new category', async () => {
      const categoryData = createCategoryDto();

      const res = await authRequest(app, accessToken)
        .post('/categories')
        .send(categoryData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.name).toBe(categoryData.name);
      expect(res.body.slug).toBe(categoryData.slug);
      expect(res.body.description).toBe(categoryData.description);

      createdCategoryId = res.body.id;
    });

    it('should fail to create category without required fields', async () => {
      const res = await authRequest(app, accessToken)
        .post('/categories')
        .send({});

      expect(res.status).toBeGreaterThanOrEqual(400);
    });

    it('should create a child category with parentId', async () => {
      const childData = createCategoryDto({
        name: `Child Category ${Date.now()}`,
        slug: `child-category-${Date.now()}`,
        parentId: createdCategoryId,
      });

      const res = await authRequest(app, accessToken)
        .post('/categories')
        .send(childData);

      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
      expect(res.body.parentId).toBe(createdCategoryId);
    });
  });

  describe('GET /categories', () => {
    it('should get all categories', async () => {
      const res = await authRequest(app, accessToken).get('/categories');

      expect([200, 201]).toContain(res.status);
      expect(Array.isArray(res.body)).toBe(true);
    });

    it('should get only root categories with rootsOnly=true', async () => {
      const res = await authRequest(app, accessToken).get('/categories?rootsOnly=true');

      expect([200, 201]).toContain(res.status);
      expect(Array.isArray(res.body)).toBe(true);
      res.body.forEach((category: any) => {
        expect(category.parentId).toBeNull();
      });
    });
  });

  describe('GET /categories/:id', () => {
    it('should get a category by id', async () => {
      const res = await authRequest(app, accessToken).get(`/categories/${createdCategoryId}`);

      expect([200, 201]).toContain(res.status);
      expect(res.body.id).toBe(createdCategoryId);
    });

    it('should return 404 for non-existent category', async () => {
      const res = await authRequest(app, accessToken).get(`/categories/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });
  });

  describe('GET /categories/slug/:slug', () => {
    it('should get a category by slug', async () => {
      const getRes = await authRequest(app, accessToken).get(`/categories/${createdCategoryId}`);
      const slug = getRes.body.slug;

      const res = await authRequest(app, accessToken).get(`/categories/slug/${slug}`);

      expect([200, 201]).toContain(res.status);
      expect(res.body.slug).toBe(slug);
    });

    it('should return 404 for non-existent slug', async () => {
      const res = await authRequest(app, accessToken).get('/categories/slug/non-existent-slug-12345');

      expect(res.status).toBe(404);
    });
  });

  describe('PATCH /categories/:id', () => {
    it('should update a category', async () => {
      const updateData = {
        name: `Updated Category ${Date.now()}`,
        description: 'Updated description',
      };

      const res = await authRequest(app, accessToken)
        .patch(`/categories/${createdCategoryId}`)
        .send(updateData);

      expect([200, 201]).toContain(res.status);
      expect(res.body.name).toBe(updateData.name);
      expect(res.body.description).toBe(updateData.description);
    });

    it('should return 404 when updating non-existent category', async () => {
      const res = await authRequest(app, accessToken)
        .patch(`/categories/${FAKE_UUID}`)
        .send({ name: 'Updated' });

      expect(res.status).toBe(404);
    });
  });

  describe('DELETE /categories/:id', () => {
    it('should delete a category', async () => {
      const categoryData = createCategoryDto({
        name: `Category To Delete ${Date.now()}`,
        slug: `category-to-delete-${Date.now()}`,
      });

      const createRes = await authRequest(app, accessToken)
        .post('/categories')
        .send(categoryData);

      const categoryToDeleteId = createRes.body.id;

      const res = await authRequest(app, accessToken).delete(`/categories/${categoryToDeleteId}`);

      expect([200, 201, 204]).toContain(res.status);

      // Verify deletion
      const getRes = await authRequest(app, accessToken).get(`/categories/${categoryToDeleteId}`);
      expect(getRes.status).toBe(404);
    });

    it('should return 404 when deleting non-existent category', async () => {
      const res = await authRequest(app, accessToken).delete(`/categories/${FAKE_UUID}`);

      expect(res.status).toBe(404);
    });
  });
});
