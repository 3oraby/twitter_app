part of 'update_tweet_cubit.dart';

abstract class UpdateTweetState {}

final class UpdateTweetInitial extends UpdateTweetState {}

final class UpdateTweetLoadingState extends UpdateTweetState {}

final class UpdateTweetLoadedState extends UpdateTweetState {
  final TweetDetailsEntity updatedTweetDetailsEntity;

  UpdateTweetLoadedState({required this.updatedTweetDetailsEntity});
}

final class UpdateTweetFailureState extends UpdateTweetState {
  final String message;

  UpdateTweetFailureState({required this.message});
}
