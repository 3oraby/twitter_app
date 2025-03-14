import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_drawer_list_tile_option.dart';
import 'package:twitter_app/core/widgets/custom_logout_button.dart';
import 'package:twitter_app/core/widgets/drawer_user_info.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/bookmark/presentation/screens/user_bookmarks_screen.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class AppDrawerBody extends StatelessWidget {
  const AppDrawerBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.verticalDrawerPadding,
            horizontal: AppConstants.horizontalDrawerPadding,
          ),
          child: Column(
            children: [
              const DrawerUserInfo(),
              const Divider(
                color: AppColors.dividerColor,
                height: 36,
              ),
              CustomDrawerListTileOption(
                title: context.tr("Profile"),
                iconData: Icons.person_2_outlined,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    UserProfileScreen.routeId,
                    arguments: getCurrentUserEntity(),
                  );
                },
              ),
              const VerticalGap(8),
              CustomDrawerListTileOption(
                title: context.tr("Bookmarks"),
                iconData: Icons.bookmark_border,
                onTap: () {
                  Navigator.pushNamed(context, UserBookmarksScreen.routeId);
                },
              ),
              const VerticalGap(8),
              CustomDrawerListTileOption(
                title: context.tr("Settings"),
                iconData: Icons.settings,
                onTap: () {},
              ),
              const Divider(
                color: AppColors.dividerColor,
                height: 36,
              ),
              const CustomLogOutButton(),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: const Icon(
                      Icons.wb_sunny,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
