import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    this.actions,
    this.title,
    this.centerTitle = true,
    this.floating = true,
    this.pinned = false,
    this.snap = false,
    this.forceElevated = false,
    this.backgroundColor = Colors.transparent,
    this.expandedHeight,
    this.flexibleSpace,
  });

  final bool floating;
  final bool pinned;
  final bool snap;
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool forceElevated;
  final Color backgroundColor;

  final double? expandedHeight;
  final Widget? flexibleSpace;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      snap: snap,
      forceElevated: forceElevated,
      elevation: 0,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      surfaceTintColor: AppColors.scaffoldBackgroundColor,
      title: title,
      actions: actions,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      pinned: pinned,
    );
  }
}
