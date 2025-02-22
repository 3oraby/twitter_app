import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';

class ChangeAppLanguageScreen extends StatefulWidget {
  const ChangeAppLanguageScreen({super.key});

  static const String routeId = 'kChangeAppLanguageScreen';

  @override
  State<ChangeAppLanguageScreen> createState() =>
      _ChangeAppLanguageScreenState();
}

class _ChangeAppLanguageScreenState extends State<ChangeAppLanguageScreen> {
  Future<void> _changeLanguage(Locale locale) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(
              color: AppColors.twitterAccentColor,
            ),
            const SizedBox(width: 20),
            Text(context.tr("Changing language...")),
          ],
        ),
      ),
    );

    await context.setLocale(locale);
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.pop(context);
    }

    showSuccessChangeLanguageSnackBar();
  }

  void showSuccessChangeLanguageSnackBar() {
    showCustomSnackBar(context, context.tr("Language changed successfully!"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: Text(
          context.tr("Choose Your Language"),
          style: AppTextStyles.uberMoveBlack20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: AppConstants.topPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr(
                  "Select the language you’d like to use in the app. You can change this anytime in settings."),
              style: AppTextStyles.uberMoveMedium16,
            ),
            const VerticalGap(20),
            ListTile(
              title: Text(
                context.tr("English"),
                style: AppTextStyles.uberMoveBold18,
              ),
              trailing: context.locale.languageCode == 'en'
                  ? const Icon(
                      Icons.check,
                      color: AppColors.twitterAccentColor,
                      size: 32,
                    )
                  : null,
              onTap: () => _changeLanguage(const Locale('en')),
            ),
            ListTile(
              title: Text(
                context.tr("Arabic"),
                style: AppTextStyles.uberMoveBold18,
              ),
              trailing: context.locale.languageCode == 'ar'
                  ? const Icon(
                      Icons.check,
                      color: AppColors.twitterAccentColor,
                      size: 32,
                    )
                  : null,
              onTap: () => _changeLanguage(const Locale('ar')),
            ),
          ],
        ),
      ),
    );
  }
}
