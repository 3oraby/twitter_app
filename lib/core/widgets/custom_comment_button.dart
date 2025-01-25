import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class CustomCommentButton extends StatelessWidget {
  const CustomCommentButton({
    super.key,
    required this.commentsCount,
  });

  final int commentsCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.comment,
            color: AppColors.thirdColor,
          ),
          const HorizontalGap(6),
          Text(
            commentsCount.toString(),
            style: AppTextStyles.uberMoveMedium18.copyWith(
              color: AppColors.thirdColor,
            ),
          ),
        ],
      ),
    );
  }
}
