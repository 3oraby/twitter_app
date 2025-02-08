import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';

part 'update_tweet_state.dart';

class UpdateTweetCubit extends Cubit<UpdateTweetState> {
  UpdateTweetCubit({required this.tweetRepo}) : super(UpdateTweetInitial());

  final TweetRepo tweetRepo;

  Future<void> updateTweet({
    required String tweetId,
    required Map<String, dynamic> data,
    required List<String>? oldMediaUrls,
    required List<File>? mediaFiles,
  }) async {
    emit(UpdateTweetLoadingState());
    var result = await tweetRepo.updateTweet(
      tweetId: tweetId,
      data: data,
      oldMediaUrls: oldMediaUrls,
      mediaFiles: mediaFiles,
    );

    result.fold(
      (failure) => emit(UpdateTweetFailureState(message: failure.message)),
      (updatedTweetDetailsEntity) => emit(UpdateTweetLoadedState(
          updatedTweetDetailsEntity: updatedTweetDetailsEntity)),
    );
  }
}
