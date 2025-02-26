import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/settings/domain/entities/setting_item_entity.dart';
import 'package:twitter_app/features/settings/presentation/screens/change_your_password_screen.dart';
import 'package:twitter_app/features/settings/presentation/screens/user_account_information_screen.dart';
import 'package:twitter_app/features/settings/presentation/widgets/custom_setting_item.dart';

class YourAccountScreen extends StatelessWidget {
  const YourAccountScreen({super.key});

  static const String routeId = 'kYourAccountScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: Column(
          children: [
            Text(
              context.tr("Your Account"),
              style: AppTextStyles.uberMoveBlack20,
            ),
            Text(
              "@${getCurrentUserEntity().email}",
              style: AppTextStyles.uberMoveMedium16
                  .copyWith(color: AppColors.thirdColor),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppConstants.topPadding,
            horizontal: AppConstants.horizontalPadding),
        child: Column(
          children: [
            Text(
              context.tr(
                  "See information about your account and learn about your account deactivation options"),
              style: AppTextStyles.uberMoveMedium18.copyWith(
                color: AppColors.thirdColor,
              ),
            ),
            const VerticalGap(36),
            for (SettingItemEntity settingItemEntity
                in AppConstants.yourAccountSettingItems)
              Column(
                children: [
                  CustomSettingItem(
                    leadingIconData: settingItemEntity.leadingIconData,
                    titleText: settingItemEntity.titleText,
                    subTitleText: settingItemEntity.subTitleText,
                    onPressed: () {
                      switch (settingItemEntity.titleText) {
                        case "Account information":
                          Navigator.pushNamed(
                              context, UserAccountInformationScreen.routeId);

                          break;
                        case "Change your password":
                          Navigator.pushNamed(
                              context, ChangeYourPasswordScreen.routeId);
                          break;
                        case "Deactiviate your account":
                          break;
                        default:
                      }
                    },
                  ),
                  const VerticalGap(24),
                ],
              )
          ],
        ),
      ),
    );
  }
}
