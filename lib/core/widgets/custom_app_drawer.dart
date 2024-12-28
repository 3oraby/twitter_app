import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/cubits/logout_cubits/logout_cubit.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/custom_drawer_list_tile_option.dart';
import 'package:twitter_app/core/widgets/custom_logout_button.dart';
import 'package:twitter_app/core/widgets/language_selection_switch.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: const DrawerBlocConsumerBody(),
    );
  }
}

class DrawerBlocConsumerBody extends StatelessWidget {
  const DrawerBlocConsumerBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Column(
            children: [
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
              const VerticalGap(24),
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
