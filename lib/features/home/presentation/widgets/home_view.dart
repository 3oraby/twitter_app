import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/widgets/show_home_tweets_body.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/followers_suggestion_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });
  AppBar buildHomeAppBar({
    required BuildContext context,
  }) {
    UserEntity currentUser = getCurrentUserEntity();
    return buildCustomAppBar(
      context,
      title: SvgPicture.asset(AppSvgs.svgXLogoWhiteBackground36),
      leading: GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Row(
          children: [
            BuildUserCircleAvatarImage(
              profilePicUrl: currentUser.profilePicUrl,
              circleAvatarRadius: 20,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, FollowersSuggestionScreen.routeId);
          },
          icon: const Icon(
            Icons.person_add_alt_1_outlined,
            size: 34,
            color: AppColors.primaryColor,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding),
        child: Column(
          children: [
            buildHomeAppBar(
              context: context,
            ),
            TabBar(
              indicatorColor: AppColors.twitterAccentColor,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: AppTextStyles.uberMoveBold18,
              unselectedLabelStyle: AppTextStyles.uberMoveBold18.copyWith(
                color: AppColors.secondaryColor,
              ),
              tabs: const [
                Tab(text: "For you"),
                Tab(text: "Following"),
              ],
            ),
            ShowHomeTweetsBody(),
          ],
        ),
      ),
    );
  }
}
