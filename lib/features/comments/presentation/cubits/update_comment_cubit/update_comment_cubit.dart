import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';

part 'update_comment_state.dart';

class UpdateCommentCubit extends Cubit<UpdateCommentState> {
  UpdateCommentCubit({
    required this.commentsRepo,
  }) : super(UpdateCommentInitial());

  final CommentsRepo commentsRepo;
  Future<void> updateComment({
    required String commentId,
    required Map<String, dynamic> data,
    required List<String>? constantMediaUrls,
    required List<String>? removedMediaUrls,
    required List<File>? mediaFiles,
  }) async {
    emit(UpdateCommentLoadingState());
    var result = await commentsRepo.updateComment(
      commentId: commentId,
      data: data,
      mediaFiles: mediaFiles,
      constantMediaUrls: constantMediaUrls,
      removedMediaUrls: removedMediaUrls,
    );

    result.fold(
      (failure) => emit(UpdateCommentFailureState(message: failure.message)),
      (updatedCommentDetails) => emit(UpdateCommentLoadedState(
          updatedCommentDetails: updatedCommentDetails)),
    );
  }
}
