import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/features/home/domain/entities/bottom_navigation_bar_item_entity.dart';

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
}

enum Gender { male, female, other }

enum CommentFiltersEnum { relevant, likes, recent }
