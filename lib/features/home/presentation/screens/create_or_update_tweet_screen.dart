import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/home/presentation/widgets/create_or_update_tweet_bloc_consumer_body.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/update_tweet_cubit/update_tweet_cubit.dart';

class CreateOrUpdateTweetScreen extends StatelessWidget {
  const CreateOrUpdateTweetScreen({super.key, this.tweetDetails});

  static const String routeId = "kCreateOrUpdateTweetScreen";
  final TweetDetailsEntity? tweetDetails;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UpdateTweetCubit(
            tweetRepo: getIt<TweetRepo>(),
          ),
        ),
      ],
      child: CreateOrUpdateTweetBlocConsumerBody(tweetDetails: tweetDetails),
    );
  }
}
