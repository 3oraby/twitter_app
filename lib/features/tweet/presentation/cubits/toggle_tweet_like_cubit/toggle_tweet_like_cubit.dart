import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';

part 'toggle_tweet_like_state.dart';

class ToggleTweetLikeCubit extends Cubit<ToggleTweetLikeState> {
  ToggleTweetLikeCubit({required this.tweetLikesRepo})
      : super(ToggleTweetLikeInitial());

  final TweetLikesRepo tweetLikesRepo;

  Future<void> toggleTweetLike({required Map<String, dynamic> data}) async {
    emit(ToggleTweetLikeLoadingState());
    var res = await tweetLikesRepo.toggleTweetLike(data: data);

    res.fold(
      (failure) => emit(ToggleTweetLikeFailureState(message: failure.message)),
      (success) => emit(ToggleTweetLikeLoadedState()),
    );
  }
}
