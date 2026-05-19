import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/widgets/free_map_tile_layer.widget.dart';

/// Compact, non-interactive map preview showing a single
/// location pin. Falls back to a neutral placeholder when
/// coordinates are unavailable.
class MapPreviewWidget extends StatelessWidget {
  const MapPreviewWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.width,
    this.height = 160,
    this.borderRadius,
    this.onTap,
  });

  /// Latitude of the location to display.
  final double? latitude;

  /// Longitude of the location to display.
  final double? longitude;

  /// Optional fixed width for thumbnail usage.
  final double? width;

  /// Height of the map container.
  final double height;

  /// Optional border radius override.
  final BorderRadius? borderRadius;

  /// Optional tap callback for parent workflows.
  final VoidCallback? onTap;

  bool get _hasCoordinates => latitude != null && longitude != null;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDimens.radiusMediumSmall;

    if (!_hasCoordinates) {
      return _NoLocationPlaceholder(
        width: width,
        height: height,
        borderRadius: radius,
        onTap: onTap,
      );
    }

    final center = LatLng(latitude!, longitude!);

    return _TappablePreview(
      borderRadius: radius,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          width: width,
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
                const FreeMapTileLayer(),
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
      ),
    );
  }
}

class _LocationPin extends StatelessWidget {
  const _LocationPin();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Symbols.location_on,
      color: Theme.of(context).colorScheme.error,
      size: 32,
      fill: 1,
    );
  }
}

class _NoLocationPlaceholder extends StatelessWidget {
  const _NoLocationPlaceholder({
    required this.height,
    required this.borderRadius,
    this.width,
    this.onTap,
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _TappablePreview(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: borderRadius,
        ),
        child: Icon(
          Symbols.map,
          size: AppDimens.iconXxl,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _TappablePreview extends StatelessWidget {
  const _TappablePreview({
    required this.child,
    required this.borderRadius,
    this.onTap,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return child;

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: borderRadius, child: child),
    );
  }
}
