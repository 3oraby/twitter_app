import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo.dart';
import 'package:twitter_app/core/services/storage_service.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';

class FilesRepoImpl extends FilesRepo {
  final StorageService storageService;
  FilesRepoImpl({required this.storageService});

  @override
  Future<Either<Failure, String>> uploadFile(File file) async {
    try {
      String fileUrl =
          await storageService.uploadFile(file, BackendEndpoints.uploadFiles);
      return Right(fileUrl);
    } catch (e) {
      log("error in FilesRepoImpl.uploadFile() ${e.toString()}");
      return const Left(ServerFailure(message: "Failed to upload file"));
    }
  }

  @override
  Future<Either<Failure, String>> updateFile({
    required String oldFileUrl,
    required File file,
  }) async {
    try {
      String fileUrl = await storageService.updateFile(
        oldFileUrl: oldFileUrl,
        newFile: file,
      );
      return Right(fileUrl);
    } catch (e) {
      log("error in FilesRepoImpl.updateFile() ${e.toString()}");
      return const Left(ServerFailure(message: "Failed to update file"));
    }
  }
}
