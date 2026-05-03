import 'package:admin_panel/core/entities/store.entity.dart' show Store;
import 'package:admin_panel/core/models/store.model.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// A compact, non-interactive map preview showing a
/// single location pin. Falls back to a placeholder
/// when no coordinates are available.
class MapPreviewWidget extends StatelessWidget {
  const MapPreviewWidget({
    this.latitude,
    this.longitude,
    this.height = 160,
    super.key,
  });

  /// Latitude of the location to display
  final double? latitude;

  /// Longitude of the location to display
  final double? longitude;

  /// Height of the map container
  final double height;

  bool get _hasCoordinates => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasCoordinates) {
      return _NoLocationPlaceholder(height: height);
    }

    final center = LatLng(latitude!, longitude!);

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: SizedBox(
        height: height,
        child: IgnorePointer(
          child: FlutterMap(
            options: MapOptions(
              initialCenter: center,
              initialZoom: 15,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.none,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: _tileUrlTemplate,
                userAgentPackageName: 'com.healytics.admin',
                maxZoom: 18,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: 32,
                    height: 32,
                    child: const _LocationPin(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns Mapbox raster tile URL when a token
  /// is configured, otherwise falls back to OSM.
  String get _tileUrlTemplate {
    final token = Store.tryGet<String>(StoreKey.mapboxAccessToken);
    if (token != null && token.isNotEmpty) {
      return 'https://api.mapbox.com/styles/v1/'
          'mapbox/streets-v12/tiles/{z}/{x}/{y}'
          '@2x?access_token=$token';
    }
    return 'https://tile.openstreetmap.org/'
        '{z}/{x}/{y}.png';
  }
}

/// Default location pin marker
class _LocationPin extends StatelessWidget {
  const _LocationPin();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Icon(Icons.location_on, color: colorScheme.error, size: 32);
  }
}

/// Placeholder shown when no lat/long available
class _NoLocationPlaceholder extends StatelessWidget {
  const _NoLocationPlaceholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusSmall,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off,
              size: 24,
              color: colorScheme.onSurfaceVariant,
            ),
            AppDimens.verticalExtraSmall,
            Text(
              'No location data',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
