part of 'delete_reply_cubit.dart';

abstract class DeleteReplyState {}

final class DeleteReplyInitial extends DeleteReplyState {}

final class DeleteReplyLoadingState extends DeleteReplyState {}

final class DeleteReplyLoadedState extends DeleteReplyState {}

final class DeleteReplyFailureState extends DeleteReplyState {
  final String message;

  DeleteReplyFailureState({required this.message});
}
