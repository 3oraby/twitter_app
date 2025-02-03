import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/collapsed_make_reply_section.dart';
import 'package:twitter_app/features/comments/presentation/widgets/expanded_make_reply_section.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';
import 'package:twitter_app/features/replies/presentation/cubits/make_new_reply_cubit/make_new_reply_cubit.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomMakeReplySection extends StatelessWidget {
  const CustomMakeReplySection({
    super.key,
    required this.isSectionExpanded,
    required this.onTextFieldTap,
    required this.currentUser,
    required this.replyingToUserName,
    this.tweetDetailsEntity,
    this.commentDetailsEntity,
    this.onFieldSubmitted,
    this.isComment = true,
  });

  final TweetDetailsEntity? tweetDetailsEntity;
  final CommentDetailsEntity? commentDetailsEntity;
  final bool isSectionExpanded;
  final VoidCallback onTextFieldTap;
  final UserEntity currentUser;
  final String replyingToUserName;
  final bool isComment;
  final void Function(String?)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MakeNewCommentCubit(
            commentsRepo: getIt<CommentsRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => MakeNewReplyCubit(
            repliesRepo: getIt<RepliesRepo>(),
          ),
        ),
      ],
      child: isSectionExpanded
          ? GestureDetector(
              onTap: () {},
              child: ExpandedMakeReplySection(
                currentUser: currentUser,
                tweetDetailsEntity: tweetDetailsEntity,
                commentDetailsEntity: commentDetailsEntity,
                replyingToUserName: replyingToUserName,
                isComment: isComment,
                onFieldSubmitted: onFieldSubmitted,
              ),
            )
          : CollapsedMakeReplySection(
              currentUser: currentUser,
              onTextFieldTap: onTextFieldTap,
            ),
    );
  }
}
