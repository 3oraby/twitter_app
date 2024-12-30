import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

AppBar buildCustomAppBar(
  BuildContext context, {
  Widget? title,
  bool centerTitle = true,
  bool automaticallyImplyLeading = true,
}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: AppColors.scaffoldBackgroundColor,
    title: title,
    centerTitle: centerTitle,
    automaticallyImplyLeading: automaticallyImplyLeading,
  );
}
