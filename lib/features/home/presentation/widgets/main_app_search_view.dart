import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/leading_app_bar_user_image.dart';
import 'package:twitter_app/features/search/presentation/screens/search_screen.dart';

class MainAppSearchView extends StatelessWidget {
  const MainAppSearchView({
    super.key,
  });
  AppBar buildSearchAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      leading: const LeadingAppBarUserImage(),
      title: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, SearchScreen.routeId);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.textFieldBackgroundColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 3,
            children: [
              const Icon(
                Icons.search,
                color: AppColors.thirdColor,
              ),
              Text(
                "Search",
                style: AppTextStyles.uberMoveMedium20.copyWith(
                  color: AppColors.thirdColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      child: Column(
        children: [
          buildSearchAppBar(context: context),
        ],
      ),
    );
  }
}
