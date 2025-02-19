import 'package:flutter/material.dart';
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
    return MakeNewCommentBlocConsumerBody(
      tweetDetailsEntity: tweetDetailsEntity,
    );
  }
}
