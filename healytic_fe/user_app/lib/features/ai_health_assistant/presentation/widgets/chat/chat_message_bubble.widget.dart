import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/ai_health_assistant/'
    'domain/entities/chat_message.entity.dart';
import 'package:user_app/router/routes.dart';

/// Telegram-style chat bubble: clean, minimal, with
/// subtle rounded corners and lightweight shadows.
///
/// AI messages are left-aligned; user messages are
/// right-aligned with the primary color.
///
/// For bot messages the widget dispatches on
/// [ChatMessageType] to render text, service
/// recommendation cards, or location chips.
class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message.isUser
        ? _UserBubble(message: message)
        : _AiBubble(message: message);
  }
}

// ──────────────────────────────────────────────────────
// AI bubble — left-aligned with avatar
// ──────────────────────────────────────────────────────

class _AiBubble extends StatelessWidget {
  final ChatMessage message;
  const _AiBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timeStr = DateFormat.jm().format(message.timestamp);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimens.widthFraction(context, fraction: 0.78),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Bot avatar intentionally uses a local
            // icon so tests do not depend on external
            // image availability.
            Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 14,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            SizedBox(width: AppDimens.spaceXs),

            // Bubble + time
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBubbleContent(context),
                  _buildTimestamp(context, timeStr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dispatches to the correct bubble content based
  /// on [ChatMessageType].
  Widget _buildBubbleContent(BuildContext context) {
    return switch (message.messageType) {
      ChatMessageType.text => _TextBubbleContent(text: message.text),
      ChatMessageType.serviceRecommendation => _ServiceRecommendationContent(
        metadata: message.metadata,
      ),
      ChatMessageType.nerLocation => _NerLocationContent(
        metadata: message.metadata,
      ),
    };
  }

  Widget _buildTimestamp(BuildContext context, String timeStr) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.spaceSm,
        top: AppDimens.spaceXxs,
      ),
      child: Text(
        timeStr,
        style: textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// Text bubble content (default)
// ──────────────────────────────────────────────────────

/// Regex matching markdown-style bold markers
/// (`**text**`). Captures the inner content.
final _boldPattern = RegExp(r'\*\*(.+?)\*\*');

/// Parses [raw] text, converting `**bold**` segments
/// into bold [TextSpan]s while keeping the rest normal.
List<TextSpan> _parseFormattedText(
  String raw,
  TextStyle? baseStyle,
) {
  final spans = <TextSpan>[];
  final matches = _boldPattern.allMatches(raw);
  var lastEnd = 0;

  for (final match in matches) {
    // Normal text before this bold segment.
    if (match.start > lastEnd) {
      spans.add(
        TextSpan(
          text: raw.substring(lastEnd, match.start),
        ),
      );
    }

    // Bold segment (group 1 = inner content).
    spans.add(
      TextSpan(
        text: match.group(1),
        style: baseStyle?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    lastEnd = match.end;
  }

  // Remaining normal text after the last match.
  if (lastEnd < raw.length) {
    spans.add(TextSpan(text: raw.substring(lastEnd)));
  }

  return spans;
}

class _TextBubbleContent extends StatelessWidget {
  final String text;
  const _TextBubbleContent({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final baseStyle = textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurface,
      height: 1.4,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Text.rich(
        TextSpan(
          style: baseStyle,
          children: _parseFormattedText(
            text,
            baseStyle,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// Service recommendation content
// ──────────────────────────────────────────────────────

class _ServiceRecommendationContent extends StatelessWidget {
  final Map<String, dynamic>? metadata;

  const _ServiceRecommendationContent({this.metadata});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final recommendations =
        (metadata?['recommendations'] as List?)?.cast<Map<String, dynamic>>() ??
        [];

    if (recommendations.isEmpty) {
      return _TextBubbleContent(text: 'No recommendations available.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(textTheme, colorScheme),
        ...recommendations.map(
          (rec) => Padding(
            padding: EdgeInsets.only(top: AppDimens.spaceXs),
            child: _ServiceCard(data: rec),
          ),
        ),
      ],
    );
  }

  /// Section header with icon and title.
  Widget _buildHeader(TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimens.spaceXs,
        bottom: AppDimens.spaceXs,
      ),
      child: Row(
        children: [
          Icon(
            Symbols.medical_services,
            size: AppDimens.iconSm,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppDimens.spaceXxs),
          Text(
            'Recommended Services',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String? _stringValue(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  if (value is num) {
    return value.toString();
  }
  return null;
}

String _priceText(Object? value) {
  if (value is String) return value;
  if (value is num) return value.toString();
  if (value is Map) {
    final amount = value['amount'];
    final currency = value['currency'];
    if (amount is num) {
      final formatted = NumberFormat.decimalPattern().format(amount);
      return currency is String && currency.isNotEmpty
          ? '$formatted $currency'
          : formatted;
    }
  }
  return '';
}

String _ratingText(Object? value) {
  if (value is String) return value;
  if (value is num) return value.toString();
  if (value is Map) {
    final average = value['average'];
    if (average is num) {
      return average.toStringAsFixed(1);
    }
  }
  return '';
}

String _locationText(Object? value) {
  if (value is String) return value;
  if (value is Map) {
    final parts = [value['address'], value['district'], value['city']]
        .whereType<String>()
        .where((part) => part.trim().isNotEmpty)
        .map((part) => part.trim())
        .toList();
    return parts.join(', ');
  }
  return '';
}

// ──────────────────────────────────────────────────────
// Service card — flat or nested recommendation shape
// ──────────────────────────────────────────────────────

/// Rich service card reading either flat
/// [AiRecommendationItemDto] fields or nested
/// backend/mock SSE payload fields.
class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ServiceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final serviceId = data['service_id'] as String? ?? '';

    return GestureDetector(
      onTap: () {
        if (serviceId.isNotEmpty) {
          ServiceDetailsRoute(serviceId: serviceId).push(context);
        }
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimens.radiusMediumSmall,
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ServiceCardImage(data: data),
            _ServiceCardBody(data: data),
          ],
        ),
      ),
    );
  }
}

/// Image header with category chip and rating badge.
class _ServiceCardImage extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ServiceCardImage({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final imageUrl =
        _stringValue(data, 'imageUrl') ?? _stringValue(data, 'image_url');
    final category =
        _stringValue(data, 'category') ?? _stringValue(data, 'badge');
    final rating = _ratingText(data['rating']);

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(colorScheme, imageUrl),
          if (category != null && category.isNotEmpty)
            Positioned(
              top: AppDimens.spaceSm,
              left: AppDimens.spaceSm,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSm,
                  vertical: AppDimens.spaceXxs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.92),
                  borderRadius: AppDimens.radiusPill,
                ),
                child: Text(
                  category,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          if (rating.isNotEmpty)
            Positioned(
              top: AppDimens.spaceSm,
              right: AppDimens.spaceSm,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceSm,
                  vertical: AppDimens.spaceXxs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.scrim.withValues(alpha: 0.6),
                  borderRadius: AppDimens.radiusMediumSmall,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Symbols.star,
                      size: AppDimens.iconXs,
                      color: colorScheme.tertiary,
                      fill: 1.0,
                    ),
                    SizedBox(width: AppDimens.spaceXxs),
                    Text(
                      rating,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onInverseSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme, String? url) {
    if (url != null && url.isNotEmpty) {
      return NetworkImageAuto(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (_) => _buildPlaceholder(colorScheme),
      );
    }
    return _buildPlaceholder(colorScheme);
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Icon(
        Symbols.medical_services,
        size: AppDimens.iconXxl,
        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.4),
      ),
    );
  }
}

/// Body: title, duration, location, vendor, price.
class _ServiceCardBody extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ServiceCardBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final name = _stringValue(data, 'name') ?? '';
    final duration = _stringValue(data, 'duration') ?? '';
    final location = _locationText(data['location']);
    final vendorName =
        _stringValue(data, 'vendorName') ??
        _stringValue(data, 'staff_name') ??
        '';
    final price = _priceText(data['price']);
    final serviceId = _stringValue(data, 'service_id') ?? '';

    return Padding(
      padding: EdgeInsets.all(AppDimens.spaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            name,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.spaceXxs),

          // Duration
          if (duration.isNotEmpty)
            _InfoRow(icon: Symbols.schedule, text: duration),

          // Location
          if (location.isNotEmpty) ...[
            SizedBox(height: AppDimens.spaceXxs),
            _InfoRow(icon: Symbols.location_on, text: location),
          ],

          // Vendor name
          if (vendorName.isNotEmpty) ...[
            SizedBox(height: AppDimens.spaceXxs),
            _InfoRow(icon: Symbols.storefront, text: vendorName),
          ],

          SizedBox(height: AppDimens.spaceSm),

          // Divider + price footer
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppDimens.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  price,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppDimens.spaceXs),
              _ViewButton(serviceId: serviceId),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact icon + text info row for card metadata.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.iconXs,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceXxs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Small CTA button navigating to service details.
class _ViewButton extends StatelessWidget {
  final String serviceId;
  const _ViewButton({required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.primary,
      borderRadius: AppDimens.radiusSmall,
      child: InkWell(
        borderRadius: AppDimens.radiusSmall,
        onTap: () {
          if (serviceId.isNotEmpty) {
            ServiceDetailsRoute(serviceId: serviceId).push(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceXs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              SizedBox(width: AppDimens.spaceXxs),
              Icon(
                Symbols.arrow_forward,
                size: AppDimens.iconXs,
                color: theme.colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// NER location content
// ──────────────────────────────────────────────────────

class _NerLocationContent extends StatelessWidget {
  final Map<String, dynamic>? metadata;
  const _NerLocationContent({this.metadata});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final entities =
        (metadata?['entities'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    if (entities.isEmpty) {
      return _TextBubbleContent(text: 'No locations detected.');
    }

    return Container(
      padding: EdgeInsets.all(AppDimens.spaceSm),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(
              left: AppDimens.spaceXs,
              bottom: AppDimens.spaceXs,
            ),
            child: Row(
              children: [
                Icon(
                  Symbols.location_on,
                  size: 16,
                  color: colorScheme.tertiary,
                ),
                SizedBox(width: AppDimens.spaceXxs),
                Text(
                  'Detected Locations',
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Location chips
          Wrap(
            spacing: AppDimens.spaceXs,
            runSpacing: AppDimens.spaceXxs,
            children: entities.map((entity) {
              final value = entity['value'] as String? ?? '';
              return Chip(
                label: Text(
                  value,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                avatar: Icon(
                  Symbols.place,
                  size: 14,
                  color: colorScheme.tertiary,
                ),
                backgroundColor: colorScheme.surface,
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// User bubble — right-aligned, primary color
// ──────────────────────────────────────────────────────

class _UserBubble extends StatelessWidget {
  final ChatMessage message;
  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final timeStr = DateFormat.jm().format(message.timestamp);

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDimens.widthFraction(context, fraction: 0.78),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spaceMd,
                vertical: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                message.text,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: AppDimens.spaceSm,
                top: AppDimens.spaceXxs,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeStr,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  if (message.isRead) ...[
                    SizedBox(width: AppDimens.spaceXxs),
                    Icon(
                      Icons.done_all_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
