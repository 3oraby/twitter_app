import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/widgets/custom_drawer_list_tile_option.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({
    super.key,
  });

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  late bool switchValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.locale.languageCode == 'ar') {
      switchValue = true;
    } else {
      switchValue = false;
    }
  }

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
              const VerticalGap(24),
              Switch(
                value: switchValue,
                onChanged: (value) async {
                  if (value) {
                    await context.setLocale(const Locale('ar'));
                  } else {
                    await context.setLocale(const Locale('en'));
                  }
                  setState(() {
                    switchValue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
