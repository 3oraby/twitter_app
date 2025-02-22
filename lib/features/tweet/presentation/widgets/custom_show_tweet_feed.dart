import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/delete_tweet_cubit/delete_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/show_tweet_feed_bloc_builder_body.dart';

class CustomShowTweetFeed extends StatelessWidget {
  const CustomShowTweetFeed({
    super.key,
    this.tweetFilterOption = const GetTweetsFilterOptionModel(),
    this.targetUserId,
  });
  final GetTweetsFilterOptionModel tweetFilterOption;
  final String? targetUserId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetTweetsCubit(
            tweetRepo: getIt<TweetRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => DeleteTweetCubit(
            tweetRepo: getIt<TweetRepo>(),
          ),
        ),
      ],
      child: ShowTweetFeedBlocBuilderBody(
        tweetFilterOption: tweetFilterOption,
        targetUserId: targetUserId,
      ),
    );
  }
}
