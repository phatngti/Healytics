/// Administrative location option used by cascading address dropdowns.
class LocationEntity {
  const LocationEntity({
    required this.id,
    required this.name,
    this.fullName,
    this.level,
  });

  final String id;
  final String name;
  final String? fullName;
  final String? level;
}
