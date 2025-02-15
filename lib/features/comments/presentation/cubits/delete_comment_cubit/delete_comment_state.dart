part of 'delete_comment_cubit.dart';

abstract class DeleteCommentState {}

final class DeleteCommentInitial extends DeleteCommentState {}

final class DeleteCommentLoadingState extends DeleteCommentState {}

final class DeleteCommentLoadedState extends DeleteCommentState {}

final class DeleteCommentFailureState extends DeleteCommentState {
  final String message;

  DeleteCommentFailureState({required this.message});
}
