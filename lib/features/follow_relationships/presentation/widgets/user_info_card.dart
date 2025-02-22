import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_toggle_follow_button.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
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
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: BuildUserCircleAvatarImage(
              profilePicUrl: user.profilePicUrl,
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: context.locale == const Locale("en")
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Text(
                "${user.firstName} ${user.lastName}",
                style: AppTextStyles.uberMoveExtraBold18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  style: AppTextStyles.uberMoveBold16.copyWith(
                    color: AppColors.secondaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const VerticalGap(4),
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
                      style: AppTextStyles.uberMoveBold14.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            trailing: Visibility(
              visible: user.userId != currentUserId,
              child: CustomToggleFollowButton(
                followedId: user.userId,
                followingId: currentUserId,
                isActive: isActiveFollowButton,
                useFollowBack: showFollowsYouLabel,
              ),
            ),
          ),
          if (user.bio != null)
            Row(
              children: [
                Text(
                  user.bio!,
                  style: AppTextStyles.uberMoveMedium18,
                ),
              ],
            )
        ],
      ),
    );
  }
}
