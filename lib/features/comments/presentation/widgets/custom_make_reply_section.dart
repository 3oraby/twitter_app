import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/collapsed_make_reply_section.dart';
import 'package:twitter_app/features/comments/presentation/widgets/expanded_make_reply_section.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomMakeReplySection extends StatelessWidget {
  const CustomMakeReplySection({
    super.key,
    required this.tweetDetailsEntity,
    required this.isSectionExpanded,
    required this.onTextFieldTap,
    required this.currentUser,
    required this.replyingToUserName,
    this.isComment = true,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final bool isSectionExpanded;
  final VoidCallback onTextFieldTap;
  final UserEntity currentUser;
  final String replyingToUserName;
  final bool isComment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MakeNewCommentCubit(
        commentsRepo: getIt<CommentsRepo>(),
      ),
      child: isSectionExpanded
          ? GestureDetector(
              onTap: () {},
              child: ExpandedMakeReplySection(
                currentUser: currentUser,
                tweetDetailsEntity: tweetDetailsEntity,
                replyingToUserName: replyingToUserName,
                isComment: isComment,
              ),
            )
          : CollapsedMakeReplySection(
              currentUser: currentUser,
              onTextFieldTap: onTextFieldTap,
            ),
    );
  }
}
