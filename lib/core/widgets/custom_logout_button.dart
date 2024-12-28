import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/show_logout_confirmation_dialog.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomLogOutButton extends StatelessWidget {
  const CustomLogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showLogoutConfirmationDialog(context: context);
      },
      child: Text(
        "Log Out",
        style: AppTextStyles.uberMoveBold20.copyWith(
          color: AppColors.errorColor,
        ),
      ),
    );
  }
}
