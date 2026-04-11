class LocationCoordinate {
  final double latitude;
  final double longitude;

  const LocationCoordinate({required this.latitude, required this.longitude});

  @override
  String toString() {
    return 'LocationCoordinate('
        'latitude: $latitude, '
        'longitude: $longitude'
        ')';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LocationCoordinate &&
            runtimeType == other.runtimeType &&
            latitude == other.latitude &&
            longitude == other.longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}
