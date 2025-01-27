import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/home/presentation/widgets/make_new_tweet_bloc_consumer_body.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/make_new_tweet_cubits/make_new_tweet_cubit.dart';

class MakeNewTweetScreen extends StatelessWidget {
  const MakeNewTweetScreen({super.key});

  static const String routeId = "kMakeNewTweetScreen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MakeNewTweetCubit(
        tweetRepo: getIt<TweetRepo>(),
      ),
      child: MakeNewTweetBlocConsumerBody(),
    );
  }
}
