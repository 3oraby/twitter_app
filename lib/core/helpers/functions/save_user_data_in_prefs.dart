import 'dart:convert';
import 'dart:developer';

import 'package:twitter_app/core/constants/local_storage_data_names.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

Future<void> saveUserDataInPrefs({
  required UserEntity user,
}) async {
  log('execute saveUserDataInPrefs()');
  var jsonData = jsonEncode(UserModel.fromEntity(user).toJson());
  log("user data: $jsonData");
  await SharedPreferencesSingleton.setString(
      LocalStorageDataNames.kUserData, jsonData);
}
