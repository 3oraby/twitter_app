import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/widgets/keep_alive_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_likes_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_media_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_posts_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_retweets_tab.dart';

class ShowUserProfileScreenTabs extends StatelessWidget {
  const ShowUserProfileScreenTabs({
    super.key,
    this.targetUserId,
  });

  final String? targetUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalPadding,
        vertical: AppConstants.topPadding,
      ),
      child: TabBarView(
        children: [
          KeepAliveTab(
              child: UserProfilePostsTab(
            targetUserId: targetUserId,
          )),
          KeepAliveTab(
              child: UserProfileMediaTab(
            targetUserId: targetUserId,
          )),
          KeepAliveTab(
              child: UserProfileLikesTab(
            targetUserId: targetUserId,
          )),
          KeepAliveTab(
              child: UserProfileRetweetsTab(
            targetUserId: targetUserId,
          )),
        ],
      ),
    );
  }
}
