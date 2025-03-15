import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/settings/domain/entities/setting_item_entity.dart';
import 'package:twitter_app/features/settings/presentation/screens/display_and_languages_screen.dart';
import 'package:twitter_app/features/settings/presentation/screens/your_account_screen.dart';
import 'package:twitter_app/features/settings/presentation/widgets/custom_setting_item.dart';

class SettingView extends StatelessWidget {
  const SettingView({
    super.key,
  });

  AppBar buildSettingsAppBar({
    required BuildContext context,
  }) {
    return buildCustomAppBar(
      context,
      title: Column(
        children: [
          Text(
            context.tr(
              "Settings",
            ),
            style: AppTextStyles.uberMoveBlack(context,20),
          ),
          Text(
            "@${getCurrentUserEntity().email}",
            style: AppTextStyles.uberMoveMedium(context,16)
                .copyWith(color: AppColors.thirdColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildSettingsAppBar(context: context),
          const VerticalGap(24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
              ),
              child: ListView.separated(
                itemCount: AppConstants.settingItems.length,
                separatorBuilder: (context, index) => const VerticalGap(24),
                itemBuilder: (context, index) {
                  SettingItemEntity settingItemEntity =
                      AppConstants.settingItems[index];
                  return CustomSettingItem(
                    leadingIconData: settingItemEntity.leadingIconData,
                    titleText: settingItemEntity.titleText,
                    subTitleText: settingItemEntity.subTitleText,
                    onPressed: () {
                      if (index == 0) {
                        Navigator.pushNamed(context, YourAccountScreen.routeId);
                      } else {
                        Navigator.pushNamed(
                            context, DisplayAndLanguagesScreen.routeId);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
