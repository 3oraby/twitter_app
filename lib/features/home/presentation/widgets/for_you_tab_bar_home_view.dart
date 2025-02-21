import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/home/presentation/widgets/for_you_tab_bar_body.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';

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
        } else if (state is GetTweetsLoadedState) {
          return ForYouTabBarBody(
            tweets: state.tweets,
          );
        }
        return const SizedBox();
      },
    );
  }
}
