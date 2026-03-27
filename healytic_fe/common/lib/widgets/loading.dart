import 'package:flutter/material.dart';

/// A centered circular loading spinner using the theme's primary color.
///
/// Drop this widget into any page or container that needs a loading state.
///
/// ```dart
/// if (isLoading) const LoadingWidget()
/// ```
class LoadingWidget extends StatelessWidget {
  /// Creates a [LoadingWidget].
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
