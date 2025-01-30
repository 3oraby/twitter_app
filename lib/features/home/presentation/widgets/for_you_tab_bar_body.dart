import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_tweet_info_card.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/comments/presentation/screens/show_tweet_comments_screen.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ForYouTabBarBody extends StatefulWidget {
  const ForYouTabBarBody({
    super.key,
    required this.tweets,
  });
  final List<TweetDetailsEntity> tweets;

  @override
  State<ForYouTabBarBody> createState() => _ForYouTabBarBodyState();
}

class _ForYouTabBarBodyState extends State<ForYouTabBarBody> {
  _refreshPage() {
    BlocProvider.of<GetTweetsCubit>(context).getTweets();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const VerticalGap(24),
          for (int index = 0; index < widget.tweets.length; index++) ...[
            CustomTweetInfoCard(
              tweetDetailsEntity: widget.tweets[index],
              onTweetTap: () {
                Navigator.pushNamed(
                  context,
                  ShowTweetCommentsScreen.routeId,
                  arguments: widget.tweets[index],
                ).then(
                  (value) {
                    _refreshPage();
                  },
                );
              },
            ),
            if (index != widget.tweets.length - 1)
              const Divider(
                color: AppColors.dividerColor,
                height: 24,
              ),
          ],
        ],
      ),
    );
  }
}
