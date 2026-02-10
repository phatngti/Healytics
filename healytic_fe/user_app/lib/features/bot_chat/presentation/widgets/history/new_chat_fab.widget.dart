import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Teal floating action button used to start a new chat
/// conversation from the history page.
class NewChatFab extends StatelessWidget {
  /// Optional callback when the FAB is pressed. If `null` the
  /// button is rendered but does nothing.
  final VoidCallback? onPressed;

  const NewChatFab({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimens.avatarLg,
      height: AppDimens.avatarLg,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: const Color(0xFF00BFA5),
        elevation: 6,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: AppDimens.iconXxl),
      ),
    );
  }
}
