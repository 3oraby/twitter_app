import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';

part 'delete_reply_state.dart';

class DeleteReplyCubit extends Cubit<DeleteReplyState> {
  DeleteReplyCubit({
    required this.repliesRepo,
  }) : super(DeleteReplyInitial());

  final RepliesRepo repliesRepo;

  Future<void> deleteReply({
    required String commentId,
    required String replyId,
    List<String>? removedMediaFiles,
  }) async {
    emit(DeleteReplyLoadingState());
    var res = await repliesRepo.deleteReply(
      commentId: commentId,
      replyId: replyId,
      removedMediaFiles: removedMediaFiles,
    );
    res.fold(
      (failure) => emit(DeleteReplyFailureState(message: failure.message)),
      (success) => emit(DeleteReplyLoadedState()),
    );
  }
}
