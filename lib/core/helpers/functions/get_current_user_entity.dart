import 'dart:convert';
import 'dart:developer';

import 'package:twitter_app/core/constants/local_storage_data_names.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

UserEntity getCurrentUserEntity() {
  try {
    var jsonString =
        SharedPreferencesSingleton.getString(LocalStorageDataNames.kUserData);

    if (jsonString == null || jsonString.isEmpty) {
      log("User data is null or empty. error in getCurrentUserEntityMethod");
      throw const CustomException(
          message: 'An error occurred. Please try again.');
    }

    log("current user data $jsonString");
    var jsonData = jsonDecode(jsonString);

    UserEntity userEntity = UserModel.fromJson(jsonData);

    return userEntity;
  } catch (e) {
    log("Error while fetching the current user entity: $e");
    throw const CustomException(
        message: 'An error occurred. Please try again.');
  }
}
