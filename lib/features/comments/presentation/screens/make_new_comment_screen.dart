import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/make_new_comment_bloc_consumer_body.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class MakeNewCommentScreen extends StatelessWidget {
  const MakeNewCommentScreen({
    super.key,
    required this.tweetDetailsEntity,
  });
  static const String routeId = 'kMakeNewCommentScreen';

  final TweetDetailsEntity tweetDetailsEntity;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MakeNewCommentCubit(
        commentsRepo: getIt<CommentsRepo>(),
      ),
      child: MakeNewCommentBlocConsumerBody(
        tweetDetailsEntity: tweetDetailsEntity,
      ),
    );
  }
}
