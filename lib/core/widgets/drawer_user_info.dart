import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_images.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

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
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: userEntity.profilePicUrl != null
                  ? NetworkImage(
                      userEntity.profilePicUrl!,
                    )
                  : const AssetImage(
                      AppImages.imagesDefaultProfilePicture,
                    ),
              onBackgroundImageError: (error, stackTrace) {
                const AssetImage(AppImages.imagesDefaultProfilePicture);
              },
            ),
            const HorizontalGap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userEntity.firstName} ${userEntity.lastName}",
                    style: AppTextStyles.uberMoveBold22,
                    overflow: TextOverflow.visible,
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
        const VerticalGap(16),
        Row(
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
                    color: AppColors.secondaryColor,
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
                    color: AppColors.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
