import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/cubits/get_comment_replies_cubit/get_comment_replies_cubit.dart';
import 'package:twitter_app/features/replies/presentation/cubits/make_new_reply_cubit/make_new_reply_cubit.dart';
import 'package:twitter_app/features/replies/presentation/widgets/custom_reply_info_card.dart';

class ShowCommentRepliesBlocConsumerBody extends StatefulWidget {
  const ShowCommentRepliesBlocConsumerBody({
    super.key,
    required this.commentDetailsEntity,
  });

  final CommentDetailsEntity commentDetailsEntity;

  @override
  State<ShowCommentRepliesBlocConsumerBody> createState() =>
      _ShowCommentRepliesBlocConsumerBodyState();
}

class _ShowCommentRepliesBlocConsumerBodyState
    extends State<ShowCommentRepliesBlocConsumerBody> {
  List<ReplyDetailsEntity> replies = [];
  bool isRepliesHidden = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MakeNewReplyCubit, MakeNewReplyState>(
      listener: (context, makeNewReplyState) {
        if (makeNewReplyState is MakeNewReplyLoadedState) {
          if (makeNewReplyState.replyDetailsEntity.commentId ==
              widget.commentDetailsEntity.commentId) {
            setState(() {
              replies.insert(0, makeNewReplyState.replyDetailsEntity);
              isRepliesHidden = false;
            });
          }
        }
      },
      child: BlocConsumer<GetCommentRepliesCubit, GetCommentRepliesState>(
        listener: (context, state) {
          if (state is GetCommentRepliesFailureState) {
            showCustomSnackBar(context, state.message);
          } else if (state is GetCommentRepliesLoadedState) {
            setState(() {
              replies.addAll(state.replies);
            });
          }
        },
        builder: (context, state) {
          if (state is GetCommentRepliesLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          return Column(
            children: [
              Visibility(
                visible: isRepliesHidden,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isRepliesHidden = false;
                    });
                    BlocProvider.of<GetCommentRepliesCubit>(context)
                        .getCommentReplies(
                      commentId: widget.commentDetailsEntity.commentId,
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
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
                              "View ${widget.commentDetailsEntity.comment.repliesCount} replies",
                              style: AppTextStyles.uberMoveMedium16.copyWith(
                                color: AppColors.thirdColor,
                              ),
                            ),
                            Icon(
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
              Column(
                children: isRepliesHidden
                    ? []
                    : replies
                        .map((reply) =>
                            CustomReplyInfoCard(replyDetailsEntity: reply))
                        .toList(),
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
                      Expanded(
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
                            Icon(
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
