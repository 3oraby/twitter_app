import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/presentation/cubits/get_comment_replies_cubit/get_comment_replies_cubit.dart';
import 'package:twitter_app/features/replies/presentation/widgets/show_comment_replies_body.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetCommentRepliesCubit, GetCommentRepliesState>(
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

        return ShowCommentRepliesBody(
          commentDetailsEntity: widget.commentDetailsEntity,
          replies: replies,
        );
      },
    );
  }
}
