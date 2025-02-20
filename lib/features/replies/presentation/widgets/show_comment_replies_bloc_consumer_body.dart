import 'dart:developer';

import 'package:dartz/dartz.dart' as dartz;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/screens/update_comments_and_replies_screen.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/cubits/delete_reply_cubit/delete_reply_cubit.dart';
import 'package:twitter_app/features/replies/presentation/cubits/get_comment_replies_cubit/get_comment_replies_cubit.dart';
import 'package:twitter_app/features/replies/presentation/cubits/make_new_reply_cubit/make_new_reply_cubit.dart';
import 'package:twitter_app/features/replies/presentation/cubits/update_reply_cubit.dart/update_reply_cubit.dart';
import 'package:twitter_app/features/replies/presentation/widgets/custom_reply_info_card.dart';

class ShowCommentRepliesBlocConsumerBody extends StatefulWidget {
  const ShowCommentRepliesBlocConsumerBody({
    super.key,
    required this.currentUser,
    required this.commentDetailsEntity,
    required this.onReplyButtonPressed,
  });

  final UserEntity currentUser;
  final CommentDetailsEntity commentDetailsEntity;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;

  @override
  State<ShowCommentRepliesBlocConsumerBody> createState() =>
      _ShowCommentRepliesBlocConsumerBodyState();
}

class _ShowCommentRepliesBlocConsumerBodyState
    extends State<ShowCommentRepliesBlocConsumerBody> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ReplyDetailsEntity? removedReply;
  int? updatedReplyIndex;
  int? removedReplyIndex;
  List<ReplyDetailsEntity> replies = [];
  bool isRepliesHidden = true;
  bool isRepliesReached = false;

  void _fetchCommentReplies() {
    BlocProvider.of<GetCommentRepliesCubit>(context).getCommentReplies(
      commentId: widget.commentDetailsEntity.commentId,
    );
  }

  void _removeReply(int index) {
    setState(() {
      log("delete the reply at $index ");
      removedReplyIndex = index;
      removedReply = replies[index];

      _listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: CustomReplyInfoCard(
            replyDetailsEntity: removedReply!,
            currentUser: widget.currentUser,
            onReplyButtonPressed: (value) {},
          ),
        ),
        duration: const Duration(milliseconds: 350),
      );
    });
    widget.commentDetailsEntity.comment.decrementRepliesCount();

    if (removedReply != null) {
      BlocProvider.of<DeleteReplyCubit>(context).deleteReply(
        replyId: removedReply!.replyId,
        commentId: removedReply!.commentId,
        removedMediaFiles: removedReply!.reply.mediaUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MakeNewReplyCubit, MakeNewReplyState>(
          listener: (context, makeNewReplyState) {
            if (makeNewReplyState is MakeNewReplyLoadedState) {
              if (makeNewReplyState.replyDetailsEntity.commentId ==
                  widget.commentDetailsEntity.commentId) {
                log("newReply");
                setState(() {
                  isRepliesHidden = false;
                  widget.commentDetailsEntity.comment.incrementRepliesCount();
                  if (isRepliesReached) {
                    _listKey.currentState?.insertItem(replies.length);
                    replies.add(makeNewReplyState.replyDetailsEntity);
                  } else {
                    _fetchCommentReplies();
                  }
                });
              }
            }
          },
        ),
        BlocListener<UpdateReplyCubit, UpdateReplyState>(
          listener: (context, state) {
            if (state is UpdateReplyFailureState) {
              showCustomSnackBar(context, context.tr(state.message));
            } else if (state is UpdateReplyLoadedState) {
              setState(() {
                log("indexxxxx => $updatedReplyIndex");
                if (updatedReplyIndex != null) {
                  log("not null");
                  replies[updatedReplyIndex!] = state.updatedReplyDetails;
                } else {
                  log("can not update the comment");
                }
              });
            }
          },
        ),
        BlocListener<DeleteReplyCubit, DeleteReplyState>(
          listener: (context, state) {
            if (state is DeleteReplyFailureState) {
              showCustomSnackBar(context, context.tr(state.message));
              if (removedReplyIndex != null && removedReply != null) {
                _listKey.currentState?.insertItem(
                  removedReplyIndex!,
                  duration: const Duration(milliseconds: 400),
                );
              }
            } else if (state is DeleteReplyLoadedState) {
              if (removedReplyIndex != null) {
                setState(() {
                  replies.removeAt(removedReplyIndex!);
                });
              } else {
                log("can not delete the reply");
              }
            }
          },
        ),
      ],
      child: BlocConsumer<GetCommentRepliesCubit, GetCommentRepliesState>(
        listener: (context, state) {
          if (state is GetCommentRepliesFailureState) {
            setState(() {
              isRepliesHidden = true;
            });
            showCustomSnackBar(context, context.tr(state.message));
          } else if (state is GetCommentRepliesLoadedState) {
            setState(() {
              replies.addAll(state.replies);
              isRepliesReached = true;
            });
          }
        },
        builder: (context, state) {
          if (state is GetCommentRepliesLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          return Column(
            children: [
              Visibility(
                visible: isRepliesHidden &&
                    widget.commentDetailsEntity.comment.repliesCount > 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isRepliesHidden = false;
                    });
                    if (!isRepliesReached) {
                      _fetchCommentReplies();
                    }
                  },
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: AppColors.thirdColor,
                        ),
                      ),
                      const HorizontalGap(12),
                      Expanded(
                        flex: 6,
                        child: Row(
                          children: [
                            Text(
                              "${context.tr("View")} ${widget.commentDetailsEntity.comment.repliesCount} ${context.tr("replies")}",
                              style: AppTextStyles.uberMoveMedium16.copyWith(
                                color: AppColors.thirdColor,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: AppColors.thirdColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isRepliesHidden)
                AnimatedList(
                  key: _listKey,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  initialItemCount: replies.length,
                  itemBuilder: (context, index, animation) => SizeTransition(
                    sizeFactor: animation,
                    child: Column(
                      key: ValueKey(replies[index].replyId),
                      children: [
                        CustomReplyInfoCard(
                          currentUser: widget.currentUser,
                          replyDetailsEntity: replies[index],
                          onReplyButtonPressed: widget.onReplyButtonPressed,
                          onDeleteReplyTap: () {
                            _removeReply(index);
                          },
                          onEditReplyTap: () {
                            log('User selected: update reply');
                            Navigator.pushNamed(
                              context,
                              UpdateCommentsAndRepliesScreen.routeId,
                              arguments: replies[index],
                            );
                            updatedReplyIndex = index;
                          },
                        ),
                        const VerticalGap(16),
                      ],
                    ),
                  ),
                ),
              Visibility(
                visible: !isRepliesHidden,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isRepliesHidden = true;
                    });
                  },
                  child: Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: AppColors.thirdColor,
                        ),
                      ),
                      const HorizontalGap(12),
                      Expanded(
                        flex: 6,
                        child: Row(
                          children: [
                            Text(
                              "Hide",
                              style: AppTextStyles.uberMoveMedium16.copyWith(
                                color: AppColors.thirdColor,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_up,
                              size: 20,
                              color: AppColors.thirdColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
