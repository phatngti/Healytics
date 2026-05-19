import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

class FreeMapTileLayer extends StatelessWidget {
  const FreeMapTileLayer({super.key, this.maxZoom = 19});

  final double maxZoom;

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate:
          'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.healytics.user_app',
      maxZoom: maxZoom,
    );
  }
}

class FreeMapAttribution extends StatelessWidget {
  const FreeMapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return const RichAttributionWidget(
      showFlutterMapAttribution: false,
      attributions: [
        TextSourceAttribution('OpenStreetMap contributors'),
        TextSourceAttribution('CARTO'),
      ],
    );
  }
}
