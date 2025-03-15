import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class AuthSwitchWidget extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onActionPressed;
  final Color? promptTextColor;
  final Color? actionTextColor;
  final double? promptTextSize;
  final double? actionTextSize;

  const AuthSwitchWidget({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onActionPressed,
    this.promptTextColor,
    this.actionTextColor,
    this.promptTextSize = 18,
    this.actionTextSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color effectiveActionTextColor =
        actionTextColor ?? theme.colorScheme.onSurface;
    final Color underlineColor = theme.colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style:
              AppTextStyles.uberMoveRegular(context, promptTextSize!).copyWith(
            color: promptTextColor ?? theme.colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: onActionPressed,
          child: Text(
            actionText,
            style:
                AppTextStyles.uberMoveBold(context, actionTextSize!).copyWith(
              color: effectiveActionTextColor,
              decoration: TextDecoration.underline,
              decorationColor: underlineColor,
            ),
          ),
        ),
      ],
    );
  }
}
