import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class CustomTriggerButton extends StatelessWidget {
  const CustomTriggerButton({
    super.key,
    this.onPressed,
    this.child,
    this.isEnabled = true,
    this.backgroundColor,
    this.buttonDescription,
    this.buttonHeight = 60,
    this.buttonWidth = double.infinity,
    this.borderWidth = 0,
    this.borderColor = AppColors.primaryColor,
    this.borderRadius = AppConstants.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.horizontalPadding = 16,
  });

  final bool isEnabled;
  final VoidCallback? onPressed;
  final Text? buttonDescription;
  final Color? backgroundColor;
  final double buttonHeight;
  final double buttonWidth;
  final Widget? child;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final MainAxisAlignment mainAxisAlignment;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color buttonBackgroundColor = backgroundColor ??
        (theme.brightness == Brightness.dark
            ? theme.colorScheme.primaryContainer
            : AppColors.primaryColor);
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          border: Border.all(
            width: borderWidth,
            color: borderWidth == 0 ? Colors.white : borderColor,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child ??
            Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                if (prefixIcon != null) prefixIcon!,
                HorizontalGap(horizontalPadding),
                if (buttonDescription != null) buttonDescription!,
                HorizontalGap(horizontalPadding),
                if (suffixIcon != null) suffixIcon!
              ],
            ),
      ),
    );
  }
}
