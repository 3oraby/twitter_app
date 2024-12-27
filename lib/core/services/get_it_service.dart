import 'package:get_it/get_it.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/services/firestore_service.dart';
import 'package:twitter_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:twitter_app/features/user/data/repo_impl/user_repo_impl.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<AuthRepo>(
      AuthRepoImpl(firebaseAuthService: getIt<FirebaseAuthService>()));

  getIt.registerSingleton<UserRepo>(UserRepoImpl(
    databaseService: getIt<DatabaseService>(),
    firebaseAuthService: getIt<FirebaseAuthService>(),
  ));
}
