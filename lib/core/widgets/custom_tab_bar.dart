import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
  });

  final List<Widget> tabs;
  final TabController? controller;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorColor: AppColors.twitterAccentColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: AppTextStyles.uberMoveBold18,
      unselectedLabelStyle: AppTextStyles.uberMoveBold18.copyWith(
        color: AppColors.secondaryColor,
      ),
      tabs: tabs,
    );
  }
}
