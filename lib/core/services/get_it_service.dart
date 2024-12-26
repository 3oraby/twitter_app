import 'package:get_it/get_it.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/services/firestore_service.dart';
import 'package:twitter_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:twitter_app/features/user/data/repo_impl/user_repo_impl.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<AuthRepoImpl>(
      AuthRepoImpl(firebaseAuthService: getIt<FirebaseAuthService>()));

  getIt.registerSingleton<UserRepoImpl>(
      UserRepoImpl(databaseService: getIt<DatabaseService>()));

}
