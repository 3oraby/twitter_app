part of 'add_new_tweet_like_cubit.dart';

abstract class AddNewTweetLikeState {}

final class AddNewTweetLikeInitial extends AddNewTweetLikeState {}

final class AddNewTweetLikeLoadingState extends AddNewTweetLikeState {}

final class AddNewTweetLikeLoadedState extends AddNewTweetLikeState {}

final class AddNewTweetLikeFailureState extends AddNewTweetLikeState {
  final String message;
  AddNewTweetLikeFailureState({required this.message});
}
