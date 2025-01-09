import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';
import 'package:twitter_app/features/home/domain/repos/tweet_repo.dart';

part 'make_new_tweet_state.dart';

class MakeNewTweetCubit extends Cubit<MakeNewTweetState> {
  MakeNewTweetCubit({required this.tweetRepo}) : super(MakeNewTweetInitial());

  final TweetRepo tweetRepo;

  Future<void> makeNewTweet({required Map<String, dynamic> data}) async {
    emit(MakeNewTweetLoadingState());
    var result = await tweetRepo.makeNewTweet(data: data);

    result.fold(
      (failure) => emit(MakeNewTweetFailureState(message: failure.message)),
      (tweetEntity) => emit(MakeNewTweetLoadedState(tweetEntity: tweetEntity)),
    );
  }
}
