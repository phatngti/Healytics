import 'package:admin_panel/features/admin/category/datasource/category_implement.repository.dart';
import 'package:admin_panel/features/admin/category/domain/category.entity.dart'
    as admin_category;
import 'package:admin_panel/features/admin/category/domain/category.repository.dart';
import 'package:admin_panel/features/admin/category/presentation/providers/category.provider.dart';
import 'package:admin_panel/features/partner/employee/data/employee_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.repository.dart';
import 'package:admin_panel/features/partner/employee/presentation/providers/employee.provider.dart';
import 'package:admin_panel/features/partner/products/data/product_impl.repository.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart'
    as product_category;
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/product.repository.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'employee visible total and page share one employee list fetch',
    () async {
      final repository = _CountingEmployeeRepository(_employees);
      final container = ProviderContainer(
        overrides: [employeeRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(employeeProvider.future);
      final notifier = container.read(employeeProvider.notifier);

      expect(await notifier.getVisibleTotalRows(), _employees.length);
      expect(
        await notifier.getVisiblePage(startingAt: 0, count: 2),
        hasLength(2),
      );
      expect(repository.getAllCalls, 1);

      await notifier.getVisibleTotalRows();
      expect(repository.getAllCalls, 1);

      notifier.setStatusFilter(EmployeeStatusFilter.active);
      await notifier.getVisibleTotalRows();
      expect(repository.getAllCalls, 2);
    },
  );

  test('product visible total and page share one product list fetch', () async {
    final repository = _CountingProductRepository(_products);
    final container = ProviderContainer(
      overrides: [productRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await container.read(productProvider.future);
    final notifier = container.read(productProvider.notifier);

    expect(await notifier.getVisibleTotalRows(), _products.length);
    expect(
      await notifier.getVisiblePage(startingAt: 0, count: 2),
      hasLength(2),
    );
    expect(repository.getAllCalls, 1);

    await notifier.getVisibleTotalRows();
    expect(repository.getAllCalls, 1);

    notifier.setStatusFilter(ProductStatusFilter.active);
    await notifier.getVisibleTotalRows();
    expect(repository.getAllCalls, 2);
  });

  test(
    'category visible total and page share one category list fetch',
    () async {
      final repository = _CountingCategoryRepository(_categories);
      final container = ProviderContainer(
        overrides: [categoryRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(categoryProvider.future);
      final notifier = container.read(categoryProvider.notifier);

      expect(await notifier.getVisibleTotalRows(), _categories.length);
      expect(
        await notifier.getVisiblePage(startingAt: 0, count: 2),
        hasLength(2),
      );
      expect(repository.getAllCalls, 1);

      await notifier.getVisibleTotalRows();
      expect(repository.getAllCalls, 1);

      notifier.setVisibilityFilter(CategoryVisibilityFilter.visible);
      await notifier.getVisibleTotalRows();
      expect(repository.getAllCalls, 2);
    },
  );
}

final _employees = [
  _employee('employee-1', 'A Doctor', 'DOCTOR', 'ACTIVE'),
  _employee('employee-2', 'B Therapist', 'THERAPIST', 'INACTIVE'),
  _employee('employee-3', 'C Manager', 'MANAGER', 'ACTIVE'),
];

BasicEmployeeEntity _employee(
  String id,
  String name,
  String role,
  String status,
) {
  return BasicEmployeeEntity(
    id: EmployeeId(id),
    fullName: name,
    displayName: name,
    avatar: '',
    role: role,
    position: role,
    rating: 4.5,
    reviewCount: 2,
    status: status,
    email: '$id@example.com',
    phone: '000',
    address: '',
    city: '',
    state: '',
    country: '',
  );
}

final _productCategory = product_category.CategoryEntity(
  id: 'category-1',
  name: 'Category',
  slug: 'category',
);

final _products = [
  Product(
    id: ProductId('product-1'),
    name: 'A Product',
    description: 'One',
    basePrice: 100,
    status: 'active',
    category: _productCategory,
  ),
  Product(
    id: ProductId('product-2'),
    name: 'B Product',
    description: 'Two',
    basePrice: 200,
    status: 'draft',
    category: _productCategory,
  ),
];

final _categories = [
  admin_category.CategoryEntity(
    id: admin_category.CategoryId('category-1'),
    name: 'A Category',
    isVisible: true,
  ),
  admin_category.CategoryEntity(
    id: admin_category.CategoryId('category-2'),
    name: 'B Category',
    isVisible: false,
  ),
];

class _CountingEmployeeRepository implements EmployeeRepository {
  _CountingEmployeeRepository(this.employees);

  final List<EmployeeEntity> employees;
  int getAllCalls = 0;

  @override
  Future<List<EmployeeEntity>> getAllEmployees({
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    getAllCalls += 1;
    return [...employees];
  }

  @override
  Future<List<EmployeeEntity>> getEmployees(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    final all = await getAllEmployees(sortedBy: sortedBy, sortedAsc: sortedAsc);
    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CountingProductRepository implements ProductRepository {
  _CountingProductRepository(this.products);

  final List<Product> products;
  int getAllCalls = 0;

  @override
  Future<List<Product>> getAllProducts({
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    getAllCalls += 1;
    return [...products];
  }

  @override
  Future<List<Product>> getProducts(
    int startingAt,
    int count,
    String? sortedBy,
    bool? sortedAsc,
  ) async {
    final all = await getAllProducts(sortedBy: sortedBy, sortedAsc: sortedAsc);
    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _CountingCategoryRepository implements CategoryRepository {
  _CountingCategoryRepository(this.categories);

  final List<admin_category.CategoryEntity> categories;
  int getAllCalls = 0;

  @override
  Future<List<admin_category.CategoryEntity>> getAllCategories({
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    getAllCalls += 1;
    return [...categories];
  }

  @override
  Future<List<admin_category.CategoryEntity>> getCategories({
    required int startingAt,
    required int count,
    String? sortedBy,
    bool? sortedAsc,
  }) async {
    final all = await getAllCategories(
      sortedBy: sortedBy,
      sortedAsc: sortedAsc,
    );
    final end = (startingAt + count).clamp(0, all.length);
    return all.sublist(startingAt.clamp(0, all.length), end);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
