part of 'toggle_comment_likes_cubit.dart';

abstract class ToggleCommentLikesState {}

final class ToggleCommentLikesInitial extends ToggleCommentLikesState {}

final class ToggleCommentLikesLoadingState extends ToggleCommentLikesState {}

final class ToggleCommentLikesLoadedState extends ToggleCommentLikesState {}

final class ToggleCommentLikesFailureState extends ToggleCommentLikesState {
  final String message;

  ToggleCommentLikesFailureState({required this.message});
}
