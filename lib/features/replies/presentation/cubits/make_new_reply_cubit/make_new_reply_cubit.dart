import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';

part 'make_new_reply_state.dart';

class MakeNewReplyCubit extends Cubit<MakeNewReplyState> {
  MakeNewReplyCubit({required this.repliesRepo}) : super(MakeNewReplyInitial());

  final RepliesRepo repliesRepo;

  Future<void> makeNewReply({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  }) async {
    emit(MakeNewReplyLoadingState());
    var res = await repliesRepo.makeNewReply(
      data: data,
      mediaFiles: mediaFiles,
    );

    res.fold(
      (failure) => emit(MakeNewReplyFailureState(message: failure.message)),
      (replyDetailsEntity) => emit(MakeNewReplyLoadedState(
        replyDetailsEntity: replyDetailsEntity,
      )),
    );
  }
}
