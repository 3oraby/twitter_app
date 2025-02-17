part of 'update_reply_cubit.dart';

abstract class UpdateReplyState {}

final class UpdateReplyInitial extends UpdateReplyState {}

final class UpdateReplyLoadingState extends UpdateReplyState {}

final class UpdateReplyLoadedState extends UpdateReplyState {
  final ReplyDetailsEntity updatedReplyDetails;

  UpdateReplyLoadedState({required this.updatedReplyDetails});
}

final class UpdateReplyFailureState extends UpdateReplyState {
  final String message;

  UpdateReplyFailureState({required this.message});
}
