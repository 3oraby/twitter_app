
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';
import 'package:twitter_app/features/replies/presentation/cubits/get_comment_replies_cubit/get_comment_replies_cubit.dart';
import 'package:twitter_app/features/replies/presentation/widgets/show_comment_replies_bloc_consumer_body.dart';

class ShowCommentRepliesPart extends StatelessWidget {
  const ShowCommentRepliesPart({
    super.key,
    required this.commentDetailsEntity,
  });

  final CommentDetailsEntity commentDetailsEntity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetCommentRepliesCubit(
        repliesRepo: getIt<RepliesRepo>(),
      ),
      child: ShowCommentRepliesBlocConsumerBody(
          commentDetailsEntity: commentDetailsEntity),
    );
  }
}
