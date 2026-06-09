import 'package:admin_panel/features/partner/employee/data/employee_impl.repository.dart';
import 'package:admin_panel/features/partner/employee/domain/create_employee.request.dart';
import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_status.dart';
import 'package:admin_panel/features/partner/employee/domain/update_employee.request.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee.provider.freezed.dart';
part 'employee.provider.g.dart';

enum EmployeeTableSort {
  name,
  position,
  rating,
  reviewCount,
  status,
  createdAt,
}

enum EmployeeRoleFilter { all, doctor, therapist, receptionist, manager }

enum EmployeeStatusFilter { all, active, inactive, onLeave }

/// State for employee management operations.
@freezed
abstract class EmployeeState with _$EmployeeState {
  /// Creates employee table state.
  const factory EmployeeState({
    @Default('') String searchQuery,
    @Default(EmployeeTableSort.name) EmployeeTableSort sortBy,
    @Default(true) bool sortAscending,
    @Default(EmployeeRoleFilter.all) EmployeeRoleFilter roleFilter,
    @Default(EmployeeStatusFilter.all) EmployeeStatusFilter statusFilter,
    @Default(<String>{}) Set<String> selectedIds,
    @Default(0) int reloadToken,
  }) = _EmployeeState;
}

/// Notifier for managing employee operations.
///
/// Provides methods for CRUD operations on employees including:
/// - Fetching paginated employee lists
/// - Getting employee details by ID
/// - Creating, updating, and deleting employees
/// - Filtering employees by role
@riverpod
class EmployeeNotifier extends _$EmployeeNotifier {
  int? _visibleEmployeesCacheKey;
  Future<List<EmployeeEntity>>? _visibleEmployeesCache;

  @override
  FutureOr<EmployeeState> build() async {
    return const EmployeeState();
  }

