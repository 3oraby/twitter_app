import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

abstract class BookmarkRepo {
  Future<Either<Failure, Success>> toggleBookmark({
    required Map<String, dynamic> data,
  });
}
