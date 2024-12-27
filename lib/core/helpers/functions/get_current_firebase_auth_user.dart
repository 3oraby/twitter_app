import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';

User getCurrentFirebaseAuthUser() {
  return getIt<AuthRepo>().getCurrentFirebaseAuthUser();
}
