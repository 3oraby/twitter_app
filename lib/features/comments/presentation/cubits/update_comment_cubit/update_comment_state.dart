part of 'update_comment_cubit.dart';

abstract class UpdateCommentState {}

final class UpdateCommentInitial extends UpdateCommentState {}

final class UpdateCommentLoadingState extends UpdateCommentState {}

final class UpdateCommentLoadedState extends UpdateCommentState {
  final CommentDetailsEntity updatedCommentDetails;

  UpdateCommentLoadedState({required this.updatedCommentDetails});
}

final class UpdateCommentFailureState extends UpdateCommentState {
  final String message;

  UpdateCommentFailureState({required this.message});
}
