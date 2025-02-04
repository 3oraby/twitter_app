import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/replies/domain/repos/reply_likes_repo.dart';

part 'toggle_reply_likes_state.dart';

class ToggleReplyLikesCubit extends Cubit<ToggleReplyLikesState> {
  ToggleReplyLikesCubit({
    required this.replyLikesRepo,
  }) : super(ToggleReplyLikesInitial());
  final ReplyLikesRepo replyLikesRepo;

  Future<void> toggleReplyLikes({
    required Map<String, dynamic> data,
  }) async {
    emit(ToggleReplyLikesLoadingState());
    var res = await replyLikesRepo.toggleReplyLikes(data: data);
    res.fold(
      (failure) => emit(ToggleReplyLikesFailureState(message: failure.message)),
      (success) => emit(ToggleReplyLikesLoadedState()),
    );
  }
}
