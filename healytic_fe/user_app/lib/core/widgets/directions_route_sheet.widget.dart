import 'dart:convert';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/core/entities/location_coordinate.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/providers/location.provider.dart';
import 'package:user_app/core/services/location.service.dart';
import 'package:user_app/core/widgets/free_map_tile_layer.widget.dart';
import 'package:user_openapi/api.dart';

class DirectionsRouteSheet extends ConsumerStatefulWidget {
  const DirectionsRouteSheet({
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.destinationName,
    required this.destinationAddress,
    super.key,
  });

  final double destinationLatitude;
  final double destinationLongitude;
  final String destinationName;
  final String destinationAddress;

  static Future<void> show(
    BuildContext context, {
    required double destinationLatitude,
    required double destinationLongitude,
    required String destinationName,
    required String destinationAddress,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DirectionsRouteSheet(
        destinationLatitude: destinationLatitude,
        destinationLongitude: destinationLongitude,
        destinationName: destinationName,
        destinationAddress: destinationAddress,
      ),
    );
  }

  @override
  ConsumerState<DirectionsRouteSheet> createState() =>
      _DirectionsRouteSheetState();
}

class _DirectionsRouteSheetState extends ConsumerState<DirectionsRouteSheet> {
  late Future<_DirectionsRouteData> _routeFuture;

  @override
  void initState() {
    super.initState();
    _routeFuture = _loadRoute();
  }

  Future<_DirectionsRouteData> _loadRoute() async {
    final location = await ref
        .read(locationServiceProvider)
        .getCurrentCoordinate();
    final destination = LocationCoordinate(
      latitude: widget.destinationLatitude,
      longitude: widget.destinationLongitude,
    );

    final response = await ref
        .read(apiServiceProvider)
        .mapboxApi
        .mapboxControllerDirections(
          _coordinateQuery(location),
          _coordinateQuery(destination),
        );

    if (response == null || response.route.length < 2) {
      throw const _DirectionsException(
        'No route is available for this location.',
      );
    }

    return _DirectionsRouteData(
      origin: location,
      destination: destination,
      response: response,
    );
  }

  String _coordinateQuery(LocationCoordinate coordinate) {
    return '${coordinate.latitude},${coordinate.longitude}';
  }

  void _retry() {
    setState(() {
      _routeFuture = _loadRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FractionallySizedBox(
      heightFactor: 0.78,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            SizedBox(height: AppDimens.spaceSm),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.spaceLg,
                AppDimens.spaceMd,
                AppDimens.spaceSm,
                AppDimens.spaceSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.destinationName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: AppDimens.spaceXs),
                        Text(
                          widget.destinationAddress,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<_DirectionsRouteData>(
                future: _routeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const _DirectionsLoading();
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return _DirectionsError(
                      message: _friendlyError(snapshot.error),
                      onRetry: _retry,
                    );
                  }

                  return _DirectionsRouteContent(data: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _friendlyError(Object? error) {
    if (error is LocationServiceException) return error.message;
    if (error is _DirectionsException) return error.message;
    if (error is ApiException) return _friendlyApiError(error);
    return 'Unable to load directions. Please try again.';
  }

  String _friendlyApiError(ApiException error) {
    final rawMessage = error.message;
    if (rawMessage == null || rawMessage.isEmpty) {
      return 'Unable to load directions. Please try again.';
    }

    try {
      final decoded = jsonDecode(rawMessage);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'];
        if (message is String && message.isNotEmpty) {
          return message.replaceFirst('Directions failed: ', '');
        }
      }
    } catch (_) {
      // The generated client exposes the response body as a string.
    }

    if (rawMessage.contains('No driving route is available')) {
      return 'No driving route is available between your location and this clinic.';
    }
    return 'Unable to load directions. Please try again.';
  }
}

class _DirectionsRouteContent extends StatelessWidget {
  const _DirectionsRouteContent({required this.data});

  final _DirectionsRouteData data;

  @override
  Widget build(BuildContext context) {
    final points = data.routePoints;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceLg),
            child: _DirectionsMap(data: data, routePoints: points),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppDimens.spaceLg),
          child: Row(
            children: [
              Expanded(
                child: _RouteMetric(
                  icon: Symbols.route,
                  label: 'Distance',
                  value: data.response.distanceText,
                ),
              ),
              SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: _RouteMetric(
                  icon: Symbols.schedule,
                  label: 'Duration',
                  value: data.response.durationText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DirectionsMap extends StatelessWidget {
  const _DirectionsMap({required this.data, required this.routePoints});

  final _DirectionsRouteData data;
  final List<LatLng> routePoints;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.36),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: ClipRRect(
        borderRadius: AppDimens.radiusMediumSmall,
        child: FlutterMap(
          options: MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: LatLngBounds.fromPoints(routePoints),
              padding: const EdgeInsets.fromLTRB(54, 72, 54, 72),
            ),
            interactionOptions: const InteractionOptions(
              flags:
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom |
                  InteractiveFlag.drag,
            ),
          ),
          children: [
            const FreeMapTileLayer(),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  color: colorScheme.surface,
                  strokeWidth: 9,
                ),
                Polyline(
                  points: routePoints,
                  color: colorScheme.primary,
                  strokeWidth: 5,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(data.origin.latitude, data.origin.longitude),
                  width: 40,
                  height: 40,
                  child: _OriginMarker(color: colorScheme.primary),
                ),
                Marker(
                  point: LatLng(
                    data.destination.latitude,
                    data.destination.longitude,
                  ),
                  width: 46,
                  height: 46,
                  child: _DestinationMarker(color: colorScheme.error),
                ),
              ],
            ),
            const FreeMapAttribution(),
          ],
        ),
      ),
    );
  }
}

class _OriginMarker extends StatelessWidget {
  const _OriginMarker({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 2),
            color: Color(0x33000000),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
        child: Icon(
          Symbols.my_location,
          color: color,
          size: AppDimens.iconMd,
          fill: 1,
        ),
      ),
    );
  }
}

class _DestinationMarker extends StatelessWidget {
  const _DestinationMarker({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 4),
            color: Color(0x33000000),
          ),
        ],
      ),
      child: Icon(Symbols.location_on, color: color, size: 28, fill: 1),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppDimens.iconMd, color: colorScheme.primary),
          SizedBox(width: AppDimens.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionsLoading extends StatelessWidget {
  const _DirectionsLoading();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: AppDimens.spaceMd),
          Text(
            'Loading directions...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionsError extends StatelessWidget {
  const _DirectionsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.location_off,
              size: AppDimens.iconXxl,
              color: colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppDimens.spaceMd),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimens.spaceMd),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Symbols.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionsRouteData {
  const _DirectionsRouteData({
    required this.origin,
    required this.destination,
    required this.response,
  });

  final LocationCoordinate origin;
  final LocationCoordinate destination;
  final DirectionsResponseDto response;

  List<LatLng> get routePoints => response.route
      .map(
        (point) =>
            LatLng(point.latitude.toDouble(), point.longitude.toDouble()),
      )
      .toList(growable: false);
}

class _DirectionsException implements Exception {
  const _DirectionsException(this.message);

  final String message;
}
