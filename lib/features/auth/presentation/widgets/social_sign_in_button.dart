
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_trigger_button.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.description,
    required this.logoName,
    required this.onPressed,
  });
  final String logoName;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomTriggerButton(
      backgroundColor: AppColors.lightBackgroundColor,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(logoName),
          const HorizontalGap(16),
          Text(
            description,
            style: AppTextStyles.uberMoveBold18,
          ),
        ],
      ),
    );
  }
}