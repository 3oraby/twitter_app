import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_show_tweet_feed.dart';

class UserBookmarksScreen extends StatelessWidget {
  const UserBookmarksScreen({super.key});

  static const String routeId = 'kUserBookmarksScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: Text(
          context.tr("Bookmarks"),
          style: AppTextStyles.uberMoveBlack(context,20),
        ),
      ),
      body: const CustomShowTweetFeed(
        tweetFilterOption: GetTweetsFilterOptionModel(
          includeBookmarkedTweets: true,
        ),
        mainLabelEmptyBody: "No bookmarks yet 📌",
        subLabelEmptyBody: "Save tweets to revisit them later 🔖",
      ),
    );
  }
}
