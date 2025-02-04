import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_comment_info_card.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';

class ShowAllCommentsBody extends StatefulWidget {
  const ShowAllCommentsBody({
    super.key,
    required this.comments,
    required this.onReplyButtonPressed,
  });

  final List<CommentDetailsEntity> comments;
  final ValueChanged<dartz.Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;

  @override
  State<ShowAllCommentsBody> createState() => _ShowAllCommentsBodyState();
}

class _ShowAllCommentsBodyState extends State<ShowAllCommentsBody> {
  late List<CommentDetailsEntity> comments;

  @override
  void initState() {
    super.initState();
    comments = widget.comments;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MakeNewCommentCubit, MakeNewCommentState>(
      listener: (context, state) {
        if (state is MakeNewCommentLoadedState) {
          setState(() {
            comments.insert(0, state.commentDetails);
          });
        }
      },
      child: Column(
        children: [
          const VerticalGap(24),
          for (int index = 0; index < widget.comments.length; index++) ...[
            CustomCommentInfoCard(
              commentDetailsEntity: widget.comments[index],
              onReplyButtonPressed: widget.onReplyButtonPressed,
            ),
            if (index != widget.comments.length - 1)
              const Divider(
                color: AppColors.dividerColor,
                height: 24,
              ),
          ],
          const VerticalGap(32),
        ],
      ),
    );
  }
}
