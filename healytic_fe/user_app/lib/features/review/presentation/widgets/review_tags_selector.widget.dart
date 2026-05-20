import 'package:flutter/material.dart';

class ReviewTagsSelector extends StatelessWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final ValueChanged<String> onTagToggled;

  const ReviewTagsSelector({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.onTagToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      alignment: WrapAlignment.center,
      children: availableTags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        final colorScheme = Theme.of(context).colorScheme;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTagToggled(tag),
            borderRadius: BorderRadius.circular(100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                tag,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
