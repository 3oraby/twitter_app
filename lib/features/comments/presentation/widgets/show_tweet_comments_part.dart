import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/get_tweet_comments_cubit/get_tweet_comments_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_all_comments_bloc_consumer_body.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ShowTweetCommentsPart extends StatelessWidget {
  const ShowTweetCommentsPart({
    super.key,
    required this.tweetDetailsEntity,
    required this.onReplyButtonPressed,
    required this.selectedCommentedFilter,
    required this.currentUser,
  });

  final UserEntity currentUser;
  final TweetDetailsEntity tweetDetailsEntity;
  final ValueChanged<Either<CommentDetailsEntity, ReplyDetailsEntity>>
      onReplyButtonPressed;
  final ValueNotifier<String> selectedCommentedFilter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTweetCommentsCubit(
        commentsRepo: getIt<CommentsRepo>(),
      ),
      child: ShowAllCommentsBlocConsumerBody(
        currentUser: currentUser,
        tweetId: tweetDetailsEntity.tweetId,
        onReplyButtonPressed: onReplyButtonPressed,
        selectedCommentedFilter: selectedCommentedFilter,
      ),
    );
  }
}
