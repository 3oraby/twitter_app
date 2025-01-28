part of 'get_tweet_comments_cubit.dart';

abstract class GetTweetCommentsState {}

final class GetTweetCommentsInitial extends GetTweetCommentsState {}

final class GetTweetCommentsLoadingState extends GetTweetCommentsState {}

final class GetTweetCommentsLoadedState extends GetTweetCommentsState {
  final List<CommentDetailsEntity> comments;

  GetTweetCommentsLoadedState({required this.comments});
}

final class GetTweetCommentsEmptyState extends GetTweetCommentsState {}

final class GetTweetCommentsFailureState extends GetTweetCommentsState {
  final String message;

  GetTweetCommentsFailureState({required this.message});
}
