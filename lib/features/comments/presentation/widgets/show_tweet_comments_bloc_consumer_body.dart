import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/custom_failure_body_widget.dart';
import 'package:twitter_app/features/comments/presentation/cubits/get_tweet_comments_cubit/get_tweet_comments_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_tweet_comments_body.dart';

class ShowTweetCommentsBlocConsumerBody extends StatefulWidget {
  const ShowTweetCommentsBlocConsumerBody({
    super.key,
    required this.tweetId,
  });

  final String tweetId;
  @override
  State<ShowTweetCommentsBlocConsumerBody> createState() =>
      _ShowTweetCommentsBlocConsumerBodyState();
}

class _ShowTweetCommentsBlocConsumerBodyState
    extends State<ShowTweetCommentsBlocConsumerBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetTweetCommentsCubit>(context)
        .getTweetComments(tweetId: widget.tweetId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetTweetCommentsCubit, GetTweetCommentsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is GetTweetCommentsEmptyState) {
          return CustomEmptyBodyWidget(
            mainLabel: "There is no comments on this tweet",
            subLabel: "be the first one to comment",
          );
        } else if (state is GetTweetCommentsFailureState) {
          return CustomFailureBodyWidget(message: state.message);
        } else if (state is GetTweetCommentsLoadingState) {
          return CircularProgressIndicator(
            color: AppColors.primaryColor,
          );
        } else if (state is GetTweetCommentsLoadedState) {
          return ShowTweetCommentsBody(
            comments: state.comments,
          );
        }
        return SizedBox();
      },
    );
  }
}
