part of 'delete_tweet_cubit.dart';

abstract class DeleteTweetState {}

final class DeleteTweetInitial extends DeleteTweetState {}

final class DeleteTweetLoadingState extends DeleteTweetState {}

final class DeleteTweetLoadedState extends DeleteTweetState {}

final class DeleteTweetFailureState extends DeleteTweetState {
  final String message;

  DeleteTweetFailureState({required this.message});
}
