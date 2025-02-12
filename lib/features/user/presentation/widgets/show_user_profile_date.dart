import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/custom_user_follow_relation_ships_count.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class ShowUserProfileData extends StatelessWidget {
  const ShowUserProfileData({
    super.key,
    required this.userEntity,
  });

  final UserEntity userEntity;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            image: userEntity.coverPicUrl != null
                ? DecorationImage(
                    image: NetworkImage(userEntity.coverPicUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        Positioned(
          left: AppConstants.horizontalPadding,
          bottom: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${userEntity.firstName ?? ''} ${userEntity.lastName ?? ''}",
                style: AppTextStyles.uberMoveBlack26,
              ),
              Text(
                "@${userEntity.email}",
                style: AppTextStyles.uberMoveMedium20.copyWith(
                  color: AppColors.thirdColor,
                ),
              ),
              const VerticalGap(12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: AppColors.thirdColor,
                  ),
                  const HorizontalGap(4),
                  Text(
                    "Joined ${DateFormat('MMMM yyyy').format(userEntity.joinedAt.toDate())}",
                    style: AppTextStyles.uberMoveMedium18
                        .copyWith(color: AppColors.thirdColor),
                  ),
                ],
              ),
              const VerticalGap(12),
              CustomUserFollowRelationShipsCount(userEntity: userEntity),
              const VerticalGap(12),
            ],
          ),
        ),
        Positioned(
          left: AppConstants.horizontalPadding,
          bottom: 220,
          child: BuildUserCircleAvatarImage(
            profilePicUrl: userEntity.profilePicUrl,
            circleAvatarRadius: 40,
          ),
        ),
        Positioned(
          right: 16,
          bottom: 230,
          child: CustomContainerButton(
            internalVerticalPadding: 4,
            backgroundColor: Colors.white,
            borderColor: AppColors.borderColor,
            borderWidth: 1,
            child: Text(
              "Edit profile",
              style: AppTextStyles.uberMoveExtraBold16,
            ),
          ),
        ),
      ],
    );
  }
}
