import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

abstract class UserRepo {
  Future<Either<Failure, Success>> addUserToFirestore({
    required Map<String, dynamic> data,
    required String documentId,
  });
}
