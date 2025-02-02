part of 'make_new_reply_cubit.dart';

abstract class MakeNewReplyState {}

final class MakeNewReplyInitial extends MakeNewReplyState {}

final class MakeNewReplyLoadingState extends MakeNewReplyState {}

final class MakeNewReplyLoadedState extends MakeNewReplyState {}

final class MakeNewReplyFailureState extends MakeNewReplyState {
  final String message;

  MakeNewReplyFailureState({required this.message});
}
