import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/keep_alive_tab.dart';
import 'package:twitter_app/features/home/presentation/widgets/following_tab_bar_home_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/for_you_tab_bar_home_view.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/delete_tweet_cubit/delete_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';

class ShowHomeTweetsBody extends StatelessWidget {
  const ShowHomeTweetsBody({
    super.key,
  });

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
      child: const Expanded(
        child: TabBarView(
          children: [
            KeepAliveTab(child: ForYouTabBarHomeView()),
            KeepAliveTab(child: FollowingTabBarHomeView()),
          ],
        ),
      ),
    );
  }
}
