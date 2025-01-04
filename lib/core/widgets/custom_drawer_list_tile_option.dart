import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomDrawerListTileOption extends StatelessWidget {
  const CustomDrawerListTileOption({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      leading: Icon(
        iconData,
        color: AppColors.primaryColor,
        size: 30,
      ),
      title: Text(
        title,
        style: AppTextStyles.uberMoveBlack20,
      ),
    );
  }
}
