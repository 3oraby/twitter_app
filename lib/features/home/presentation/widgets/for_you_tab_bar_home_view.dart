import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';
import 'package:twitter_app/features/home/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';

class ForYouTabBarHomeView extends StatefulWidget {
  const ForYouTabBarHomeView({super.key});

  @override
  State<ForYouTabBarHomeView> createState() => _ForYouTabBarHomeViewState();
}

class _ForYouTabBarHomeViewState extends State<ForYouTabBarHomeView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetTweetsCubit>(context).getTweets();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTweetsCubit, GetTweetsState>(
      builder: (context, state) {
        if (state is GetTweetsLoadedState) {
          return ForYouTabBarBody(
            tweets: state.tweets,
          );
        }
        return const SizedBox();
      },
    );
  }
}

class ForYouTabBarBody extends StatelessWidget {
  const ForYouTabBarBody({
    super.key,
    required this.tweets,
  });
  final List<TweetEntity> tweets;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: tweets.length,
      separatorBuilder: (context, index) => const VerticalGap(16),
      itemBuilder: (context, index) => Container(
        color: Colors.amber,
        child: Column(
          children: [Text(tweets[index].content!)],
        ),
      ),
    );
  }
}
