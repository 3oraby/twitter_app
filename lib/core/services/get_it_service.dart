import 'package:get_it/get_it.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo_impl.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/services/firestore_service.dart';
import 'package:twitter_app/core/services/storage_service.dart';
import 'package:twitter_app/core/services/supabase_storage_service.dart';
import 'package:twitter_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:twitter_app/features/home/data/repo_impl/follow_repo_impl.dart';
import 'package:twitter_app/features/home/data/repo_impl/tweet_repo_impl.dart';
import 'package:twitter_app/features/home/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/home/domain/repos/tweet_repo.dart';
import 'package:twitter_app/features/user/data/repo_impl/user_repo_impl.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<StorageService>(SupabaseStorageService());

  getIt.registerSingleton<UserRepo>(
    UserRepoImpl(
      databaseService: getIt<DatabaseService>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
    ),
  );
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(
    firebaseAuthService: getIt<FirebaseAuthService>(),
    userRepo: getIt<UserRepo>(),
  ));

  getIt.registerSingleton<FilesRepo>(
    FilesRepoImpl(
      storageService: getIt<StorageService>(),
    ),
  );

  getIt.registerSingleton<TweetRepo>(TweetRepoImpl(
    databaseService: getIt<DatabaseService>(),
    storageService: getIt<StorageService>(),
  ));

  getIt.registerSingleton<FollowRepo>(FollowRepoImpl(
    databaseService: getIt<DatabaseService>(),
  ));
}
