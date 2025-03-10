import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_empty_body_widget.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/cubits/delete_comment_cubit/delete_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/cubits/update_comment_cubit/update_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/screens/update_comments_and_replies_screen.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_comment_info_card.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ShowAllCommentsBody extends StatefulWidget {
  const ShowAllCommentsBody({
    super.key,
    required this.tweetDetailsEntity,
    required this.currentUser,
    required this.comments,
    required this.onReplyButtonPressed,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final UserEntity currentUser;
  final List<CommentDetailsEntity> comments;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;

  @override
  State<ShowAllCommentsBody> createState() => _ShowAllCommentsBodyState();
}

class _ShowAllCommentsBodyState extends State<ShowAllCommentsBody> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<CommentDetailsEntity> comments;
  CommentDetailsEntity? removedComment;
  int? updatedCommentIndex;
  int? removedCommentIndex;

  @override
  void initState() {
    super.initState();
    comments = List.from(widget.comments);
  }

  void _removeComment(int index) {
    log("delete the comment at index $index");
    removedCommentIndex = index;
    removedComment = comments[index];
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: CustomCommentInfoCard(
          commentDetailsEntity: removedComment!,
          currentUser: widget.currentUser,
          onReplyButtonPressed: (value) {},
        ),
      ),
      duration: const Duration(milliseconds: 400),
    );
    BlocProvider.of<DeleteCommentCubit>(context).deleteComment(
      tweetId: removedComment!.tweetId,
      commentId: removedComment!.commentId,
      mediaFiles: removedComment!.comment.mediaUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MakeNewCommentCubit, MakeNewCommentState>(
          listener: (context, state) {
            if (state is MakeNewCommentLoadedState) {
              log("make new comment state ");
              setState(() {
                _listKey.currentState?.insertItem(0);
                comments.insert(0, state.commentDetails);
                widget.tweetDetailsEntity.makeComment();
                widget.comments.insert(0, state.commentDetails);
              });
              for (CommentDetailsEntity commentDetailsEntity in comments) {
                log(commentDetailsEntity.comment.likes.toString());
              }
            }
          },
        ),
        BlocListener<DeleteCommentCubit, DeleteCommentState>(
          listener: (context, state) {
            if (state is DeleteCommentFailureState) {
              showCustomSnackBar(context, context.tr(state.message));
              if (removedCommentIndex != null && removedComment != null) {
                _listKey.currentState?.insertItem(
                  removedCommentIndex!,
                  duration: const Duration(milliseconds: 400),
                );
              }
            } else if (state is DeleteCommentLoadedState) {
              if (removedCommentIndex != null) {
                setState(() {
                  widget.tweetDetailsEntity.deleteComment();
                  comments.removeAt(removedCommentIndex!);
                  widget.comments.removeAt(removedCommentIndex!);
                });
              } else {
                log("can not delete the comment");
              }
            }
          },
        ),
        BlocListener<UpdateCommentCubit, UpdateCommentState>(
          listener: (context, state) {
            if (state is UpdateCommentLoadedState) {
              setState(() {
                comments[updatedCommentIndex!] = state.updatedCommentDetails;
                widget.comments[updatedCommentIndex!] =
                    state.updatedCommentDetails;
              });
            }
          },
        ),
      ],
      child: comments.isEmpty
          ? const CustomEmptyBodyWidget(
              mainLabel: "No comments yet! 💬",
              subLabel: "Be the first to share your thoughts 💡",
              showImage: false,
            )
          : AnimatedList(
              key: _listKey,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              initialItemCount: comments.length,
              itemBuilder: (context, index, animation) => SizeTransition(
                sizeFactor: animation,
                child: Column(
                  key: ValueKey(comments[index].commentId),
                  children: [
                    const VerticalGap(24),
                    CustomCommentInfoCard(
                      commentDetailsEntity: comments[index],
                      onReplyButtonPressed: widget.onReplyButtonPressed,
                      currentUser: widget.currentUser,
                      onDeleteCommentTap: () {
                        _removeComment(index);
                      },
                      onEditCommentTap: () {
                        log('User selected: update comment');
                        Navigator.pushNamed(
                          context,
                          UpdateCommentsAndRepliesScreen.routeId,
                          arguments: comments[index],
                        );
                        updatedCommentIndex = index;
                      },
                    ),
                    if (index != comments.length - 1)
                      const Divider(
                        color: AppColors.dividerColor,
                        height: 24,
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
