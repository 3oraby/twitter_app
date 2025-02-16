import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';

part 'delete_comment_state.dart';

class DeleteCommentCubit extends Cubit<DeleteCommentState> {
  DeleteCommentCubit({
    required this.commentsRepo,
  }) : super(DeleteCommentInitial());

  final CommentsRepo commentsRepo;
  Future<void> deleteComment({
    required String tweetId,
    required String commentId,
    List<String>? mediaFiles,
  }) async {
    emit(DeleteCommentLoadingState());
    var res = await commentsRepo.deleteComment(
      commentId: commentId,
      mediaFiles: mediaFiles,
      tweetId: tweetId,
    );
    res.fold(
      (failure) => emit(DeleteCommentFailureState(message: failure.message)),
      (success) => emit(DeleteCommentLoadedState()),
    );
  }
}
