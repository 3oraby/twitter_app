

import 'package:dartz/dartz.dart';
import 'package:twitter_app/core/errors/failures.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/success/success.dart';
import 'package:twitter_app/core/utils/backend_endpoints.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

class UserRepoImpl extends UserRepo {
  final DatabaseService databaseService;

  UserRepoImpl({required this.databaseService});

  @override
  Future<Either<Failure, Success>> addUserData({
    required Map<String, dynamic> data,
    required String documentId,
  }) async {
    try {
      await databaseService.addData(
        path: BackendEndpoints.addUserData,
        data: data,
        documentId: documentId,
      );
      return right(Success());
    } catch (e) {
      await getIt<FirebaseAuthService>().deleteCurrentUser();
      return left(ServerFailure(message: e.toString()));
    }
  }
}
