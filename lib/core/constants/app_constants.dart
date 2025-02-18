import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/features/home/domain/entities/bottom_navigation_bar_item_entity.dart';
import 'package:twitter_app/features/settings/domain/entities/setting_item_entity.dart';

class AppConstants {
  static const double borderRadius = 12;
  static const double bottomSheetBorderRadius = 28;
  static const double menusBorderRadius = 24;
  static const double horizontalPadding = 12;
  static const double horizontalDrawerPadding = 24;
  static const double topPadding = 16;
  static const double bottomPadding = 36;
  static const double contentTextFieldPadding = 22;
  static const AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  static List<BottomNavigationBarItemEntity> bottomNavigationBarItems(
          {required BuildContext context}) =>
      [
        BottomNavigationBarItemEntity(
          itemIcon: Icons.home,
          name: context.tr("Home"),
        ),
        BottomNavigationBarItemEntity(
          itemIcon: Icons.search,
          name: context.tr("Search"),
        ),
        BottomNavigationBarItemEntity(
          itemIcon: Icons.notifications_active_outlined,
          name: context.tr("Notifications"),
        ),
        BottomNavigationBarItemEntity(
          itemIcon: Icons.settings,
          name: context.tr("Settings"),
        ),
      ];

  static const List<String> commentFilters = [
    "Most relevant replies",
    "Most liked replies",
    "Most recent replies",
  ];

  static List<SettingItemEntity> settingItems = [
    SettingItemEntity(
      leadingIconData: Icons.person_2_outlined,
      titleText: "Your account",
      subTitleText:
          "See information about your account , download an achieve of your data , or learn about your account deactivation options",
    ),
    SettingItemEntity(
      leadingIconData: Icons.display_settings,
      titleText: "display and languages",
      subTitleText: "Manage how X content it displayed to you",
    ),
  ];
  static List<SettingItemEntity> yourAccountSettingItems = [
    SettingItemEntity(
      leadingIconData: Icons.person_2_outlined,
      titleText: "Account information",
      subTitleText:
          "See your account information like your phone number and email address",
    ),
    SettingItemEntity(
      leadingIconData: Icons.vpn_key,
      titleText: "Change your password",
      subTitleText: "Change your password at any time",
    ),
    SettingItemEntity(
      leadingIconData: Icons.power_settings_new,
      titleText: "Deactiviate your account",
      subTitleText: "Find out how you can deactiviate your account",
    ),
  ];
}

enum Gender { male, female, other }

enum CommentFiltersEnum { relevant, likes, recent }
