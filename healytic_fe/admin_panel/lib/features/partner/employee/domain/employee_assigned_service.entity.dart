/// Display-ready summary of a service assigned to an employee.
class EmployeeAssignedServiceEntity {
  const EmployeeAssignedServiceEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.basePrice,
    required this.currency,
    required this.isPrimary,
    this.salePrice,
    this.durationMinutes,
    this.categoryName,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String status;
  final double basePrice;
  final double? salePrice;
  final String currency;
  final int? durationMinutes;
  final String? categoryName;
  final String? imageUrl;
  final bool isPrimary;
}
