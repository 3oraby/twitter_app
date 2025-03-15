import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_toggle_follow_button.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.user,
    required this.currentUserId,
    this.isActiveFollowButton = false,
    this.showFollowsYouLabel = false,
  });

  final UserEntity user;
  final String currentUserId;
  final bool isActiveFollowButton;
  final bool showFollowsYouLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          UserProfileScreen.routeId,
          arguments: user,
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        isThreeLine: true,
        leading: BuildUserCircleAvatarImage(
          profilePicUrl: user.profilePicUrl,
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: AppTextStyles.uberMoveExtraBold(context,18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.email,
                    style: AppTextStyles.uberMoveBold(context,18).copyWith(
                      color: AppColors.secondaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: user.userId != currentUserId,
              child: CustomToggleFollowButton(
                followedId: user.userId,
                followingId: currentUserId,
                isActive: isActiveFollowButton,
                useFollowBack: showFollowsYouLabel,
              ),
            ),
          ],
        ),
        subtitle: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: showFollowsYouLabel,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.highlightBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  context.tr("Follows you"),
                  style: AppTextStyles.uberMoveBold(context,14).copyWith(
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ),
            if (user.bio != null)
              Text(
                user.bio!,
                style: AppTextStyles.uberMoveMedium(context,16),
              ),
          ],
        ),
      ),
    );
  }
}
