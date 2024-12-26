import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

AppBar buildCustomAppBar(
  BuildContext context, {
  required String title,
  bool centerTitle = true,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: AppColors.scaffoldBackgroundColor,
    title: Text(
      title,
      style: AppTextStyles.uberMoveBold24,
    ),
    centerTitle: centerTitle,
    automaticallyImplyLeading: automaticallyImplyLeading,
  );
}
