import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class ShowUserProfileTabBars extends StatelessWidget {
  const ShowUserProfileTabBars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        indicatorColor: AppColors.twitterAccentColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AppTextStyles.uberMoveBold18,
        unselectedLabelStyle: AppTextStyles.uberMoveBold18.copyWith(
          color: AppColors.secondaryColor,
        ),
        tabs: [
          Tab(text: context.tr("Posts")),
          Tab(text: context.tr("Media")),
          Tab(text: context.tr("Likes")),
        ],
      ),
    );
  }
}
