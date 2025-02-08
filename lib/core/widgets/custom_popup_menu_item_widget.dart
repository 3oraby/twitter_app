
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomPopupMenuItemWidget extends StatelessWidget {
  const CustomPopupMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.titleColor = AppColors.primaryColor,
    this.iconColor = AppColors.primaryColor,
  });

  final String title;
  final IconData icon;
  final Color titleColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.uberMoveMedium18.copyWith(
            color: titleColor,
          ),
        ),
        const Spacer(),
        Icon(
          icon,
          color: iconColor,
        ),
      ],
    );
  }
}
