import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    this.actions,
    this.title,
    this.centerTitle = true,
    this.floating = true,
    this.snap = false,
    this.forceElevated = false,
  });

  final bool floating;
  final bool snap;
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool forceElevated;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      snap: snap,
      forceElevated: forceElevated,
      elevation: 0,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      surfaceTintColor: AppColors.scaffoldBackgroundColor,
      title: title,
      actions: actions,
    );
  }
}
