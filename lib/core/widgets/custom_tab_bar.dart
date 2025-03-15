import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.tabAlignment,
    this.labelPadding,
    this.padding,
  });

  final List<Widget> tabs;
  final TabController? controller;
  final bool isScrollable;
  final TabAlignment? tabAlignment;
  final EdgeInsetsGeometry? labelPadding;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: isScrollable,
      tabAlignment: tabAlignment,
      labelPadding: labelPadding,
      padding: padding,
      indicatorColor: AppColors.twitterAccentColor,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: AppTextStyles.uberMoveBold(context,18),
      unselectedLabelStyle: AppTextStyles.uberMoveBold(context,18).copyWith(
        color: AppColors.secondaryColor,
      ),
      tabs: tabs,
    );
  }
}
