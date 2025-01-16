part of 'get_tweets_cubit.dart';

abstract class GetTweetsState {}

final class GetTweetsInitial extends GetTweetsState {}

final class GetTweetsLoadingState extends GetTweetsState {}

final class GetTweetsLoadedState extends GetTweetsState {
  final List<TweetDetailsEntity> tweets;
  GetTweetsLoadedState({required this.tweets});
}

final class GetTweetsFailureState extends GetTweetsState {
  final String message;
  GetTweetsFailureState({required this.message});
}
