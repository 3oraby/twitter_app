import 'package:flutter/material.dart';
import 'package:twitter_app/features/home/presentation/widgets/create_or_update_tweet_bloc_consumer_body.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CreateOrUpdateTweetScreen extends StatelessWidget {
  const CreateOrUpdateTweetScreen({super.key, this.tweetDetails});

  static const String routeId = "kCreateOrUpdateTweetScreen";
  final TweetDetailsEntity? tweetDetails;

  @override
  Widget build(BuildContext context) {
    return CreateOrUpdateTweetBlocConsumerBody(tweetDetails: tweetDetails);
  }
}
