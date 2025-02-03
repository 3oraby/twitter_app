part of 'get_comment_replies_cubit.dart';

abstract class GetCommentRepliesState {}

final class GetCommentRepliesInitial extends GetCommentRepliesState {}

final class GetCommentRepliesLoadingState extends GetCommentRepliesState {}

final class GetCommentRepliesEmptyState extends GetCommentRepliesState {}

final class GetCommentRepliesLoadedState extends GetCommentRepliesState {
  List<ReplyDetailsEntity> replies;
  GetCommentRepliesLoadedState({required this.replies});
}

final class GetCommentRepliesFailureState extends GetCommentRepliesState {
  final String message;

  GetCommentRepliesFailureState({required this.message});
}
