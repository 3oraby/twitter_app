import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

class CustomContainerButton extends StatelessWidget {
  const CustomContainerButton({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.twitterAccentColor,
    this.internalHorizontalPadding = 16,
    this.internalVerticalPadding = 16,
    this.borderRadius = 30,
    this.onPressed,
    this.height,
    this.width,
  });

  final Widget child;
  final Color backgroundColor;
  final double internalHorizontalPadding;
  final double internalVerticalPadding;
  final double borderRadius;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
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
