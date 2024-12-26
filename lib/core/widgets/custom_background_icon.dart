import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

class CustomBackgroundIcon extends StatelessWidget {
  const CustomBackgroundIcon({
    super.key,
    required this.iconData,
    this.iconColor = AppColors.primaryColor,
    this.backgroundColor = AppColors.highlightBackgroundColor,
    this.borderRadius = 30,
    this.contentPadding = 12,
    this.iconSize = 24,
  });

  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final Color backgroundColor;
  final double borderRadius;
  final double contentPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(contentPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
