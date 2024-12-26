import 'dart:convert';

import 'package:twitter_app/core/constants/local_storage_data_names.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';
import 'package:twitter_app/features/auth/data/models/firebase_auth_user_model.dart';

FirebaseAuthUserModel getCurrentUser() {
  var jsonString = SharedPreferencesSingleton.getString(
      LocalStorageDataNames.kFirebaseAuthUserData);
  FirebaseAuthUserModel firebaseAuthUserModel =
      FirebaseAuthUserModel.fromJson(json: jsonDecode(jsonString));
  return firebaseAuthUserModel;
}
