import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/user_connections_screen.dart';

class CustomUserFollowRelationShipsCount extends StatelessWidget {
  const CustomUserFollowRelationShipsCount({
    super.key,
    required this.userEntity,
  });

  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, UserConnectionsScreen.routeId);
      },
      child: Row(
        children: [
          Row(
            children: [
              Text(
                userEntity.nFollowing.toString(),
                style: AppTextStyles.uberMoveBold16,
              ),
              Text(
                context.tr(" Following"),
                style: AppTextStyles.uberMoveMedium16.copyWith(
                  color: AppColors.thirdColor,
                ),
              ),
            ],
          ),
          const HorizontalGap(16),
          Row(
            children: [
              Text(
                userEntity.nFollowers.toString(),
                style: AppTextStyles.uberMoveBold16,
              ),
              Text(
                context.tr(" Followers"),
                style: AppTextStyles.uberMoveMedium16.copyWith(
                  color: AppColors.thirdColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
