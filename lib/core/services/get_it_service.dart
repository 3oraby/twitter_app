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
import 'package:twitter_app/features/bookmark/data/repo_impl/bookmark_repo_impl.dart';
import 'package:twitter_app/features/bookmark/domain/repos/bookmark_repo.dart';
import 'package:twitter_app/features/comments/data/repo_impl/comment_likes_repo_impl.dart';
import 'package:twitter_app/features/comments/data/repo_impl/comments_repo_impl.dart';
import 'package:twitter_app/features/comments/domain/repos/comment_likes_repo.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/follow_relationships/data/repo_impl/follow_repo_impl.dart';
import 'package:twitter_app/features/replies/data/repo_impl/replies_repo_impl.dart';
import 'package:twitter_app/features/replies/data/repo_impl/reply_likes_repo_impl.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';
import 'package:twitter_app/features/replies/domain/repos/reply_likes_repo.dart';
import 'package:twitter_app/features/search/data/repo_impl/users_search_repo_impl.dart';
import 'package:twitter_app/features/search/domain/repos/users_search_repo.dart';
import 'package:twitter_app/features/tweet/data/repo_impl/retweet_repo_impl.dart';
import 'package:twitter_app/features/tweet/data/repo_impl/tweet_likes_repo_impl.dart';
import 'package:twitter_app/features/tweet/data/repo_impl/tweet_repo_impl.dart';
import 'package:twitter_app/features/follow_relationships/domain/repos/follow_repo.dart';
import 'package:twitter_app/features/tweet/domain/repos/retweet_repo.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';
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

  getIt.registerSingleton<TweetLikesRepo>(TweetLikesRepoImpl(
    databaseService: getIt<DatabaseService>(),
  ));
  getIt.registerSingleton<RetweetRepo>(RetweetRepoImpl(
    databaseService: getIt<DatabaseService>(),
  ));

  getIt.registerSingleton<BookmarkRepo>(BookmarkRepoImpl(
    databaseService: getIt<DatabaseService>(),
  ));

  getIt.registerSingleton<CommentsRepo>(CommentsRepoImpl(
    databaseService: getIt<DatabaseService>(),
    storageService: getIt<StorageService>(),
  ));

  getIt.registerSingleton<CommentLikesRepo>(CommentLikesRepoImpl(
    databaseService: getIt<DatabaseService>(),
  ));

  getIt.registerSingleton<ReplyLikesRepo>(ReplyLikesRepoImpl(
    databaseService: getIt<DatabaseService>(),
  ));

  getIt.registerSingleton<RepliesRepo>(RepliesRepoImpl(
    databaseService: getIt<DatabaseService>(),
    storageService: getIt<StorageService>(),
  ));

  getIt.registerSingleton<UsersSearchRepo>(UsersSearchRepoImpl(
    databaseService: getIt<DatabaseService>(),
  ));
}
