import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_drawer_list_tile_option.dart';
import 'package:twitter_app/core/widgets/custom_logout_button.dart';
import 'package:twitter_app/core/widgets/drawer_user_info.dart';
import 'package:twitter_app/core/widgets/language_selection_switch.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';

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
                onTap: () {},
              ),
              const VerticalGap(8),
              CustomDrawerListTileOption(
                title: context.tr("Bookmarks"),
                iconData: Icons.bookmark_border,
                onTap: () {},
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
                mainAxisAlignment: MainAxisAlignment.start,
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
              const LanguageSelectionSwitch(),
              const VerticalGap(24),
            ],
          ),
        ),
      ),
    );
  }
}
