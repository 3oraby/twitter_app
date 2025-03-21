import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';
import 'package:twitter_app/features/replies/presentation/cubits/delete_reply_cubit/delete_reply_cubit.dart';
import 'package:twitter_app/features/replies/presentation/cubits/get_comment_replies_cubit/get_comment_replies_cubit.dart';
import 'package:twitter_app/features/replies/presentation/widgets/show_comment_replies_bloc_consumer_body.dart';

class ShowCommentRepliesPart extends StatelessWidget {
  const ShowCommentRepliesPart({
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetCommentRepliesCubit(
            repliesRepo: getIt<RepliesRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => DeleteReplyCubit(
            repliesRepo: getIt<RepliesRepo>(),
          ),
        ),
      ],
      child: ShowCommentRepliesBlocConsumerBody(
        currentUser: currentUser,
        commentDetailsEntity: commentDetailsEntity,
        onReplyButtonPressed: onReplyButtonPressed,
      ),
    );
  }
}