  /// Returns the total count of employees.
  Future<int> getTotalRows() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getTotalRows();
  }

  /// Retrieves a paginated list of employees.
  ///
  /// - [startingAt]: Index to start fetching from.
  /// - [count]: Number of employees to fetch.
  /// - [search]: Optional search/sort field.
  /// - [sortAscending]: Optional sort direction.
  Future<List<EmployeeEntity>> getEmployees({
    required int startingAt,
    required int count,
    String? search,
    bool? sortAscending,
  }) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployees(startingAt, count, search, sortAscending);
  }

  Future<int> getVisibleTotalRows() async {
    return (await _getVisibleEmployees()).length;
  }

  Future<List<EmployeeEntity>> getVisiblePage({
    required int startingAt,
    required int count,
  }) async {
    final employees = await _getVisibleEmployees();
    return _page(employees, startingAt, count);
  }

  void setSearchQuery(String value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        searchQuery: value,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setSort(EmployeeTableSort sortBy) {
    final current = _currentState;
    final nextAscending = current.sortBy == sortBy
        ? !current.sortAscending
        : _defaultSortAscending(sortBy);
    _setTableState(
      current.copyWith(
        sortBy: sortBy,
        sortAscending: nextAscending,
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setRoleFilter(EmployeeRoleFilter value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        roleFilter: value,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void setStatusFilter(EmployeeStatusFilter value) {
    final current = _currentState;
    _setTableState(
      current.copyWith(
        statusFilter: value,
        selectedIds: const <String>{},
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  void toggleSelection(String id, bool selected) {
    final current = _currentState;
    final selectedIds = {...current.selectedIds};
    if (selected) {
      selectedIds.add(id);
    } else {
      selectedIds.remove(id);
    }
    _setTableState(current.copyWith(selectedIds: selectedIds));
  }

  void clearSelection() {
    final current = _currentState;
    if (current.selectedIds.isEmpty) return;
    _setTableState(current.copyWith(selectedIds: const <String>{}));
  }

  /// Deletes an employee by their ID.
  Future<void> deleteEmployee(EmployeeId id) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.deleteEmployee(id);
  }

  Future<void> deleteOne(String id) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.deleteEmployee(EmployeeId(id));
    _afterDelete(idsToRemove: {id});
  }

  Future<void> deleteSelected() async {
    final ids = _currentState.selectedIds.toList(growable: false);
    if (ids.isEmpty) return;

    final repo = ref.read(employeeRepositoryProvider);
    await Future.wait(ids.map((id) => repo.deleteEmployee(EmployeeId(id))));
    _afterDelete(idsToRemove: ids.toSet());
  }

  /// Updates an existing employee's information.
  Future<void> updateEmployee(UpdateEmployeeRequest request) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.updateEmployee(request);
  }

  /// Updates only an employee's status.
  Future<void> updateEmployeeStatus(
    EmployeeId id,
    EmployeeStatusType status,
  ) async {
    final repo = ref.read(employeeRepositoryProvider);
    await repo.updateEmployeeStatus(id, status);
  }

  /// Retrieves a single employee by their ID.
  Future<EmployeeEntity> getEmployeeById(EmployeeId id) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployeeById(id);
  }

  /// Creates a new doctor employee.
  Future<EmployeeEntity> createDoctor(CreateDoctorRequest request) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createDoctor(request);
  }

  /// Creates a new spa therapist employee.
  Future<EmployeeEntity> createSpaTherapist(
    CreateSpaTherapistRequest request,
  ) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createSpaTherapist(request);
  }

  /// Creates a new massage therapist employee.
  Future<EmployeeEntity> createMassageTherapist(
    CreateMassageTherapistRequest request,
  ) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createMassageTherapist(request);
  }

  /// Retrieves employees filtered by role.
  ///
  /// - [role]: The role to filter by (e.g., 'DOCTOR', 'THERAPIST').
  Future<List<EmployeeEntity>> getEmployeesByRole(String role) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getEmployeesByRole(role: role);
  }

  /// Retrieves available spa skills options.
  Future<Map<String, String>> getSpaSkills() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getSpaSkills();
  }

  /// Retrieves available device proficiency options.
  Future<Map<String, String>> getDeviceProficiency() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getDeviceProficiency();
  }

  /// Retrieves available massage skills options.
  Future<Map<String, String>> getMassageSkills() async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.getMassageSkills();
  }

  /// Creates a new massage skill for the partner.
  Future<Map<String, String>> createMassageSkill(String name) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createMassageSkill(name);
  }

  /// Creates a new spa skill for the partner.
  Future<Map<String, String>> createSpaSkill(String name) async {
    final repo = ref.read(employeeRepositoryProvider);
    return repo.createSpaSkill(name);
  }

  EmployeeState get _currentState => state.value ?? const EmployeeState();

  void _setTableState(EmployeeState value) {
    state = AsyncValue.data(value);
  }

  void _afterDelete({required Set<String> idsToRemove}) {
    final current = _currentState;
    _invalidateVisibleEmployeesCache();
    _setTableState(
      current.copyWith(
        selectedIds: current.selectedIds.difference(idsToRemove),
        reloadToken: current.reloadToken + 1,
      ),
    );
  }

  Future<List<EmployeeEntity>> _getVisibleEmployees() async {
    final cacheKey = _visibleEmployeesKey(_currentState);
    final cached = _visibleEmployeesCache;
    if (_visibleEmployeesCacheKey == cacheKey && cached != null) {
      return cached;
    }

    final future = _loadVisibleEmployees(cacheKey);
    _visibleEmployeesCacheKey = cacheKey;
    _visibleEmployeesCache = future;
    return future;
  }

  Future<List<EmployeeEntity>> _loadVisibleEmployees(int cacheKey) async {
    try {
      return await _fetchVisibleEmployees();
    } catch (_) {
      if (_visibleEmployeesCacheKey == cacheKey) {
        _invalidateVisibleEmployeesCache();
      }
      rethrow;
    }
  }

  Future<List<EmployeeEntity>> _fetchVisibleEmployees() async {
    final repo = ref.read(employeeRepositoryProvider);
    final employees = await repo.getAllEmployees();
    final query = _currentState;
    final normalizedSearch = query.searchQuery.trim().toLowerCase();

    final filtered = employees.where((employee) {
      final matchesSearch =
          normalizedSearch.isEmpty ||
          employee.id.value.toLowerCase().contains(normalizedSearch) ||
          employee.fullName.toLowerCase().contains(normalizedSearch) ||
          employee.email.toLowerCase().contains(normalizedSearch) ||
          employee.phone.toLowerCase().contains(normalizedSearch) ||
          employee.role.toLowerCase().contains(normalizedSearch);

      final matchesRole = switch (query.roleFilter) {
        EmployeeRoleFilter.all => true,
        EmployeeRoleFilter.doctor => employee.role.toUpperCase() == 'DOCTOR',
        EmployeeRoleFilter.therapist =>
          employee.role.toUpperCase() == 'THERAPIST',
        EmployeeRoleFilter.receptionist =>
          employee.role.toUpperCase() == 'RECEPTIONIST',
        EmployeeRoleFilter.manager => employee.role.toUpperCase() == 'MANAGER',
      };

      final matchesStatus = switch (query.statusFilter) {
        EmployeeStatusFilter.all => true,
        EmployeeStatusFilter.active =>
          employee.status.toUpperCase() == 'ACTIVE',
        EmployeeStatusFilter.inactive =>
          employee.status.toUpperCase() == 'INACTIVE',
        EmployeeStatusFilter.onLeave =>
          employee.status.toUpperCase() == 'ON_LEAVE',
      };

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();

    filtered.sort((a, b) {
      final comparison = switch (query.sortBy) {
        EmployeeTableSort.name => _compareText(a.fullName, b.fullName),
        EmployeeTableSort.position => _compareText(a.position, b.position),
        EmployeeTableSort.rating => a.rating.compareTo(b.rating),
        EmployeeTableSort.reviewCount => a.reviewCount.compareTo(b.reviewCount),
        EmployeeTableSort.status => _compareText(a.status, b.status),
        EmployeeTableSort.createdAt => _compareNullableDateTime(
          a.createdAt,
          b.createdAt,
        ),
      };
      return query.sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  int _visibleEmployeesKey(EmployeeState state) {
    return Object.hash(
      state.searchQuery,
      state.sortBy,
      state.sortAscending,
      state.roleFilter,
      state.statusFilter,
      state.reloadToken,
    );
  }

  void _invalidateVisibleEmployeesCache() {
    _visibleEmployeesCacheKey = null;
    _visibleEmployeesCache = null;
  }

  List<T> _page<T>(List<T> items, int startingAt, int count) {
    if (startingAt >= items.length) return [];
    final end = (startingAt + count).clamp(0, items.length);
    return items.sublist(startingAt.clamp(0, items.length), end);
  }

  int _compareText(String a, String b) {
    return a.toLowerCase().compareTo(b.toLowerCase());
  }

  bool _defaultSortAscending(EmployeeTableSort sortBy) {
    return switch (sortBy) {
      EmployeeTableSort.createdAt => false,
      _ => true,
    };
  }

  int _compareNullableDateTime(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    return a.compareTo(b);
  }
}
