import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
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
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.horizontalPadding,
                              vertical: AppConstants.topPadding,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                  AppConstants.bottomSheetBorderRadius,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 4,
                                  width: 60,
                                  color: AppColors.dividerColor,
                                ),
                                const VerticalGap(10),
                                Text(
                                  context.tr("Dark Mode"),
                                  style:
                                      AppTextStyles.uberMoveBlack(context, 22),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.tr("Dark Mode"),
                                      style: AppTextStyles.uberMoveBlack(
                                          context, 20),
                                    ),
                                    Switch(
                                      value: Theme.of(context).brightness ==
                                          Brightness.dark,
                                      onChanged: (value) {
                                        context
                                            .read<ThemeCubit>()
                                            .toggleTheme(value);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
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
