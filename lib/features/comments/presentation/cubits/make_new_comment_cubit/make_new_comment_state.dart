part of 'make_new_comment_cubit.dart';

abstract class MakeNewCommentState {}

final class MakeNewCommentInitial extends MakeNewCommentState {}

final class MakeNewCommentLoadingState extends MakeNewCommentState {}

final class MakeNewCommentLoadedState extends MakeNewCommentState {}

final class MakeNewCommentFailureState extends MakeNewCommentState {
  final String message;

  MakeNewCommentFailureState({required this.message});
}
