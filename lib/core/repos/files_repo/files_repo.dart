import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';

abstract class FilesRepo {
  Future<Either<Failure, String>> uploadFile(File file);
  Future<Either<Failure, String>> updateFile({
    required String oldFileUrl,
    required File file,
  });
}
