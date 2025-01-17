part of 'toggle_tweet_like_cubit.dart';

abstract class ToggleTweetLikeState {}

final class ToggleTweetLikeInitial extends ToggleTweetLikeState {}

final class ToggleTweetLikeLoadingState extends ToggleTweetLikeState {}

final class ToggleTweetLikeLoadedState extends ToggleTweetLikeState {}

final class ToggleTweetLikeFailureState extends ToggleTweetLikeState {
  final String message;
  ToggleTweetLikeFailureState({required this.message});
}
