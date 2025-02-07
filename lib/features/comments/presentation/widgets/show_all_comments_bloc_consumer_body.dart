import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/custom_failure_body_widget.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/cubits/get_tweet_comments_cubit/get_tweet_comments_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_all_comments_body.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';

class ShowAllCommentsBlocConsumerBody extends StatefulWidget {
  const ShowAllCommentsBlocConsumerBody({
    super.key,
    required this.tweetId,
    required this.onReplyButtonPressed,
    required this.selectedCommentedFilter,
    required this.scrollController,
  });

  final String tweetId;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;
  final ValueNotifier<String> selectedCommentedFilter;
  final ScrollController scrollController;

  @override
  State<ShowAllCommentsBlocConsumerBody> createState() =>
      _ShowAllCommentsBlocConsumerBodyState();
}

class _ShowAllCommentsBlocConsumerBodyState
    extends State<ShowAllCommentsBlocConsumerBody> {
  late List<CommentDetailsEntity> comments;
  bool isLastPage = false;
  int pageLimit = 10;
  @override
  void initState() {
    super.initState();
    comments = [];
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchComments();
    });
    widget.selectedCommentedFilter.addListener(_fetchComments);
    widget.scrollController.addListener(_onScroll);
  }

  _onScroll() {
    if (widget.scrollController.position.pixels ==
        widget.scrollController.position.maxScrollExtent) {
      if (!isLastPage) {
        _fetchComments();
      }
    }
  }

  @override
  void dispose() {
    widget.selectedCommentedFilter.removeListener(_fetchComments);
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _fetchComments() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<GetTweetCommentsCubit>(context).getTweetComments(
        tweetId: widget.tweetId,
        filter: widget.selectedCommentedFilter.value,
        limit: pageLimit,
        startAfter: comments.isNotEmpty
            ? [
                comments.last.comment.repliesCount,
                comments.last.comment.likes,
              ]
            : null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetTweetCommentsCubit, GetTweetCommentsState>(
      listener: (context, state) {
        if (state is GetTweetCommentsLoadedState) {
          comments.addAll(state.comments);
          if (state.comments.length < pageLimit) {
            isLastPage = true;
          }
        }
      },
      builder: (context, state) {
        if (state is GetTweetCommentsEmptyState) {
          return CustomEmptyBodyWidget(
            mainLabel: "No comments yet! 💬",
            subLabel: "Be the first to share your thoughts 💡",
            showImage: false,
          );
        } else if (state is GetTweetCommentsFailureState) {
          return CustomFailureBodyWidget(message: state.message);
        }
        return Column(
          children: [
            ShowAllCommentsBody(
              comments: comments,
              onReplyButtonPressed: widget.onReplyButtonPressed,
            ),
            if (state is GetTweetCommentsLoadingState)
              Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
          ],
        );
      },
    );
  }
}
