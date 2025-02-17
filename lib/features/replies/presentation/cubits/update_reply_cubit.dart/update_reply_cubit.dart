import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';

part 'update_reply_state.dart';

class UpdateReplyCubit extends Cubit<UpdateReplyState> {
  UpdateReplyCubit({
    required this.repliesRepo,
  }) : super(UpdateReplyInitial());

  final RepliesRepo repliesRepo;
  Future<void> updateReply({
    required String replyId,
    required Map<String, dynamic> data,
    required List<String>? constantMediaUrls,
    required List<String>? removedMediaUrls,
    required List<File>? mediaFiles,
  }) async {
    emit(UpdateReplyLoadingState());
    var result = await repliesRepo.updateReply(
      replyId: replyId,
      data: data,
      mediaFiles: mediaFiles,
      constantMediaUrls: constantMediaUrls,
      removedMediaUrls: removedMediaUrls,
    );

    result.fold(
      (failure) => emit(UpdateReplyFailureState(message: failure.message)),
      (updatedReplyDetails) => emit(UpdateReplyLoadedState(
          updatedReplyDetails: updatedReplyDetails)),
    );
  }
}
