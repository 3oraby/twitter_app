part of 'toggle_comment_likes_cubit.dart';

abstract class ToggleCommentLikesState {}

final class ToggleCommentLikesInitial extends ToggleCommentLikesState {}

final class ToggleCommentLikesLoadingState extends ToggleCommentLikesState {}

final class ToggleCommentLikesLoadedState extends ToggleCommentLikesState {
  final String toggledLikeId;

  ToggleCommentLikesLoadedState({required this.toggledLikeId});
}

final class ToggleCommentLikesFailureState extends ToggleCommentLikesState {
  final String message;

  ToggleCommentLikesFailureState({required this.message});
}
