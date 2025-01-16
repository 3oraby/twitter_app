import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';

part 'add_new_tweet_like_state.dart';

class AddNewTweetLikeCubit extends Cubit<AddNewTweetLikeState> {
  AddNewTweetLikeCubit({required this.tweetLikesRepo})
      : super(AddNewTweetLikeInitial());

  final TweetLikesRepo tweetLikesRepo;

  Future<void> addNewLike({required Map<String, dynamic> data}) async {
    emit(AddNewTweetLikeLoadingState());
    var res = await tweetLikesRepo.addNewLike(data: data);

    res.fold(
      (failure) => emit(AddNewTweetLikeFailureState(message: failure.message)),
      (success) => emit(AddNewTweetLikeLoadedState()),
    );
  }
}
