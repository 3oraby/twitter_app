
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onTabChange,
  });

  final ValueChanged onTabChange;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: 8,
        ),
        child: FittedBox(
          child: GNav(
              gap: 4,
              backgroundColor: Colors.transparent,
              color: AppColors.primaryColor,
              activeColor: AppColors.primaryColor,
              tabBackgroundColor: AppColors.lightBackgroundColor,
              padding: const EdgeInsets.all(16),
              onTabChange: onTabChange,
              tabs: AppConstants.bottomNavigationBarItems(context: context).map(
                (item) {
                  return GButton(
                    icon: item.itemIcon,
                    text: item.name,
                  );
                },
              ).toList()),
        ),
      ),
    );
  }
}