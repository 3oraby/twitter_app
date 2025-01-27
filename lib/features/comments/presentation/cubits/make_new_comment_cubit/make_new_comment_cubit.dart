import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';

part 'make_new_comment_state.dart';

class MakeNewCommentCubit extends Cubit<MakeNewCommentState> {
  MakeNewCommentCubit({required this.commentsRepo})
      : super(MakeNewCommentInitial());

  final CommentsRepo commentsRepo;

  Future<void> makeNewComment({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  }) async {
    emit(MakeNewCommentLoadingState());
    var res = await commentsRepo.makeNewComment(
      data: data,
      mediaFiles: mediaFiles,
    );
    res.fold(
      (failure) => emit(MakeNewCommentFailureState(message: failure.message)),
      (success) => emit(MakeNewCommentLoadedState()),
    );
  }
}
