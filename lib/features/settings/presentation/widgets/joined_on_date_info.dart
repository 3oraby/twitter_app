import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/format_date_from_timestamp.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';

class JoinedOnDateInfo extends StatelessWidget {
  const JoinedOnDateInfo({
    super.key,
    required this.joinedAt,
  });

  final Timestamp joinedAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today,
          color: Colors.blueGrey,
          size: 24,
        ),
        const HorizontalGap(12),
        Text(
          context.tr("Joined on: "),
          style: AppTextStyles.uberMoveBold(context, 20).copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        Expanded(
          child: Text(
            formatDateFromTimestamp(
              context: context,
              timestamp: joinedAt,
            ),
            style: AppTextStyles.uberMoveMedium(context, 18).copyWith(
              color: AppColors.primaryColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
