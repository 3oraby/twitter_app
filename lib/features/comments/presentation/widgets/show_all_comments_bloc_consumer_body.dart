import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/custom_failure_body_widget.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/cubits/get_tweet_comments_cubit/get_tweet_comments_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_all_comments_body.dart';

class ShowAllCommentsBlocConsumerBody extends StatefulWidget {
  const ShowAllCommentsBlocConsumerBody({
    super.key,
    required this.tweetId,
    required this.onReplyButtonPressed,
  });

  final String tweetId;
  final ValueChanged<CommentDetailsEntity> onReplyButtonPressed;

  @override
  State<ShowAllCommentsBlocConsumerBody> createState() =>
      _ShowAllCommentsBlocConsumerBodyState();
}

class _ShowAllCommentsBlocConsumerBodyState
    extends State<ShowAllCommentsBlocConsumerBody> {
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
            mainLabel: "No comments yet! 💬",
            subLabel: "Be the first to share your thoughts 💡",
            showImage: false,
          );
        } else if (state is GetTweetCommentsFailureState) {
          return CustomFailureBodyWidget(message: state.message);
        } else if (state is GetTweetCommentsLoadingState) {
          return CircularProgressIndicator(
            color: AppColors.primaryColor,
          );
        } else if (state is GetTweetCommentsLoadedState) {
          return ShowAllCommentsBody(
            comments: state.comments,
            onReplyButtonPressed: widget.onReplyButtonPressed,
          );
        }
        return SizedBox();
      },
    );
  }
}
