import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/success/success.dart';

abstract class CommentsRepo {
  Future<Either<Failure, Success>> makeNewComment({
    required Map<String, dynamic> data,
    required List<File>? mediaFiles,
  });
}
