import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/widgets/for_you_tab_bar_body.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/make_new_tweet_cubits/make_new_tweet_cubit.dart';

class ForYouTabBarHomeView extends StatefulWidget {
  const ForYouTabBarHomeView({super.key});

  @override
  State<ForYouTabBarHomeView> createState() => _ForYouTabBarHomeViewState();
}

class _ForYouTabBarHomeViewState extends State<ForYouTabBarHomeView> {
  late UserEntity currentUser;
  List<TweetDetailsEntity> tweets = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetTweetsCubit>(context).getTweets();
    currentUser = getCurrentUserEntity();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MakeNewTweetCubit, MakeNewTweetState>(
          listener: (context, makeNewTweetState) {
            if (makeNewTweetState is MakeNewTweetLoadedState) {
              log("make new tweet");
              setState(() {
                tweets = [makeNewTweetState.tweetDetailsEntity, ...tweets];
              });
            }
          },
        ),
      ],
      child: BlocConsumer<GetTweetsCubit, GetTweetsState>(
        listener: (context, state) {
          if (state is GetTweetsLoadedState) {
            setState(() {
              tweets.addAll(state.tweets);
            });
          }
        },
        builder: (context, state) {
          if (state is GetTweetsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          } else if (state is GetTweetsFailureState) {
            return Center(
              child: Text(state.message),
            );
          }
          return ForYouTabBarBody(
            tweets: tweets,
            currentUser: currentUser,
          );
        },
      ),
    );
  }
}
