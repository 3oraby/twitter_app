part of 'toggle_reply_likes_cubit.dart';

abstract class ToggleReplyLikesState {}

final class ToggleReplyLikesInitial extends ToggleReplyLikesState {}

final class ToggleReplyLikesLoadingState extends ToggleReplyLikesState {}

final class ToggleReplyLikesLoadedState extends ToggleReplyLikesState {}

final class ToggleReplyLikesFailureState extends ToggleReplyLikesState {
  final String message;

  ToggleReplyLikesFailureState({required this.message});
}
