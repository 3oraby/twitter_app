import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/get_tweets_cubit/get_tweets_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/show_tweet_feed_body.dart';

class ShowTweetFeedBlocBuilderBody extends StatefulWidget {
  const ShowTweetFeedBlocBuilderBody({
    super.key,
    this.tweetFilterOption = const GetTweetsFilterOptionModel(),
    this.targetUserId,
    this.query,
    required this.mainLabelEmptyBody,
    required this.subLabelEmptyBody,
  });

  final GetTweetsFilterOptionModel tweetFilterOption;
  final String? targetUserId;
  final String? query;
  final String mainLabelEmptyBody;
  final String subLabelEmptyBody;
  @override
  State<ShowTweetFeedBlocBuilderBody> createState() =>
      _ShowTweetFeedBlocBuilderBodyState();
}

class _ShowTweetFeedBlocBuilderBodyState
    extends State<ShowTweetFeedBlocBuilderBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetTweetsCubit>(context).getTweets(
      tweetFilterOption: widget.tweetFilterOption,
      targetUserId: widget.targetUserId,
      query: widget.query,
    );
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
          return ShowTweetFeedBody(
            tweets: state.tweets,
            mainLabelEmptyBody: widget.mainLabelEmptyBody,
            subLabelEmptyBody: widget.subLabelEmptyBody,
          );
        }
        return const SizedBox();
      },
    );
  }
}
