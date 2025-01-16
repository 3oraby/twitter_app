part of 'make_new_tweet_cubit.dart';

abstract class MakeNewTweetState {}

final class MakeNewTweetInitial extends MakeNewTweetState {}

final class MakeNewTweetLoadingState extends MakeNewTweetState {}

final class MakeNewTweetLoadedState extends MakeNewTweetState {
  final TweetEntity tweetEntity;
  MakeNewTweetLoadedState({required this.tweetEntity});
}

final class MakeNewTweetFailureState extends MakeNewTweetState {
  final String message;
  MakeNewTweetFailureState({required this.message});
}
