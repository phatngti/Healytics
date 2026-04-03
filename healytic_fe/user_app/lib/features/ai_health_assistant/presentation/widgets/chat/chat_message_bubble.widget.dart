import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';
import 'package:intl/intl.dart';

import 'package:user_app/features/ai_health_assistant/domain/entities/chat_message.entity.dart';

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

  /// Small avatar URL shown beside AI messages.
  static const String botAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/'
      'AB6AXuC8GfSYKLidcI6WkfSjR9kq2CSeJJBNIN_Hsarp'
      '_MgZcaIVmyjsCO8m1dILd3Fzk_Kc7RO-zBbIsr2biiY3'
      'sRXO8X6nbbmeaxdbxQqOylWGdPsPhtiycvRSp1EMfwjsl'
      'vHeb_GSvUgWJpMqhvTONsLtcbSPTqPmDAJgAcrQ_w4hAj'
      'GKN2x-pq53vY5DQUtagO9cyliTTYNRQVDJUqwiYbkGaAc'
      'ISV5S05iYIlsBmDiTdZN4j2pBQs3hocgvSMCGLgLHIw8M'
      'o9USy6o';

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
            // Bot avatar
            Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spaceMd),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: const NetworkImage(
                  ChatMessageBubble.botAvatarUrl,
                ),
                onBackgroundImageError: (_, __) {},
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

class _TextBubbleContent extends StatelessWidget {
  final String text;
  const _TextBubbleContent({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd,
        vertical: AppDimens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(18),
        ),
      ),
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
          height: 1.4,
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
        _buildCardList(recommendations),
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
            Icons.medical_services_rounded,
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

  /// Vertical list of service recommendation cards.
  Widget _buildCardList(List<Map<String, dynamic>> items) {
    return Column(
      children: items
          .map(
            (rec) => Padding(
              padding: EdgeInsets.only(top: AppDimens.spaceXs),
              child: _ServiceCard(data: rec),
            ),
          )
          .toList(),
    );
  }
}

/// Rich service recommendation card with image,
/// badge, rating, location, staff, and price.
class _ServiceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ServiceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
    );
  }
}

/// Image header with optional badge overlay.
class _ServiceCardImage extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ServiceCardImage({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final imageUrl = data['image_url'] as String?;
    final badge = data['badge'] as String?;

    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildImage(colorScheme, imageUrl),
          if (badge != null) _buildBadge(textTheme, colorScheme, badge),
        ],
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme, String? url) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(colorScheme),
      );
    }
    return _buildPlaceholder(colorScheme);
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Icon(
        Icons.medical_services_outlined,
        size: AppDimens.iconXxl,
        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.4),
      ),
    );
  }

  Widget _buildBadge(
    TextTheme textTheme,
    ColorScheme colorScheme,
    String label,
  ) {
    return Positioned(
      top: AppDimens.spaceSm,
      right: AppDimens.spaceSm,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceSm,
          vertical: AppDimens.spaceXxs,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: AppDimens.radiusExtraSmall,
        ),
        child: Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Body section: title, rating, location, staff, price.
class _ServiceCardBody extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ServiceCardBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(AppDimens.spaceSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(textTheme, colorScheme),
          SizedBox(height: AppDimens.spaceXs),
          _buildRatingRow(textTheme, colorScheme),
          SizedBox(height: AppDimens.spaceXs),
          _buildLocationRow(textTheme, colorScheme),
          SizedBox(height: AppDimens.spaceXxs),
          _buildStaffRow(textTheme, colorScheme),
          SizedBox(height: AppDimens.spaceSm),
          _buildPriceFooter(textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTitle(TextTheme textTheme, ColorScheme colorScheme) {
    final name = data['name'] as String? ?? '';
    return Text(
      name,
      style: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRatingRow(TextTheme textTheme, ColorScheme colorScheme) {
    final rating = data['rating'] as Map<String, dynamic>? ?? {};
    final avg = rating['average'] as num? ?? 0;
    final bookedCount = data['booked_count'] as num?;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.spaceXs,
            vertical: AppDimens.spaceXxs,
          ),
          decoration: BoxDecoration(
            color: colorScheme.tertiaryContainer.withValues(alpha: 0.3),
            borderRadius: AppDimens.radiusExtraSmall,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_rounded,
                size: AppDimens.iconXs,
                color: colorScheme.tertiary,
              ),
              SizedBox(width: AppDimens.spaceXxs),
              Text(
                avg.toStringAsFixed(1),
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ),
        if (bookedCount != null) ...[
          SizedBox(width: AppDimens.spaceSm),
          Flexible(
            child: Text(
              '${_formatNumber(bookedCount)}+ booked',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationRow(TextTheme textTheme, ColorScheme colorScheme) {
    final loc = data['location'] as Map<String, dynamic>? ?? {};
    final address = loc['address'] as String? ?? '';
    final district = loc['district'] as String? ?? '';
    final label = [address, district].where((s) => s.isNotEmpty).join(' • ');

    return Row(
      children: [
        Icon(
          Icons.location_on_rounded,
          size: AppDimens.iconXs,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceXxs),
        Expanded(
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStaffRow(TextTheme textTheme, ColorScheme colorScheme) {
    final staffName = data['staff_name'] as String? ?? '';
    return Row(
      children: [
        Icon(
          Icons.person_rounded,
          size: AppDimens.iconXs,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceXxs),
        Expanded(
          child: Text(
            staffName,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceFooter(TextTheme textTheme, ColorScheme colorScheme) {
    final price = data['price'] as Map<String, dynamic>? ?? {};
    final amount = price['amount'] as num? ?? 0;
    final currency = price['currency'] as String? ?? '';

    return Column(
      children: [
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
                '${_formatNumber(amount)} $currency',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppDimens.spaceXs),
            _BookButton(colorScheme: colorScheme),
          ],
        ),
      ],
    );
  }
}

/// Small filled "Book" CTA button.
class _BookButton extends StatelessWidget {
  final ColorScheme colorScheme;
  const _BookButton({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: AppDimens.radiusSmall,
      child: InkWell(
        borderRadius: AppDimens.radiusSmall,
        onTap: () {
          // TODO: Navigate to booking flow.
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.spaceMd,
            vertical: AppDimens.spaceXs,
          ),
          child: Text(
            'Book',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// Formats [value] with comma separators for thousands.
String _formatNumber(num value) {
  return value
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
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
                  Icons.location_on_rounded,
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
                  Icons.place_rounded,
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
