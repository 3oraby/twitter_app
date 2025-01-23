import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

abstract class RetweetRepo {
  Future<Either<Failure, Success>> toggleRetweet({
    required Map<String, dynamic> data,
  });
}
