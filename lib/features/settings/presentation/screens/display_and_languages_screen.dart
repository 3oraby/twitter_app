import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/settings/presentation/screens/change_app_language_screen.dart';
import 'package:twitter_app/features/settings/presentation/widgets/custom_setting_item.dart';

class DisplayAndLanguagesScreen extends StatelessWidget {
  const DisplayAndLanguagesScreen({super.key});

  static const String routeId = 'kDisplayAndLanguagesScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: Text(
          context.tr("Display and Languages"),
          style: AppTextStyles.uberMoveBlack20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.topPadding,
        ),
        child: Column(
          children: [
            CustomSettingItem(
              leadingIconData: Icons.language,
              titleText: context.tr("Language"),
              subTitleText: context.tr(
                  "You can select the language you want to use in the app for a more comfortable and seamless experience."),
              onPressed: () {
                Navigator.pushNamed(context, ChangeAppLanguageScreen.routeId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
