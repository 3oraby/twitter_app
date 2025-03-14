import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class CustomUserInformationItem extends StatelessWidget {
  const CustomUserInformationItem({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.tr(title),
            style: AppTextStyles.uberMoveExtraBold(context, 20).copyWith(
              color: onTap == null
                  ? Colors.grey[600]
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const HorizontalGap(8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: AppTextStyles.uberMoveMedium(context, 18).copyWith(
                      color: onTap == null
                          ? Colors.grey[500]
                          : AppColors.thirdColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onTap != null) ...[
                  const HorizontalGap(12),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
