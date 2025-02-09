import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_user_follow_relation_ships_count.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/widgets/show_user_profile_screen_tabs.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.userEntity});

  static const String routeId = 'kUserProfileScreen';
  final UserEntity userEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    image: userEntity.coverPicUrl != null
                        ? DecorationImage(
                            image: NetworkImage(userEntity.coverPicUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: AppColors.twitterAccentColor,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: -30,
                  child: BuildUserCircleAvatarImage(
                    profilePicUrl: userEntity.profilePicUrl,
                    circleAvatarRadius: 40,
                  ),
                ),
              ],
            ),
            const VerticalGap(36),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
              ),
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
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: AppColors.twitterAccentColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelStyle: AppTextStyles.uberMoveBold18,
                          unselectedLabelStyle:
                              AppTextStyles.uberMoveBold18.copyWith(
                            color: AppColors.secondaryColor,
                          ),
                          tabs: const [
                            Tab(text: "Posts"),
                            Tab(text: "Media"),
                            Tab(text: "Likes"),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: ShowUserProfileScreenTabs(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
