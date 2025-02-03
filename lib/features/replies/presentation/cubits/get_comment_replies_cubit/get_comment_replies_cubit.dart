import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';

part 'get_comment_replies_state.dart';

class GetCommentRepliesCubit extends Cubit<GetCommentRepliesState> {
  GetCommentRepliesCubit({
    required this.repliesRepo,
  }) : super(GetCommentRepliesInitial());

  final RepliesRepo repliesRepo;

  Future<void> getCommentReplies({
    required String commentId,
  }) async {
    emit(GetCommentRepliesLoadingState());
    var res = await repliesRepo.getCommentReplies(commentId: commentId);
    res.fold(
      (failure) =>
          emit(GetCommentRepliesFailureState(message: failure.message)),
      (replies) {
        if (replies.isEmpty) {
          emit(GetCommentRepliesEmptyState());
        } else {
          emit(GetCommentRepliesLoadedState(replies: replies));
        }
      },
    );
  }
}
