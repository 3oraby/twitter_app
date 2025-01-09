import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/home/data/models/tweet_model.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';
import 'package:twitter_app/features/home/domain/repos/tweet_repo.dart';

class TweetRepoImpl extends TweetRepo {
  final DatabaseService databaseService;

  TweetRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, TweetEntity>> makeNewTweet({
    required Map<String, dynamic> data,
  }) async {
    try {
      await databaseService.addData(
        path: BackendEndpoints.makeNewTweet,
        data: data,
      );
      return right(TweetModel.fromMap(data).toEntity());
    } catch (e) {
      log("Exception in TweetRepoImpl.makeNewTweet() ${e.toString()}");
      return left(const ServerFailure(message: "Failed to post the tweet"));
    }
  }
}
