import 'package:flutter/material.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class ForYouTabBarHomeView extends StatelessWidget {
  const ForYouTabBarHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomShowTweetFeed(
      mainLabelEmptyBody: "Nothing to see here yet",
      subLabelEmptyBody: "Start following users to get personalized tweets",
    );
  }
}
