import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/services/custom_bloc_observer.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';
import 'package:twitter_app/core/services/supabase_storage_service.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/cubits/update_comment_cubit/update_comment_cubit.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';
import 'package:twitter_app/features/replies/presentation/cubits/update_reply_cubit.dart/update_reply_cubit.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/make_new_tweet_cubits/make_new_tweet_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/update_tweet_cubit/update_tweet_cubit.dart';
import 'package:twitter_app/twitter_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesSingleton.init();
  await SupabaseStorageService.supabaseInit();
  setupGetIt();
  Bloc.observer = CustomBlocObserver();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: DevicePreview(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MakeNewTweetCubit(
                tweetRepo: getIt<TweetRepo>(),
              ),
            ),
            BlocProvider(
              create: (context) => UpdateTweetCubit(
                tweetRepo: getIt<TweetRepo>(),
              ),
            ),
            BlocProvider(
              create: (context) => MakeNewCommentCubit(
                commentsRepo: getIt<CommentsRepo>(),
              ),
            ),
            BlocProvider(
              create: (context) => UpdateCommentCubit(
                commentsRepo: getIt<CommentsRepo>(),
              ),
            ),
            BlocProvider(
              create: (context) => UpdateReplyCubit(
                repliesRepo: getIt<RepliesRepo>(),
              ),
            ),
          ],
          child: const TwitterApp(),
        ),
      ),
    ),
  );
}
