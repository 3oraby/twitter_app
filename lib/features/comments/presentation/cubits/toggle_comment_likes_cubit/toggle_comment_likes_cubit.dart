import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/comments/domain/repos/comment_likes_repo.dart';

part 'toggle_comment_likes_state.dart';

class ToggleCommentLikesCubit extends Cubit<ToggleCommentLikesState> {
  ToggleCommentLikesCubit({required this.commentLikesRepo})
      : super(ToggleCommentLikesInitial());

  final CommentLikesRepo commentLikesRepo;

  Future<void> toggleCommentLikes({required Map<String, dynamic> data}) async {
    emit(ToggleCommentLikesLoadingState());
    var res = await commentLikesRepo.toggleCommentLikes(data: data);
    res.fold(
      (failure) => emit(ToggleCommentLikesFailureState(message: failure.message)),
      (likeId) => emit(ToggleCommentLikesLoadedState(toggledLikeId: likeId)),
    );
  }
}
