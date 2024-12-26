import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

class CustomDragHandleWidget extends StatelessWidget {
  const CustomDragHandleWidget({
    super.key,
    this.color = AppColors.dividerColor,
    this.height = 5,
    this.width = 30,
    this.borderRadius = 12,
  });

  final double width;
  final double height;
  final Color color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
