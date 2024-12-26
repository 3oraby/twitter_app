import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.internalHorizontalPadding = 12,
    this.internalVerticalPadding = 12,
    this.borderRadius = AppConstants.borderRadius,
    this.onPressed,
  });

  final Widget child;
  final Color backgroundColor;
  final double internalHorizontalPadding;
  final double internalVerticalPadding;
  final double borderRadius;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: internalHorizontalPadding,
          vertical: internalVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child,
      ),
    );
  }
}
