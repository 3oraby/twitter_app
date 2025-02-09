import 'package:flutter/material.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_likes_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_media_tab.dart';
import 'package:twitter_app/features/user/presentation/widgets/user_profile_posts_tab.dart';

class ShowUserProfileScreenTabs extends StatelessWidget {
  const ShowUserProfileScreenTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        UserProfilePostsTab(),
        UserProfileMediaTab(),
        UserProfileLikesTab(),
      ],
    );
  }
}
