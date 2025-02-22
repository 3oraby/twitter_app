import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_user_follow_relation_ships_count.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class DrawerUserInfo extends StatefulWidget {
  const DrawerUserInfo({super.key});

  @override
  State<DrawerUserInfo> createState() => _DrawerUserInfoState();
}

class _DrawerUserInfoState extends State<DrawerUserInfo> {
  late UserEntity userEntity;

  @override
  void initState() {
    super.initState();
    userEntity = getCurrentUserEntity();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              UserProfileScreen.routeId,
              arguments: userEntity,
            );
          },
          child: Row(
            children: [
              BuildUserCircleAvatarImage(
                profilePicUrl: userEntity.profilePicUrl,
              ),
              const HorizontalGap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userEntity.firstName} ${userEntity.lastName}",
                      style: AppTextStyles.uberMoveBold22,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const VerticalGap(4),
                    Text(
                      userEntity.email,
                      style: AppTextStyles.uberMoveMedium16.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const VerticalGap(16),
        CustomUserFollowRelationShipsCount(userEntity: userEntity),
      ],
    );
  }
}
