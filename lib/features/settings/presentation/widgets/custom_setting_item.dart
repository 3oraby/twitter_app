import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';

class CustomSettingItem extends StatelessWidget {
  const CustomSettingItem({
    super.key,
    required this.leadingIconData,
    required this.titleText,
    required this.subTitleText,
    required this.onPressed,
  });

  final IconData leadingIconData;
  final String titleText;
  final String subTitleText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.all(0),
      leading: Icon(
        leadingIconData,
      ),
      title: Text(
        context.tr(titleText),
        style: AppTextStyles.uberMoveBlack(context,20),
      ),
      subtitle: Text(
        context.tr(subTitleText),
        style: AppTextStyles.uberMoveRegular(context,16)
            .copyWith(color: AppColors.thirdColor),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.thirdColor,
      ),
    );
  }
}
