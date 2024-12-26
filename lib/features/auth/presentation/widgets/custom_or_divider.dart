
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
class CustomOrDivider extends StatelessWidget {
  const CustomOrDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Colors.grey,
          ),
        ),
        const HorizontalGap(16),
        Text(
          context.tr("or"),
          style: AppTextStyles.uberMoveRegular20.copyWith(
            color: AppColors.secondaryColor,
          ),
        ),
        const HorizontalGap(16),
        const Expanded(
          child: Divider(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
